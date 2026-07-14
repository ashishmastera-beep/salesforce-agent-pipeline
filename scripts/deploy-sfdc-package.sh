#!/usr/bin/env bash
# Usage: ./scripts/deploy-sfdc-package.sh DEMO-2 devall [--test-level RunLocalTests]
set -euo pipefail
KEY="${1:?Usage: deploy-sfdc-package.sh <STORY-KEY> <ORG-ALIAS> [--test-level X]}"
ORG="${2:?Missing org alias (devall|uat|prodsim)}"
shift 2
MANIFEST=".sf_docs/${KEY}/package.xml"
[ -f "$MANIFEST" ] || { echo "ERROR: $MANIFEST not found — run the developer agent first."; exit 1; }
echo ">>> Deploying ${KEY} to ${ORG} using ${MANIFEST}"
sf project deploy start -x "$MANIFEST" -o "$ORG" --wait 20 "$@"
echo ">>> Deploy complete. Verify in org: sf org open -o ${ORG}"
