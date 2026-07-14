# Salesforce AI Agent Pipeline — Working Demo Kit

Ready-to-use scaffold for demoing an agentic Salesforce delivery pipeline
(Jira enrichment → architect → developer → deploy → PR → UAT → prod) with
**GitHub Copilot** (Demo 1) and **Claude Code** (Demo 2) as interchangeable engines.

Everything below runs on a personal laptop with free/trial accounts.

---

## Part A — One-time setup (do this over 1–2 evenings)

### A1. Accounts (all free except AI tools)
1. **Jira Cloud Free** → create site, project key **DEMO**.
2. **Salesforce Developer Edition orgs** (free): create 2 (or 3):
   dev = `devall`, UAT = `uat`, optional prod = `prodsim`.
3. **GitHub**: free account, create private repo `salesforce-agent-pipeline`.
4. **Copilot Pro**: start the 30-day free trial (needed for agent mode + MCP).
5. **Claude Pro** ($20/mo): only when you're ready to build Demo 2.

### A2. Laptop tools
```bash
# Install Git, Node LTS, VS Code, jq, then:
npm install -g @salesforce/cli
sf org login web -a devall     # browser login to dev org
sf org login web -a uat        # browser login to UAT org
```

### A3. This repo
```bash
git init && git add -A && git commit -m "Agent pipeline scaffold"
git remote add origin <your-github-repo-url> && git push -u origin main
cp .env.example .env           # fill in Jira site/email/API token
bash bootstrap.sh              # verifies sf, jq, orgs, Jira access
```
Create the Jira API token at id.atlassian.com → Security → API tokens.

### A4. Seed the dev org
```bash
sf project deploy start -d force-app -o devall   # pushes AccountReviewBatch + test
```
Then in `devall` Setup, create custom field **Account.Last_Reviewed__c (Date)** —
DEMO-1 needs it to exist so the agent can discover it. Retrieve it into the repo:
```bash
sf project retrieve start -m "CustomField:Account.Last_Reviewed__c" -o devall
git add -A && git commit -m "Seed Last_Reviewed__c field" && git push
```

### A5. Create the 3 demo stories in Jira (paste these thin summaries as-is)
- **DEMO-1** — "Update the account review batch to also stamp the Last Reviewed date"
- **DEMO-2** — "New component on Account page to preview account health summary"
- **DEMO-3** — "Guided screen flow for case escalation"

(They're deliberately vague — that's what makes the enrichment step impressive.)

### A6. Wire up Copilot
1. Install **GitHub Copilot** + **Copilot Chat** extensions in VS Code, sign in.
2. Open this repo. VS Code reads `.vscode/mcp.json` → click **Start** on the
   `atlassian` and `github` MCP servers and complete the OAuth prompts.
3. Verify: in Copilot Chat (Agent mode) ask *"fetch Jira issue DEMO-1"* — it should
   call the Atlassian MCP tool and show your story.
4. Chat modes appear in the Copilot Chat mode dropdown: `sf-architect`,
   `sf-developer`, `sf-devops`. Prompts run as `/jira-enrich`.

### A7. Wire up GitHub Actions (the DevOps agent)
1. Get auth URLs:
   `sf org display --verbose -o uat` → copy **Sfdx Auth Url**.
2. Repo → Settings → Secrets → Actions: add `SF_UAT_AUTH_URL` (and `SF_PROD_AUTH_URL`).
3. Repo → Settings → Environments → create **prod** → add yourself as
   **Required reviewer**. That's your live approval gate.

### A8. Wire up Claude Code (Demo 2)
```bash
# after subscribing to Claude Pro and installing Claude Code:
cd salesforce-agent-pipeline
claude mcp add --transport http atlassian https://mcp.atlassian.com/v1/sse
claude          # agents auto-load from .claude/agents/
```

---

## Part B — Demo-day script (~20 min per tool)

> Rehearse fully at least once. Run DEMO-1 the night before as a dry run;
> keep DEMO-2 (LWC) as your live centerpiece — it demos best visually.

| # | Step | What you do | What audience sees |
|---|------|-------------|--------------------|
| 1 | Show the problem | Open Jira DEMO-2 | A thin, vague story |
| 2 | **Enrich** | Copilot Chat: `/jira-enrich` → storyKey DEMO-2 (Claude: ask the jira-enrich flow) | Agent pulls story via MCP, inspects repo, proposes BDD criteria; you approve; **refresh Jira — story is rewritten** |
| 3 | **Architect** | Switch to `sf-architect` mode → "design DEMO-2" | ResearchSpec.md + TechnicalSpec.md appear in `.sf_docs/DEMO-2/`, with open questions answered |
| 4 | Human gate #1 | Skim TechnicalSpec, say "approved" | Governance story: AI proposes, human disposes |
| 5 | **Develop** | Switch to `sf-developer` mode → "implement DEMO-2" | Feature branch, LWC bundle + Apex controller + test + package.xml written live |
| 6 | **Deploy to dev** | `bash scripts/deploy-sfdc-package.sh DEMO-2 devall` | Green deploy; `sf org open -o devall` → show the component on the Account page |
| 7 | **PR** | `sf-devops` mode → "create PR for DEMO-2" | PR opens on GitHub with story link + summary |
| 8 | Human gate #2 | Merge the PR in the browser | — |
| 9 | **DevOps** | Watch Actions tab | UAT deploy runs tests automatically; **prod job waits for your approval**; click Approve → prod deploys |
| 10 | Repeat fast | DEMO-1 (batch) live if time; DEMO-3 (flow) pre-baked on a branch | Same pipeline generalizes across Apex/LWC/Flow |

**Talking points**
- The repo scaffold is identical for both tools — swap the engine, keep the process.
- Rules auto-apply by file type (`.github/instructions/` ↔ `.claude/rules/`) — show one file.
- Two human gates (spec approval, PR merge) + one release gate (prod environment).

**Backup plan:** keep a `demo-backup` branch with all three stories fully implemented,
so if a live generation stumbles you switch branches and continue from deploy.

---

## Part C — Known rough edges
- Flow XML (DEMO-3) is the flakiest for any AI tool — keep it to 2–3 screens and
  always verify in Flow Builder. Pre-bake it.
- Copilot Free tier is too limited for agent mode demos — use the Pro trial.
- Dev Edition orgs have no sandboxes; we simulate the landscape with separate
  Dev Edition orgs, which is exactly right for a personal demo.
- Rate limits exist on both Pro plans; avoid burning them the morning of the demo.
