import { readAmf3 } from './amf3.js';

export class ByteReader extends Uint8Array {
  position = 0;

  get view() {
    return (this.dataView ??= new DataView(this.buffer, this.byteOffset, this.byteLength));
  }

  get remaining() {
    return this.byteLength - this.position;
  }

  readUint8() {
    return this[this.position++];
  }

  readInt8() {
    return this.view.getInt8(this.position++);
  }

  readInt16() {
    const v = this.view.getInt16(this.position);
    this.position += 2;
    return v;
  }

  readUint16() {
    const v = this.view.getUint16(this.position);
    this.position += 2;
    return v;
  }

  readInt32() {
    const v = this.view.getInt32(this.position);
    this.position += 4;
    return v;
  }

  readFloat32() {
    const v = this.view.getFloat32(this.position);
    this.position += 4;
    return v;
  }

  readObject() {
    const { value, position } = readAmf3(this, this.position);
    this.position = position;
    return value;
  }
}

export class BitReader {
  bits = 0;
  bitIndex = 0;

  constructor(bytes) {
    this.bytes = bytes;
    this.position = 0;
  }

  readBit() {
    if (this.bitIndex === 0) this.bits = this.bytes[this.position++];
    const bit = (this.bits >> (7 - this.bitIndex)) & 1;
    this.bitIndex = (this.bitIndex + 1) % 8;
    return bit;
  }

  readBits(count) {
    let n = 0;
    for (let i = 0; i < count; i++) n = (n << 1) | this.readBit();
    return n;
  }

  alignToByte() {
    this.bitIndex = 0;
  }
}

const pipe = async (bytes, stream) => new Uint8Array(await new Response(new Blob([bytes]).stream().pipeThrough(stream)).arrayBuffer());

export const inflate = async bytes => ByteReader.from(await pipe(bytes, new DecompressionStream('deflate')));

export const deflate = bytes => pipe(bytes, new CompressionStream('deflate'));
