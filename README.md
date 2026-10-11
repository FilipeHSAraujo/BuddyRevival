# BuddyRevival

BuddyRevival brings BuddyPoke back to life in the browser. BuddyPoke was a Flash application that lived inside Orkut, MySpace and hi5 around 2008–2012: you dressed up a small 3D character (the "buddy"), set its mood, and "poked" friends with short two-character animations — hugs, kisses, sword fights, rock-band jams.

Flash is gone, but the original data is not. The `.bin` packages that BuddyPoke shipped still contain the meshes, skeletons, animations and the texture catalog. This project reads those packages directly and renders them with a small software 3D engine written in plain JavaScript on top of the Canvas 2D API. There is no build step, no framework and no dependency.

The social layer (friend lists, bulletins, network APIs) is intentionally left out. Everything else — the wardrobe, moods, pokes, look codes and translations — works.

```
web/
├── index.html            markup only
├── styles.css
├── src/
│   ├── main.js           wires everything together
│   ├── engine/           reads packages and draws 3D scenes; knows nothing about buddies
│   ├── domain/           buddies, catalogs, textures, wardrobe, poses, translations
│   └── ui/               DOM rendering for the wardrobe and the action grids
└── assets/               the data: packages, catalog, wardrobe, moods, pokes, icons, languages
tests/engine.test.mjs     regression test, runs on Node
tools/add-symbol.mjs      adds artwork to the texture library
EXPORTED/                 raw export of the original SWF (reference material, not loaded at runtime)
```

---

## Table of contents

1. [Running it](#1-running-it)
2. [Using the app](#2-using-the-app)
3. [Ubiquitous language](#3-ubiquitous-language)
4. [Architecture](#4-architecture)
5. [The package format](#5-the-package-format)
6. [The engine, step by step](#6-the-engine-step-by-step)
7. [Textures and the catalog](#7-textures-and-the-catalog)
8. [The wardrobe](#8-the-wardrobe)
9. [Look codes](#9-look-codes)
10. [Extending BuddyRevival](#10-extending-buddyrevival)
11. [Testing](#11-testing)
12. [Deploying to GitHub Pages](#12-deploying-to-github-pages)
13. [Known limitations](#13-known-limitations)
14. [Credits and license](#14-credits-and-license)

---

## 1. Running it

The app uses ES modules and `fetch`, so it must be served over HTTP; opening `index.html` from the file system will not work.

Any static server will do. With Python:

```bash
python -m http.server 8417
```

Then open <http://localhost:8417/web/>.

Requirements: a browser with `OffscreenCanvas`, `CompressionStream`/`DecompressionStream` and `DOMMatrix`. Every current version of Chrome, Edge, Firefox and Safari qualifies.

To run the tests you need Node 18 or newer:

```bash
node tests/engine.test.mjs
```

---

## 2. Using the app

The screen has a canvas on the left and three tabs on the right.

**Customize Appearance.** Pick *You* or *Friend*, then change any option. Each row is an option (Hair, Shirt, Shoes…). Each square in a row is a selector: a colored square opens a palette, a picture opens a list of styles. Click a choice and the buddy is redressed immediately. Drag on the canvas to turn the buddy around.

- **Default** restores the original look.
- **Random** picks a random value for every selector.
- **Buddy code** shows the current look as a short text code. *Copy* puts it on the clipboard; paste a code and press *Apply* to wear it.

Rows appear and disappear depending on what you are wearing. *Hair Color* is hidden while a cap is on; *Boot Pattern* only shows up when boots are selected.

**Change Mood.** Plays one of 39 mood animations on your buddy.

**Poke a Friend.** Places both buddies on a stage and plays one of 28 paired animations.

Looks are saved in `localStorage` under the key `buddyrevival`. A look can also be passed in the URL, which is how the original Flash embed received it:

```
http://localhost:8417/web/?buddy=eNo1UUluwzAMvPUhOud...
```

The interface language follows the browser. Portuguese, Spanish, French, Thai and Chinese bundles are included; anything else falls back to English.

---

## 3. Ubiquitous language

The code uses one vocabulary everywhere — in class names, file names, data files and this document. When you add something, use these words.

| Term | Meaning |
|---|---|
| **Buddy** | One character: its scene, animations, catalog and renderer. `domain/buddy.js` |
| **Package** | A `.bin` file holding a buddy or a stage: descriptor, catalog, geometry, animations. `engine/package.js` |
| **Scene** | The tree of scene nodes loaded from a package. |
| **Scene node** | A transform in the tree. It may carry a mesh. Bones are scene nodes too. |
| **Mesh** | Triangles, texture coordinates and an optional skin attached to a node. |
| **Skin** | The bone weights that deform a mesh when the skeleton moves. |
| **Camera** | A special node with a field of view. A package may contain several. |
| **Renderer** | Projects visible triangles and paints them back to front. |
| **Animation** | A named clip (`hug1`, `mood_happy`, `pose_contra`) made of tracks. |
| **Track** | The per-frame data of one node: position, rotation, visibility, material frame. |
| **Stage** | A package with slots (`Buddy1`, `Buddy2`) that hosts other buddies. Used by pokes. |
| **Catalog** | The XML that describes everything a buddy can wear. `assets/chick/catalog.xml` |
| **Item** | A wearable piece of geometry (a hairstyle, a skirt, a cap). Items are shown or hidden. |
| **Material option** | A named group of materials (`Head`, `Body`, `Hair`). Items point to one with `mat`. |
| **Material** | A stack of layers composed into one bitmap. |
| **Layer** | One slot in a material. It holds several textures and selects one by index. |
| **Texture** | One choice inside a layer. It points to a symbol and optionally a color option. |
| **Symbol** | A piece of vector artwork (SVG) in the texture library, possibly with several frames. |
| **Texture library** | `symbols.json`, `icons.json`, `library.json` and the palette images. `domain/textures.js` |
| **Color option** | A named palette (`ShrtSpectrum`, `Skin`, `Eye`) that can tint a texture. |
| **Palette** | A one-row PNG where each pixel is a color. |
| **Lightmap** | A shading symbol laid over a material to give it volume. |
| **Mask** | A symbol that cuts a texture to a shape (a print that follows the shirt cut). |
| **Cull group / region** | Faces hidden when an item is worn, so hair does not poke through a cap. |
| **Prop** | Geometry only shown by animations (a guitar, a rose). |
| **Wardrobe** | The list of options shown in the customization tab. `assets/wardrobe.xml` |
| **Option** | One row in the wardrobe (Hair, Shirt). |
| **Selector** | One control inside an option. Three kinds: `color`, `texture`, `itemGroup`. |
| **Look** | The value of every selector, as `{ selectorId: index }`. |
| **Look code** | A look compressed into a short URL-safe string. |
| **Mood** | A solo animation with a caption. `assets/moods.xml` |
| **Poke** | A paired animation with a caption. `assets/pokes.xml` |
| **Pose** | An idle animation played while customizing. `domain/poses.js` |

---

## 4. Architecture

The code is split into three layers. Each layer may only import from the layers below it.

```
            ┌──────────────────────────────┐
  ui        │ wardrobe-panel   action-grid │   DOM only
            └──────────────┬───────────────┘
            ┌──────────────┴───────────────┐
  domain    │ buddy  wardrobe  textures    │   what a buddy is and wears
            │ catalog  poses  i18n         │
            └──────────────┬───────────────┘
            ┌──────────────┴───────────────┐
  engine    │ package  scene-graph  mesh   │   generic 3D: bytes in, pixels out
            │ renderer animation skin math │
            │ amf3 binary mesh-decoder     │
            └──────────────────────────────┘
```

**Engine** (`web/src/engine`) knows how to read a package and draw a scene. It does not know what a hat is. A material, for the engine, is any object with a `bitmap` and a `showFrame(frame)` method. You could feed it a different game's data if it used the same format.

**Domain** (`web/src/domain`) gives meaning to the data. `Buddy` wraps a scene and dresses it from the catalog. `TextureLibrary` turns catalog materials into bitmaps. `Wardrobe` maps the rows of `wardrobe.xml` to catalog attributes. Nothing in this layer touches the page.

**UI** (`web/src/ui`) builds DOM from domain objects and calls back when the user picks something. It holds no state of its own besides which picker is open.

**`main.js`** is the composition root. It loads the assets, creates two buddies and the stage, connects the tabs and buttons, and runs the frame loop. If you want to change *behavior* of the page, this is usually the only file to edit.

### The frame loop

```
requestAnimationFrame
  ├─ wardrobe tab → keepPosing(buddy) → buddy.render(ctx)
  ├─ mood tab     → me.step()         → me.render(ctx)
  └─ poke tab     → stage.render(ctx)   (steps both guests, then draws)
```

`step()` advances the current animation according to wall-clock time and the clip's frames per second, so playback speed is the same at 30 or 144 Hz.

### Dressing a buddy

Every change in the wardrobe ends with `buddy.dress()`:

```
dress()
  ├─ textures.preload(catalog)   decode only the SVGs the current look needs
  ├─ applyMaterials()            one Material per worn item's geometry
  ├─ applyVisibility()           show worn items, hide culled regions
  └─ scene.hideProps()           props stay hidden until an animation shows them
```

The catalog is a live XML document. Selectors write attributes into it (`textureIndex`, `colorIndex`, `visible`), and `dress()` reads it back. The catalog *is* the state.

---

## 5. The package format

A package (`chick.bin`, `setting.bin`) starts with the ASCII signature `buddylabs` followed by one AMF3-encoded object:

| Key | Content | Encoding |
|---|---|---|
| `d` | Descriptor XML (`<buddy name geo mat anim catalog>`) | zlib |
| `c` | Catalog XML | zlib |
| `g` | Scene graph | zlib + AMF3 |
| `a` | Animation library followed by N animations | zlib + AMF3 stream |
| `m` | The original texture SWF | raw |

**AMF3** is Flash's binary serialization format. `engine/amf3.js` implements the parts the packages use: integers (U29 variable-length), doubles, strings, arrays, byte arrays and typed objects, plus the three reference tables (strings, objects, traits). Typed objects keep their Flash class alias under the `CLASS` symbol, which is how `buildNode` knows that an object is a `Me` (mesh), `Ca` (camera) or `No` (plain node).

You can inspect any package from the browser console while the app is open:

```js
const { readPackage } = await import('./src/engine/package.js');
const pack = await readPackage(new Uint8Array(await (await fetch('assets/chick.bin')).arrayBuffer()));
[...pack.animations.keys()];   // 94 animation names
[...pack.scene.nodes.keys()];  // 99 node names: bones, meshes, cameras
```

---

## 6. The engine, step by step

### 6.1 Mesh decompression

Meshes are stored with the **Edgebreaker** algorithm (Rossignac, 1999). Instead of listing three vertex indices per triangle, Edgebreaker walks the surface triangle by triangle and records one of five symbols — **C, L, E, R, S** — describing how each new triangle connects to the boundary already visited. A whole mesh becomes a string of roughly two bits per triangle.

`engine/mesh-decoder.js` replays that walk. It rebuilds the *corner table* (for every corner, the vertex it touches and its opposite corner), resolves handles for meshes with holes, and zips the boundary back together. Vertex positions and UVs are quantized: each component is an integer of a few bits read with `BitReader`, then scaled back into the mesh's bounding box. Skin influences — which bones move which vertex, and how much — follow in a second stream.

### 6.2 Scene graph and skinning

Each `SceneNode` has a position and an axis-angle rotation. `updateWorld()` composes the local matrix with the parent's world matrix, recursively.

Skinned meshes use **linear blend skinning**. At load time each vertex is stored relative to each bone that influences it (`inverseBind × restPosition`). At render time:

```
deformed = Σ  weightᵢ × boneWorldᵢ × offsetᵢ
```

`engine/skin.js` does exactly that, every frame, for every visible skinned mesh.

### 6.3 Animation

An animation is a list of tracks, one per animated node. A track may carry:

- **positions** — three 16-bit integers per frame, normalized into the library's bounding box;
- **rotations** — either one constant quaternion, or four channels (x, y, z, w) compressed with a **Daubechies D4 wavelet**. The decoder reads the coefficients (16-bit for the first, most significant ones, 8-bit for the rest) and runs the inverse transform level by level, then converts each quaternion to axis-angle;
- **visibility** — one byte per frame, which is how props appear;
- **material frames** — which frame of a multi-frame symbol to show, which is how faces blink and change expression.

Tracks are decoded lazily the first time a clip plays.

### 6.4 Rendering

There is no WebGL. `engine/renderer.js` is a classic software pipeline built on Canvas 2D:

1. **Camera.** The view matrix is the inverse of the camera's transform. If the camera has a `lookAt` target, the orientation is computed from it; `centerOffset` shifts the image so the buddy is framed slightly above center.
2. **Projection.** Each vertex is transformed to view space and projected with a perspective divide. With `f = 1 / tan(fov / 2)`:
   `x' = x · f · w/2 / z + w/2`, `y' = −y · f · w/2 / z + h/2`. Using the width for both axes keeps pixels square.
3. **Culling.** A triangle is skipped when its screen-space winding shows it faces away from the camera, or when its region is culled by a worn item.
4. **Sorting.** Remaining triangles are sorted by the depth of their farthest vertex, farthest first — the **painter's algorithm**. It is correct enough for small convex-ish characters and avoids a depth buffer, which Canvas 2D does not have.
5. **Texturing.** For each triangle, the renderer computes the affine matrix that maps the texture triangle onto the screen triangle, sets it on a `CanvasPattern`, and fills the triangle path. Each triangle is grown by 0.6 px to hide anti-aliasing seams between neighbors.

Affine mapping is not perspective-correct, but triangles on a buddy are small enough that the difference is invisible — the original Flash renderer made the same trade-off.

---

## 7. Textures and the catalog

### 7.1 The texture library

The original textures were vector symbols inside `chick.swf`. They have been exported to SVG and bundled into JSON so the browser can load them in two requests instead of hundreds:

| File | Content |
|---|---|
| `assets/chick/symbols.json` | `{ "SymbolName": ["<svg…frame 1>", "<svg…frame 2>", …] }` |
| `assets/chick/icons.json` | `{ "Icon_SymbolName": "<svg…>", "Char_Group_Category_Item": "<svg…>" }` |
| `assets/chick/library.json` | `clipRects`, `colorOptions`, `masks`, `lightmaps`, `maskFilters` |
| `assets/chick/palette_*.png` | Palettes, one pixel per color, read left to right |

Each SVG carries a registration point in its first group, `<g transform="matrix(1.0, 0.0, 0.0, 1.0, X, Y)">`. The library uses `−X, −Y` as the offset where the symbol is stamped. This is the format JPEXS Free Flash Decompiler produces; if you draw new art by hand, keep that wrapper (see [10.3](#103-add-a-new-texture-a-shirt-print)).

SVGs are decoded into images lazily: `preload(catalog)` collects only the symbols the current look uses.

### 7.2 Composing a material

A material in the catalog looks like this (trimmed):

```xml
<materialOption name="Body" materialIndex="0">
  <material name="Material" clipRect="Body Clip Rect">
    <layer name="Skin" textureIndex="0" colorIndex="3">
      <texture symbol="Body" color="Skin" colorSelection="3"/>
    </layer>
    <layer name="ShrtLength" textureIndex="0">
      <texture symbol="Shrt_Tee"><mask maskSelection="Shrt_Tee"/></texture>
      …
    </layer>
    <layer name="ShrtLayer2" textureIndex="8" lockColor="ShrtLayer2Color" grabMask="ShrtLength">
      <texture symbol="Shrt_Logo_Question" color="ShrtSpectrum" colorSelection="5"/>
      …
    </layer>
  </material>
</materialOption>
```

`TextureLibrary.compose()` paints the layers in order onto an `OffscreenCanvas` the size of the material's clip rectangle:

1. Pick the texture: the layer's `textureIndex`, or the index of the layer named in `lockTexture`.
2. Stamp the symbol (at the requested animation frame).
3. Tint it. If the texture has a `color`, look up the color option. Palettes become a multiply matrix built from the pixel's RGB; the `Eye` option has explicit 4×5 color matrices (`colorMat`) that also shift hue. The index comes from `colorSelection`, or from the layer named in `lockColor`.
4. Mask it. A texture's `<mask>` children, or the masks of the layer named in `grabMask`, are drawn and combined with `destination-in`, so a print never spills past the shirt's cut.
5. Blend it onto the sheet (`blendMode`: multiply, overlay, screen, …).
6. After all layers, apply the item's lightmap twice at 50 % — once with `hard-light`, once with `overlay` — to fake shading.
7. Fill white underneath unless the material has `hasAlpha="true"`.

### 7.3 Items, visibility and culling

```xml
<itemCategory name="Hair">
  <item name="BCap" visGroup="HeadTop" visible="false" geo1="BCap" mat="BCap"
        cull1="Hair_Cap" cull2="BCap_Hair1" lightmap1="BCap Lightmap"/>
```

- `geo1`…`geo4` — scene nodes shown when the item is worn.
- `mat` — the material option those meshes use. `lightmap1`…`lightmap4` pair with each geometry.
- `visible` — worn or not. `alwaysVis="true"` is always worn (the body).
- `visGroup` — items in the same group are mutually exclusive; the wardrobe shows one at a time.
- `cull1`…`cull3` — cull groups to hide when worn. A cull group lists regions; faces tagged with those regions are skipped by the renderer.
- `prop="true"` — geometry that animations reveal; its material is built on first use.

---

## 8. The wardrobe

`assets/wardrobe.xml` decides what the customization tab shows:

```xml
<wardrobe>
  <option name="Shirt">
    <texture   path="Body;Material;ShrtLength"            id="sht"/>
    <color     path="Body;Material;ShrtColor;BlankClip"   id="shc"/>
    <texture   path="Body;Material;ShrtLayer1"            id="sl1t"/>
    <color     path="Body;Material;ShrtLayer1Color;BlankClip" id="sl1c"/>
  </option>
  <option name="Hair">
    <itemGroup path="Hair;HeadTop" id="hrt"/>
  </option>
</wardrobe>
```

Each child of an `<option>` is a selector. The `path` is split on `;`:

| Kind | Path | What it controls | Choices shown |
|---|---|---|---|
| `texture` | `MaterialOption;Material;Layer` | the layer's `textureIndex` | `Icon_<symbol>` for every texture in the layer |
| `color` | `MaterialOption;Material;Layer;Symbol` | `colorIndex` of the layer and `colorSelection` of the texture with that symbol | every color of the texture's color option |
| `itemGroup` | `ItemCategory;VisGroup` | which item of the group is `visible` | `Char_<group>_<category>_<item>` icons |

The `id` is the key stored in look codes. **Never reuse or rename an id**, or saved looks will put values in the wrong place.

A color selector whose color option has one color or less is dropped automatically — there is nothing to choose.

Two tables in `domain/wardrobe.js` add behavior that cannot be expressed in the XML:

- `OPTION_RULES` — when an option row is visible, as a predicate over the current look. `'Boot Pattern': look => look.sst == 5` hides the row unless shoe style 5 (boots) is selected.
- `SELECTOR_RESETS` — which selectors to reset to 0 when a texture selector changes. Switching from boots to sandals clears the boot pattern so it does not come back unexpectedly.

---

## 9. Look codes

A look code is the original BuddyPoke serialization, so codes from the old app still decode:

```
look   = { "hdc": 3, "hrt": 20, "shc": 120, … }
json   = JSON.stringify(look)
amf    = 0x06 + U29(length·2 + 1) + utf8(json)      an AMF3 string
code   = base64(zlib(amf)), with '+' replaced by '_'
```

`encodeLook` and `decodeLook` in `domain/wardrobe.js` implement both directions. Applying a code always starts from `DEFAULT_LOOK_CODE` and overlays the decoded values, so a code that omits some ids — because it was made before those ids existed — still produces a complete look. An invalid code is ignored and the default is kept.

Because looks store **indices**, the rule for every list in the project is: **append, never insert or reorder**. Adding the 26th shirt print at the end of the layer keeps every existing code valid; inserting it at position 3 shifts everybody's shirt.

---

## 10. Extending BuddyRevival

All recipes below edit data files and need no code change unless stated. Reload the page with the cache disabled (DevTools → Network → *Disable cache*) to see the result.

### 10.1 Add a color to an existing palette

Palettes are one-row PNGs. To add a shirt color, widen `assets/chick/palette_shrt_spectrum.png` by one pixel and paint the new color in the last column. It shows up at the end of every `ShrtSpectrum` picker.

For `Eye`, the composer prefers a color matrix when one exists for the index (`colorOptions.Eye.colorMat` in `library.json`). A new pixel beyond the existing 36 matrices falls back to a plain tint, which works; add a 20-number matrix to `colorMat` if you want the hue-shift look of the originals.

### 10.2 Add a new color option

1. Create `assets/chick/palette_neon.png`, one row of pixels.
2. Register it in `library.json`:
   ```json
   "colorOptions": { "Neon": { "palette": "palette_neon" }, … }
   ```
3. Use it on any texture in the catalog: `<texture symbol="Shrt_Logo_Star" color="Neon" colorSelection="0"/>`.

### 10.3 Add a new texture (a shirt print)

Say you want a lightning-bolt print on the second shirt layer.

1. **Draw it.** Make an SVG in the coordinate space of the body sheet (`Body Clip Rect`, 300 × 200). The simplest way to get the position right is to copy an existing print out of `symbols.json` (for instance `Shrt_Logo_Star`), keep its outer `<svg>` and `<g transform="matrix(…)">`, and replace the shapes inside. Make a 36 × 36 icon the same way, based on `Icon_Shrt_Logo_Star` in `icons.json`.

2. **Add it to the library.**
   ```bash
   node tools/add-symbol.mjs Shrt_Logo_Bolt bolt.svg --icon bolt-icon.svg
   ```
   This writes `Shrt_Logo_Bolt` into `symbols.json` and `Icon_Shrt_Logo_Bolt` into `icons.json`. Several SVG files make several frames.

3. **Add it to the catalog.** In `assets/chick/catalog.xml`, append a texture at the **end** of the `ShrtLayer2` layer:
   ```xml
   <texture symbol="Shrt_Logo_Bolt" color="ShrtSpectrum" colorSelection="0"/>
   ```

That's it. The *Shirt 2* row already has a `texture` selector pointing at `Body;Material;ShrtLayer2`, so the new icon appears in its list and the print is masked to the shirt cut by `grabMask="ShrtLength"`.

### 10.4 Add a new wardrobe row (a new button)

Suppose the catalog has a layer you want to expose — for example a third shirt layer you added as `ShrtLayer3` plus `ShrtLayer3Color`.

1. Add the option to `assets/wardrobe.xml`:
   ```xml
   <option name="Shirt 3">
     <texture path="Body;Material;ShrtLayer3" id="sl3t"/>
     <color   path="Body;Material;ShrtLayer3Color;BlankClip" id="sl3c"/>
   </option>
   ```
   The order of `<option>` elements is the order of the rows.
2. Pick ids that have never been used.
3. Optional: hide the row in some situations by adding a rule to `OPTION_RULES` in `domain/wardrobe.js`:
   ```js
   'Shirt 3': look => look.sht != 5,
   ```
4. Optional: translate the label (see [10.9](#109-translate-or-add-a-language)).

### 10.5 Add a new item to an item group

Items need geometry, and geometry lives inside the package. You can add an item that **reuses existing geometry** — a second cap that uses the same mesh with another material, for example — by appending to the category:

```xml
<item name="BCap_Red" visGroup="HeadTop" visible="false" alwaysVis="false"
      geo1="BCap" mat="BCap" cull1="Hair_Cap" cull2="BCap_Hair1" lightmap1="BCap Lightmap"/>
```

Then add a `Char_Hair_BCap_Red` icon to `icons.json` (the name is `group_category_item`; the group of every chick item is `Char`).

New meshes need a new package; see [Known limitations](#13-known-limitations).

### 10.6 Add a mood

Append a line to `assets/moods.xml`:

```xml
<mood id="m_zen" name="zen" desc="% is zen" hist="% is feeling zen" a0="mood_meditative" icon="mood_meditative"/>
```

- `a0` — any animation in `chick.bin` (list them with the console snippet in [section 5](#5-the-package-format)).
- `icon` — a PNG in `assets/icons/` without extension.
- `desc` — the caption; `%` becomes "You".

### 10.7 Add a poke

Append to `assets/pokes.xml`:

```xml
<poke id="hug3" name="group hug" desc="Group hug with %" hist="%1 and %2 had a group hug" a0="hug1" a1="hug2"/>
```

- `a0` plays on you (stage slot `Buddy1`), `a1` on your friend (`Buddy2`). The two clips were authored as pairs, so mixing clips from different pokes will make the buddies miss each other.
- The icon is derived from `a0`: `anim_` + `a0` with the first `1` removed (`hug1` → `anim_hug.png`).
- `hist` is the caption: `%1` is you, `%2` your friend.

### 10.8 Add a button to the page

Toolbar buttons are plain HTML plus a handler in `main.js`. To add a *Mirror friend* button that copies your look to your friend:

```html
<!-- index.html, inside the first .toolbar -->
<button class="button" id="mirror"></button>
```

```js
// main.js: add  mirror: 'Mirror'  to the labels object, then
$('mirror').onclick = async () => {
  await wardrobe.wear(buddies.friend, wardrobe.lookOf(buddies.me));
  save('friend');
};
```

Handlers that change the buddy being edited should go through `edit(...)`, which also redraws the wardrobe panel and saves the look.

### 10.9 Translate or add a language

Translations are keyed by the English text:

```xml
<!-- assets/i18n/pt.xml -->
<msg name="Shirt 3">Camisa 3</msg>
```

`t(text)` returns the translation, or the English text when there is none. Entries named `text(f)` hold a feminine form for languages that need one.

To add a language, create `assets/i18n/de.xml` with the same structure and add `'de'` to `LANGUAGES` in `domain/i18n.js`.

### 10.10 Change the idle poses

While customizing, the buddy cycles through poses. `POSES` in `domain/poses.js` is a Markov chain: for each pose, the next one is chosen by a random number falling into a range.

```js
pose_stand: {
  pose_stand: [0, 0.1],             10 %: stay
  pose_stand_lookAround: [0.1, 0.333],
  …
}
```

Add or rebalance entries to change the behavior. Every name must be an animation in the package.

---

## 11. Testing

`tests/engine.test.mjs` runs on Node without a browser. It loads `chick.bin`, renders six animation frames with every mesh visible, and compares a signature of the projected triangles (count, plus a weighted sum of screen coordinates and depths) to known values. Any change to decoding, skinning, animation or projection breaks it. It also checks that look codes survive an encode/decode round trip.

```bash
node tests/engine.test.mjs
```

Node has no `DOMMatrix`, so the test provides a minimal 2D version — the only browser API the engine needs.

The signatures were taken from the original transpiled Flash player and confirmed identical (to 10⁻⁹) after the refactor. If you change the engine on purpose, regenerate them and say why in the commit.

---

## 12. Deploying to GitHub Pages

The app is static, so it runs on GitHub Pages as is.

1. Push the repository to GitHub.
2. *Settings → Pages → Build and deployment*: deploy from the `main` branch, root folder.
3. Open `https://<user>.github.io/<repository>/`. The `index.html` at the root redirects to `web/`, and `.nojekyll` tells Pages to serve the files as they are.

All paths in the app are relative, so the `/<repository>/` prefix works without changes. The heaviest file is `symbols.json` (about 2.3 MB); GitHub Pages serves it gzipped.

---

## 13. Known limitations

- **No new geometry.** Meshes, skeletons and animations come from the original packages. Writing new ones requires an exporter that produces Edgebreaker-compressed AMF3 — possible, but not part of this project. Everything that is texture, color, catalog or wardrobe data is editable.
- **Social features are out of scope.** Friend lists, network APIs, bulletins and photo uploads were tied to services that no longer exist.
- **Mask blur.** The original softened some masks with a blur filter (`maskFilters`); masks here are hard-edged.
- **Head size.** The catalog declares a head-size slider whose bones do not exist in the shipped skeleton, so it is not offered.
- **Painter's algorithm.** Rare intersecting triangles may sort incorrectly, exactly as in the original.

---

## 14. Credits and license

BuddyPoke was created by Buddy Labs, Inc. The character data, artwork, animations and texts in `web/assets` and `EXPORTED` are theirs and are included for preservation. The code in this repository is released under the MIT License (see `LICENSE`); that license covers the code, not the original assets.
