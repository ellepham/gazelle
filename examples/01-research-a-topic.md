# Example: Research a Topic

**Skill:** `/research`
**Time:** 15-30 minutes
**MCPs used:** Notion, Slack (optional: Circleback, Drive)

## Scenario

Your team is debating whether to build a bulk export feature. There's been some Slack chatter and a few customer requests, but nobody knows how strong the signal actually is.

## Run it

```
/research "bulk export feature demand"
```

## What happens

1. **Gazelle loads your context** from `context-training/domain.md` — your product, users, and terminology
2. **Launches parallel source-researcher agents** — one per connected tool:
   - Notion agent searches your knowledge base for specs, feedback, and decisions about exports
   - Slack agent searches relevant channels for conversations mentioning export, bulk, download
   - Filesystem agent checks for prior research on this topic
   - (If connected) Circleback agent searches meeting transcripts
   - (If connected) Drive agent searches shared documents
3. **Merges results** with source diversity checks — flags when all evidence traces back to one person
4. **Produces an evidence ledger** with confidence ratings

## Example output

```markdown
## Research: bulk export feature demand

**Sources searched:** Notion (12 pages), Slack (47 threads), filesystem (3 prior docs)
**Unique voices:** 8 (across 4 customers + 4 internal)
**Confidence:** MEDIUM — qualitative signal is consistent but no usage data yet

### Findings

| #   | What                                         | Who          | Source          | Confidence |
| --- | -------------------------------------------- | ------------ | --------------- | ---------- |
| 1   | 3 enterprise customers asked for CSV export  | CS team      | Slack #feedback | HIGH       |
| 2   | Current workaround: manual copy-paste        | Power users  | Notion feedback | MEDIUM     |
| 3   | Competitor launched bulk export last quarter | Product team | Slack #product  | HIGH       |
| 4   | Internal estimate: 2 sprint effort           | Engineering  | Notion RFC      | MEDIUM     |

### Evidence Quality

- 3 of 8 voices are from the same CS rep relaying customer feedback — really 5 independent signals
- No usage data (analytics not queried — connect Omni MCP for quantitative validation)
- Enterprise-only signal — zero SMB evidence

### Gaps

- No usage data on current export feature (how often is single export used?)
- No direct customer interviews (all evidence is secondhand via CS)
- No pricing/willingness-to-pay signal

### Suggested Next Steps

- `/insights "bulk export"` — synthesize these findings into actionable insights
- `/opportunity-sizing "bulk export"` — if analytics connected, size the opportunity
- `/competitive-analysis "CompetitorX export"` — deeper competitive comparison
```

## Key things to notice

- **Every finding cites its source** — no fabricated quotes or made-up data
- **Confidence ratings** are honest — MEDIUM because it's all qualitative
- **Gaps are explicit** — Gazelle tells you what's missing, not just what it found
- **Unique voice count** — catches echo chamber bias (one person repeating = one signal)
- **Next steps** — chains to the natural follow-up skills
