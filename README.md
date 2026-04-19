# LegionForge Media

Central source of truth for LegionForge brand assets — logos, icons, CSS tokens, and press files.

## Public asset base

| Path | Use for |
|------|---------|
| `https://assets.legionforge.org/current/` | Always-latest approved branding |
| `https://assets.legionforge.org/v1/` | Pinned to brand-v1.0.0 |

## Canonical assets

```
https://assets.legionforge.org/current/logos/legionforge-logo-color.svg
https://assets.legionforge.org/current/logos/legionforge-logo-transparent.png
https://assets.legionforge.org/current/logos/legionforge-logo-light.png
https://assets.legionforge.org/current/logos/legionforge-logo-dark.png
https://assets.legionforge.org/current/icons/favicon.svg
https://assets.legionforge.org/current/css/brand.css
```

## Brand CSS

```html
<link rel="stylesheet" href="https://assets.legionforge.org/current/css/brand.css">
```

Provides CSS custom properties for colors and logo URLs. See [docs/brand-guide.md](docs/brand-guide.md).

## Favicon

```html
<link rel="icon" href="https://assets.legionforge.org/current/icons/favicon.svg" type="image/svg+xml">
<link rel="icon" href="https://assets.legionforge.org/current/icons/favicon.ico" sizes="any">
```

## Repository layout

```
src/         Editable source files and WIP — not for external consumption
dist/        Published web-safe outputs served via GitHub Pages
  current/   Latest approved assets
  v1/        Pinned brand-v1.0.0 assets
docs/        Brand guide and release process
```

## Contributing

See [docs/release-process.md](docs/release-process.md) for how to update assets and cut a release.

All changes go through a PR. The validate workflow checks structural integrity before merge.
Do not link to `src/` files or raw branch URLs in external projects — use `assets.legionforge.org` URLs only.
