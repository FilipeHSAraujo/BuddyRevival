export class Vector3 {
  constructor(x = 0, y = 0, z = 0) {
    this.x = x;
    this.y = y;
    this.z = z;
  }

  static read(bytes) {
    bytes.position = 0;
    return new Vector3(bytes.readFloat32(), bytes.readFloat32(), bytes.readFloat32());
  }
}

export class AxisAngle {
  constructor(x = 0, y = 1, z = 0, angle = 0) {
    this.x = x;
    this.y = y;
    this.z = z;
    this.angle = angle;
  }

  static read(bytes) {
    bytes.position = 0;
    return new AxisAngle(bytes.readFloat32(), bytes.readFloat32(), bytes.readFloat32(), bytes.readFloat32());
  }

  static fromQuaternion(x, y, z, w, fallbackAxis) {
    const length = Math.hypot(x, y, z, w);
    [x, y, z, w] = [x / length, y / length, z / length, w / length];
    const sin = Math.sqrt(1 - w * w);
    const axis = sin < 0.001 ? fallbackAxis ?? [x, y, z] : [x / sin, y / sin, z / sin];
    return new AxisAngle(axis[0], axis[1], axis[2], 2 * Math.acos(w));
  }
}

export class Matrix4 {
  e = new Float64Array([1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1]);

  identity() {
    this.e.set([1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1]);
    return this;
  }

  copy(other) {
    this.e.set(other.e);
    return this;
  }

  translation(x, y, z) {
    this.identity();
    this.e[12] = x;
    this.e[13] = y;
    this.e[14] = z;
    return this;
  }

  translate(x, y, z) {
    const e = this.e;
    e[12] += e[0] * x + e[4] * y + e[8] * z;
    e[13] += e[1] * x + e[5] * y + e[9] * z;
    e[14] += e[2] * x + e[6] * y + e[10] * z;
    return this;
  }

  rotate(angle, x, y, z) {
    const e = this.e;
    const c = Math.cos(-angle);
    const s = Math.sin(-angle);
    const t = 1 - c;
    const r = [
      c + x * x * t, z * s + y * x * t, -y * s + z * x * t,
      -z * s + x * y * t, c + y * y * t, x * s + z * y * t,
      y * s + x * z * t, -x * s + y * z * t, c + z * z * t,
    ];
    const [a0, a1, a2, a4, a5, a6, a8, a9, a10] = [e[0], e[1], e[2], e[4], e[5], e[6], e[8], e[9], e[10]];
    for (let col = 0; col < 3; col++) {
      const [p, q, w] = [r[col], r[3 + col], r[6 + col]];
      e[col * 4] = a0 * p + a4 * q + a8 * w;
      e[col * 4 + 1] = a1 * p + a5 * q + a9 * w;
      e[col * 4 + 2] = a2 * p + a6 * q + a10 * w;
    }
    return this;
  }

  rotateBy(axisAngle) {
    return axisAngle && axisAngle.angle !== 0 ? this.rotate(axisAngle.angle, axisAngle.x, axisAngle.y, axisAngle.z) : this;
  }

  multiply(other) {
    const a = this.e.slice();
    const b = other.e;
    const e = this.e;
    for (let col = 0; col < 3; col++) {
      for (let row = 0; row < 3; row++) {
        e[col * 4 + row] = a[row] * b[col * 4] + a[4 + row] * b[col * 4 + 1] + a[8 + row] * b[col * 4 + 2];
      }
    }
    for (let row = 0; row < 3; row++) {
      e[12 + row] = a[row] * b[12] + a[4 + row] * b[13] + a[8 + row] * b[14] + a[12 + row];
    }
    return this;
  }

  invertAffine() {
    const e = this.e;
    const [tx, ty, tz] = [-e[12], -e[13], -e[14]];
    const det = -e[8] * e[5] * e[2] + e[4] * e[9] * e[2] + e[8] * e[1] * e[6] - e[0] * e[9] * e[6] - e[4] * e[1] * e[10] + e[0] * e[5] * e[10];
    if (det === 0) return this;
    const inv = [
      (-e[9] * e[6] + e[5] * e[10]) / det, (e[9] * e[2] - e[1] * e[10]) / det, (-e[5] * e[2] + e[1] * e[6]) / det,
      (e[8] * e[6] - e[4] * e[10]) / det, (-e[8] * e[2] + e[0] * e[10]) / det, (e[4] * e[2] - e[0] * e[6]) / det,
      (-e[8] * e[5] + e[4] * e[9]) / det, (e[8] * e[1] - e[0] * e[9]) / det, (-e[4] * e[1] + e[0] * e[5]) / det,
    ];
    [e[0], e[1], e[2], e[4], e[5], e[6], e[8], e[9], e[10]] = inv;
    e[12] = tx * e[0] + ty * e[4] + tz * e[8];
    e[13] = tx * e[1] + ty * e[5] + tz * e[9];
    e[14] = tx * e[2] + ty * e[6] + tz * e[10];
    return this;
  }

  lookAt(eye, target) {
    const e = this.identity().e;
    let [fx, fy, fz] = [target.x - eye.x, target.y - eye.y, target.z - eye.z];
    const length = Math.hypot(fx, fy, fz);
    if (length !== 0) [fx, fy, fz] = [fx / length, fy / length, fz / length];
    const side = [-fz, 0, fx];
    const up = [side[1] * fz - side[2] * fy, side[2] * fx - side[0] * fz, side[0] * fy - side[1] * fx];
    [e[0], e[4], e[8]] = [side[0], up[0], -fx];
    [e[1], e[5], e[9]] = [side[1], up[1], -fy];
    [e[2], e[6], e[10]] = [side[2], up[2], -fz];
    return this.translate(-eye.x, -eye.y, -eye.z);
  }

  toAxisAngle() {
    const e = this.e;
    const trace = e[0] + e[5] + e[10];
    let x, y, z, w;
    if (trace >= 0) {
      const s = Math.sqrt(trace + 1);
      w = 0.5 * s;
      x = (e[6] - e[9]) * (0.5 / s);
      y = (e[8] - e[2]) * (0.5 / s);
      z = (e[1] - e[4]) * (0.5 / s);
    } else if (e[0] > e[5] && e[0] > e[10]) {
      const s = Math.sqrt(1 + e[0] - e[5] - e[10]);
      x = 0.5 * s;
      y = (e[1] + e[4]) * (0.5 / s);
      z = (e[8] + e[2]) * (0.5 / s);
      w = (e[6] - e[9]) * (0.5 / s);
    } else if (e[5] > e[10]) {
      const s = Math.sqrt(1 + e[5] - e[0] - e[10]);
      y = 0.5 * s;
      x = (e[1] + e[4]) * (0.5 / s);
      z = (e[6] + e[9]) * (0.5 / s);
      w = (e[8] - e[2]) * (0.5 / s);
    } else {
      const s = Math.sqrt(1 + e[10] - e[0] - e[5]);
      z = 0.5 * s;
      x = (e[8] + e[2]) * (0.5 / s);
      y = (e[6] + e[9]) * (0.5 / s);
      w = (e[1] - e[4]) * (0.5 / s);
    }
    const sin = Math.sqrt(1 - w * w);
    return sin < 0.001 ? new AxisAngle(x, y, z, 2 * Math.acos(w)) : new AxisAngle(x / sin, y / sin, z / sin, 2 * Math.acos(w));
  }
}

export const IDENTITY = new Matrix4();
