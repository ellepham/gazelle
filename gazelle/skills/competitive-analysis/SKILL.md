---
name: competitive-analysis
description: "Structured competitive intelligence: internal signals (Slack, Notion, Circleback) + external research → comparison matrix. Use when evaluating competitors, positioning against alternatives, or preparing for deal post-mortems."
when_to_use: "Use when comparing your product to competitors or evaluating market position. Examples: 'compare us to [competitor]', 'competitive intel', 'what does competitor X do', 'deal post-mortem'"
effort: high
argument-hint: "[competitor]"
context: "fork"
---

# Competitive Analysis

**Voice:** Casual, direct, honest. Abbrevs ok (w/, bc, tbh, imo, kinda).
Lead w/ answer, context after. Flag gaps helpfully (coach, not auditor). Cite sources always.

## Usage

```
/competitive-analysis [competitor or feature area]
/competitive-analysis [competitor name]
/competitive-analysis "feature area" --deep
```

**Flags:**

- `--quick` — internal signals only (Slack + Notion + filesystem). ~20 min.
- `--deep` — internal + external web research + pricing + UX teardown. ~1 hr.
- `--vs [competitor]` — head-to-head comparison against specific competitor
- `--project [name]` — save to specific project state folder
- `--deal [company]` — frame analysis around a specific deal/customer loss

## Protocol

### 1. Load Context

Read these before starting:

- `projects/gazelle-agent/context-training/domain.md` — your products, positioning, key terms
- `projects/gazelle-agent/context-training/evidence-thresholds.md` — confidence criteria
- Check for existing competitive state: `projects/gazelle-agent/.state/projects/{topic}/competitive-analysis.md`

### 2. Internal Signal Gathering (Parallel)

Launch `source-researcher` subagents in parallel:

```
source-researcher → "Search Slack for [competitor]. Check competition monitoring,
  product, and sales channels.
  Look for: mentions, deal losses, feature comparisons, pricing intel, customer quotes
  about switching. Also search for '[competitor] alternative', '[competitor] vs'.
  Count unique mentions and people."

source-researcher → "Search Notion for [competitor]. Check competition database,
  user feedback board, discovery docs, deal post-mortems. Extract:
  feature comparisons, pricing, customer reactions, win/loss context."

source-researcher → "Search Circleback for [competitor]. Look for customer meetings
  where competitor was mentioned — demo comparisons, switching discussions,
  feature requests framed as 'competitor X has this'. Extract exact quotes."

source-researcher → "Search filesystem for [competitor]. Check projects/discovery/,
  shared/documentation/, session-logs/. Look for past competitive analysis,
  deal notes, research that mentions this competitor."
```

### 3. External Research (if --deep)

Use web search for:

- **Product:** What features does [competitor] offer? Recent launches? Product page screenshots.
- **Pricing:** Published pricing? Tiers? Per-seat vs. per-module? Any conference pricing shared?
- **Positioning:** How do they describe themselves? What problem do they claim to solve?
- **Reviews:** G2, Capterra reviews. What do users praise/complain about?
- **News:** Recent funding, partnerships, acquisitions, conference talks.
- **Tech:** What stack? API? Integrations? AI features?

### 4. Synthesize into Comparison Matrix

**Define your known competitor context in `context-training/domain.md`.** Use this structure as a starting point, updating from sources:

| Competitor         | Type              | Known Strengths | Known Weaknesses | Pricing Signal |
| ------------------ | ----------------- | --------------- | ---------------- | -------------- |
| **[Competitor 1]** | [Direct/Indirect] | [Strengths]     | [Weaknesses]     | [Pricing info] |
| **[Competitor 2]** | [Direct/Indirect] | [Strengths]     | [Weaknesses]     | [Pricing info] |

**Cross-Area Competitive Positioning:**

When your product has multiple areas/modules, don't just compare at the product level — break it down:

| Dimension                | Your Product    | Competitor Approach | Your Edge        |
| ------------------------ | --------------- | ------------------- | ---------------- |
| [Area A capability]      | [your approach] | [their approach]    | [your advantage] |
| [Area B capability]      | [your approach] | [their approach]    | [your advantage] |
| [Cross-area integration] | [your approach] | [their approach]    | [your advantage] |

**Cross-Area Risk Analysis:**

When a competitor threatens one area, assess cross-area churn risk:

```markdown
## Cross-Area Risk

| Scenario                                                       | Risk                                                    | Evidence          |
| -------------------------------------------------------------- | ------------------------------------------------------- | ----------------- |
| Customer loses Area A to competitor                            | HIGH — may also churn Area B (users use both)           | [cite deal data]  |
| Customer uses Area A only + competitor adds similar capability | MEDIUM — single-area customers have less switching cost | [cite usage data] |
| Customer uses Area A+B + you ship cross-area integration       | LOW — cross-area integration increases lock-in          | [strategic bet]   |
```

Always assess: "If this customer leaves [area], what else do we lose?"

```markdown
# Competitive Analysis: [Competitor] vs [Your Product]

**Date:** [date]
**Sources:** [list sources checked with counts]
**Confidence:** [HIGH/MEDIUM/LOW based on evidence depth]

## Quick Summary

[2-3 sentences: who they are, where they compete with you, threat level]

## Head-to-Head Comparison

| Dimension     | Your Product | [Competitor] | Edge             | Evidence      |
| ------------- | ------------ | ------------ | ---------------- | ------------- |
| [Area A]      | ...          | ...          | Yours/Theirs/Tie | [source link] |
| [Area B]      | ...          | ...          | ...              | [source link] |
| [Area C]      | ...          | ...          | ...              | [source link] |
| AI Features   | ...          | ...          | ...              | [source link] |
| Pricing       | ...          | ...          | ...              | [source link] |
| UX/Usability  | ...          | ...          | ...              | [source link] |
| Integrations  | ...          | ...          | ...              | [source link] |
| Customer Base | ...          | ...          | ...              | [source link] |

## Deal Impact

| Metric                         | Value           | Source               |
| ------------------------------ | --------------- | -------------------- |
| Known lost deals               | [count]         | [Slack/Notion links] |
| Revenue at risk                | [amount]        | [deal references]    |
| Accounts mentioning competitor | [customer list] | [sources]            |

## What They Do Better

[Be honest. List specific features/approaches where competitor wins. Cite customer quotes if available.]

## What You Do Better

[Specific advantages. Cite evidence — not just "we're better at AI."]

## Customer Quotes About Competitor

> "[quote]" — [person], [company], [date], [source link]

## Strategic Implications

- **Defend:** [what to protect/strengthen]
- **Attack:** [where to differentiate]
- **Watch:** [emerging threats or shifts]

## Recommended Actions

| #   | Action | Urgency | Owner Suggestion |
| --- | ------ | ------- | ---------------- |
```

### 5. Save Output

Save to: `projects/gazelle-agent/.state/projects/{topic}/competitive-analysis.md`

If `--deal` flag used, also format a deal-specific brief:

```markdown
## Deal Brief: [Company]

**Situation:** [1-2 sentences about the deal context]
**Competitor threat:** [what the competitor offers that we don't]
**Our edge:** [what we offer that they don't]
**Recommended play:** [specific tactical recommendation]
```

### 6. Offer Next Steps

> "competitive analysis saved. next options:
>
> - generate voice cards from this? (`/create-deliverable --type voice-cards`)
> - size the opportunity? (`/opportunity-sizing [area]`)
> - feed into design spec? (`/design-spec [feature]`)"

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

Define your known competitive landscape in `context-training/domain.md`. Include: direct competitors, indirect alternatives, and adjacent tools your users might use.

## Design Principles

Reference your design principles from `context-training/design-principles.md`.

## Team

List your team structure here: Design, PM, Engineering, CS, Leadership roles.
