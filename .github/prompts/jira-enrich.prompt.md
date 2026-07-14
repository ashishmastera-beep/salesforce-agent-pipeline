---
mode: agent
description: Enrich a thin Jira story into a testable, development-ready story
---
Enrich Jira story ${input:storyKey}.

1. Fetch the story via Atlassian MCP (fallback: `bash scripts/fetch-jira-story.sh ${input:storyKey}`).
2. Inspect `force-app/` to ground every assumption in real metadata (object/field/class names).
3. Rewrite the story with: Business Context, Scope (in/out), BDD Acceptance Criteria
   (Given/When/Then — at least 3 scenarios incl. one negative), Technical Notes
   (real API names), and Open Questions with recommended answers.
4. Show me the enriched text for approval, THEN update the Jira description via MCP
   and add a comment "Enriched by AI agent — pending human review."
