import { Renderer } from '../engine/renderer.js';

const VIEW = { width: 692, height: 520 };
const MARGIN = 0.08;
const BACKGROUND = '#fff';
const INK = '#222';
const MUTED = '#9a9aa2';
const WATERMARK = 'BuddyRevival';

const NO_PAINT = { createPattern: () => ({ setTransform() {} }), beginPath() {}, lineTo() {}, fill() {} };

export const ASPECTS = {
  portrait: { gif: [360, 640], mp4: [1080, 1920] },
  square: { gif: [480, 480], mp4: [1080, 1080] },
  landscape: { gif: [640, 480], mp4: [1440, 1080] },
};

// Screen-space box covering every triangle of every frame, at the 692×520 view.
function contentBounds(source, frames) {
  const renderer = new Renderer(VIEW.width, VIEW.height, source.camera);
  const box = { left: Infinity, top: Infinity, right: -Infinity, bottom: -Infinity };
  for (const frame of frames) {
    source.showFrame(frame);
    renderer.render(NO_PAINT, source.scene);
    for (const t of renderer.queue) {
      for (const { x, y, z } of [t.a, t.b, t.c]) {
        if (!(z > 0) || Math.abs(x) > 4 * VIEW.width || Math.abs(y) > 4 * VIEW.height) continue;
        box.left = Math.min(box.left, x);
        box.right = Math.max(box.right, x);
        box.top = Math.min(box.top, y);
        box.bottom = Math.max(box.bottom, y);
      }
    }
  }
  if (!Number.isFinite(box.left)) return { left: 0, top: 0, right: VIEW.width, bottom: VIEW.height };
  return box;
}

function wrap(g, text, maxWidth) {
  const lines = [];
  let line = '';
  for (const word of text.split(/\s+/).filter(Boolean)) {
    const next = line ? `${line} ${word}` : word;
    if (line && g.measureText(next).width > maxWidth) {
      lines.push(line);
      line = word;
    } else line = next;
  }
  if (line) lines.push(line);
  return lines;
}

/**
 * Prepares a canvas that can draw any frame of an animation, framed to fit the output size.
 * source: { scene, camera, frameCount, showFrame(frame) }; caption: text drawn under the buddies, '' for none.
 */
export function createClip(source, { width, height, caption = '', step = 1 }) {
  const frames = [];
  for (let f = 0; f < source.frameCount; f += step) frames.push(f);

  const canvas = new OffscreenCanvas(width, height);
  const g = canvas.getContext('2d', { willReadFrequently: true });
  const unit = Math.min(width, height);
  const captionSize = Math.round(unit * 0.055);
  g.font = `600 ${captionSize}px system-ui, sans-serif`;
  const lines = caption.split('\n').flatMap(paragraph => wrap(g, paragraph, width * 0.88));
  const band = lines.length ? lines.length * captionSize * 1.3 + unit * 0.06 : 0;
  const stageHeight = height - band;

  const bounds = contentBounds(source, frames);
  const boxWidth = Math.max(1, bounds.right - bounds.left);
  const boxHeight = Math.max(1, bounds.bottom - bounds.top);
  const scale = Math.min((width * (1 - 2 * MARGIN)) / boxWidth, (stageHeight * (1 - 2 * MARGIN)) / boxHeight);
  const renderer = new Renderer(VIEW.width * scale, VIEW.height * scale, source.camera);
  // Buddies and caption are centered together, so tall formats don't leave a gap between them.
  const contentHeight = Math.min(stageHeight, scale * boxHeight / (1 - 2 * MARGIN));
  const top = (height - contentHeight - band) / 2;
  const captionTop = top + contentHeight;
  const offsetX = width / 2 - scale * (bounds.left + bounds.right) / 2;
  const offsetY = top + contentHeight / 2 - scale * (bounds.top + bounds.bottom) / 2;

  const draw = frame => {
    source.showFrame(frame);
    g.setTransform(1, 0, 0, 1, 0, 0);
    g.globalCompositeOperation = 'source-over';
    g.fillStyle = BACKGROUND;
    g.fillRect(0, 0, width, height);

    g.save();
    g.beginPath();
    g.rect(0, 0, width, captionTop);
    g.clip();
    g.translate(offsetX, offsetY);
    renderer.render(g, source.scene);
    g.restore();

    g.textAlign = 'center';
    g.textBaseline = 'middle';
    g.fillStyle = INK;
    g.font = `600 ${captionSize}px system-ui, sans-serif`;
    lines.forEach((line, i) => g.fillText(line, width / 2, captionTop + unit * 0.02 + captionSize * 1.3 * (i + 0.5)));

    const markSize = Math.max(10, Math.round(unit * 0.03));
    g.font = `600 ${markSize}px system-ui, sans-serif`;
    g.textAlign = 'right';
    g.textBaseline = 'bottom';
    g.fillStyle = MUTED;
    g.fillText(WATERMARK, width - markSize * 0.6, height - markSize * 0.4);
    return canvas;
  };

  return { canvas, frames, draw, fps: 30 / step };
}
