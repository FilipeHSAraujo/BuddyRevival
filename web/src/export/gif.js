// Minimal animated GIF encoder: one global palette (median cut), LZW, and
// unchanged pixels left transparent so each frame only stores what moved.

const TRANSPARENT = 255;
const MAX_COLORS = 255;
const bin = (r, g, b) => ((r >> 3) << 10) | ((g >> 3) << 5) | (b >> 3);

export class PaletteBuilder {
  histogram = new Uint32Array(32768);
  sums = new Float64Array(3 * 32768);

  add(rgba) {
    for (let i = 0; i < rgba.length; i += 8) {
      const key = bin(rgba[i], rgba[i + 1], rgba[i + 2]);
      this.histogram[key]++;
      this.sums[3 * key] += rgba[i];
      this.sums[3 * key + 1] += rgba[i + 1];
      this.sums[3 * key + 2] += rgba[i + 2];
    }
  }

  build() {
    const colors = [];
    this.histogram.forEach((count, key) => {
      if (count) colors.push({ r: this.sums[3 * key] / count, g: this.sums[3 * key + 1] / count, b: this.sums[3 * key + 2] / count, count });
    });
    if (!colors.length) colors.push({ r: 255, g: 255, b: 255, count: 1 });
    let boxes = [colors];
    while (boxes.length < MAX_COLORS) {
      let best = -1;
      let bestScore = 0;
      let bestChannel = 'r';
      boxes.forEach((box, i) => {
        if (box.length < 2) return;
        for (const channel of ['r', 'g', 'b']) {
          let min = 255;
          let max = 0;
          let weight = 0;
          for (const c of box) {
            min = Math.min(min, c[channel]);
            max = Math.max(max, c[channel]);
            weight += c.count;
          }
          const score = (max - min) * Math.sqrt(weight);
          if (score > bestScore) [best, bestScore, bestChannel] = [i, score, channel];
        }
      });
      if (best < 0) break;
      const box = boxes[best].sort((p, q) => p[bestChannel] - q[bestChannel]);
      const half = box.reduce((s, c) => s + c.count, 0) / 2;
      let cut = 0;
      for (let seen = 0; cut < box.length - 1 && seen + box[cut].count < half; cut++) seen += box[cut].count;
      cut = Math.max(1, cut);
      boxes.splice(best, 1, box.slice(0, cut), box.slice(cut));
    }
    const palette = new Uint8Array(768);
    boxes.forEach((box, i) => {
      const total = box.reduce((s, c) => s + c.count, 0);
      palette[3 * i] = Math.round(box.reduce((s, c) => s + c.r * c.count, 0) / total);
      palette[3 * i + 1] = Math.round(box.reduce((s, c) => s + c.g * c.count, 0) / total);
      palette[3 * i + 2] = Math.round(box.reduce((s, c) => s + c.b * c.count, 0) / total);
    });
    return { palette, size: boxes.length };
  }
}

class ByteWriter {
  bytes = new Uint8Array(1 << 16);
  length = 0;

  byte(value) {
    if (this.length === this.bytes.length) {
      const grown = new Uint8Array(this.bytes.length * 2);
      grown.set(this.bytes);
      this.bytes = grown;
    }
    this.bytes[this.length++] = value;
  }

  word(value) {
    this.byte(value & 255);
    this.byte((value >> 8) & 255);
  }

  all(values) {
    for (const v of values) this.byte(v);
  }

  result() {
    return this.bytes.slice(0, this.length);
  }
}

function lzw(out, indices) {
  const minCodeSize = 8;
  const clear = 1 << minCodeSize;
  const end = clear + 1;
  let codeSize = minCodeSize + 1;
  let next = end + 1;
  let table = new Map();
  let block = [];
  let buffer = 0;
  let bits = 0;
  const flushBlock = () => {
    out.byte(block.length);
    out.all(block);
    block = [];
  };
  const emit = code => {
    buffer |= code << bits;
    bits += codeSize;
    while (bits >= 8) {
      block.push(buffer & 255);
      if (block.length === 255) flushBlock();
      buffer >>= 8;
      bits -= 8;
    }
  };

  out.byte(minCodeSize);
  emit(clear);
  let prefix = indices[0];
  for (let i = 1; i < indices.length; i++) {
    const k = indices[i];
    const key = prefix * 256 + k;
    const found = table.get(key);
    if (found !== undefined) {
      prefix = found;
      continue;
    }
    emit(prefix);
    if (next === 4096) {
      emit(clear);
      table = new Map();
      codeSize = minCodeSize + 1;
      next = end + 1;
    } else {
      table.set(key, next++);
      if (next > 1 << codeSize && codeSize < 12) codeSize++;
    }
    prefix = k;
  }
  emit(prefix);
  emit(end);
  if (bits > 0) block.push(buffer & 255);
  if (block.length) flushBlock();
  out.byte(0);
}

export class GifEncoder {
  out = new ByteWriter();
  previous = null;
  elapsed = 0;
  written = 0;

  constructor(width, height, { palette, size }, fps) {
    this.width = width;
    this.height = height;
    this.palette = palette;
    this.size = size;
    this.fps = fps;
    this.lookup = new Int16Array(32768).fill(-1);
    const out = this.out;
    out.all([...'GIF89a'].map(c => c.charCodeAt(0)));
    out.word(width);
    out.word(height);
    out.all([0xf7, 0, 0]);
    out.all(palette);
    out.all([0x21, 0xff, 11, ...[...'NETSCAPE2.0'].map(c => c.charCodeAt(0)), 3, 1, 0, 0, 0]);
  }

  nearest(r, g, b) {
    const key = bin(r, g, b);
    let index = this.lookup[key];
    if (index >= 0) return index;
    const p = this.palette;
    let best = Infinity;
    for (let i = 0; i < this.size; i++) {
      const d = (p[3 * i] - r) ** 2 + (p[3 * i + 1] - g) ** 2 + (p[3 * i + 2] - b) ** 2;
      if (d < best) [best, index] = [d, i];
    }
    this.lookup[key] = index;
    return index;
  }

  addFrame(rgba) {
    const { width, height } = this;
    const indices = new Uint8Array(width * height);
    for (let i = 0, p = 0; i < indices.length; i++, p += 4) indices[i] = this.nearest(rgba[p], rgba[p + 1], rgba[p + 2]);

    // Only the rectangle that changed since the previous frame is stored.
    let [left, top, right, bottom] = [0, 0, width - 1, height - 1];
    const previous = this.previous;
    if (previous) {
      [left, top, right, bottom] = [width, height, -1, -1];
      for (let y = 0; y < height; y++) {
        for (let x = 0; x < width; x++) {
          if (indices[y * width + x] === previous[y * width + x]) continue;
          if (x < left) left = x;
          if (x > right) right = x;
          if (y < top) top = y;
          if (y > bottom) bottom = y;
        }
      }
      if (right < 0) [left, top, right, bottom] = [0, 0, 0, 0];
    }
    const w = right - left + 1;
    const h = bottom - top + 1;
    const patch = new Uint8Array(w * h);
    for (let y = 0; y < h; y++) {
      for (let x = 0; x < w; x++) {
        const i = (y + top) * width + x + left;
        patch[y * w + x] = previous && indices[i] === previous[i] ? TRANSPARENT : indices[i];
      }
    }
    this.previous = indices;

    // GIF delays are in hundredths of a second; carry the rounding error over.
    this.written++;
    const delay = Math.round((this.written * 100) / this.fps) - this.elapsed;
    this.elapsed += delay;

    const out = this.out;
    out.all([0x21, 0xf9, 4, (1 << 2) | 1]);
    out.word(delay);
    out.all([TRANSPARENT, 0, 0x2c]);
    out.word(left);
    out.word(top);
    out.word(w);
    out.word(h);
    out.byte(0);
    lzw(out, patch);
  }

  finish() {
    this.out.byte(0x3b);
    return new Blob([this.out.result()], { type: 'image/gif' });
  }
}
