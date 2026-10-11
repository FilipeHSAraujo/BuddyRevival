import { Camera } from './scene-graph.js';

export class Renderer {
  queue = [];
  patterns = new WeakMap();
  seamPadding = 0.6;

  constructor(width, height, camera = new Camera()) {
    this.width = width;
    this.height = height;
    this.camera = camera;
  }

  get view() {
    return this.camera.view;
  }

  render(ctx, scene) {
    this.camera.update(this);
    const tan = Math.tan(this.camera.fov / 2);
    this.scaleX = (1 / tan) * (this.width / 2);
    this.scaleY = -(this.width / (this.height * tan)) * (this.height / 2);
    this.queue.length = 0;
    scene.draw(this);
    this.queue.sort((p, q) => q.depth - p.depth);
    this.paint(ctx);
  }

  project(transform, vertices, out) {
    const e = transform.e;
    const cx = this.width / 2;
    const cy = this.height / 2;
    for (let i = 0; i < vertices.length; i++) {
      const { x, y, z } = vertices[i];
      const p = out[i];
      p.z = -(e[2] * x + e[6] * y + e[10] * z + e[14]);
      p.x = (this.scaleX * (e[0] * x + e[4] * y + e[8] * z + e[12])) / p.z + cx;
      p.y = (this.scaleY * (e[1] * x + e[5] * y + e[9] * z + e[13])) / p.z + cy;
    }
  }

  paint(ctx) {
    const m = new DOMMatrix();
    ctx.imageSmoothingEnabled = true;
    for (const t of this.queue) {
      const { a, b, c } = t;
      m.a = b.x - a.x;
      m.b = b.y - a.y;
      m.c = c.x - a.x;
      m.d = c.y - a.y;
      m.e = a.x;
      m.f = a.y;
      m.multiplySelf(t.textureToTriangle);
      let pattern = this.patterns.get(t.bitmap);
      if (!pattern) this.patterns.set(t.bitmap, (pattern = ctx.createPattern(t.bitmap, 'repeat')));
      pattern.setTransform(m);
      ctx.fillStyle = pattern;
      const cx = (a.x + b.x + c.x) / 3;
      const cy = (a.y + b.y + c.y) / 3;
      ctx.beginPath();
      for (const v of [a, b, c]) {
        const dx = v.x - cx;
        const dy = v.y - cy;
        const grow = this.seamPadding / (Math.hypot(dx, dy) || 1);
        ctx.lineTo(v.x + dx * grow, v.y + dy * grow);
      }
      ctx.fill();
    }
  }
}
