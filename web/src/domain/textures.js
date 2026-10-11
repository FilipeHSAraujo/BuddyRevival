import { attr, children, isWorn, items, materialOption, named, selectedMaterial, toIndex } from './catalog.js';

const BLEND_MODES = { multiply: 'multiply', overlay: 'overlay', hardlight: 'hard-light', screen: 'screen', add: 'lighter', lighten: 'lighten', darken: 'darken', difference: 'difference' };

const canvas = (width, height) => new OffscreenCanvas(Math.max(1, width), Math.max(1, height));

const loadImage = src => new Promise(resolve => {
  const image = new Image();
  image.onload = () => resolve(image);
  image.onerror = () => resolve(null);
  image.src = src;
});

const svgOrigin = svg => {
  const m = svg.match(/<g transform="matrix\(1\.0, 0\.0, 0\.0, 1\.0, ([-\d.]+), ([-\d.]+)\)">/);
  return m ? { x: -m[1], y: -m[2] } : { x: 0, y: 0 };
};

function applyColorMatrix(target, m) {
  const g = target.getContext('2d', { willReadFrequently: true });
  const image = g.getImageData(0, 0, target.width, target.height);
  const d = image.data;
  for (let i = 0; i < d.length; i += 4) {
    const [r, gr, b, a] = [d[i], d[i + 1], d[i + 2], d[i + 3]];
    d[i] = m[0] * r + m[1] * gr + m[2] * b + m[3] * a + m[4];
    d[i + 1] = m[5] * r + m[6] * gr + m[7] * b + m[8] * a + m[9];
    d[i + 2] = m[10] * r + m[11] * gr + m[12] * b + m[13] * a + m[14];
    d[i + 3] = m[15] * r + m[16] * gr + m[17] * b + m[18] * a + m[19];
  }
  g.putImageData(image, 0, 0);
}

const tint = color => [(color >> 16 & 255) / 255, 0, 0, 0, 0, 0, (color >> 8 & 255) / 255, 0, 0, 0, 0, 0, (color & 255) / 255, 0, 0, 0, 0, 0, 1, 0];

const pickIndex = (index, length) => {
  if (index >= length) return length - 1;
  if (index === -1) return length <= 1 ? 0 : Math.floor(Math.random() * (length - 0.001));
  return index;
};

const maskSelections = texture => children(texture, 'mask').filter(m => m.hasAttribute('maskSelection')).map(m => attr(m, 'maskSelection'));

export class TextureLibrary {
  symbols = {};
  palettes = {};

  static async load(base) {
    const library = new TextureLibrary();
    library.base = base;
    const [data, svgs] = await Promise.all(['library.json', 'symbols.json'].map(f => fetch(base + f).then(r => r.json())));
    library.data = data;
    for (const [name, frames] of Object.entries(svgs)) library.symbols[name] = frames.map(svg => ({ svg, image: undefined, ...svgOrigin(svg) }));
    for (const option of Object.values(data.colorOptions)) library.palettes[option.palette] ??= await library.loadPalette(option.palette);
    return library;
  }

  async loadPalette(name) {
    const image = await loadImage(`${this.base}${name}.png`);
    const g = canvas(image.width, image.height).getContext('2d');
    g.drawImage(image, 0, 0);
    const d = g.getImageData(0, 0, image.width, image.height).data;
    const colors = [];
    for (let i = 0; i < d.length; i += 4) colors.push((d[i] << 16) | (d[i + 1] << 8) | d[i + 2]);
    return colors;
  }

  async preload(catalog) {
    const names = new Set(Object.values(this.data.lightmaps));
    for (const item of items(catalog).filter(isWorn)) {
      const layers = children(selectedMaterial(materialOption(catalog, attr(item, 'mat'))), 'layer');
      for (const layer of layers) {
        const selected = attr(named(layers, attr(layer, 'lockTexture'))[0] ?? layer, 'textureIndex');
        const textures = children(layer, 'texture');
        for (const texture of selected === '' ? textures : [textures[Math.min(toIndex(selected), textures.length - 1)]]) {
          names.add(attr(texture, 'symbol'));
          for (const mask of children(texture, 'mask')) names.add(attr(mask, 'maskSelection'));
        }
      }
    }
    const pending = [...names].flatMap(n => this.symbols[n] ?? []).filter(frame => frame.image === undefined);
    await Promise.all(pending.map(async frame => {
      const url = URL.createObjectURL(new Blob([frame.svg], { type: 'image/svg+xml' }));
      frame.image = await loadImage(url);
      URL.revokeObjectURL(url);
    }));
  }

  async icons() {
    this.iconSet ??= fetch(`${this.base}icons.json`).then(r => r.json()).then(svgs => Object.fromEntries(
      Object.entries(svgs).map(([name, svg]) => [name, { url: URL.createObjectURL(new Blob([svg], { type: 'image/svg+xml' })), ...svgOrigin(svg) }]),
    ));
    return this.iconSet;
  }

  colors(colorOption) {
    const option = this.data.colorOptions[colorOption];
    if (!option) return null;
    return this.palettes[option.palette] ?? option.colorMat?.map((_, i) => i) ?? null;
  }

  symbol(name, frame = 1) {
    const frames = this.symbols[name];
    return frames ? frames[Math.min(frame, frames.length) - 1] : null;
  }

  stamp(g, symbol) {
    if (symbol?.image) g.drawImage(symbol.image, symbol.x, symbol.y);
  }

  compose(material, lightmap = null, frame = 1) {
    const layers = this.composeLayers(material, lightmap, frame);
    if (!layers) return null;
    const out = canvas(layers.width, layers.height);
    const g = out.getContext('2d');
    if (attr(material, 'hasAlpha') !== 'true') {
      g.fillStyle = '#fff';
      g.fillRect(0, 0, out.width, out.height);
    }
    g.drawImage(layers, 0, 0);
    return out;
  }

  composeLayers(material, lightmap, frame) {
    const layers = children(material, 'layer');
    const rect = this.data.clipRects[attr(material, 'clipRect')];
    if (!layers.length || !rect) return null;
    const [, , width, height] = rect;
    const sheet = canvas(width, height);
    const sg = sheet.getContext('2d');
    const masksByLayer = {};

    for (const layer of layers) {
      const lockedTexture = attr(named(layers, attr(layer, 'lockTexture'))[0], 'textureIndex');
      const lockedColor = attr(named(layers, attr(layer, 'lockColor'))[0], 'colorIndex');
      const textures = children(layer, 'texture');
      let textureIndex = layer.hasAttribute('lockTexture') && lockedTexture !== '' ? toIndex(lockedTexture) : -1;
      if (textureIndex === -1) {
        const own = attr(layer, 'textureIndex');
        textureIndex = own !== '' ? toIndex(own) : Math.floor(Math.random() * textures.length);
      }
      textureIndex = Math.min(textureIndex, textures.length - 1);
      const texture = textures[textureIndex];
      const layerName = attr(layer, 'name');
      if (layerName) layer.setAttribute('textureIndex', textureIndex);
      const symbolName = attr(texture, 'symbol');
      if (!symbolName) continue;
      const symbol = this.symbol(symbolName, frame);
      if (!symbol) return null;

      let borrowedFrom = null;
      let maskNames = null;
      if (layer.hasAttribute('grabMask')) {
        const owner = named(layers, attr(layer, 'grabMask'))[0];
        maskNames = maskSelections(children(owner, 'texture')[toIndex(attr(owner, 'textureIndex'))]);
        if (maskNames.length) borrowedFrom = attr(layer, 'grabMask');
      }
      if (!borrowedFrom && children(texture, 'mask').length) maskNames = maskSelections(texture);
      const masks = maskNames?.map(n => this.symbol(n, frame)).filter(Boolean) ?? [];

      let colorIndex = layer.hasAttribute('lockColor') && lockedColor !== '' ? toIndex(lockedColor) : -1;
      if (colorIndex !== -1) texture.setAttribute('colorSelection', colorIndex);
      else colorIndex = attr(texture, 'colorSelection') === '' ? -1 : toIndex(attr(texture, 'colorSelection'));
      let matrix = null;
      const option = this.data.colorOptions[attr(texture, 'color')];
      if (option?.colorMat && colorIndex < option.colorMat.length) {
        colorIndex = pickIndex(colorIndex, option.colorMat.length);
        matrix = option.colorMat[colorIndex];
      } else if (option && this.palettes[option.palette]) {
        const palette = this.palettes[option.palette];
        colorIndex = pickIndex(colorIndex, palette.length);
        matrix = tint(palette[colorIndex]);
      }
      texture.setAttribute('colorSelection', colorIndex);
      layer.setAttribute('colorIndex', colorIndex);

      const paint = canvas(width, height);
      const pg = paint.getContext('2d', { willReadFrequently: true });
      this.stamp(pg, symbol);
      if (matrix) applyColorMatrix(paint, matrix);

      if (masks.length) {
        let mask = borrowedFrom ? masksByLayer[borrowedFrom] : null;
        if (!borrowedFrom) {
          mask = canvas(width, height);
          const mg = mask.getContext('2d');
          for (const m of masks) this.stamp(mg, m);
          masksByLayer[layerName] = mask;
        }
        if (mask) {
          pg.globalCompositeOperation = 'destination-in';
          pg.drawImage(mask, 0, 0);
        }
        sg.drawImage(paint, 0, 0);
      } else {
        sg.globalCompositeOperation = BLEND_MODES[attr(layer, 'blendMode').toLowerCase()] ?? 'source-over';
        sg.drawImage(paint, 0, 0);
        sg.globalCompositeOperation = 'source-over';
      }
    }

    const light = lightmap ? this.symbol(this.data.lightmaps[lightmap], frame) : null;
    if (light?.image) {
      sg.globalAlpha = 0.5;
      for (const mode of ['hard-light', 'overlay']) {
        sg.globalCompositeOperation = mode;
        this.stamp(sg, light);
      }
      sg.globalAlpha = 1;
      sg.globalCompositeOperation = 'source-over';
    }
    return sheet;
  }
}
