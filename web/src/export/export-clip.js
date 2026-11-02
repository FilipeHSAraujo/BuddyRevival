import { ASPECTS, createClip } from './clip.js';
import { GifEncoder, PaletteBuilder } from './gif.js';
import { Mp4Encoder, supportedCodec } from './mp4.js';

const GIF_STEP = 2;
const MIN_VIDEO_SECONDS = 5;

const breathe = () => new Promise(resolve => setTimeout(resolve, 0));

export const canExportVideo = () => supportedCodec(...ASPECTS.portrait.mp4).then(Boolean);

async function exportGif(source, [width, height], caption, progress) {
  const clip = createClip(source, { width, height, caption, step: GIF_STEP });
  const g = clip.canvas.getContext('2d', { willReadFrequently: true });
  const pixels = () => g.getImageData(0, 0, width, height).data;
  const total = clip.frames.length * 2;
  const palette = new PaletteBuilder();
  for (const [i, frame] of clip.frames.entries()) {
    clip.draw(frame);
    palette.add(pixels());
    progress((i + 1) / total);
    await breathe();
  }
  const encoder = new GifEncoder(width, height, palette.build(), clip.fps);
  for (const [i, frame] of clip.frames.entries()) {
    clip.draw(frame);
    encoder.addFrame(pixels());
    progress((clip.frames.length + i + 1) / total);
    await breathe();
  }
  return encoder.finish();
}

async function exportMp4(source, [width, height], caption, progress) {
  const clip = createClip(source, { width, height, caption });
  const encoder = await Mp4Encoder.create(width, height, clip.fps);
  if (!encoder) throw new Error('video-unsupported');
  const loops = Math.max(1, Math.ceil((MIN_VIDEO_SECONDS * clip.fps) / clip.frames.length));
  const total = loops * clip.frames.length;
  for (let n = 0; n < total; n++) {
    await encoder.addFrame(clip.draw(clip.frames[n % clip.frames.length]));
    progress((n + 1) / total);
    if (n % 4 === 3) await breathe();
  }
  return encoder.finish();
}

/**
 * Renders one loop of an animation into a GIF or MP4 file.
 * source: { scene, camera, frameCount, showFrame(frame), name }; caption: text under the buddies.
 */
export async function exportClip(source, { format, aspect, caption = '', onProgress = () => {} }) {
  const size = ASPECTS[aspect]?.[format];
  if (!size) throw new Error(`unknown export: ${format} ${aspect}`);
  const blob = format === 'gif' ? await exportGif(source, size, caption, onProgress) : await exportMp4(source, size, caption, onProgress);
  const name = `buddyrevival-${source.name}-${aspect}.${format}`.replace(/[^\w.-]+/g, '_');
  return new File([blob], name, { type: blob.type });
}
