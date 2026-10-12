# Contributing to BuddyRevival

Thanks for wanting to help bring BuddyPoke back. Bug reports, ideas, artwork, translations and code are all welcome, and you don't need to be a programmer to contribute.

## Ways to help

- **Report a bug.** Something renders wrong, an animation glitches, a look code doesn't load.
- **Suggest something.** A new outfit, mood, poke, or a change to how the app works.
- **Draw.** New shirt prints, colors, palettes and icons are just SVG and PNG.
- **Translate.** Fix a translation or add a new language.
- **Write code.** Pick an open issue, especially the ones labeled `good first issue`.
- **Share old look codes.** If you still have a code from the original app, test it and tell us if it looks right.

## Opening an issue

Search the [existing issues](https://github.com/FilipeHSAraujo/BuddyRevival/issues) first; someone may have reported it already.

For a bug, include:

1. What you did, step by step.
2. What you expected and what happened instead.
3. Browser and operating system.
4. Your look code, if the problem is about a buddy's appearance.
5. A screenshot or short recording, and any errors from the browser console (F12 → Console).

For an idea, describe what you want and why. A sketch or a reference to how the original BuddyPoke did it helps a lot.

## Setting up

There is no build step and nothing to install.

```bash
git clone https://github.com/<your-user>/BuddyRevival.git
cd BuddyRevival
python -m http.server 8417
```

Open <http://localhost:8417/web/>. Keep DevTools open with *Disable cache* checked in the Network tab, so your changes show up on reload.

Read the [README](README.md) before changing code. Sections 3 (ubiquitous language) and 4 (architecture) explain how the project is organized, and section 10 has step-by-step recipes for adding clothes, colors, wardrobe rows, moods, pokes, buttons and languages.

## Making a change

1. Fork the repository and create a branch from `main`:
   ```bash
   git checkout -b fix/eye-color-picker
   ```
2. Make the change. Keep it focused: one fix or feature per pull request.
3. Run the tests:
   ```bash
   node tests/engine.test.mjs
   ```
4. Open the app and check the change by hand: the wardrobe, a mood and a poke.
5. Commit and open a pull request against `main`, explaining what changed and why. Link the issue it solves (`Closes #12`). For visual changes, add a before/after screenshot.

## Code style

The codebase is small and consistent; please keep it that way.

- **Plain JavaScript, ES modules, no dependencies.** Don't add a framework, bundler or npm package. If the browser or the standard library does it, use that.
- **No comments.** Names should explain the code. If something needs a comment, try renaming or splitting it first.
- **English everywhere** — identifiers, data files, commit messages and docs. User-facing text goes through `t()` and the language bundles in `web/assets/i18n`.
- **Use the project's vocabulary.** Buddy, catalog, item, material, layer, texture, symbol, wardrobe, option, selector, look, mood, poke. The full glossary is in the README. Don't introduce synonyms.
- **Respect the layers.** `engine` knows nothing about buddies, `domain` never touches the DOM, `ui` holds no state. Imports only go downward.
- **Match the surrounding code**: two-space indentation, single quotes, semicolons, small functions, classes only where there is real state.
- **Data over code.** If something can be expressed in `catalog.xml`, `wardrobe.xml`, `moods.xml` or `pokes.xml`, do it there.

## Rules that protect saved looks

Look codes store **indices**, and people share them. Breaking them silently breaks everyone's buddy.

- **Append, never insert or reorder.** New textures go at the end of their layer, new colors at the end of the palette, new items at the end of their group.
- **Never rename or reuse a selector `id`** in `wardrobe.xml`.
- **Don't remove choices.** If something must go, open an issue first so we can plan a migration.

## Changing the engine

The test compares the projected triangles of six animation frames to values taken from the original Flash renderer. If your change makes it fail, that's almost always a regression. If you are changing the rendering on purpose, update the expected values in `tests/engine.test.mjs` and explain in the pull request why the output changed.

## Commit messages

Short, imperative and in English:

```
Add lightning bolt shirt print
Fix eye color picker showing one extra swatch
```

## Assets and copyright

The original BuddyPoke data, artwork and texts belong to Buddy Labs and are kept here for preservation. New artwork you contribute must be your own work, and by submitting it you agree to release it under the project's MIT license. Don't submit artwork copied from other games, brands or artists.

## Code of conduct

Be kind and patient. Many people arrive here out of nostalgia, not code. Help newcomers, critique ideas rather than people, and assume good intent. Harassment or discrimination of any kind isn't tolerated, and the maintainer may remove comments or block accounts that cross that line.

## Questions

Not sure where to start, or whether an idea fits? Open an issue and ask. There are no silly questions here.
