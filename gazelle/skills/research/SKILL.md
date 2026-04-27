---
name: research
description: "Multi-source research with evidence ledger. Searches Notion, Slack, analytics, Drive, Figma across your connected data sources. Use when investigating a topic, checking user signal, or gathering evidence for design decisions."
when_to_use: "Use when investigating a topic, checking user signal, or gathering evidence. Examples: 'research this', 'what do users say about', 'investigate', 'gather evidence for'"
effort: high
argument-hint: "[topic] [--quick] [--deep]"
context: "fork"
---

# Discovery Research

**Voice:** Casual, direct, honest. Abbrevs ok (w., bc, tbh, imo, kinda).
Lead w. answer, context after. Flag gaps helpfully (coach, not auditor). Cite sources always.

## Usage

```
/research [topic]
```

**Flags:**

- `--quick` — desk research only (Notion + Slack + filesystem). ~30 min.
- `--deep` — all sources + cross-referencing. 1-2 hours.
- `--sources [list]` — restrict to specific sources (notion,slack,analytics,drive,figma,web,files)
- `--project [name]` — save to specific project state folder
- `--batch` — run multiple topics in parallel. Pass comma-separated topics: `/research "topic1" "topic2" "topic3" --batch`

## Forked Execution Note

This skill runs with `context: "fork"` — it executes in an isolated sub-agent. The main conversation only receives the final research output, not intermediate tool noise.

**Implication:** You cannot ask the user clarifying questions mid-run. The topic was provided at invocation. If context is truly ambiguous, the parent agent should ask before invoking this skill.

## Protocol

### 1. Load Context

Read these before starting:

- `projects/gazelle-agent/context-training/data-sources.md` — what's where, query patterns
- `projects/gazelle-agent/context-training/domain.md` — terms, products, users
- `projects/gazelle-agent/context-training/evidence-thresholds.md` — confidence criteria
- `projects/gazelle-agent/context-training/reality-check-rules.md` — anti-pattern detection

Check for existing state:

- `projects/gazelle-agent/.state/projects/{topic}/` — resume if exists

### 2. Resolve Your Product Terminology

Before searching, translate any module/product shorthand into full search terms using `context-training/domain.md`.

Load your product's module aliases and terminology from `domain.md`. For each module alias mentioned in the topic, expand it to the full set of search terms defined in your domain file. If the topic is ambiguous across modules, scope the search explicitly and instruct subagents to exclude terms from other modules to prevent cross-module contamination.

Always pass the expanded terms to subagents. If the topic mentions a specific module, subagent prompts should explicitly exclude other module terms to prevent cross-contamination.

### 3. Ask Clarifying Questions (Max 3)

**Skip this step when running forked** (you can't interact with the user). Use defaults: open exploration, all customers, thorough investigation matching the flag (`--quick` or `--deep`).

When running inline (non-forked), ask before searching:

1. **hypothesis or open?** — "testing a specific claim or exploring broadly?"
2. **scope** — "all customers or specific segment? how far back?"
3. **urgency** — "quick signal check or thorough investigation?"

Keep questions tight. Don't over-ask. If topic is clear, skip to searching.

### 4. Search Using Subagents (Parallel)

Launch `source-researcher` subagents in parallel — one per data source. This keeps noisy MCP output isolated and runs 3-5x faster than sequential search.

**Launch these in parallel:**

```
source-researcher → "Search Notion for [topic]. Check user feedback board,
  discovery board, product docs, strategy pages, past research notes."

source-researcher → "Search Slack for [topic]. Check relevant product channels,
  feedback channels, design channels, engineering channels. Count unique voices. Check thread replies."

source-researcher → "Search Circleback for [topic]. Look for customer meeting
  transcripts, demos, feedback sessions. Extract quotes, participants, dates."

source-researcher → "Search Google Drive for [topic]. Interview transcripts,
  research docs, strategy decks, meeting notes, CS call summaries."

source-researcher → "Search filesystem for [topic]. Check projects/ for past
  research, shared/ for existing knowledge, session-logs/ for recent work."
```

**If quantitative data is needed, also launch:**

```
gazelle-analyst → "Query your analytics tool for [topic]. Check data-sources.md for event names.
  Get adoption, engagement, drop-offs, segmentation. Filter internal users."
```

**Optional (if topic requires external context):**

- Web search for competitive analysis, industry trends

**After all subagents return:** collect results in main context for synthesis.

### 5. During Search — Track Sources

As you find things, build the evidence ledger in real-time:

```markdown
| #   | Claim            | Source        | Type       | Confidence   | Notes     |
| --- | ---------------- | ------------- | ---------- | ------------ | --------- |
| 1   | [what you found] | [where, link] | quant/qual | HIGH/MED/LOW | [context] |
```

**Confidence rules (from evidence-thresholds.md):**

- **HIGH** — 3+ independent sources, quant + qual, consistent across segments
- **MEDIUM** — 2 sources or single source type, directionally useful
- **LOW** — 1 source, anecdotal, secondhand, or old data (>6 months)

### 6. Pattern Check

Before writing output, quick self-check:

- [ ] **One-sided?** — did i look for counter-evidence too?
- [ ] **Echo chamber?** — do sources converge bc they're genuinely independent, or same origin?
- [ ] **Whose voice?** — is one person dominating the evidence? flag if so
- [ ] **Who's missing?** — only active users? only enterprise? note gaps
- [ ] **Say-do gap?** — do user statements match their actual behavior in analytics?
- [ ] **Recency bias?** — am i over-indexing on what's freshest?

If any flag triggers, mention it — helpfully, not harshly.

### 7. Write Output

**Source Link Rules (MANDATORY):**

Every finding MUST include a real URL, not a placeholder. If you can't get the actual link, mark the finding `[UNVERIFIED]` — never leave `[link]` unfilled.

Real link formats to use:

- **Notion:** `https://www.notion.so/your-workspace/Page-Title-abc123def456`
- **Slack:** `slack://channel?team=TEAM_ID&id={CHANNEL_ID}&message={MESSAGE_TS}` (desktop deep link — web links don't navigate correctly). Fallback: `Search #channel: from:@Person "keywords" ~YYYY-MM-DD`
- **Circleback:** `https://app.circleback.ai/meetings/[meeting-id]`
- **Google Drive:** `https://drive.google.com/file/d/[file-id]/view`
- **Analytics:** no link — cite as `Analytics: [event_name] query, [date]`

Example of CORRECT finding:
`- 78% of users screen >100 articles/week — https://www.notion.so/your-workspace/User-Interview-abc123`

Example of INCORRECT finding (do NOT do this):
`- Users find screening tedious — [link]`

Present findings in chat using this structure:

```markdown
## what i found

### [Source 1] [confidence emoji] [confidence level]

- [finding] — [actual URL or analytics citation]
- [finding] — [actual URL or analytics citation]

### [Source 2] [confidence emoji] [confidence level]

- [finding] — [actual URL or analytics citation]

## evidence ledger

### what we know

| Claim   | Sources   | Confidence   |
| ------- | --------- | ------------ |
| [claim] | [sources] | HIGH/MED/LOW |

### what we DON'T know

- [gap] — [how to fill]

### assumptions (unvalidated)

- [assumption] — [based on]

## my take

[honest 2-3 sentence assessment]

## what i'd do next

1. [next step]
2. [next step]
3. [next step]

...or: /insights {topic} to synthesize what we have
```

### 8. Save State

Save full findings to:

```
projects/gazelle-agent/.state/projects/{topic-kebab-case}/research.md
```

Use this template:

```markdown
# Research: [Topic]

**Date:** [date]
**Question:** [what we investigated]
**Sources searched:** [list]
**Depth:** [quick/standard/deep]

## Summary

[2-3 sentences]

## Evidence Ledger

[full table from output]

## Detailed Findings

### Analytics

[findings + queries used]

### Notion

[findings + links]

### Slack

[findings + links + unique voice count]

### Other Sources

[findings]

## Gaps & Unknowns

- [ ] [gap 1]
- [ ] [gap 2]

## Anti-Pattern Flags

[any flags triggered]

## Raw Sources

- [all links]
```

Also create/update `context.md` in the same project folder:

```markdown
# Project: [Topic]

**Started:** [date]
**Status:** Research phase
**Last updated:** [date]

## What

[1-2 sentences on what we're investigating]

## Why

[why this matters]

## State

- [x] Research — [date]
- [ ] Insights
- [ ] Personas
- [ ] Journey map
- [ ] Spec
```

## Source-Specific Tips

Source-specific search instructions are embedded in each `gazelle-source-researcher` subagent prompt.
For analytics details, the `gazelle-analyst` subagent has the full schema and query patterns.

### CS Team Shortcut

Before deep research, ask in chat: "should i check w. CS first? they might already know."
CS talks to users daily. Sometimes a 5-min Slack DM replaces hours of research.

## Batch Mode (`--batch`)

When `--batch` is passed with multiple topics:

1. **Parse topics** from arguments (space-separated, quoted strings)
2. **For each topic**, spawn a separate `research` fork in parallel:
   - Each fork gets its own topic, runs the full protocol independently
   - Each saves to its own state folder: `projects/gazelle-agent/.state/projects/{topic}/research.md`
3. **Track status** — maintain a status table:
   ```
   | Topic | Status | Key finding |
   |-------|--------|-------------|
   | topic1 | DONE | [one-liner] |
   | topic2 | RUNNING | ... |
   | topic3 | PENDING | ... |
   ```
4. **When all complete**, synthesize cross-topic findings:
   - What themes appear across multiple topics?
   - Which topics have the strongest evidence?
   - What's the recommended priority order?
5. **Save cross-topic synthesis** to: `projects/gazelle-agent/.state/projects/batch-{date}/cross-topic-synthesis.md`

## Integration

- **Subagents used:** `gazelle-source-researcher` (parallel, per source), `gazelle-analyst` (analytics)
- Outputs feed into: `/insights [topic]`
- State saved to: `projects/gazelle-agent/.state/projects/`
- Evidence rules from: `context-training/evidence-thresholds.md`
- Pattern awareness from: `context-training/reality-check-rules.md`

---

## Appendix: Domain Context

> To customize Gazelle for your company, populate `context-training/domain.md` with your product's modules, users, key terms, competitors, and team structure. See the template in that file for the expected format.
>
> This appendix is intentionally empty in the open-source distribution. Your company-specific context lives in the context-training files, not here.
