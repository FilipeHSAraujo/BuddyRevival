import { ByteReader } from './binary.js';
import { AxisAngle, Vector3 } from './math.js';

const SQRT3 = Math.sqrt(3);
const SMOOTH = (SQRT3 - 1) / Math.SQRT2;
const DETAIL = (SQRT3 + 1) / Math.SQRT2;
const NEAR = (SQRT3 - 2) / 4;
const FAR = SQRT3 / 4;

function inverseD4Step(data, n) {
  const half = n / 2;
  const s = Array.from({ length: half }, (_, i) => data[i] / SMOOTH);
  const d = Array.from({ length: half }, (_, i) => data[i + half] / DETAIL);
  s[half - 1] += d[0];
  for (let i = 0; i < half - 1; i++) s[i] += d[i + 1];
  for (let i = 1; i < half; i++) data[2 * i + 1] = d[i] + NEAR * s[i - 1] + FAR * s[i];
  data[1] = d[0] + FAR * s[0] + NEAR * s[half - 1];
  for (let i = 0; i < half; i++) data[2 * i] = s[i] - SQRT3 * data[2 * i + 1];
}

function decodeWaveletChannel(bytes, frameCount, preciseCount) {
  bytes.position = 0;
  const preciseScale = bytes.readUint16();
  const coarseScale = bytes.readUint16();
  const size = 2 ** Math.ceil(Math.log2(frameCount));
  const data = new Array(size).fill(0);
  for (let i = 0; bytes.remaining > 0; i++) data[i] = i < preciseCount ? bytes.readInt16() / preciseScale : bytes.readInt8() / coarseScale;
  for (let n = 4; n <= size; n *= 2) inverseD4Step(data, n);
  return data;
}

function decodeRotations(rot, frameCount, preciseCount) {
  if (rot instanceof ByteReader) {
    rot.position = 0;
    const q = [0, 0, 0, 0].map(() => rot.readInt16() / (65535 / 2));
    const r = AxisAngle.fromQuaternion(...q);
    return [r.x, r.y, r.z, r.angle];
  }
  const [x, y, z, w] = ['x', 'y', 'z', 'w'].map(k => decodeWaveletChannel(rot[k], frameCount, preciseCount));
  const out = [];
  for (let f = 0; f < frameCount; f++) {
    const r = AxisAngle.fromQuaternion(x[f], y[f], z[f], w[f], [1, 0, 0]);
    out.push(r.x, r.y, r.z, r.angle);
  }
  return out;
}

function decodePositions(bytes, [minX, maxX, minY, maxY, minZ, maxZ]) {
  bytes.position = 0;
  const unit = () => bytes.readUint16() / 65535;
  const out = [];
  while (bytes.remaining > 0) out.push(unit() * (maxX - minX) + minX, unit() * (maxY - minY) + minY, unit() * (maxZ - minZ) + minZ);
  return out;
}

const sample = (values, index, stride) => (index * stride >= values.length ? 0 : index * stride);

class Track {
  node = null;

  constructor(raw, library, frameCount, preciseCount) {
    this.target = library.targets[raw.target];
    this.materialFrames = raw.mat ? Array.from(raw.mat) : null;
    this.positions = raw.pos ? decodePositions(raw.pos, library.positionBounds) : null;
    this.visibility = raw.vis ?? null;
    this.rotations = raw.rot ? decodeRotations(raw.rot, frameCount, preciseCount) : null;
  }

  apply(scene, frame) {
    if (!this.node) {
      this.node = scene.node(this.target);
      if (!this.node) return;
      if (this.positions) this.node.position ??= new Vector3();
      if (this.rotations) this.node.rotation ??= new AxisAngle();
    }
    const node = this.node;
    if (this.materialFrames && node.mesh?.material) node.mesh.material.showFrame(this.materialFrames[sample(this.materialFrames, frame, 1)]);
    if (this.positions) {
      const i = sample(this.positions, frame, 3);
      node.position.x = this.positions[i];
      node.position.y = this.positions[i + 1];
      node.position.z = this.positions[i + 2];
    }
    if (this.visibility) node.visible = this.visibility[sample(this.visibility, frame, 1)] === 1;
    if (this.rotations) {
      const i = sample(this.rotations, frame, 4);
      node.rotation.x = this.rotations[i];
      node.rotation.y = this.rotations[i + 1];
      node.rotation.z = this.rotations[i + 2];
      node.rotation.angle = this.rotations[i + 3];
    }
  }
}

export class Animation {
  tracks = null;
  startTime = null;

  constructor(raw, library) {
    this.raw = raw;
    this.library = library;
    this.name = raw.name;
    this.start = raw.start;
    this.end = raw.end;
    this.fps = raw.fps;
    this.loop = raw.loop ?? true;
    this.current = raw.start;
  }

  get frameCount() {
    return this.end - this.start + 1;
  }

  decode() {
    this.tracks ??= this.raw.controllers.map(c => new Track(c, this.library, this.frameCount, this.raw.highBits));
  }

  reset() {
    this.startTime = performance.now();
    this.current = this.start;
  }

  step(scene, advance = true) {
    this.startTime ??= performance.now();
    if (advance) {
      const seconds = (performance.now() - this.startTime) / 1000;
      this.current = Math.trunc(seconds * this.fps + this.start + 0.499);
      if (this.current > this.end) {
        if (!this.loop) return false;
        this.current = ((this.current - this.start) % (this.end - this.start)) + this.start;
      }
    }
    this.apply(scene);
    return true;
  }

  showFrame(scene, frame) {
    this.current = Math.min(this.start + frame, this.end);
    this.apply(scene);
  }

  apply(scene) {
    this.decode();
    scene.hideProps();
    for (const track of this.tracks) track.apply(scene, this.current - this.start);
  }
}

export function readAnimations(reader) {
  const raw = reader.readObject();
  raw.bounds.position = 0;
  const library = { targets: raw.targets, positionBounds: Array.from({ length: 6 }, () => raw.bounds.readFloat32()) };
  const animations = new Map();
  for (let i = 0; i < raw.numAnim; i++) {
    const animation = new Animation(reader.readObject(), library);
    animations.set(animation.name, animation);
  }
  return animations;
}
