import { Material } from '../engine/material.js';
import { readPackage } from '../engine/package.js';
import { Renderer } from '../engine/renderer.js';
import { Camera } from '../engine/scene-graph.js';
import { attr, children, isWorn, items, materialOptions, named, parseXml, toIndex } from './catalog.js';

const GEOMETRY_SLOTS = [1, 2, 3, 4];
const CULL_SLOTS = [1, 2, 3];

export class Buddy {
  animation = null;

  static async load(bytes, { width, height, textures = null, catalog = null }) {
    const pack = await readPackage(bytes);
    return new Buddy(pack, width, height, textures, parseXml(catalog ?? pack.catalog));
  }

  constructor(pack, width, height, textures, catalog) {
    this.scene = pack.scene;
    this.animations = pack.animations;
    this.textures = textures;
    this.catalog = catalog;
    this.defaultCamera = this.scene.firstCamera() ?? new Camera();
    this.renderer = new Renderer(width, height, this.defaultCamera);
  }

  get camera() {
    return this.renderer.camera;
  }

  set camera(camera) {
    this.renderer.camera = camera ?? this.defaultCamera;
  }

  get animationName() {
    return this.animation?.name ?? null;
  }

  play(name, { loop } = {}) {
    const animation = this.animations.get(name);
    if (!animation) return;
    animation.decode();
    if (loop !== undefined) animation.loop = loop;
    this.animation = animation;
    animation.reset();
  }

  step(advance = true) {
    return this.animation ? this.animation.step(this.scene, advance) : false;
  }

  showFrame(frame) {
    this.animation?.showFrame(this.scene, frame);
  }

  render(ctx) {
    this.renderer.render(ctx, this.scene);
  }

  async dress() {
    if (this.textures) {
      await this.textures.preload(this.catalog);
      this.applyMaterials();
    }
    this.applyVisibility();
    this.scene.hideProps();
  }

  applyMaterials() {
    const shared = new Map();
    for (const item of items(this.catalog).filter(isWorn)) {
      const option = named(materialOptions(this.catalog), attr(item, 'mat'))[0];
      if (!option) continue;
      const materials = children(option, 'material');
      let index = toIndex(attr(option, 'materialIndex'));
      if (index >= materials.length) {
        index = 0;
        option.setAttribute('materialIndex', 0);
      }
      const description = materials[index];
      if (!description) continue;
      for (const slot of GEOMETRY_SLOTS) {
        if (!item.hasAttribute(`geo${slot}`)) continue;
        const mesh = this.scene.node(attr(item, `geo${slot}`))?.mesh;
        if (!mesh) continue;
        const key = attr(option, 'shared') === 'true' ? attr(item, 'mat') : null;
        if (key && shared.has(key)) {
          mesh.material = shared.get(key);
          continue;
        }
        mesh.material = new Material(this.textures, description, attr(item, `lightmap${slot}`), attr(item, 'prop') === 'true');
        if (key) shared.set(key, mesh.material);
      }
    }
  }

  applyVisibility() {
    const all = items(this.catalog);
    if (!all.length) return;
    const cullGroups = [...this.catalog.getElementsByTagName('cullGroup')];
    const cullOptions = [...this.catalog.getElementsByTagName('cullOption')];
    const hideGroup = name => {
      if (!name) return;
      for (const region of children(named(cullGroups, name), 'region')) this.scene.cullRegion(attr(region, 'name'));
    };
    const applyCulling = item => {
      for (const slot of CULL_SLOTS) if (item.hasAttribute(`cull${slot}`)) hideGroup(attr(item, `cull${slot}`));
      for (const slot of CULL_SLOTS) {
        if (!item.hasAttribute(`cullOption${slot}`)) continue;
        const value = children(named(cullOptions, attr(item, `cullOption${slot}`)), 'cullvalue').find(v => attr(v, 'isDefault') === 'true');
        if (value) hideGroup(attr(value, 'cullGroup'));
      }
    };

    this.scene.find(node => { node.visible = false; return false; });
    this.scene.resetCulling();
    const shown = [];
    for (const item of all) {
      if (isWorn(item)) {
        for (const slot of GEOMETRY_SLOTS) if (item.hasAttribute(`geo${slot}`)) shown.push(attr(item, `geo${slot}`));
        applyCulling(item);
      }
      if (attr(item, 'forceCulling') === 'true') applyCulling(item);
    }
    for (const name of shown) {
      const node = this.scene.node(name);
      if (node) node.visible = true;
    }
  }
}

export class Stage {
  guests = [];

  static async load(bytes, { width, height }) {
    const pack = await readPackage(bytes);
    return new Stage(pack.scene, new Renderer(width, height, pack.scene.firstCamera() ?? new Camera()));
  }

  constructor(scene, renderer) {
    this.scene = scene;
    this.renderer = renderer;
  }

  host(buddy, slot) {
    const node = this.scene.node(slot);
    if (!node) return;
    node.children.push(buddy.scene);
    this.guests.push(buddy);
  }

  render(ctx, advance = true) {
    for (const guest of this.guests) guest.step(advance);
    this.renderer.render(ctx, this.scene);
  }

  showFrame(ctx, frame) {
    for (const guest of this.guests) guest.showFrame(frame);
    this.renderer.render(ctx, this.scene);
  }
}
