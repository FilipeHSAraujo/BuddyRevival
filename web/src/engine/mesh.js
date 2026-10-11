import { Matrix4, Vector3 } from './math.js';
import { decodeMesh } from './mesh-decoder.js';
import { Skin } from './skin.js';

export class Mesh {
  material = null;
  decoded = false;
  triangles = null;
  transform = new Matrix4();

  static from(raw) {
    return Object.assign(new Mesh(), {
      name: raw.name,
      vertexCount: raw.numVerts,
      faceCount: raw.numFaces,
      dummyVertices: new Set(raw.dummyVerts ?? []),
      depthOffset: Number.isFinite(raw.screenZDepthOffset) ? raw.screenZDepthOffset : 0,
      encoded: raw.ebc,
      encodedSkin: raw.modifier?.ebc ?? null,
    });
  }

  decode(scene) {
    const data = decodeMesh(this.encoded, this.encodedSkin, this.vertexCount, this.faceCount);
    const faces = [];
    const regions = [];
    for (let i = 0; i < data.faces.length; i += 3) {
      const face = [data.faces[i], data.faces[i + 1], data.faces[i + 2]];
      if (face.some(v => this.dummyVertices.has(v))) continue;
      faces.push(...face);
      if (data.faceRegions) regions.push(data.faceRegions[i / 3]);
    }
    this.faces = faces;
    this.faceRegions = data.faceRegions ? regions : null;
    this.meshRegion = data.meshRegion;
    this.uvs = data.uvs;
    this.vertices = Array.from({ length: this.vertexCount }, (_, i) => new Vector3(data.positions[3 * i], data.positions[3 * i + 1], data.positions[3 * i + 2]));
    this.screen = this.vertices.map(() => new Vector3());
    this.skin = data.influences ? new Skin(data.influences, scene) : null;
    this.decoded = true;
  }

  buildTriangles(bitmap) {
    const w = bitmap.width - 1;
    const h = bitmap.height - 1;
    const uv = i => [this.uvs[2 * i] * w, h - this.uvs[2 * i + 1] * h];
    this.triangles = [];
    for (let i = 0; i < this.faces.length; i += 3) {
      const [a, c, b] = [this.faces[i], this.faces[i + 1], this.faces[i + 2]];
      const [ua, va] = uv(a);
      const [ub, vb] = uv(b);
      const [uc, vc] = uv(c);
      this.triangles.push({
        a: this.screen[a],
        b: this.screen[b],
        c: this.screen[c],
        textureToTriangle: new DOMMatrix([ub - ua, vb - va, uc - ua, vc - va, ua, va]).invertSelf(),
        region: this.faceRegions?.[i / 3],
        depth: 0,
        bitmap: null,
      });
    }
  }

  draw(renderer, world, scene) {
    if (!this.decoded) this.decode(scene);
    if (!this.faceRegions && this.meshRegion >= 0 && scene.isCulled(this.meshRegion)) return;
    const bitmap = this.material.bitmap;
    if (!bitmap) return;
    if (!this.triangles) this.buildTriangles(bitmap);

    const vertices = this.skin ? this.skin.deform(this.vertices) : this.vertices;
    this.transform.copy(renderer.view);
    if (!this.skin) this.transform.multiply(world);
    renderer.project(this.transform, vertices, this.screen);

    for (const t of this.triangles) {
      if (t.region !== undefined && scene.isCulled(t.region)) continue;
      const { a, b, c } = t;
      if ((b.x - a.x) * (c.y - a.y) - (c.x - a.x) * (b.y - a.y) <= -1) continue;
      t.depth = Math.max(a.z, b.z, c.z) + this.depthOffset;
      t.bitmap = bitmap;
      renderer.queue.push(t);
    }
  }
}
