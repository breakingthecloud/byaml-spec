#!/bin/bash
# publish.sh — Publish BYaML schema version (v0.4+) to S3 registry (ByaML-003)
#
# Estructura del registry servible (schema.byaml.org v2):
#   s3://byaml-schema-registry/
#     manifest.json                        → { latest: "0.4.0", versions: [...] }
#     v0.4.0/schema.json                   (copia de graph-v0.4.schema.json)
#     v0.4.0/catalog.yaml
#     v0.4.0/relationships.yaml
#     v0.4.0/policies.yaml
#
# Uso:
#   ./scripts/publish.sh 0.4.0        # publica schema/v0.4 → v0.4.0/
#   AWS_PROFILE=dev ./scripts/publish.sh 0.4.1
#
# Requiere: aws cli, python3 (para manifest merge).
set -e

VERSION=${1:?"usage: publish.sh <version>  (ej. 0.4.0)"}
# mapea "0.4.0" → carpeta fuente "schema/v0.4" (el spec versiona como v0.4)
SHORT="${VERSION%.*}"; [[ "$SHORT" == "0.4" ]] && SHORT="0.4"
VERSION_DIR="schema/v${SHORT}"
[[ -d "${VERSION_DIR}" ]] || VERSION_DIR="schema/${SHORT}"
BUCKET="byaml-schema-registry"
PROFILE=${AWS_PROFILE:-"cc"}
PREFIX="v${VERSION}"

echo "📦 Publishing BYaML schema v${VERSION} → s3://${BUCKET}/${PREFIX}/ (src=${VERSION_DIR})"

# Validate source files (estructura v0.4)
[[ -f "${VERSION_DIR}/graph-v0.4.schema.json" ]] || { echo "❌ ${VERSION_DIR}/graph-v0.4.schema.json not found"; exit 1; }
[[ -f "${VERSION_DIR}/catalog.yaml" ]]          || { echo "❌ ${VERSION_DIR}/catalog.yaml not found"; exit 1; }
[[ -f "${VERSION_DIR}/relationships.yaml" ]]    || { echo "❌ ${VERSION_DIR}/relationships.yaml not found"; exit 1; }
[[ -f "${VERSION_DIR}/policies.yaml" ]]         || { echo "⚠ no policies.yaml in ${VERSION_DIR} — skipping policies" ; POLICIES_SKIP=1; }

# Upload (asset → key URL)
aws s3 cp "${VERSION_DIR}/graph-v0.4.schema.json" "s3://${BUCKET}/${PREFIX}/schema.json" --profile "$PROFILE"
aws s3 cp "${VERSION_DIR}/catalog.yaml"           "s3://${BUCKET}/${PREFIX}/catalog.yaml" --profile "$PROFILE"
aws s3 cp "${VERSION_DIR}/relationships.yaml"     "s3://${BUCKET}/${PREFIX}/relationships.yaml" --profile "$PROFILE"
if [[ -z "$POLICIES_SKIP" ]]; then
  aws s3 cp "${VERSION_DIR}/policies.yaml"        "s3://${BUCKET}/${PREFIX}/policies.yaml" --profile "$PROFILE"
fi

# Upload manifest (latest FIRST, then versions)
MANIFEST_FILE=$(mktemp)
aws s3 cp "s3://${BUCKET}/manifest.json" "$MANIFEST_FILE" --profile "$PROFILE" 2>/dev/null || echo '{"latest":"","versions":[]}' > "$MANIFEST_FILE"
python3 - "$VERSION" "$MANIFEST_FILE" <<'PY'
import json, sys
version, path = sys.argv[1], sys.argv[2]
with open(path) as f:
    m = json.load(f)
m["latest"] = version
if version not in m["versions"]:
    m["versions"].append(version)
with open(path, "w") as f:
    json.dump(m, f, indent=2)
PY
aws s3 cp "$MANIFEST_FILE" "s3://${BUCKET}/manifest.json" --content-type application/json --profile "$PROFILE"
rm -f "$MANIFEST_FILE"

echo "✅ Published v${VERSION} to s3://${BUCKET}/${PREFIX}/"
echo "   manifest latest=${VERSION}"