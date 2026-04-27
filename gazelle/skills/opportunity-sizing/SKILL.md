---
name: opportunity-sizing
description: "Evidence-backed opportunity scoring: analytics TAM/usage data + demand signals from Slack/Notion/Circleback + revenue impact per account. Use when deciding whether an opportunity is worth pursuing and how to prioritize against alternatives."
when_to_use: "Use when evaluating whether an opportunity is worth pursuing. Examples: 'how big is this opportunity', 'size this', 'should we build X', 'prioritize these', 'RICE score'"
argument-hint: "[opportunity]"
context: "fork"
---

# Opportunity Sizing

**Voice:** Casual, direct, honest. Abbrevs ok (w/, bc, tbh, imo, kinda).
Lead w/ answer, context after. Flag gaps helpfully (coach, not auditor). Cite sources always.

## Usage

```
/opportunity-sizing [opportunity description]
/opportunity-sizing "report writing automation"
/opportunity-sizing "bulk processing rules" --compare "query building improvement"
```

**Flags:**

- `--compare [opportunity]` — size a second opportunity for head-to-head comparison
- `--quick` — skip analytics, use only qualitative signals. ~15 min.
- `--deep` — full analytics analysis + all qualitative sources + revenue linking. ~45 min.
- `--project [name]` — save to specific project state folder
- `--from [path]` — use existing research instead of running new search

## Protocol

### 1. Load Context

Read these before starting:

- `projects/gazelle-agent/context-training/domain.md` — products, modules, users
- `projects/gazelle-agent/context-training/data-sources.md` — analytics tables, event schema
- `projects/gazelle-agent/context-training/evidence-thresholds.md` — confidence criteria
- Check for existing state: `projects/gazelle-agent/.state/projects/{topic}/`
- If journey map exists: `projects/gazelle-agent/.state/projects/{topic}/journey-map.md` — use pain points and drop-off data to inform demand signals
- If personas exist: `projects/gazelle-agent/.state/projects/{topic}/personas.md` — use persona pain points to scope TAM by user segment
- If competitive analysis exists: `projects/gazelle-agent/.state/projects/{topic}/competitive-analysis.md` — factor competitor coverage into urgency scoring

### 2. Quantitative Sizing (Analytics via usage-analyst)

Launch `usage-analyst` subagent:

```
usage-analyst → "For the opportunity '[description]', query your analytics platform to determine:

1. **Addressable users:** How many users/orgs currently use the related feature area?
   - Active users in last 90 days
   - Orgs with at least 1 active user
   - Growth trend (compare 90d vs. prior 90d)

2. **Behavioral signal:** What usage patterns suggest demand?
   - Frequency of related actions (searches, exports, clicks in area)
   - Drop-off points (where users abandon related workflows)
   - Workaround signals (manual actions that this opportunity would automate)

3. **Segment breakdown:**
   - By org size (small/medium/enterprise)
   - By product area/module
   - By user role (if detectable from events)

Note: Use aggregated/mart tables when available. Check for known data quality issues in data-sources.md.
Return actual numbers, not estimates."
```

### 3. Qualitative Signal Gathering (Parallel)

Launch `source-researcher` subagents:

```
source-researcher → "Search Slack for demand signals related to '[opportunity]'.
  Look for: feature requests, customer asks, deal blockers, workaround descriptions.
  Channels: product feedback, product discovery, sales channels.
  Count: unique customers asking, unique internal advocates, deal references."

source-researcher → "Search Notion for '[opportunity]' signal.
  Check: user feedback board (filter by related User Needs), discovery docs,
  roadmap items, enterprise deal requirements.
  Extract: customer names, urgency signals, linked deals."

source-researcher → "Search Circleback for customer discussions about '[opportunity]'.
  Look for: customers describing this pain, workarounds they use, competitors
  that solve this, willingness-to-pay signals.
  Extract: quotes, company names, deal context."
```

### 4. Revenue Impact Linking

For each customer/account that appears in the qualitative signals:

```markdown
## Revenue Impact

| Customer  | Signal               | Deal Status                    | ARR/Deal Value    | Source |
| --------- | -------------------- | ------------------------------ | ----------------- | ------ |
| [company] | [what they said/did] | [active/churned/prospect/lost] | [amount if known] | [link] |

**Total addressable revenue:** [sum of known deal values]
**At-risk revenue:** [sum of churned/at-risk accounts mentioning this]
**Expansion potential:** [sum of active accounts that would expand if this existed]
```

If deal values aren't available from research:

> "deal values not found in research sources. check your CRM or ask Sales for revenue data on: [customer list]"

### 5. Score the Opportunity

Use weighted scoring with evidence backing:

```markdown
# Opportunity Sizing: [Opportunity Name]

**Date:** [date]
**Confidence:** [HIGH/MEDIUM/LOW]

## Quick Summary

[2-3 sentences: what this opportunity is, who it serves, how big it is]

## Quantitative Size

| Metric                            | Value      | Source                      | Confidence |
| --------------------------------- | ---------- | --------------------------- | ---------- |
| Addressable users (90d active)    | [N]        | Analytics                   | HIGH       |
| Addressable orgs                  | [N]        | Analytics                   | HIGH       |
| Growth trend                      | [+/-N%]    | Analytics 90d vs. prior 90d | HIGH       |
| Related feature usage/month       | [N] events | Analytics                   | HIGH       |
| Drop-off rate in related workflow | [N%]       | Analytics                   | MEDIUM     |

## Qualitative Signal

| Metric                         | Value             | Source          | Confidence |
| ------------------------------ | ----------------- | --------------- | ---------- |
| Customers explicitly asking    | [N] from [N] orgs | Slack/Notion/CB | [level]    |
| Internal advocates             | [N] people        | Slack           | [level]    |
| Deals blocked by this          | [N]               | Slack/Notion    | [level]    |
| Competitor already solves this | [yes/no — who]    | Research        | [level]    |

## Revenue Impact

| Metric                                      | Value    |
| ------------------------------------------- | -------- |
| Known deal value at stake                   | [amount] |
| At-risk revenue (churned/churning accounts) | [amount] |
| Expansion potential                         | [amount] |

## Weighted Score

| Factor                   | Weight | Score (1-5) | Evidence                      |  Weighted   |
| ------------------------ | ------ | :---------: | ----------------------------- | :---------: |
| **Demand strength**      | 30%    |   [score]   | [N] customers asking, [trend] | [weighted]  |
| **Revenue impact**       | 25%    |   [score]   | [amount] at stake             | [weighted]  |
| **Competitive pressure** | 20%    |   [score]   | [competitor status]           | [weighted]  |
| **Usage data support**   | 15%    |   [score]   | [N] users, [trend]            | [weighted]  |
| **Strategic alignment**  | 10%    |   [score]   | [how it fits your strategy]   | [weighted]  |
| **TOTAL**                | 100%   |             |                               | **[total]** |

### Score Guide

| Score | What it means                                                                                           | Example                                                                                        |
| ----- | ------------------------------------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------- |
| 5     | Overwhelming evidence — multiple independent sources, quant + qual, customers explicitly willing to pay | "5 enterprise customers mentioned this in demos, large ARR at risk, competitor already has it" |
| 4     | Strong evidence — 2+ source types, named customers, trend data supporting                               | "3 Circleback mentions + analytics shows 40% drop-off at this step + 2 Slack requests"         |
| 3     | Moderate evidence — 1-2 sources, directional signal, plausible but not proven                           | "2 customers mentioned it, no analytics data, no competitor doing it yet"                      |
| 2     | Thin evidence — anecdotal, 1 source, secondhand, or conflicting signals                                 | "1 customer request 6 months ago, no follow-up, internal belief only"                          |
| 1     | No evidence or contradicting signals — assumption only or evidence says DON'T build                     | "internal gut feel, no customer data, 0 requests found in search"                              |

## Key Quotes

> "[quote]" — [person], [company], [date], [source]

## Cross-Area Revenue Correlation (if opportunity spans multiple product areas)

When sizing opportunities that bridge areas, add this analysis:

| Segment     | Accounts | Area A Revenue | Area B Revenue | Combined | Churn risk if Area B lost                                          |
| ----------- | -------- | -------------- | -------------- | -------- | ------------------------------------------------------------------ |
| Area B-only | [N]      | —              | [amount]       | [amount] | N/A                                                                |
| Area A-only | [N]      | [amount]       | —              | [amount] | N/A                                                                |
| Area A+B    | [N]      | [amount]       | [amount]       | [amount] | [HIGH/MED/LOW — if Area B lost to competitor, does Area A follow?] |

**Strategic moat score:** Does building this feature increase cross-area lock-in? Multi-area customers are harder to churn than single-area. Quantify the lock-in value.

## Anti-Plays (Where NOT to Focus)

Common opportunity-sizing mistakes to explicitly avoid:

- "Redesign the entire workflow" when only one step is broken — size the step, not the rewrite
- Optimizing for a tiny segment that represents <5% of addressable users — show the math on why it's not worth it
- Counting "interested" users as demand — waitlists and "that's cool" are not revenue signals
- Double-counting revenue across overlapping opportunities — if Opp A and Opp B serve the same accounts, the revenue isn't additive
- Sizing TAM by market reports instead of actual usage data — your analytics trumps industry analyst reports
- Ignoring switching costs — "users want this" means nothing if migration from current workflow costs more than the pain
- Sending drip emails to churned users instead of fixing the in-product experience

### RICE Effort Anchors (Adjusted for AI Agents)

| Effort Score | Definition                                                                           |
| ------------ | ------------------------------------------------------------------------------------ |
| 0.25         | Hours — Agent ships autonomously, human spot-checks                                  |
| 0.5          | A day — Agent drafts PR, human reviews once                                          |
| 1            | A sprint — Agent does heavy lifting, needs human review + QA                         |
| 2            | A few sprints — Agent accelerates each piece but human sequences and manages rollout |
| 5            | A quarter — Agent helps with boilerplate, human architects and coordinates           |
| 10+          | Multi-quarter — Agent contribution is incremental                                    |

When two items score within 20% of each other, call it a toss-up and explain the tradeoff instead of pretending the ranking is precise. State what to defer and what to kill. "Kill" means don't do it, not "do it later."

## Risks & Unknowns

- [what could make this opportunity smaller than it looks]
- [what we don't know that matters]

## Recommendation

[go/no-go/investigate-further with rationale]
```

### 6. Compare (if --compare)

If comparing two opportunities, generate both scorecards then add:

```markdown
## Head-to-Head: [Opp A] vs. [Opp B]

| Dimension     | [Opp A]     | [Opp B]     | Edge         |
| ------------- | ----------- | ----------- | ------------ |
| Demand        | [score]     | [score]     | [winner]     |
| Revenue       | [score]     | [score]     | [winner]     |
| Competitive   | [score]     | [score]     | [winner]     |
| Usage data    | [score]     | [score]     | [winner]     |
| Strategic fit | [score]     | [score]     | [winner]     |
| **TOTAL**     | **[total]** | **[total]** | **[winner]** |

**Bottom line:** [1-2 sentences on which to pursue and why]
```

### 7. Save Output

Save to: `projects/gazelle-agent/.state/projects/{topic}/opportunity-sizing.md`

### 8. Offer Next Steps

> "sizing complete. score: [total]/5 ([recommendation]).
>
> next options:
>
> - compare against another opportunity? (`/opportunity-sizing [other] --compare`)
> - generate a 1-pager from this? (`/create-deliverable --type one-pager --for [stakeholder]`)
> - validate the underlying job? (`/jtbd [segment]`)
> - pressure-test with a PR/FAQ? (`/working-backwards [feature]`)
> - run a pre-mortem before launch? (`/pre-mortem [feature]`)
> - design an experiment to test? (`/experiment-design [hypothesis]`)
> - expand the idea constructively? (`/yes-and [idea]`)
> - start a full discovery? (`/research [topic] --deep`)"

---

## Appendix: Domain Context

> Inline reference so this skill works in any environment (Cowork, Cursor, Claude Code) without external context files.
> **Replace this section with your own company/product context.** See `context-training/domain.md` for the full template.

## Your Product

Describe your company and product here. Include: what you do, who your customers are, your key modules/features, and your market position.

## Modules / Product Areas

| Area       | Name   | What it does  | Owner      |
| ---------- | ------ | ------------- | ---------- |
| **Area 1** | [Name] | [Description] | [PM/Owner] |
| **Area 2** | [Name] | [Description] | [PM/Owner] |

## Users

| Persona  | Does            | Product Area |
| -------- | --------------- | ------------ |
| [Role 1] | [Primary tasks] | [Area]       |
| [Role 2] | [Primary tasks] | [Area]       |

**User context:** Describe your users' general context — their industry, expectations, trust level with AI, tool familiarity, etc.

## Key Terms

Define your domain-specific terminology here.

## Competitors

| Competitor         | vs. Your Product   |
| ------------------ | ------------------ |
| **[Competitor 1]** | [How they compare] |

## Design Principles

Reference your design principles from `context-training/design-principles.md`.

## Team

List your team structure here: Design, PM, Engineering, CS, Leadership roles.
