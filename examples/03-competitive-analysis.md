# Example: Run a Competitive Analysis

**Skill:** `/competitive-analysis`
**Time:** 20-60 minutes
**MCPs used:** Slack, Notion (optional: web search, Circleback)

## Scenario

A competitor just launched a feature that overlaps with your roadmap. Sales is asking "how do we compare?" and leadership wants a positioning response.

## Run it

```
/competitive-analysis "CompetitorX"
```

## What happens

1. **Searches internal sources first** — Slack (deal discussions, lost deals, competitive mentions), Notion (competitive intel pages, sales battlecards), Circleback (customer calls mentioning the competitor)
2. **Web search** — the competitor's website, changelog, pricing page, reviews (G2, Capterra)
3. **Structures everything** into a comparison matrix with evidence quality ratings

## Example output

```markdown
## Competitive Analysis: CompetitorX

**Date:** 2026-04-13
**Sources:** Slack (23 threads), Notion (4 pages), web (pricing page, 3 review sites)
**Confidence:** MEDIUM-HIGH — good internal signal, limited direct customer comparison data

### TL;DR

CompetitorX is stronger on onboarding (self-serve, no demo needed) and pricing
transparency. You're stronger on depth of analytics, team collaboration features,
and enterprise security. The overlap is growing — they're building analytics features
that were previously your differentiator.

### Feature Comparison

| Capability          | You                | CompetitorX         | Who wins | Evidence quality                           |
| ------------------- | ------------------ | ------------------- | -------- | ------------------------------------------ |
| Core analytics      | Deep, customizable | Basic, improving    | You      | HIGH (product comparison)                  |
| Onboarding          | Requires demo      | Self-serve in 5 min | Them     | HIGH (tested directly)                     |
| Pricing             | Custom quotes      | Public pricing page | Them     | HIGH (public info)                         |
| Team features       | Full collaboration | Single-user focus   | You      | MEDIUM (limited competitor data)           |
| AI features         | Mature (2 years)   | New (launched Q1)   | You      | MEDIUM (their AI is new, hard to evaluate) |
| Enterprise security | SOC2, SSO, SCIM    | SOC2, no SSO        | You      | HIGH (public docs)                         |

### Internal Signal

**What sales is hearing:**

- "3 deals in Q1 mentioned CompetitorX in evaluation" — Sales (Slack, Mar 2026)
- "Lost deal to CompetitorX — customer said our onboarding was too complex" — AE (Slack, Feb 2026)
- "Customer almost churned after seeing CompetitorX pricing page — asked why we don't publish prices" — CS (Slack, Jan 2026)

**Unique voices:** 5 (3 AEs, 1 CS, 1 PM)
**Signal strength:** MEDIUM — consistent theme but small sample

### Positioning Recommendations

| Audience                    | Message                                                                                                 | Evidence                    |
| --------------------------- | ------------------------------------------------------------------------------------------------------- | --------------------------- |
| **Prospects in evaluation** | Lead with depth + team features. Acknowledge onboarding gap — offer white-glove setup.                  | Lost deal feedback          |
| **Existing customers**      | Emphasize roadmap (AI features, collaboration). Show what CompetitorX can't do yet.                     | Feature gap analysis        |
| **Leadership**              | Onboarding and pricing transparency are real gaps. CompetitorX is moving fast — 2 major releases in Q1. | Web research + sales signal |

### What CompetitorX Does Better (Be Honest)

1. **Self-serve onboarding** — users can start in 5 minutes vs your demo-required flow
2. **Pricing transparency** — public page vs "contact sales"
3. **Speed of iteration** — 2 major releases in Q1 2026

### What You Do Better

1. **Analytics depth** — customizable dashboards, advanced filtering, team views
2. **Enterprise security** — SSO, SCIM, audit logs
3. **AI maturity** — 2 years of ML models vs their Q1 launch
4. **Team collaboration** — shared dashboards, comments, permissions

### Gaps in This Analysis

- No direct customer comparison interviews (all signal is secondhand from sales/CS)
- CompetitorX pricing not verified beyond public page (may have enterprise pricing)
- No usage data comparison (would need customer permission to benchmark)

### Suggested Next Steps

- `/create-deliverable "CompetitorX response" --type one-pager` — stakeholder-ready summary
- `/research "onboarding friction" --deep` — investigate the gap they're exploiting
- `/experiment-design "self-serve onboarding pilot"` — test if simplified onboarding moves the needle
```

## Key things to notice

- **Internal signal first, then external** — your team's real experiences, not just feature-checking websites
- **Honest about what they do better** — not a cheerleading exercise
- **Evidence quality on every claim** — "HIGH (public info)" vs "MEDIUM (limited data)"
- **Actionable recommendations** — specific next steps, not vague "monitor the competition"
- **Unique voice count on internal signal** — 5 people saying it vs 1 person saying it 5 times
