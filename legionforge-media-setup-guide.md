# LegionForge Media Repository Setup Guide

This guide is written so you can hand it to Claude Code and use it as a working spec for building `github.com/LegionForge/media` as the central source of truth for LegionForge logos, icons, social assets, press files, and published static branding assets.

The goal is:

1. One centralized media repository you control
2. Public, stable asset URLs usable by open-source repos
3. Clean, intentional updates through versioned releases
4. A setup that avoids raw GitHub branch URLs as the long-term production dependency

GitHub repository organization guidance recommends clear structure, predictable naming, and repository-level documentation so teams can navigate and automate around the repo more easily.[web:41][web:75]
GitHub Pages supports publishing to a custom domain, and GitHub releases are based on tags that mark specific points in repository history.[web:67][web:76]

---

## Recommended Architecture

Use this model:

- **Source of truth repo:** `github.com/LegionForge/media`
- **Published assets host:** `https://assets.legionforge.org`
- **Versioning model:** semantic-ish brand versions like `brand-v1.0.0`
- **Consumption model:** other repos link to published URLs, not to mutable branch files

Why this architecture:

- GitHub Pages gives you stable public hosting and supports custom domains.[web:66][web:69]
- Custom domains can be configured in repository Pages settings, and branch-based Pages publishing creates a `CNAME` file automatically.[web:67]
- Releases map to tags, which makes asset changes reviewable and reversible.[web:76][web:77]
- Keeping structure and documentation explicit improves maintainability and collaboration.[web:41][web:75]

---

## High-Level Repo Layout

Use a repo structure like this:

```text
media/
├─ README.md
├─ LICENSE
├─ .gitignore
├─ CODEOWNERS
├─ docs/
│  ├─ brand-guide.md
│  ├─ release-process.md
│  └─ publishing.md
├─ src/
│  ├─ logos/
│  │  ├─ primary/
│  │  ├─ alternate/
│  │  ├─ mark/
│  │  └─ lockups/
│  ├─ icons/
│  ├─ social/
│  ├─ press-kit/
│  └─ brand-guide/
├─ dist/
│  ├─ current/
│  │  ├─ logos/
│  │  ├─ icons/
│  │  ├─ social/
│  │  └─ manifest.json
│  ├─ v1/
│  │  ├─ logos/
│  │  ├─ icons/
│  │  ├─ social/
│  │  └─ manifest.json
│  └─ v2/
│     └─ ...
└─ .github/
   └─ workflows/
      ├─ validate-assets.yml
      └─ publish-pages.yml
```

### Folder Purpose

- `src/`: editable source files, originals, working exports, non-public maintainer material
- `dist/`: web-safe published outputs only
- `dist/current/`: latest approved public asset set
- `dist/v1/`, `dist/v2/`: versioned public asset sets for pinned consumers
- `docs/`: rules, usage, release notes, brand guidance

This follows general repository best practices of grouping related content into clear folders, keeping top-level docs obvious, and documenting structure in the repo itself.[web:41][web:75]

---

## Design Rules for the Repo

Use these repo rules from day one:

### 1. Treat `src/` and `dist/` differently

- `src/` is for editable masters and internal working files
- `dist/` is for published outputs only
- Open-source repos should consume files from `dist/`, not from `src/`

### 2. Prefer stable formats

- Logos: keep canonical web versions as `SVG`, plus fallback `PNG`
- Social cards: `PNG` or `JPG` depending on quality/size tradeoff
- Press kit: zip bundles and PDF guide if needed
- Avoid publishing giant unoptimized binaries unless you truly need them

### 3. Keep names boring and predictable

Examples:

- `legionforge-logo-primary-dark.svg`
- `legionforge-logo-primary-light.svg`
- `legionforge-mark-monochrome.svg`
- `legionforge-social-og-default.png`

Predictable naming improves discoverability and automation.[web:41]

### 4. Document what is canonical

In `README.md` and `docs/brand-guide.md`, explicitly say:

- Which logo is the default canonical logo
- Which variants are allowed on dark/light backgrounds
- Which files are deprecated
- Which published path consumers should use

---

## Consumer URL Strategy

Use **published URLs** like these in other LegionForge repos:

```text
https://assets.legionforge.org/current/logos/legionforge-logo-primary-dark.svg
https://assets.legionforge.org/v1/logos/legionforge-logo-primary-dark.svg
```

Use two access modes:

### `current/`

Use when you want all projects to inherit the latest approved branding automatically.

Pros:
- One update changes all consumers
- Easy to manage for org-wide visual consistency

Cons:
- Bigger blast radius if a bad asset is published

### `v1/`, `v2/`, etc.

Use when a repo should pin to a known approved version.

Pros:
- Predictable, reviewable upgrades
- Safer for docs, websites, OSS packages, and screenshots

Cons:
- Each repo must intentionally upgrade versions

GitHub releases are tied to tags, which makes this versioned model natural and auditable.[web:76][web:77]

---

## What Not to Use as the Primary Production Pattern

Do **not** make `raw.githubusercontent.com/.../main/...` your primary long-term production asset pattern.

Why:

- Mutable branch references are harder to reason about operationally
- Cache behavior around raw GitHub asset delivery can be inconvenient for immediate rollout expectations, especially when people expect branch changes to propagate like a proper versioned asset host.[web:43][web:46]
- It blurs the line between source files and published assets

Raw links are acceptable for quick experiments, but they are not the cleanest system for controlled brand distribution.[web:43][web:46]

---

## GitHub Pages Setup

GitHub Pages supports custom domains for published sites and assets.[web:66][web:69]

### Recommended Domain Setup

Use a dedicated subdomain:

```text
assets.legionforge.org
```

Why a subdomain is better than using the root domain:

- Clear separation of concerns
- Easier DNS management
- Cleaner mental model for public asset hosting

### GitHub Pages Steps

1. Create the `LegionForge/media` repository
2. Push your initial structure
3. In GitHub repo settings, open **Pages**
4. Choose publishing from either:
   - a branch, or
   - a GitHub Actions workflow
5. Set the custom domain to `assets.legionforge.org`
6. Enable HTTPS after DNS is correct

GitHub Docs states that repo admins can configure a custom domain in the Pages settings, and branch-based publishing creates a `CNAME` file in the publishing source branch automatically.[web:67]

### DNS Notes

You will need to point your DNS for `assets.legionforge.org` to GitHub Pages according to GitHub Pages custom domain instructions.[web:66][web:67][web:74]

---

## Suggested Publishing Model

Use **source on default branch** and **publish public assets through GitHub Actions**.

Recommended branch strategy:

- `main`: source of truth for repo content
- optional `gh-pages`: deployed static output, if using a Pages deployment action

Why this is better than manually editing a published branch:

- Clean separation between authored files and deployed output
- Easier automation
- Fewer accidental deploy mistakes

---

## Suggested Release Model

Use a simple release process:

### Release naming

- `brand-v1.0.0`
- `brand-v1.1.0`
- `brand-v2.0.0`

### Versioning meaning

- **Patch**: small fixes, file optimization, metadata cleanup, non-breaking corrections
- **Minor**: additive assets, new variants, new social cards, new icons
- **Major**: changed canonical branding, renamed files, deprecated paths, changed default logo system

### Release flow

1. Make asset changes in `src/`
2. Export/update approved files in `dist/current/`
3. If release is breaking or materially new, copy approved public outputs into a new version folder like `dist/v2/`
4. Update `manifest.json`
5. Open PR and review
6. Merge to `main`
7. Create tag and GitHub release
8. Publish Pages deployment

GitHub says releases are based on tags, and managing releases through drafts/publishing is a supported pattern.[web:76][web:77]

---

## Example `manifest.json`

Put one in each published version directory.

```json
{
  "name": "LegionForge brand assets",
  "version": "v1",
  "releaseTag": "brand-v1.0.0",
  "updatedAt": "2026-04-19T00:00:00Z",
  "canonical": {
    "primaryLogoDark": "/v1/logos/legionforge-logo-primary-dark.svg",
    "primaryLogoLight": "/v1/logos/legionforge-logo-primary-light.svg",
    "mark": "/v1/logos/legionforge-mark-monochrome.svg"
  },
  "deprecated": []
}
```

This helps both humans and tooling discover the current canonical assets.

---

## Suggested Root `README.md`

Your root README should include:

- Purpose of the repository
- Difference between `src/` and `dist/`
- Canonical public base URL
- Current brand release tag
- Quick links to default logo files
- Rules for contributors
- Release process summary

Example top section:

```md
# LegionForge Media

Central source of truth for LegionForge brand and marketing assets.

## Public asset base

- Current: `https://assets.legionforge.org/current/`
- Versioned: `https://assets.legionforge.org/v1/`

## Canonical assets

- Primary logo dark: `https://assets.legionforge.org/current/logos/legionforge-logo-primary-dark.svg`
- Primary logo light: `https://assets.legionforge.org/current/logos/legionforge-logo-primary-light.svg`
- Mark: `https://assets.legionforge.org/current/logos/legionforge-mark-monochrome.svg`
```

---

## Suggested `CODEOWNERS`

GitHub repository best-practice guidance commonly recommends clear ownership and documentation so changes are reviewable and responsibility is obvious.[web:11][web:41]

Example:

```text
* @LegionForge
/src/logos/ @LegionForge
/dist/ @LegionForge
/docs/ @LegionForge
/.github/workflows/ @LegionForge
```

If you later add maintainers, make asset review explicit.

---

## Suggested `.gitignore`

Example:

```gitignore
.DS_Store
Thumbs.db
*.tmp
*.bak
*.psd
*.ai
*.sketch
*.xcf
node_modules/
```

If you want to keep editable design masters in another private design repo, that is often cleaner than storing every giant proprietary source file here. That last point is not directly sourced.

---

## Git LFS Guidance

Use Git LFS only if you start storing larger binaries that would otherwise bloat Git history. GitHub documents Git LFS specifically for handling large files in repositories.[web:26]

Use LFS if you expect things like:

- high-resolution marketing renders
- large screenshots
- video clips
- heavy source artifacts

Do **not** default everything into LFS if most of your published assets are small SVGs and optimized PNGs. That adds operational complexity without much gain. This recommendation is not directly sourced.

---

## GitHub Actions: What Claude Code Should Build

Ask Claude Code to create the following:

### 1. Validation workflow

Create `.github/workflows/validate-assets.yml` that:

- runs on PRs and pushes to `main`
- validates that required directories exist
- checks for duplicate filenames in published folders
- ensures every published version has a `manifest.json`
- optionally checks file size thresholds for web assets
- fails if `dist/current/` is missing canonical logo files

### 2. Publish workflow

Create `.github/workflows/publish-pages.yml` that:

- runs on push to `main` and optionally on release tags
- publishes the contents of `dist/` to GitHub Pages
- supports custom domain deployment for `assets.legionforge.org`

GitHub Pages supports publishing through repository settings and GitHub Actions workflows.[web:66][web:67]

### 3. Release helper

Optionally create a release workflow that:

- creates or validates release tags
- attaches zip bundles for press-kit assets
- generates release notes

GitHub releases are built around tags, and release automation through Actions is a common GitHub pattern.[web:76][web:77][web:73]

---

## Minimal Claude Code Task Prompt

You can paste this into Claude Code:

```md
Build a production-ready GitHub repository structure for `github.com/LegionForge/media`.

Goals:
- This repo is the central source of truth for LegionForge logos, icons, social media assets, press-kit files, and brand docs.
- Public assets must be published through GitHub Pages on `assets.legionforge.org`.
- Open-source repos in `github.com/LegionForge` should reference stable published URLs, not raw branch file URLs.
- Support both `current/` and versioned paths like `v1/` and `v2/`.
- Use GitHub releases/tags such as `brand-v1.0.0` for intentional asset rollouts.

Please generate:
1. A clean folder structure with `docs/`, `src/`, `dist/current/`, and `dist/v1/`
2. Starter placeholder README files for each major folder
3. A root `README.md` documenting purpose, public URLs, canonical assets, and contributor rules
4. A `docs/brand-guide.md` and `docs/release-process.md`
5. A `CODEOWNERS` file
6. A `.gitignore`
7. A `dist/current/manifest.json` and `dist/v1/manifest.json`
8. A GitHub Actions workflow to validate published assets
9. A GitHub Actions workflow to deploy `dist/` to GitHub Pages
10. Sensible comments in workflows so I can maintain them later

Constraints:
- Keep `src/` for editable/internal source assets and `dist/` for public published assets
- Assume canonical asset names like `legionforge-logo-primary-dark.svg` and `legionforge-mark-monochrome.svg`
- Optimize for clarity, maintainability, and safe versioned updates
- Do not use raw.githubusercontent.com URLs as the primary production pattern
```

---

## Extra Improvement Ideas

Useful enhancements you may want later:

- Add a machine-readable asset catalog JSON for tooling and websites
- Add image optimization in CI before publish
- Add a deprecation map for renamed assets
- Add a changelog page for brand asset releases
- Add a small landing page at `assets.legionforge.org` that documents the available files and versions

GitHub Pages can host documentation-style static pages in addition to raw assets, which makes this dual-purpose asset-and-docs setup practical.[web:69]

---

## Recommended First Implementation Order

1. Create the repo
2. Add the directory structure
3. Add placeholder public assets and manifests
4. Add root documentation and docs pages
5. Add validation workflow
6. Add Pages deployment workflow
7. Configure custom domain in Pages settings
8. Set DNS
9. Enable HTTPS
10. Create first tagged release like `brand-v1.0.0`

GitHub Pages custom domain setup and HTTPS support are part of the documented Pages flow.[web:66][web:74]

---

## Final Recommendation

The right model is:

- **GitHub repo for authoring and control**
- **GitHub Pages custom subdomain for public consumption**
- **tags/releases for intentional updates**
- **`current/` plus versioned directories for safety and flexibility**

That gives you centralized control, clean public URLs, and a sane rollout path across your LegionForge repos.[web:66][web:76]
