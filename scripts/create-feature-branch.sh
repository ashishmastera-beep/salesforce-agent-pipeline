#!/usr/bin/env bash
set -euo pipefail
KEY="${1:?Usage: create-feature-branch.sh <STORY-KEY>}"
git checkout main && git pull --ff-only
git checkout -b "feature/${KEY}" 2>/dev/null || git checkout "feature/${KEY}"
mkdir -p ".sf_docs/${KEY}"
echo "On branch feature/${KEY}"
