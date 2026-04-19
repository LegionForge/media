# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Purpose

`github.com/LegionForge/media` is the central source of truth for LegionForge brand and marketing assets. It has two roles: **authoring** (source files in `src/`) and **publishing** (web-safe outputs in `dist/`, served via GitHub Pages at `https://assets.legionforge.org`).

Other LegionForge repos consume assets via stable published URLs — never via `raw.githubusercontent.com` branch URLs.

## Repository Architecture

```
src/          # Editable masters, working exports — not for public consumption
dist/
  current/    # Latest approved public asset set (consumers that always want latest)
  v1/         # Pinned v1 public assets (consumers that pin to a known release)
  v2/         # etc.
docs/         # Brand rules, release process, publishing notes
.github/workflows/
  validate-assets.yml   # Runs on PR/push — checks structure + manifest presence
  publish-pages.yml     # Deploys dist/ to GitHub Pages on push to main
```

The `src/` vs `dist/` split is the critical invariant: open-source repos link to `dist/`, maintainers edit in `src/`.

## Asset Naming Convention

Canonical file names use the pattern `legionforge-{type}-{variant}-{theme}.{ext}`:

- `legionforge-logo-primary-dark.svg`
- `legionforge-logo-primary-light.svg`
- `legionforge-mark-monochrome.svg`
- `legionforge-social-og-default.png`

SVG is canonical for logos/marks; PNG is fallback or for social/press assets.

## Versioning and Releases

Release tags follow `brand-vMAJOR.MINOR.PATCH`:
- **Patch** — fixes, optimization, non-breaking corrections
- **Minor** — additive assets, new variants
- **Major** — renamed/deprecated paths, changed canonical branding

Release flow: edit `src/` → export to `dist/current/` → copy to new version dir if breaking → update `manifest.json` → PR → merge → tag → Pages deploys.

## manifest.json

Every published version directory (`dist/current/`, `dist/v1/`, etc.) must contain a `manifest.json` — the validation workflow enforces this. It declares the canonical asset paths for that version. The validate workflow will fail if `dist/current/` is missing canonical logo files or any version directory lacks a manifest.

## Public URLs

```
https://assets.legionforge.org/current/logos/legionforge-logo-primary-dark.svg
https://assets.legionforge.org/v1/logos/legionforge-logo-primary-dark.svg
```

`current/` — always the latest approved set; `v1/` etc. — pinned for stability.

## Pre-commit Scrub (Public Repo)

Before any commit, verify no internal IPs, SSH usernames, or API keys are staged. See global CLAUDE.md for the full scrub checklist and grep command.

## Git Auth Note

If pushing to GitHub fails, run:
```bash
gh auth switch --user jp-cruz && gh auth setup-git
```
