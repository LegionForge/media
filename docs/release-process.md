# Release Process

## Version naming

Tags follow `brand-vMAJOR.MINOR.PATCH`:

| Change type | Version bump | Example |
|-------------|-------------|---------|
| File optimization, metadata, non-breaking corrections | Patch | `brand-v1.0.1` |
| New variants, new icons, new social assets | Minor | `brand-v1.1.0` |
| Renamed files, deprecated paths, new canonical logo | Major | `brand-v2.0.0` |

## Release flow

1. Edit source files in `src/logos/`
2. Export approved outputs to `dist/current/logos/` (and `css/`, `icons/` as needed)
3. Update `dist/current/manifest.json` — bump `updatedAt`
4. If this is a major or minor release, copy `dist/current/` contents into a new `dist/vN/` directory and update that manifest's `version` and `releaseTag` fields
5. Open a PR and review the diff
6. Merge to `main` — Pages deployment triggers automatically
7. Create a GitHub release with tag `brand-vX.Y.Z`

## Adding a new version directory

```bash
cp -r dist/current dist/v2
# update dist/v2/manifest.json: version, releaseTag, baseUrl, updatedAt
```

Consumers pinned to `/v1/` are unaffected until they explicitly opt in to `/v2/`.

## Deprecating an asset

1. Add the old path to the `deprecated` array in the relevant `manifest.json`
2. Keep the file in place for at least one major version cycle
3. Remove in the next major bump
