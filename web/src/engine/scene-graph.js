import { CLASS } from './amf3.js';
import { AxisAngle, IDENTITY, Matrix4, Vector3 } from './math.js';
import { Mesh } from './mesh.js';

export const buildNode = raw => {
  if (raw[CLASS] === 'Sc') return new Scene(raw);
  if (raw[CLASS] === 'Ca') return new Camera(raw);
  return new SceneNode(raw);
};

export class SceneNode {
  visible = true;
  local = new Matrix4();
  world = new Matrix4();
  inverseBind = new Matrix4();

  constructor(raw = {}) {
    this.name = raw.name ?? null;
    this.position = raw.cpos ? Vector3.read(raw.cpos) : null;
    this.rotation = raw.crot ? AxisAngle.read(raw.crot) : null;
    this.mesh = raw.mesh ? Mesh.from(raw.mesh) : null;
    this.children = (raw.children ?? []).map(buildNode);
  }

  updateWorld(parentWorld) {
    if (this.position) this.local.translation(this.position.x, this.position.y, this.position.z);
    else this.local.identity();
    this.local.rotateBy(this.rotation);
    this.world.copy(parentWorld).multiply(this.local);
  }

  init(scene, parentWorld) {
    if (this.name) scene.nodes.set(this.name, this);
    this.updateWorld(parentWorld);
    this.inverseBind.copy(this.world).invertAffine();
    for (const child of this.children) child.init(scene, this.world);
  }

  draw(renderer, parentWorld, scene) {
    this.updateWorld(parentWorld);
    if (this.mesh?.material && this.visible) this.mesh.draw(renderer, this.world, scene);
    for (const child of this.children) child.draw(renderer, this.world, scene);
  }

  worldPosition() {
    const e = this.world.e;
    return new Vector3(e[12], e[13], e[14]);
  }

  find(predicate) {
    if (predicate(this)) return this;
    for (const child of this.children) {
      const found = child.find(predicate);
      if (found) return found;
    }
    return null;
  }
}

export class Scene extends SceneNode {
  nodes = new Map();
  culled = new Set();
  props = [];

  constructor(raw) {
    super(raw);
    this.boneNames = raw.bones ?? [];
    this.propNames = raw.props ?? [];
    this.regionNames = raw.cullRegions ?? [];
  }

  init() {
    super.init(this, IDENTITY);
    this.props = this.propNames.map(name => this.nodes.get(name)).filter(Boolean);
  }

  draw(renderer, parentWorld = IDENTITY) {
    super.draw(renderer, parentWorld, this);
  }

  node(name) {
    return this.nodes.get(name) ?? null;
  }

  boneAt(index) {
    return this.nodes.get(this.boneNames[index]);
  }

  firstCamera() {
    return this.find(node => node instanceof Camera);
  }

  cullRegion(name) {
    const index = this.regionNames.indexOf(name);
    if (index >= 0) this.culled.add(index);
  }

  resetCulling() {
    this.culled.clear();
  }

  isCulled(region) {
    return this.culled.has(region);
  }

  hideProps() {
    for (const prop of this.props) prop.visible = false;
  }
}

export class Camera extends SceneNode {
  view = new Matrix4();
  lookAt = null;
  centerOffset = null;

  constructor(raw = {}) {
    super(raw);
    this.fov = raw.fov ?? 0.785398;
    this.position ??= new Vector3(0, 0, 10);
    this.rotation ??= new AxisAngle(0, 1, 0, 0);
  }

  init(scene) {
    if (this.name) scene.nodes.set(this.name, this);
  }

  draw() {}

  worldPosition() {
    return new Vector3(this.position.x, this.position.y, this.position.z);
  }

  update(viewport) {
    const orientation = this.lookAt ? new Matrix4().lookAt(this.position, this.lookAt.worldPosition()).toAxisAngle() : this.rotation;
    this.view.identity();
    if (this.centerOffset) {
      const focal = 1 / Math.tan(this.fov / 2);
      this.view.rotate(this.centerOffset.x / (viewport.width / 2) / focal, 0, -1, 0);
      this.view.rotate(-(this.centerOffset.y / (viewport.height / 2)), 1, 0, 0);
    }
    this.view.rotate(-orientation.angle, orientation.x, orientation.y, orientation.z);
    this.view.translate(-this.position.x, -this.position.y, -this.position.z);
  }
}
