# Security Policy

## Supported versions

BuddyRevival has no numbered releases. Only the current `main` branch, which is what runs on <https://filipehsaraujo.github.io/BuddyRevival/>, receives fixes. Forks and older copies should update from `main`.

| Version | Supported |
| --- | --- |
| `main` (live site) | :white_check_mark: |
| Older commits and forks | :x: |

## Scope

BuddyRevival is a static site: no server, no accounts, no database. Everything runs in the visitor's browser. The parts that handle untrusted input, and where a vulnerability would matter most, are:

- **Look codes** pasted into the *Buddy code* field or passed in the URL (`?buddy=…`). They are base64, then zlib, then AMF3, then JSON, and are decoded by `web/src/domain/wardrobe.js` and `web/src/engine/amf3.js`.
- **Packages and data files** (`.bin`, XML, JSON, SVG) parsed by the engine and the texture library, in case someone serves modified assets from a fork.
- **Anything that writes to the page**, such as wardrobe labels, captions and icons.
- **`localStorage`** under the key `buddyrevival`.

Examples of issues we want to hear about:

- A crafted look code or URL that runs script, injects HTML, or reads or changes data it shouldn't (XSS).
- Input that freezes or crashes the tab, for example a zlib bomb or a deeply nested AMF3 payload.
- SVG artwork that can execute script when rendered.

Out of scope:

- GitHub Pages infrastructure, TLS and HTTP headers. Report those to GitHub.
- Problems that only happen in a fork serving its own modified assets, unless the same bug affects the original code.
- Missing security headers or "best practice" findings with no demonstrated impact.
- Social engineering, and attacks that require physical access to the victim's device.

## Reporting a vulnerability

**Please don't open a public issue for security problems.**

Report it privately through GitHub: go to the repository's **Security** tab and click **Report a vulnerability**:
<https://github.com/FilipeHSAraujo/BuddyRevival/security/advisories/new>

Include:

1. A description of the problem and its impact.
2. Steps to reproduce: the look code, URL or file involved.
3. Browser and operating system.
4. A suggested fix, if you have one.

## What to expect

This is a one-person hobby project, so the timelines are best effort:

- **Acknowledgement** within 7 days.
- **Assessment** within 14 days: whether the report is accepted, and how severe it is.
- **Updates** at least every 14 days until the issue is resolved.

If the report is **accepted**, I'll fix it on `main` (which redeploys the live site automatically), publish a GitHub security advisory, and credit you in it unless you'd rather stay anonymous.

If it's **declined**, I'll explain why. If you disagree, reply in the same advisory and we'll talk it through.

Please give me a reasonable chance to fix the problem before disclosing it publicly. 90 days is the default, and I'll coordinate the disclosure date with you.

Thanks for helping keep BuddyRevival safe.
