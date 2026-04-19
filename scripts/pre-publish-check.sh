#!/usr/bin/env bash
# LegionForge brand asset pre-publish check
# Run from repo root before any dist/ update or git push
# Usage: bash scripts/pre-publish-check.sh

set -euo pipefail
ERRORS=0

echo "=== 1. SVG color check ==="
BAD=$(grep -rEil "#447821|#00aad4|#33cc00" dist/ 2>/dev/null || true)
[ -n "$BAD" ] && echo "FAIL — wrong colors in: $BAD" && ERRORS=$((ERRORS+1)) || echo "OK"

echo "=== 2. Inkscape metadata check ==="
META=$(grep -rl "sodipodi\|xmlns:inkscape\|xmlns:sodipodi" dist/ 2>/dev/null || true)
[ -n "$META" ] && echo "FAIL — editor metadata in: $META" && ERRORS=$((ERRORS+1)) || echo "OK"

echo "=== 3. Favicon completeness ==="
FAV_ERRORS=0
for f in favicon.svg favicon.ico favicon-16x16.png favicon-32x32.png \
          apple-touch-icon.png android-chrome-192x192.png \
          android-chrome-512x512.png site.webmanifest; do
  [ -f "dist/current/icons/$f" ] || { echo "MISSING: $f"; FAV_ERRORS=$((FAV_ERRORS+1)); }
done
[ $FAV_ERRORS -eq 0 ] && echo "OK" || ERRORS=$((ERRORS+FAV_ERRORS))

echo "=== 4. Webmanifest validation ==="
python3 - <<'EOF'
import json, sys
try:
    m = json.load(open("dist/current/icons/site.webmanifest"))
    e = []
    if not m.get("name"): e.append("name is empty")
    if not m.get("short_name"): e.append("short_name is empty")
    tc = m.get("theme_color", "")
    if tc.lower() in ("", "#ffffff", "#fff"):
        e.append(f"theme_color suspect (looks like default white): {tc}")
    for icon in m.get("icons", []):
        src = icon.get("src", "")
        if src.startswith("/") and src.count("/") == 1:
            e.append(f"icon path looks root-only, may 404 in subdir: {src}")
    if e:
        [print("FAIL —", x) for x in e]
        sys.exit(1)
    else:
        print("OK")
except Exception as ex:
    print(f"FAIL — {ex}")
    sys.exit(1)
EOF
[ $? -ne 0 ] && ERRORS=$((ERRORS+1))

echo "=== 5. WIP remnant check ==="
WIP=$(git ls-files | grep -Ei "wip|draft|trial|prototype|Not-Web-Safe" 2>/dev/null || true)
[ -n "$WIP" ] && echo "FAIL — WIP files tracked in git: $WIP" && ERRORS=$((ERRORS+1)) || echo "OK"

echo "=== 6. manifest.json present in all version dirs ==="
MAN_ERRORS=0
for dir in dist/*/; do
  [ -f "${dir}manifest.json" ] || { echo "MISSING manifest.json in $dir"; MAN_ERRORS=$((MAN_ERRORS+1)); }
done
[ $MAN_ERRORS -eq 0 ] && echo "OK" || ERRORS=$((ERRORS+MAN_ERRORS))

echo "=== 7. Brand color presence check ==="
BRAND=$(grep -rlEi "#339933|#33ccff" dist/current/logos/ 2>/dev/null || true)
[ -z "$BRAND" ] && echo "WARN — brand colors not found in dist/current/logos/ SVGs" || echo "OK"

echo ""
if [ $ERRORS -eq 0 ]; then
  echo "ALL CHECKS PASSED — safe to push"
else
  echo "$ERRORS CHECK(S) FAILED — fix before pushing"
  exit 1
fi
