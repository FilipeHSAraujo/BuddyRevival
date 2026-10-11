import { IDENTITY, Vector3 } from './math.js';

const UNBOUND = { world: IDENTITY, inverseBind: IDENTITY };

export class Skin {
  constructor(influences, scene) {
    this.influences = influences;
    this.bones = new Map();
    for (const { bones } of influences) for (const i of bones) if (!this.bones.has(i)) this.bones.set(i, scene.boneAt(i) ?? UNBOUND);
    this.offsets = null;
    this.deformed = influences.map(() => new Vector3());
  }

  bindOffsets(vertices) {
    this.offsets = this.influences.map(({ bones }, v) => bones.map(i => {
      const e = this.bones.get(i).inverseBind.e;
      const { x, y, z } = vertices[v];
      return new Vector3(
        e[0] * x + e[4] * y + e[8] * z + e[12],
        e[1] * x + e[5] * y + e[9] * z + e[13],
        e[2] * x + e[6] * y + e[10] * z + e[14],
      );
    }));
  }

  deform(vertices) {
    if (!this.offsets) this.bindOffsets(vertices);
    this.influences.forEach(({ bones, weights }, v) => {
      const out = this.deformed[v];
      out.x = out.y = out.z = 0;
      bones.forEach((boneIndex, k) => {
        const e = this.bones.get(boneIndex).world.e;
        const { x, y, z } = this.offsets[v][k];
        const w = weights[k];
        out.x += (e[0] * x + e[4] * y + e[8] * z + e[12]) * w;
        out.y += (e[1] * x + e[5] * y + e[9] * z + e[13]) * w;
        out.z += (e[2] * x + e[6] * y + e[10] * z + e[14]) * w;
      });
    });
    return this.deformed;
  }
}
