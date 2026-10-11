export const CLASS = Symbol('amfClass');

export function readAmf3(bytes, position = 0) {
  const view = new DataView(bytes.buffer, bytes.byteOffset, bytes.byteLength);
  const decoder = new TextDecoder();
  const strings = [];
  const objects = [];
  const traits = [];
  let pos = position;

  const byte = () => bytes[pos++];

  const u29 = () => {
    let n = 0;
    for (let i = 0; i < 3; i++) {
      const b = byte();
      n = (n << 7) | (b & 0x7f);
      if (!(b & 0x80)) return n;
    }
    return (n << 8) | byte();
  };

  const text = length => decoder.decode(bytes.subarray(pos, (pos += length)));

  const string = () => {
    const header = u29();
    if (!(header & 1)) return strings[header >> 1];
    const length = header >> 1;
    if (!length) return '';
    const s = text(length);
    strings.push(s);
    return s;
  };

  const reference = header => (header & 1 ? null : objects[header >> 1]);

  const readTraits = header => {
    if (!(header & 2)) return traits[header >> 2];
    const t = { externalizable: !!(header & 4), dynamic: !!(header & 8), name: string(), keys: [] };
    for (let i = 0, n = header >> 4; i < n; i++) t.keys.push(string());
    traits.push(t);
    return t;
  };

  const value = () => {
    const marker = byte();
    switch (marker) {
      case 0x00: return undefined;
      case 0x01: return null;
      case 0x02: return false;
      case 0x03: return true;
      case 0x04: {
        const n = u29();
        return n & 0x10000000 ? n - 0x20000000 : n;
      }
      case 0x05: {
        const d = view.getFloat64(pos);
        pos += 8;
        return d;
      }
      case 0x06: return string();
      case 0x07:
      case 0x0b: {
        const header = u29();
        if (!(header & 1)) return objects[header >> 1];
        const xml = text(header >> 1);
        objects.push(xml);
        return xml;
      }
      case 0x08: {
        const header = u29();
        if (!(header & 1)) return objects[header >> 1];
        const date = new Date(view.getFloat64(pos));
        pos += 8;
        objects.push(date);
        return date;
      }
      case 0x09: {
        const header = u29();
        if (!(header & 1)) return objects[header >> 1];
        const array = [];
        objects.push(array);
        for (let key = string(); key !== ''; key = string()) array[key] = value();
        for (let i = 0, n = header >> 1; i < n; i++) array[i] = value();
        return array;
      }
      case 0x0a: {
        const header = u29();
        if (!(header & 1)) return reference(header);
        const t = readTraits(header);
        if (t.externalizable) throw new Error(`AMF3: externalizable class ${t.name} is not supported`);
        const object = {};
        if (t.name) Object.defineProperty(object, CLASS, { value: t.name });
        objects.push(object);
        for (const key of t.keys) object[key] = value();
        if (t.dynamic) for (let key = string(); key !== ''; key = string()) object[key] = value();
        return object;
      }
      case 0x0c: {
        const header = u29();
        if (!(header & 1)) return objects[header >> 1];
        const copy = bytes.slice(pos, (pos += header >> 1));
        objects.push(copy);
        return copy;
      }
      case 0x0d:
      case 0x0e:
      case 0x0f:
      case 0x10: {
        const header = u29();
        if (!(header & 1)) return objects[header >> 1];
        const length = header >> 1;
        const vector = [];
        objects.push(vector);
        byte();
        if (marker === 0x10) string();
        for (let i = 0; i < length; i++) {
          if (marker === 0x0d) { vector.push(view.getInt32(pos)); pos += 4; }
          else if (marker === 0x0e) { vector.push(view.getUint32(pos)); pos += 4; }
          else if (marker === 0x0f) { vector.push(view.getFloat64(pos)); pos += 8; }
          else vector.push(value());
        }
        return vector;
      }
      default:
        throw new Error(`AMF3: unknown marker 0x${marker.toString(16)} at ${pos - 1}`);
    }
  };

  return { value: value(), position: pos };
}

export function writeAmf3String(s) {
  const utf8 = new TextEncoder().encode(s);
  return new Uint8Array([0x06, ...u29Bytes((utf8.length << 1) | 1), ...utf8]);
}

function u29Bytes(n) {
  if (n < 0x80) return [n];
  if (n < 0x4000) return [(n >> 7) | 0x80, n & 0x7f];
  if (n < 0x200000) return [(n >> 14) | 0x80, ((n >> 7) & 0x7f) | 0x80, n & 0x7f];
  return [(n >> 22) | 0x80, ((n >> 15) & 0x7f) | 0x80, ((n >> 8) & 0x7f) | 0x80, n & 0xff];
}
