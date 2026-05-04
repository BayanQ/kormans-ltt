# Kormans LTT Calculator

Ontario Land Transfer Tax calculator — static HTML/CSS/JS, deployed on Netlify as an embeddable iframe widget.

## What this project is

A single-page calculator for Ontario provincial and Toronto municipal land transfer taxes (LTT). Supports first-time home buyer (FTHB) rebates. Designed to be embedded in iframes (e.g., on the Kormans.ca site). No build step, no npm dependencies, no framework.

## Key files

| File | Purpose |
|------|---------|
| `index.html` | The entire app — embedded CSS, JS, and markup in one file |
| `test.html` | QA debugger page; loads the calculator in an iframe and logs postMessage resize events |
| `netlify.toml` | Netlify deploy config — publish dir, CORS headers, cache, CSP |
| `qa-start.sh` | Start local QA server via `npx serve`; finds a free port, saves PID |
| `qa-stop.sh` | Stop local QA server by reading saved PID |

## Conventions

- **Single-file app.** All CSS and JS live inside `index.html`. Do not split into separate asset files.
- **No build pipeline.** No `package.json`, no bundler, no transpilation. What you write is what ships.
- **View switching.** The UI has three views: `form`, `results`, `breakdown`. Toggle via `showView(id)`.
- **iframe postMessage protocol.** On content resize, `index.html` posts `{ type: 'ltt-resize', height: N }` to `window.parent`. Parent windows use this to auto-size the iframe. Do not remove or rename this protocol.
- **Currency formatting.** The price input auto-formats with comma insertion as the user types. Preserve this behavior on any input changes.
- **CSS custom properties.** Colors, spacing, and radii use CSS variables defined in `:root`. Use these; don't hardcode raw values.
- **Shell scripts are executable.** `qa-start.sh` and `qa-stop.sh` must remain chmod +x.
- **QA runtime files are gitignored.** `.qa-server.pid` and `.qa-server.log` are excluded from git — do not commit them.

## Tax brackets (hardcoded in index.html)

Tax rates are encoded as bracket arrays in JS. Changes to Ontario or Toronto LTT legislation require updating these arrays directly. There is no external config file.

- **Provincial LTT**: 5 tiers up to 2.5% on $2M+
- **Toronto MLTT (residential 1–2 units)**: Same base tiers, then escalates beyond $2M up to 8.6%
- **Toronto MLTT (other/commercial)**: Different high-bracket structure, max 6.5%
- **FTHB rebates**: Provincial max $4,000; Toronto max $4,475 (residential only)

## QA workflow

```bash
./qa-start.sh    # start local server, outputs the URL
open http://localhost:<port>/test.html   # inspect iframe postMessage events
./qa-stop.sh     # stop server
```

## Deployment

- **Platform**: Netlify
- **Project ID**: `6301f91f-0075-477b-b01c-c9ed84b4382b`
- **Publish directory**: repo root (no build output folder)
- **Branch**: deploys from `main`
- **Config file**: `netlify.toml`

Deploy by merging to `main`. Netlify auto-deploys on push.

## Never-violate rules

1. **Do not add a build step or package.json** unless explicitly authorized. This is intentionally dependency-free.
2. **Do not split `index.html`** into separate CSS/JS files — the single-file constraint is intentional for the iframe embed use case.
3. **Do not remove the postMessage resize protocol** — it breaks iframe embedding on partner sites.
4. **Do not set `X-Frame-Options: DENY` or `SAMEORIGIN`** — this widget must be embeddable cross-origin.
5. **Do not merge directly to `main` without QA sign-off** — all changes go through staging first.
