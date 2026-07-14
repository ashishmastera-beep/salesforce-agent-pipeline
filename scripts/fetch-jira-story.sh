#!/usr/bin/env bash
# Usage: ./scripts/fetch-jira-story.sh DEMO-2
# Requires .env with JIRA_SITE (e.g. yourname.atlassian.net), JIRA_EMAIL, JIRA_API_TOKEN
set -euo pipefail
source "$(dirname "$0")/../.env"
KEY="${1:?Usage: fetch-jira-story.sh <STORY-KEY>}"
curl -s -u "${JIRA_EMAIL}:${JIRA_API_TOKEN}" \
  "https://${JIRA_SITE}/rest/api/3/issue/${KEY}?fields=summary,description,status,labels" \
  | jq '{key: .key, summary: .fields.summary, status: .fields.status.name, description: .fields.description}'
