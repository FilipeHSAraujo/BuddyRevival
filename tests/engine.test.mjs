import assert from 'node:assert/strict';
import { readFileSync } from 'node:fs';

globalThis.DOMMatrix ??= class {
  constructor([a, b, c, d, e, f] = [1, 0, 0, 1, 0, 0]) {
    Object.assign(this, { a, b, c, d, e, f });
  }

  multiplySelf(o) {
    const { a, b, c, d, e, f } = this;
    Object.assign(this, { a: a * o.a + c * o.b, b: b * o.a + d * o.b, c: a * o.c + c * o.d, d: b * o.c + d * o.d, e: a * o.e + c * o.f + e, f: b * o.e + d * o.f + f });
    return this;
  }

  invertSelf() {
    const { a, b, c, d, e, f } = this;
    const k = a * d - b * c;
    Object.assign(this, { a: d / k, b: -b / k, c: -c / k, d: a / k, e: (c * f - d * e) / k, f: (b * e - a * f) / k });
    return this;
  }
};

const { readPackage } = await import('../web/src/engine/package.js');
const { Renderer } = await import('../web/src/engine/renderer.js');
const { decodeLook, encodeLook, DEFAULT_LOOK_CODE } = await import('../web/src/domain/wardrobe.js');

const EXPECTED = {
  'pose_contra@0': [2659, 6098157],
  'pose_stand@5': [2620, 5984460],
  'mood_angry@10': [2779, 6284058],
  'kiss1@12': [2632, 5770524],
  'celebrate1@20': [2880, 6690072],
  'jamA1@8': [2691, 6174630],
};

const pack = await readPackage(readFileSync(new URL('../web/assets/chick.bin', import.meta.url)));
const bitmap = { width: 64, height: 64 };
pack.scene.find(node => {
  if (node.mesh) node.mesh.material = { bitmap, showFrame() {} };
  return false;
});
pack.scene.hideProps();

const renderer = new Renderer(692, 520, pack.scene.firstCamera());
const ctx = { createPattern: () => ({ setTransform() {} }), beginPath() {}, lineTo() {}, fill() {} };
const signature = queue => [queue.length, Math.round(queue.reduce((s, t) => s + t.a.x + 2 * t.b.y + 3 * t.depth, 0))];

for (const [key, expected] of Object.entries(EXPECTED)) {
  const [name, frame] = key.split('@');
  pack.animations.get(name).showFrame(pack.scene, Number(frame));
  renderer.render(ctx, pack.scene);
  assert.deepEqual(signature(renderer.queue), expected, key);
}

const look = await decodeLook(DEFAULT_LOOK_CODE);
assert.equal(Object.keys(look).length, 76);
assert.deepEqual(await decodeLook(await encodeLook({ ...look, hrt: 7 })), { ...look, hrt: 7 });

console.log('ok');
