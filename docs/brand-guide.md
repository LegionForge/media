# LegionForge Brand Guide

## Colors

| Name | Hex | Usage |
|------|-----|-------|
| Forest Green | `#339933` | Primary — shield, anvil, structural elements |
| Sky Cyan | `#33ccff` | Accent — LF letterforms |
| Black | `#000000` | On dark backgrounds |
| White | `#ffffff` | On light backgrounds |

Both hex values are web-safe.

## Logo

The logo is a shield with an anvil on top and the letters **LF** inside.

### Canonical files

| File | Use when |
|------|----------|
| `legionforge-logo-color.svg` | Default — web, docs, UI |
| `legionforge-logo-transparent.png` | Overlay on any background |
| `legionforge-logo-light.png` | On white/light backgrounds |
| `legionforge-logo-dark.png` | On dark/black backgrounds |
| `favicon.svg` | Browser tab, app icon |

### Do not use

- `src/` files are editable masters and are not for embedding in external projects
- Raw branch URLs (`raw.githubusercontent.com`) — use `assets.legionforge.org` URLs instead
- The B&W source SVG (`LegionForge_vector_bw_1024.svg`) is an authoring file, not a published asset

## Public URLs

```
https://assets.legionforge.org/current/logos/legionforge-logo-color.svg
https://assets.legionforge.org/current/logos/legionforge-logo-transparent.png
https://assets.legionforge.org/current/css/brand.css
```

Use `/current/` when you want all consumers to inherit the latest approved branding automatically.
Use `/v1/` (etc.) when you need to pin to a specific approved release.

## CSS usage

```html
<link rel="stylesheet" href="https://assets.legionforge.org/current/css/brand.css">
```

Then use CSS custom properties:

```css
.my-element {
  color: var(--lf-green);
  background: var(--lf-cyan);
}
```
