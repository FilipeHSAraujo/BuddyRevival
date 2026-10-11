export class Material {
  frames = new Map();
  frame = -1;

  constructor(textures, description, lightmap, deferred = false) {
    this.textures = textures;
    this.description = description;
    this.lightmap = lightmap;
    this.current = deferred ? null : textures.compose(description, lightmap);
  }

  get bitmap() {
    return (this.current ??= this.textures.compose(this.description, this.lightmap));
  }

  showFrame(frame) {
    if (frame === this.frame) return;
    this.frame = frame;
    if (!this.frames.has(frame)) this.frames.set(frame, this.textures.compose(this.description, this.lightmap, frame));
    this.current = this.frames.get(frame);
  }
}
