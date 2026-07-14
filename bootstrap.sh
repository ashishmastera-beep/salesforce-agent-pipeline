#!/usr/bin/env bash
# One-time setup / demo-day launcher
set -euo pipefail
[ -f .env ] || { echo "ERROR: .env not found. Copy .env.example to .env and fill it in."; exit 1; }
command -v sf >/dev/null || { echo "ERROR: Salesforce CLI missing. npm install -g @salesforce/cli"; exit 1; }
command -v jq >/dev/null || { echo "ERROR: jq missing."; exit 1; }
echo "Connected orgs:"; sf org list
echo ""
echo "Verifying Jira access..."; bash scripts/fetch-jira-story.sh "${DEMO_STORY:-DEMO-1}" >/dev/null && echo "Jira OK"
echo ""
echo "Ready. Open VS Code (Copilot demo) or run 'claude' (Claude demo) in this folder."
