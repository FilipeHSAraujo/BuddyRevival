import { BitReader } from './binary.js';

const UNSET = -3;
const BORDER = -1;
const GATE = -2;

const next = corner => 3 * Math.floor(corner / 3) + ((corner + 1) % 3);
const prev = corner => next(next(corner));
const triangleOf = corner => Math.floor(corner / 3);

const readInt32s = bytes => {
  const values = [];
  if (!bytes) return values;
  bytes.position = 0;
  while (bytes.remaining > 0) values.push(bytes.readInt32());
  return values;
};

const readFloats = (bytes, count) => {
  bytes.position = 0;
  return Array.from({ length: count }, () => bytes.readFloat32());
};

const readOperation = bits => (bits.readBit() === 0 ? 'C' : ['S', 'R', 'L', 'E'][bits.readBits(2)]);

class Edgebreaker {
  triangle = 0;
  vertex = 0;
  handleCursor = 0;

  constructor(faceCount, vertexCount, handles, regions) {
    this.opposite = new Int32Array(3 * faceCount).fill(UNSET);
    this.cornerVertex = new Int32Array(3 * faceCount);
    this.operations = [];
    this.handles = handles;
    this.regions = regions;
    this.visitedTriangle = new Uint8Array(faceCount);
    this.markedVertex = new Uint8Array(vertexCount);
  }

  readRegion() {
    if (this.regions) this.regions.values[this.triangle] = this.regions.bits.readBits(this.regions.bitCount) + this.regions.min;
  }

  decodeComponent(start) {
    const { opposite, cornerVertex } = this;
    this.vertex += 2;
    cornerVertex[start] = this.vertex - 2;
    cornerVertex[start + 1] = this.vertex;
    cornerVertex[start + 2] = this.vertex - 1;
    opposite[start] = BORDER;
    opposite[start + 1] = BORDER;
    this.decodeConnectivity(start + 2);
    this.readRegion();
    this.vertex++;
    this.triangle++;
  }

  decodeConnectivity(corner) {
    const { opposite, cornerVertex } = this;
    for (;;) {
      this.readRegion();
      this.triangle++;
      const created = 3 * this.triangle;
      opposite[corner] = created;
      opposite[created] = corner;
      cornerVertex[created + 1] = cornerVertex[prev(corner)];
      cornerVertex[created + 2] = cornerVertex[next(corner)];
      corner = next(opposite[corner]);
      switch (this.operations[this.triangle - 1]) {
        case 'C':
          opposite[next(corner)] = BORDER;
          cornerVertex[created] = ++this.vertex;
          break;
        case 'L':
          opposite[next(corner)] = GATE;
          if (!this.matchHandle(next(corner))) this.zip(next(corner));
          break;
        case 'R':
          opposite[corner] = GATE;
          this.matchHandle(corner);
          corner = next(corner);
          break;
        case 'S':
          this.decodeConnectivity(corner);
          corner = next(corner);
          if (opposite[corner] >= 0) return;
          break;
        case 'E':
          opposite[corner] = GATE;
          opposite[next(corner)] = GATE;
          this.matchHandle(corner);
          if (!this.matchHandle(next(corner))) this.zip(next(corner));
          return;
      }
    }
  }

  zip(corner) {
    const { opposite, cornerVertex } = this;
    let b = next(corner);
    while (opposite[b] >= 0 && opposite[b] !== corner) b = next(opposite[b]);
    if (opposite[b] !== BORDER) return;
    opposite[corner] = b;
    opposite[b] = corner;
    let a = next(corner);
    const shared = cornerVertex[next(b)];
    cornerVertex[next(a)] = shared;
    while (opposite[a] >= 0 && a !== b) {
      a = next(opposite[a]);
      cornerVertex[next(a)] = shared;
    }
    let c = prev(corner);
    while (opposite[c] >= 0 && c !== b) c = prev(opposite[c]);
    if (opposite[c] === GATE) this.zip(c);
  }

  matchHandle(corner) {
    const { opposite, handles } = this;
    if (this.handleCursor >= handles.length || corner !== handles[this.handleCursor + 1]) return false;
    const partner = handles[this.handleCursor];
    opposite[corner] = partner;
    opposite[partner] = corner;
    let c = prev(corner);
    while (opposite[c] >= 0 && c !== partner) c = prev(opposite[c]);
    if (opposite[c] === GATE) this.zip(c);
    c = prev(opposite[corner]);
    while (opposite[c] >= 0 && c !== corner) c = prev(opposite[c]);
    if (opposite[c] === GATE) this.zip(c);
    this.handleCursor += 2;
    return true;
  }

  orderVertices(stored) {
    const { opposite, cornerVertex, visitedTriangle, markedVertex } = this;
    const ordered = stored.slice();
    ordered[0] = stored[cornerVertex[0]];
    ordered[1] = stored[cornerVertex[2]];
    ordered[2] = stored[cornerVertex[1]];
    markedVertex[0] = markedVertex[1] = markedVertex[2] = 1;
    visitedTriangle[0] = 1;
    let count = 2;
    const right = c => opposite[next(c)];
    const left = c => opposite[prev(c)];
    const walk = corner => {
      for (;;) {
        visitedTriangle[triangleOf(corner)] = 1;
        const v = cornerVertex[corner];
        if (!markedVertex[v]) {
          ordered[++count] = stored[v];
          markedVertex[v] = 1;
          corner = right(corner);
        } else if (visitedTriangle[triangleOf(right(corner))]) {
          if (visitedTriangle[triangleOf(left(corner))]) return;
          corner = left(corner);
        } else if (visitedTriangle[triangleOf(left(corner))]) {
          corner = right(corner);
        } else {
          walk(right(corner));
          corner = left(corner);
          if (visitedTriangle[triangleOf(corner)]) return;
        }
      }
    };
    walk(opposite[2]);
    return ordered;
  }
}

export function decodeMesh(encoded, skinEncoded, vertexCount, faceCount) {
  const [minX, minY, minZ, maxX, maxY, maxZ] = readFloats(encoded.bounds, 6);
  const [minU, minV, maxU, maxV] = readFloats(encoded.mapBounds, 4);
  const positionSteps = 2 ** encoded.vertBits - 1;
  const uvSteps = 2 ** encoded.mapVertBits - 1;
  const positionBits = new BitReader(encoded.verts);
  const uvBits = new BitReader(encoded.mapVerts);
  const skinBits = skinEncoded?.skin ? new BitReader(skinEncoded.skin) : null;
  const weightSteps = skinBits ? 2 ** skinEncoded.skinBits - 1 : 0;

  const stored = [];
  for (let i = 0; i < vertexCount; i++) {
    const vertex = {
      x: positionBits.readBits(encoded.vertBits) * ((maxX - minX) / positionSteps) + minX,
      y: positionBits.readBits(encoded.vertBits) * ((maxY - minY) / positionSteps) + minY,
      z: positionBits.readBits(encoded.vertBits) * ((maxZ - minZ) / positionSteps) + minZ,
      u: uvBits.readBits(encoded.mapVertBits) * ((maxU - minU) / uvSteps) + minU,
      v: uvBits.readBits(encoded.mapVertBits) * ((maxV - minV) / uvSteps) + minV,
    };
    if (skinBits) {
      const count = skinBits.readBits(skinEncoded.nbpvb);
      vertex.bones = Array.from({ length: count }, () => skinBits.readBits(skinEncoded.nbib));
      vertex.weights = vertex.bones.map(() => 1);
      skinBits.alignToByte();
      if (count > 1) vertex.weights = vertex.weights.map(() => skinBits.readBits(skinEncoded.skinBits) / weightSteps);
      skinBits.alignToByte();
    }
    stored.push(vertex);
  }

  const regions = encoded.cull
    ? { bits: new BitReader(encoded.cull), bitCount: encoded.numCullBits, min: encoded.cullMin, values: new Int32Array(faceCount) }
    : null;
  const decoder = new Edgebreaker(faceCount, vertexCount, readInt32s(encoded.handles), regions);
  const operationBits = new BitReader(encoded.clers);
  const componentFaces = readInt32s(encoded.numFaces1st);
  const componentOperations = readInt32s(encoded.numClers);

  componentFaces.forEach((faces, i) => {
    const start = decoder.opposite.indexOf(UNSET);
    for (let k = 0; k < faces - 2; k++) decoder.operations.push('C');
    decoder.operations.push('R');
    for (let k = 0; k < componentOperations[i]; k++) decoder.operations.push(readOperation(operationBits));
    decoder.operations.push(undefined);
    decoder.decodeComponent(start);
  });

  const vertices = decoder.orderVertices(stored);
  return {
    positions: Float64Array.from(vertices.flatMap(v => [v.x, v.y, v.z])),
    uvs: Float64Array.from(vertices.flatMap(v => [v.u, v.v])),
    faces: decoder.cornerVertex,
    faceRegions: regions?.values ?? null,
    meshRegion: regions ? -1 : encoded.cullMin,
    influences: skinBits ? vertices.map(v => ({ bones: v.bones, weights: v.weights })) : null,
  };
}
