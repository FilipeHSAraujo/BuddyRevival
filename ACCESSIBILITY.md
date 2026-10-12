# Accessibility

BuddyRevival is about nostalgia and play, and everyone who used BuddyPoke back then, or wants to try it now, should be able to dress a buddy, set a mood and poke a friend. That includes people who use a keyboard instead of a mouse, a screen reader, zoom, or a phone.

This document explains what already works, what doesn't yet, what we expect from contributions, and how to tell us when something gets in your way. If you are reading this because you hit a barrier, please [report it](#reporting-accessibility-issues). That's exactly what we want to know.

## Priorities

We aim for the experience described by WCAG 2.2 level AA. This is a goal, not a claim: the project has not been formally evaluated against WCAG.

In order of priority:

1. **Keyboard.** Every task — choosing clothes and colors, playing moods and pokes, copying and applying look codes — should work without a mouse, with visible focus that never gets lost.
2. **Screen readers.** Every control should have a meaningful name in the user's language, and what happens on the canvas should be described in text.
3. **Motion.** The buddy is always animated. People should be able to pause it.
4. **Zoom and small screens.** The layout should work at 200 % zoom and on phones without horizontal scrolling.
5. **Language.** The interface follows the browser language (English, Portuguese, Spanish, French, Thai, Chinese) and sets the page language so screen readers pronounce it correctly.

## What works today

- The page language is set from the chosen translation.
- The three sections are real tabs (`role="tab"`, `aria-selected`, `aria-controls`), reachable with Tab and activated with Enter or Space.
- Every button is a native `<button>`, so it can be focused and activated from the keyboard.
- Mood and poke buttons have visible text labels; their icons are decorative and hidden from screen readers.
- Wardrobe pickers announce their option name and whether they are open (`aria-expanded`); choices announce whether they are selected (`aria-pressed`).
- The caption under the buddy is a live region, so screen readers announce which mood or poke is playing ("You gave Friend a bear hug").
- The look-code field has a visible label.
- Decorative side images have empty alt text.
- The layout collapses to one column on narrow screens, and the canvas scales with the page.
- Text colors meet the 4.5:1 contrast ratio against their backgrounds.

## Known limitations

These are known barriers. They are listed by how they affect people, with workarounds where one exists.

- **Keyboard focus is lost in the wardrobe.** After opening a picker or choosing a style or color, the panel is redrawn and focus jumps back to the top of the page. Keyboard and screen reader users have to tab back through the whole list after every change. *Workaround:* none comfortable yet. This is the top priority.
- **Colors are announced as codes.** Color choices are read as hexadecimal values like "#ff7f00" instead of names, so screen reader users can't tell colors apart. *Workaround:* use *Random* or apply a look code from someone else.
- **Style names are internal and in English.** Style choices are read from internal artwork names ("Shrt Logo Star") and are not translated.
- **The buddy can only be rotated with a mouse, finger or pen.** There is no keyboard control for turning the buddy around. Rotation is not needed to complete any task.
- **The canvas has no text alternative.** Screen readers don't get a description of how the buddy currently looks. The caption describes moods and pokes, but not the outfit.
- **Animations can't be paused**, and the app does not respect the system's "reduce motion" setting.
- **"Copied!" is not announced.** After pressing *Copy*, the confirmation only changes the button text, which screen readers may not read.
- **The You / Friend switch and the Default / Random buttons share one group**, which some screen readers announce as a single radio group.
- **Selected and focused look the same.** Selected choices use the same outline as the keyboard focus ring, so it can be hard to tell where focus is in a picker.
- **Tabs don't respond to arrow keys.** Screen readers announce them as tabs, which suggests arrow-key navigation, but each tab is a separate Tab stop. *Workaround:* use Tab and Enter.
- **Loading shows only "…".** There is no text message while the app loads.

Tracked issues use the [`accessibility` label](https://github.com/FilipeHSAraujo/BuddyRevival/labels/accessibility).

## Contributor expectations

Any change that touches what people see or interact with should:

- Use native HTML elements (`<button>`, `<label>`, `<input>`) before adding ARIA roles.
- Give every control a name that makes sense on its own, translated through `t()`.
- Keep focus where the user is after the interface updates. Never redraw a focused element without restoring focus.
- Keep a visible focus indicator. Don't remove outlines without replacing them.
- Never use color alone to convey information.
- Keep text contrast at 4.5:1 or more, and 3:1 for icons and control borders.
- Respect `prefers-reduced-motion` for any new motion.

There are no automated accessibility checks in the project yet. Before opening a pull request with a user-facing change, please:

1. Complete the affected task using only the keyboard.
2. Check it at 200 % browser zoom and at phone width.
3. If you can, try it with a screen reader (NVDA on Windows, VoiceOver on macOS or iOS, TalkBack on Android).

In the pull request, say what you tested and with what. A short note is enough, for example: "Keyboard only in Firefox; NVDA 2024 announces the new picker label".

## Reporting accessibility issues

Open an issue at <https://github.com/FilipeHSAraujo/BuddyRevival/issues/new> and start the title with **[Accessibility]**.

It helps to include:

- What you were trying to do (for example, "change my shirt color").
- What happened instead.
- Your browser and operating system.
- Any assistive technology you use, such as a screen reader, magnifier, switch or voice control, and its version.

Screenshots or recordings are welcome but never required. You don't need to tell us about any disability, and you don't need to know technical terms. Describing what got in your way is enough.

### Severity

You don't need to pick a severity; the maintainer assigns it during triage.

| Severity | Meaning | Example |
| --- | --- | --- |
| **Critical** | A core task can't be completed at all. | The wardrobe can't be used with a keyboard. |
| **High** | A core task is possible but very hard, or depends on help. | Focus jumps to the top after every choice. |
| **Medium** | A task works, but parts are confusing or missing information. | Colors are announced as hex codes. |
| **Low** | A minor annoyance that doesn't block anything. | The "Copied!" message isn't announced. |

### How we respond

BuddyRevival is maintained by one person in their free time, so these are best-effort commitments:

- **Acknowledgement** within 7 days.
- **Triage and severity** within 14 days, with a workaround if one exists.
- **Critical and high** issues are worked on before any new features.
- **Updates** on the issue whenever the status changes, at least once a month while it is open.
- When a fix is live, we'll ask you to confirm it works for you before closing the issue.

## Ownership and maintenance

The project maintainer, Filipe Araujo ([@FilipeHSAraujo](https://github.com/FilipeHSAraujo)), is responsible for accessibility. That means triaging reports, reviewing pull requests against the expectations above, and keeping this document accurate.

This document is reviewed whenever the interface changes significantly, and at least every six months. If maintenance passes to someone else, this responsibility passes with it, and this section will be updated.

## Supported environments

BuddyRevival runs in current desktop and mobile versions of Chrome, Edge, Firefox and Safari. It needs JavaScript, and works with mouse, touch, pen and keyboard input.

What has actually been tested:

- Chromium-based browsers on Windows desktop, with mouse and keyboard.

Not yet tested:

- Screen readers (NVDA, JAWS, VoiceOver, TalkBack).
- Voice control and switch access.
- Windows high contrast and forced-colors modes.
- Safari and Firefox with assistive technology.

If you use any of these, your report is especially valuable.

## Feedback and improvements

Suggestions for this document or for how the project handles accessibility are welcome as issues or pull requests. If you are blocked by something right now, please use the [reporting process](#reporting-accessibility-issues) above so it gets triaged.
