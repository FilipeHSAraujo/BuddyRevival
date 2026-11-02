// H.264 through WebCodecs, wrapped in a minimal MP4 (moov first, one chunk, no audio).

const CODECS = ['avc1.640028', 'avc1.4d0028', 'avc1.42e028'];
const TIMESCALE = 90000;
const KEYFRAME_EVERY = 60;

const ascii = text => [...text].map(c => c.charCodeAt(0));
const u16 = n => [(n >> 8) & 255, n & 255];
const u32 = n => [(n >>> 24) & 255, (n >>> 16) & 255, (n >>> 8) & 255, n & 255];
const zeros = n => new Array(n).fill(0);
const MATRIX = [0x00010000, 0, 0, 0, 0x00010000, 0, 0, 0, 0x40000000].flatMap(u32);

function concat(parts) {
  const arrays = parts.map(p => (p instanceof Uint8Array ? p : Uint8Array.from(p)));
  const out = new Uint8Array(arrays.reduce((s, a) => s + a.length, 0));
  let offset = 0;
  for (const a of arrays) {
    out.set(a, offset);
    offset += a.length;
  }
  return out;
}

const box = (type, ...parts) => {
  const body = concat(parts);
  return concat([u32(8 + body.length), ascii(type), body]);
};
const fullBox = (type, version, flags, ...parts) => box(type, [version, (flags >> 16) & 255, (flags >> 8) & 255, flags & 255], ...parts);

function moov({ width, height, description, samples, delta, mdatOffset }) {
  const duration = samples.length * delta;
  const movieDuration = Math.round((duration * 1000) / TIMESCALE);
  const avc1 = box('avc1',
    zeros(6), u16(1), zeros(16), u16(width), u16(height),
    u32(0x00480000), u32(0x00480000), zeros(4), u16(1), zeros(32), u16(0x18), u16(0xffff),
    box('avcC', description));
  const stbl = box('stbl',
    fullBox('stsd', 0, 0, u32(1), avc1),
    fullBox('stts', 0, 0, u32(1), u32(samples.length), u32(delta)),
    fullBox('stss', 0, 0, u32(samples.filter(s => s.key).length), ...samples.flatMap((s, i) => (s.key ? [u32(i + 1)] : []))),
    fullBox('stsc', 0, 0, u32(1), u32(1), u32(samples.length), u32(1)),
    fullBox('stsz', 0, 0, u32(0), u32(samples.length), ...samples.map(s => u32(s.data.length))),
    fullBox('stco', 0, 0, u32(1), u32(mdatOffset)));
  const minf = box('minf',
    fullBox('vmhd', 0, 1, zeros(8)),
    box('dinf', fullBox('dref', 0, 0, u32(1), fullBox('url ', 0, 1))),
    stbl);
  const mdia = box('mdia',
    fullBox('mdhd', 0, 0, u32(0), u32(0), u32(TIMESCALE), u32(duration), u16(0x55c4), u16(0)),
    fullBox('hdlr', 0, 0, u32(0), ascii('vide'), zeros(12), ascii('VideoHandler'), [0]),
    minf);
  const trak = box('trak',
    fullBox('tkhd', 0, 3, u32(0), u32(0), u32(1), u32(0), u32(movieDuration), zeros(8), u16(0), u16(0), u16(0), u16(0), MATRIX, u32(width << 16), u32(height << 16)),
    mdia);
  return box('moov',
    fullBox('mvhd', 0, 0, u32(0), u32(0), u32(1000), u32(movieDuration), u32(0x00010000), u16(0x0100), zeros(10), MATRIX, zeros(24), u32(2)),
    trak);
}

export function mux({ width, height, description, samples, fps }) {
  const ftyp = box('ftyp', ascii('isom'), u32(0x200), ascii('isomiso2avc1mp41'));
  const delta = Math.round(TIMESCALE / fps);
  const header = { width, height, description, samples, delta, mdatOffset: 0 };
  const moovSize = moov(header).length;
  header.mdatOffset = ftyp.length + moovSize + 8;
  const data = concat(samples.map(s => s.data));
  return new Blob([ftyp, moov(header), concat([u32(8 + data.length), ascii('mdat')]), data], { type: 'video/mp4' });
}

export async function supportedCodec(width, height) {
  if (typeof VideoEncoder === 'undefined') return null;
  for (const codec of CODECS) {
    try {
      const { supported } = await VideoEncoder.isConfigSupported({ codec, width, height, bitrate: 8e6, framerate: 30, avc: { format: 'avc' } });
      if (supported) return codec;
    } catch {}
  }
  return null;
}

export class Mp4Encoder {
  samples = [];
  description = null;
  error = null;
  count = 0;

  static async create(width, height, fps) {
    const codec = await supportedCodec(width, height);
    if (!codec) return null;
    return new Mp4Encoder(codec, width, height, fps);
  }

  constructor(codec, width, height, fps) {
    Object.assign(this, { width, height, fps });
    this.encoder = new VideoEncoder({
      output: (chunk, meta) => {
        if (meta?.decoderConfig?.description) this.description = new Uint8Array(meta.decoderConfig.description);
        const data = new Uint8Array(chunk.byteLength);
        chunk.copyTo(data);
        this.samples.push({ data, key: chunk.type === 'key' });
      },
      error: e => { this.error = e; },
    });
    this.encoder.configure({ codec, width, height, bitrate: Math.round(width * height * fps * 0.12), framerate: fps, latencyMode: 'quality', avc: { format: 'avc' } });
  }

  async addFrame(canvas) {
    if (this.error) throw this.error;
    const duration = 1e6 / this.fps;
    const frame = new VideoFrame(canvas, { timestamp: Math.round(this.count * duration), duration: Math.round(duration) });
    this.encoder.encode(frame, { keyFrame: this.count % KEYFRAME_EVERY === 0 });
    frame.close();
    this.count++;
    while (this.encoder.encodeQueueSize > 4) await new Promise(resolve => setTimeout(resolve, 5));
  }

  async finish() {
    await this.encoder.flush();
    this.encoder.close();
    if (this.error) throw this.error;
    return mux({ width: this.width, height: this.height, description: this.description, samples: this.samples, fps: this.fps });
  }
}
