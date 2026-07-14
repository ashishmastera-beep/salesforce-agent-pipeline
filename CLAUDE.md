# Salesforce Agent Pipeline — Claude Code Directives

Same pipeline as .github/copilot-instructions.md (read it — it is the source of truth).
Agents live in .claude/agents/. Rules in .claude/rules/salesforce/ apply by file type:
apex.md -> *.cls/*.trigger, lwc.md -> lwc/**, flow.md -> *.flow-meta.xml.

Invoke agents as:
- @sf-architect "design DEMO-2"
- @sf-developer "implement DEMO-2"
- @sf-devops "create PR for DEMO-2" / "deploy DEMO-2 to devall"

Jira access: Atlassian MCP server (or scripts/fetch-jira-story.sh fallback).
Never commit .env. Never deploy to prodsim from the laptop.
