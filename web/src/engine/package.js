import { readAnimations } from './animation.js';
import { ByteReader, inflate } from './binary.js';
import { buildNode } from './scene-graph.js';

const SIGNATURE = 'buddylabs';
const text = bytes => new TextDecoder().decode(bytes);

export async function readPackage(bytes) {
  const reader = ByteReader.from(bytes);
  if (text(reader.subarray(0, SIGNATURE.length)) !== SIGNATURE) throw new Error('Not a buddy package');
  reader.position = SIGNATURE.length;
  const sections = reader.readObject();
  const scene = buildNode((await inflate(sections.g)).readObject());
  scene.init();
  return {
    descriptor: text(await inflate(sections.d)),
    catalog: text(await inflate(sections.c)),
    scene,
    animations: sections.a ? readAnimations(await inflate(sections.a)) : new Map(),
    textureMovie: sections.m ?? null,
  };
}
