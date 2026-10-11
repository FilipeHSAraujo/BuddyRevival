import { writeAmf3String } from '../engine/amf3.js';
import { deflate, inflate } from '../engine/binary.js';
import { attr, children, fetchXml, materialOptions, named, toIndex } from './catalog.js';

export const DEFAULT_LOOK_CODE = 'eNo1UUluwzAMvPUhOudQeQnSPEdSYAWWYcJ0AxRBH9Bfl8voNOSQIoejj7/vd6glh/twCUlxvIR6nOEeowZKTBKQMJ_KQnxZPnRCglkClg7t5GyFrJ3C5yoYjYgoDLYk04h8Mnz8nEB9IDseDIJ9EtNuOdNhajfUt9Qxu_o5O7G0jn7WtqJx1XNlA1cnuLpmbvG08yTQllGjQaibBS6DdOpVES0EbwgXU/eGuje8Pn3_2i85TRBTBuIF2wsJEqQnSK_J3O7kShvyhpzhPjMmcgSvZotZXEAUSCoj8snzinqFkjIDr6ijv/pv8Q7rdl2oDTtBwk74h6W9_ge8XOZyRJu2HLrl9x_zjKUt';

const OPTION_RULES = {
  'Hair Color': look => look.hrt != 31 && look.hrt > 3,
  'Hair Streak': look => look.hrt != 31 && look.hrt > 3,
  'Shaved Hair': look => look.hrt == 31,
  'Cap': look => look.hrt >= 0 && look.hrt <= 3,
  'Cap 2': look => look.hrt >= 0 && look.hrt <= 3,
  'High Belt Pattern': look => look.blt >= 1 && look.blt <= 3,
  'Low Belt Pattern': look => look.blt >= 4 && look.blt <= 6,
  'Sling Pattern': look => look.sst >= 0 && look.sst <= 3,
  'Shoe Pattern': look => look.sst == 4,
  'Boot Pattern': look => look.sst == 5,
  'Skirt 2': look => look.ski >= 1,
  'Skirt 3': look => look.ski >= 1,
};

const SELECTOR_RESETS = {
  sst: index => [
    ...(index < 1 || index > 3 ? ['sd1'] : []),
    ...(index != 4 ? ['sd3', 'sh1'] : []),
    ...(index != 5 ? ['sd5', 'sh3'] : []),
  ],
  blt: index => [...(index < 1 || index > 3 ? ['hbp'] : []), ...(index < 4 || index > 6 ? ['lbp'] : [])],
};

function layersAt(catalog, [optionName, , layerName]) {
  return children(named(materialOptions(catalog), optionName), 'material', 'layer').filter(layer => attr(layer, 'name') === layerName);
}

function colorSelector(id, buddy, path) {
  const texture = children(layersAt(buddy.catalog, path), 'texture').find(t => attr(t, 'symbol') === path[3]);
  const colors = texture && buddy.textures.colors(attr(texture, 'color'));
  if (!colors || colors.length <= 1) return null;
  const layer = texture.parentNode;
  layer.setAttribute('colorIndex', attr(texture, 'colorSelection'));
  return {
    id,
    kind: 'color',
    colors,
    get: () => toIndex(attr(layer, 'colorIndex')),
    set: index => {
      layer.setAttribute('colorIndex', index);
      texture.setAttribute('colorSelection', index);
    },
  };
}

function textureSelector(id, buddy, path) {
  const layer = layersAt(buddy.catalog, path)[0];
  if (!layer) return null;
  return {
    id,
    kind: 'texture',
    icons: children(layer, 'texture').map(t => `Icon_${attr(t, 'symbol')}`),
    get: () => toIndex(attr(layer, 'textureIndex')),
    set: index => layer.setAttribute('textureIndex', index),
  };
}

function itemGroupSelector(id, buddy, [category, visGroup]) {
  const categories = children(buddy.catalog, 'group', 'categories', 'itemCategory');
  const items = children(named(categories, category), 'item').filter(item => attr(item, 'visGroup') === visGroup);
  const iconOf = item => [item.parentNode.parentNode.parentNode, item.parentNode, item].map(e => attr(e, 'name')).join('_');
  return {
    id,
    kind: 'itemGroup',
    icons: items.map(iconOf),
    get: () => Math.max(0, items.findLastIndex(item => attr(item, 'visible') === 'true')),
    set: index => items.forEach((item, i) => item.setAttribute('visible', i === index ? 'true' : 'false')),
  };
}

const SELECTOR_KINDS = { color: colorSelector, texture: textureSelector, itemGroup: itemGroupSelector };

const toBase64 = bytes => btoa(String.fromCharCode(...bytes)).replace(/\+/g, '_');
const fromBase64 = code => Uint8Array.from(atob(code.replace(/_/g, '+')), c => c.charCodeAt(0));

export const encodeLook = async look => toBase64(await deflate(writeAmf3String(JSON.stringify(look))));

export const decodeLook = async code => JSON.parse((await inflate(fromBase64(code))).readObject());

export class Wardrobe {
  static async load(url) {
    return new Wardrobe(await fetchXml(url));
  }

  constructor(document) {
    this.document = document;
  }

  options(buddy) {
    return children(this.document, 'option').map(option => ({
      name: attr(option, 'name'),
      selectors: [...option.children]
        .map(e => SELECTOR_KINDS[e.tagName]?.(attr(e, 'id'), buddy, attr(e, 'path').split(';')))
        .filter(Boolean),
    }));
  }

  selectors(buddy) {
    return this.options(buddy).flatMap(option => option.selectors);
  }

  lookOf(buddy) {
    return Object.fromEntries(this.selectors(buddy).map(s => [s.id, s.get()]));
  }

  visibleOptions(buddy) {
    const options = this.options(buddy);
    const look = Object.fromEntries(options.flatMap(o => o.selectors).map(s => [s.id, s.get()]));
    return options.filter(option => OPTION_RULES[option.name]?.(look) ?? true);
  }

  async choose(buddy, selector, index) {
    if (selector.kind === 'texture') {
      const selectors = this.selectors(buddy);
      for (const id of SELECTOR_RESETS[selector.id]?.(index) ?? []) selectors.find(s => s.id === id)?.set(0);
    }
    selector.set(index);
    await buddy.dress();
  }

  async wear(buddy, ...looks) {
    const selectors = this.selectors(buddy);
    for (const look of looks) for (const s of selectors) if (look[s.id] != null) s.set(look[s.id]);
    await buddy.dress();
  }

  async wearCode(buddy, code) {
    const looks = [await decodeLook(DEFAULT_LOOK_CODE)];
    if (code && code !== DEFAULT_LOOK_CODE) {
      try {
        looks.push(await decodeLook(code));
      } catch {}
    }
    await this.wear(buddy, ...looks);
  }

  async wearOverDefault(buddy, look) {
    await this.wear(buddy, await decodeLook(DEFAULT_LOOK_CODE), look);
  }

  async randomize(buddy) {
    for (const s of this.selectors(buddy)) s.set(Math.floor(Math.random() * (s.colors ?? s.icons).length));
    await buddy.dress();
  }

  codeOf(buddy) {
    return encodeLook(this.lookOf(buddy));
  }
}
