---
name: feedback-synthesizer
description: "Periodic feedback synthesis across all sources (Circleback, Notion, Slack). Clusters by User Need taxonomy, identifies trends, and surfaces emerging themes. Use for ongoing feedback monitoring, not topic-driven discovery."
when_to_use: "Use when synthesizing customer feedback across sources. Examples: 'what are users saying', 'feedback trends', 'cluster feedback', 'User Need patterns'"
argument-hint: "[topic or 'all']"
context: "fork"
---

# Feedback Synthesizer

**Voice:** Casual, direct, honest. Abbrevs ok (w/, bc, tbh, imo, kinda).
Lead w/ answer, context after. Flag gaps helpfully (coach, not auditor). Cite sources always.

## Usage

```
/feedback-synthesizer
/feedback-synthesizer --since 2w
/feedback-synthesizer --module [area-name]
/feedback-synthesizer --customer "Customer Name"
```

**Flags:**

- `--since [period]` — time window: `1w`, `2w`, `1m`, `3m` (default: `2w`)
- `--module [name|all]` — filter to specific product area (default: all)
- `--customer [name]` — filter to specific customer
- `--needs-only` — skip raw findings, just show User Need clustering
- `--trending` — highlight items trending up (more mentions than previous period)
- `--project [name]` — save to specific project state folder

## Protocol

### 1. Load Context

Read these before starting:

- `projects/gazelle-agent/context-training/domain.md` — terms, products, modules
- `projects/gazelle-agent/context-training/evidence-thresholds.md` — confidence criteria
- `projects/feedback-clustering/user-needs-definitions.md` — your User Need definitions (if exists)
- `projects/feedback-clustering/gold-standard-examples.md` — example classifications (if exists)

If User Need definitions don't exist at those paths, search your project directories for user need definitions or taxonomy files.

### 2. Gather Feedback (Parallel)

Launch `source-researcher` subagents in parallel, scoped to the time window:

```
source-researcher → "Search Circleback for customer meetings in the last [period].
  Extract: feedback items, feature requests, pain points, complaints, praise.
  For each: note customer name, speaker, date, verbatim quote.
  Focus on product feedback, not internal meetings."

source-researcher → "Search Notion user feedback board for items created/updated
  in the last [period].
  Extract: feedback text, customer, module/area, status, linked user need."

source-researcher → "Search Slack for customer feedback in the last [period].
  Channels: product feedback, discovery, customer-facing channels.
  Look for: bug reports, feature requests, complaints, praise, usage observations.
  Include CS team relaying customer feedback."
```

If `--module` specified, add module filter to each subagent query.
If `--customer` specified, add customer filter to each subagent query.

### 3. Deduplicate

Same feedback often appears in multiple sources (customer says it in a call → CS posts in Slack → gets added to Notion). Deduplicate by:

- Match on customer + topic + time proximity (<1 week)
- Keep the richest version (usually the Circleback transcript quote)
- Note all sources it appeared in (multi-source = stronger signal)

```markdown
## Deduplication

- [N] raw feedback items found
- [N] after deduplication
- [N] appeared in 2+ sources (strong signal)
```

### 4. Classify by User Need

For each unique feedback item, classify against your User Need definitions.

**Define your User Need taxonomy in `projects/feedback-clustering/user-needs-definitions.md`.** Use this structure:

| UN ID | Name        | Product Area | Example feedback signals                   |
| ----- | ----------- | ------------ | ------------------------------------------ |
| UN-01 | [Need Name] | [Area]       | "[example feedback]", "[example feedback]" |
| UN-02 | [Need Name] | [Area]       | "[example feedback]", "[example feedback]" |
| UN-03 | [Need Name] | [Area(s)]    | "[example feedback]", "[example feedback]" |
| UN-04 | [Need Name] | [Area(s)]    | "[example feedback]", "[example feedback]" |
| UN-05 | [Need Name] | [Area]       | "[example feedback]", "[example feedback]" |

**Cross-Area Feedback Patterns:**

When analyzing all areas (default), also look for these cross-area signals:

| Pattern                           | Signals                                                      | Implication                                            |
| --------------------------------- | ------------------------------------------------------------ | ------------------------------------------------------ |
| **User active in multiple areas** | Same customer complains about Area A AND Area B in same call | Cross-functional user — shared pain points matter more |
| **Cross-area churn risk**         | Customer mentions competitor in context of any area          | If they leave one area, risk losing all                |
| **Integration need**              | Feedback mentioning workflows spanning multiple areas        | Cross-area integration gap                             |
| **Shared trust issue**            | Same complaint about AI trust across areas                   | Platform-level problem, not area-specific              |

When cross-area patterns are found, add a dedicated section:

```markdown
## Cross-Area Patterns

| Pattern | Customers | Areas   | Implication |
| ------- | --------- | ------- | ----------- |
| [what]  | [who]     | [areas] | [so what]   |
```

When gold-standard examples exist at `projects/feedback-clustering/gold-standard-examples.md`, use them as primary reference. Use your taxonomy definitions as fallback.

```markdown
## Feedback by User Need

| User Need          | Count | Trend            | Customers       | Top Quote                            |
| ------------------ | ----- | ---------------- | --------------- | ------------------------------------ |
| [UN-01: Need Name] | [N]   | [up/down/stable] | [customer list] | "[verbatim quote — person, company]" |
| [UN-03: Need Name] | [N]   | ...              | ...             | ...                                  |
| **Unclassified**   | [N]   | —                | ...             | ...                                  |
```

**Classification rules:**

- Use the gold-standard examples as reference; use taxonomy definitions as fallback
- If a feedback item maps to multiple User Needs, list the primary one and note secondaries
- If it doesn't match any User Need, classify as "Unclassified" and flag it — this might be a NEW user need
- Confidence per classification: HIGH (matches gold-standard closely), MEDIUM (reasonable match), LOW (ambiguous)
- Always include verbatim quote with attribution: `"[exact quote]" — [Name], [Company], [date]`

### 5. Identify Trends

Compare current period to previous period (if data available):

```markdown
## Trends

### Rising (more mentions than previous period)

| User Need | Current | Previous | Change | Notable            |
| --------- | ------- | -------- | ------ | ------------------ |
| [need]    | [N]     | [N]      | +[N]   | [why this matters] |

### Declining (fewer mentions)

| User Need | Current | Previous | Change | Notable |
| --------- | ------- | -------- | ------ | ------- |

### New Signals (not seen before)

- [feedback that doesn't match existing User Needs — potential new need]

### Customer Health Flags

| Customer                                                | Signal           | Urgency     |
| ------------------------------------------------------- | ---------------- | ----------- |
| [customer with sharp usage drop or multiple complaints] | [what they said] | HIGH/MEDIUM |
```

### 6. Synthesize

```markdown
# Feedback Synthesis: [period]

**Period:** [start] to [end]
**Sources:** Circleback ([N] meetings), Notion ([N] items), Slack ([N] messages)
**After dedup:** [N] unique feedback items from [N] customers

## Top 5 User Needs This Period

1. **[UN-XX: Name]** — [N] mentions from [N] customers
   - Key quote: "[quote]" — [person], [company]
   - Trend: [up/down/stable vs. previous period]
   - Implication: [1 sentence — what this means for product]

2. ...

## Emerging Signals

[Feedback that doesn't fit existing taxonomy — potential new User Needs]

## Customer Health Alerts

[Customers showing negative signals: complaints, usage drops, competitor mentions]

## Recommended Actions

| #   | Action | Based On | Priority | Owner Suggestion |
| --- | ------ | -------- | -------- | ---------------- |

## Raw Feedback Log

[Full deduplicated list with source links — for drill-down]
```

### 7. Save Output

Save to: `projects/gazelle-agent/.state/feedback/synthesis-[date].md`

Also append summary to: `projects/gazelle-agent/.state/feedback/trend-log.md` (running log of period-over-period trends)

### Anti-Hallucination Rules

- **Never fabricate customer quotes.** Every verbatim quote must come from Circleback, Notion, or Slack with a real link. Use [UNVERIFIED] if paraphrasing from memory.
- **Never invent feedback volume.** Don't say "5 customers mentioned X" unless you actually counted 5 distinct customers in the data. If uncertain: "at least N customers" or "multiple customers."
- **Never conflate internal consensus with customer evidence.** If the signal is from team members discussing what they think users want, label it "INTERNAL" not "CUSTOMER."
- **Never leave placeholders unfilled.** No [link], [customer name], [amount], [date] in final output. Use [UNVERIFIED] if the data is real but the source link is unknown.
- **Trend claims need data.** Don't say "rising" or "declining" without comparing two periods. If only one period of data exists, say "no trend data — first measurement."

### 8. Offer Next Steps

> "synthesis complete. [N] feedback items from [N] customers across [period].
>
> top signal: [#1 User Need] ([N] mentions, [trend])
>
> next options:
>
> - dig deeper into a specific User Need? (`/research [user-need]`)
> - generate voice cards for the top signals? (`/create-deliverable --type voice-cards`)
> - share this w/ CS? (output is formatted for non-technical readers)"

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
