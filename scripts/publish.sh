#!/bin/bash
# publish.sh — Publish BYaML schema version to S3 registry
# Migrado desde private-byaml-schema (local, brickstore) a breakingthecloud/byaml-spec (ByaML-001).
# El registry versionado real se construye/reinventa en ByaML-003 (schema.byaml.org v2).
# Estructura de assets servible: schema/v0.3/{schema,catalog,policies,relationships}.{json,yaml}
set -e

VERSION=${1:-"0.3"}
BUCKET="byaml-schema-registry"
PROFILE=${AWS_PROFILE:-"cc"}

echo "📦 Publishing BYaML schema v${VERSION} to s3://${BUCKET}/"

# Validate files exist (nueva estructura: schema/<version>/<asset>)
VERSION_DIR="schema/${VERSION}"
[[ -f "${VERSION_DIR}/schema.json" ]]      || { echo "❌ ${VERSION_DIR}/schema.json not found"; exit 1; }
[[ -f "${VERSION_DIR}/catalog.yaml" ]]     || { echo "❌ ${VERSION_DIR}/catalog.yaml not found"; exit 1; }
[[ -f "${VERSION_DIR}/policies.yaml" ]]    || { echo "❌ ${VERSION_DIR}/policies.yaml not found"; exit 1; }
[[ -f "${VERSION_DIR}/relationships.yaml" ]] || { echo "❌ ${VERSION_DIR}/relationships.yaml not found"; exit 1; }

# Upload
aws s3 cp "${VERSION_DIR}/schema.json"       "s3://${BUCKET}/v${VERSION}/schema.json"       --profile $PROFILE
aws s3 cp "${VERSION_DIR}/catalog.yaml"      "s3://${BUCKET}/v${VERSION}/catalog.yaml"      --profile $PROFILE
aws s3 cp "${VERSION_DIR}/policies.yaml"     "s3://${BUCKET}/v${VERSION}/policies.yaml"     --profile $PROFILE
aws s3 cp "${VERSION_DIR}/relationships.yaml" "s3://${BUCKET}/v${VERSION}/relationships.yaml" --profile $PROFILE

# Update manifest
MANIFEST=$(aws s3 cp "s3://${BUCKET}/manifest.json" - --profile $PROFILE 2>/dev/null || echo '{"latest":"","versions":[]}')
NEW_MANIFEST=$(echo "$MANIFEST" | python3 -c "
import sys, json
m = json.load(sys.stdin)
m['latest'] = '${VERSION}'
if '${VERSION}' not in m['versions']:
    m['versions'].append('${VERSION}')
print(json.dumps(m))
")
echo "$NEW_MANIFEST" | aws s3 cp - "s3://${BUCKET}/manifest.json" --content-type application/json --profile $PROFILE

echo "✅ Published v${VERSION} to s3://${BUCKET}/"
echo "   manifest: $NEW_MANIFEST"
