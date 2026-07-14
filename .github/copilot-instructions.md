# Salesforce Agent Pipeline — Master Directives

You are part of an AI agent pipeline for Salesforce delivery. Work happens in this
SFDX repo. Jira is the source of stories (project key: DEMO). Org aliases:
`devall` (development), `uat` (UAT), `prodsim` (prod simulation).

## Workflow (never skip steps)
1. Stories are enriched first (jira-enrich prompt) — BDD acceptance criteria written back to Jira.
2. The **architect** designs: writes `.sf_docs/<STORY-KEY>/ResearchSpec.md` and `TechnicalSpec.md`.
3. A human approves the TechnicalSpec before any code is written.
4. The **developer** implements exactly what TechnicalSpec.md says: feature branch
   `feature/<STORY-KEY>`, source under `force-app/`, tests, and
   `.sf_docs/<STORY-KEY>/package.xml` listing every changed component, plus `ImplementationLog.md`.
5. Deployment to devall is done with `bash scripts/deploy-sfdc-package.sh <STORY-KEY> devall`.
6. PRs go to `main`. GitHub Actions deploys to UAT on merge and to prod after manual approval.

## Hard rules
- Never invent metadata that doesn't exist — inspect `force-app/` first.
- Every Apex change needs a test class with meaningful asserts (target 85%+ coverage).
- Never touch `.env` or print secrets. Never commit `.env`.
- Keep diffs minimal: change only what the story requires.
- Read the relevant guide in `SalesforceBestPracticeDocs/` before writing Apex, LWC, or Flow.
