---
name: insights
description: "Synthesize research findings into insights, HMW questions, and recommendations. Reads research state and produces actionable design direction with confidence ratings."
when_to_use: "Use when synthesizing research findings into actionable direction. Examples: 'what are the insights', 'synthesize findings', 'HMW questions', 'what did we learn'"
effort: low
argument-hint: "[topic]"
allowed-tools: Read, Grep, Glob, Write, Edit
---

# Discovery Insights

**Voice:** Casual, direct, honest. Abbrevs ok (w., bc, tbh, imo, kinda).
Lead w. answer, context after. Flag gaps helpfully (coach, not auditor). Cite sources always.

## Usage

```
/insights [topic]
```

**Flags:**

- `--from [path]` — point to specific research file (default: reads from `.state/projects/{topic}/research.md`)
- `--project [name]` — specify project folder name

**Prerequisites:** Run `/research [topic]` first, or point to existing research with `--from`.

## Protocol

### 1. Load State

Read in this order:

1. `projects/gazelle-agent/.state/projects/{topic}/research.md` — raw findings
2. `projects/gazelle-agent/.state/projects/{topic}/context.md` — project context
3. `projects/gazelle-agent/context-training/evidence-thresholds.md` — confidence criteria
4. `projects/gazelle-agent/context-training/service-design-methods.md` — what to recommend next
5. `projects/gazelle-agent/context-training/design-principles.md` — your design philosophy

If no research state exists, tell the user:

> "no research found for '{topic}'. run `/research {topic}` first, or point me to existing findings w. `--from [path]`"

### 2. Phase Gate Check

Before synthesizing, assess evidence quality:

```markdown
phase check: Research → Insights

evidence inventory:

- [N] sources across [types]
- [N] unique customers/people represented
- time range: [dates]
- source type diversity: [quant/qual/both]

assessment:
[HIGH/MED/LOW] [honest 1-2 sentence assessment]

[proceed / or recommend filling gaps first]
```

**Minimum bar for synthesis (from evidence-thresholds.md):**

- At least 2 source types (e.g., analytics + Slack, not just Slack)
- At least 3 unique voices (not 1 person in 5 threads)
- If below minimum: synthesize anyway but flag prominently: "thin evidence — treat as hypotheses not conclusions"

### 3. Synthesize: Observations → Patterns → Insights

This is the core skill. The progression:

**Observation** (raw data point):

> "3 users mentioned they use Excel alongside our product"

**Pattern** (recurring theme):

> "Users maintain parallel systems because our product doesn't export in their format"

**Insight** (the WHY):

> "Users need data in familiar formats to trust the workflow — it's about control, not features"

**Process:**

1. **List all observations** from research.md (every finding, quote, data point)
2. **Group into themes** — what clusters naturally? Name each cluster.
3. **For each theme:**
   - What's the pattern across observations?
   - WHY does this happen? (the insight)
   - How confident are we? (based on evidence strength)
   - What's the evidence? (cite specific sources)
4. **Generate HMW questions** — turn insights into design opportunities
5. **Prioritize** — which insights are strongest? which HMWs most actionable?

**HMW Quality Bar (read before writing HMW questions):**

Bad HMWs (too vague — reject these):

- Bad: "HMW improve the product?" — too broad, not actionable
- Bad: "HMW make users happier?" — meaningless
- Bad: "HMW use AI better?" — not specific to a problem

Good HMWs (specific to your product domain):

- Good: "HMW help [specific role] trust AI screening scores enough to reduce manual re-review?" (from insight: users re-screen AI decisions bc they fear audit exposure)
- Good: "HMW reduce the time from [data ingestion] to [user review decision]?" (from insight: daily review takes 45+ min bc of false positive noise)
- Good: "HMW let [specific role] validate AI-extracted data without leaving the primary workflow?" (from insight: extracted data must be checked against sources, currently done in a separate tab)

Rule: HMW questions must name a SPECIFIC user role (from `domain.md`), a SPECIFIC workflow step, and the SPECIFIC barrier to overcome.

**Cross-Module Insight Synthesis:**

When research spans multiple product modules, also look for these cross-module patterns:

| Pattern type               | What to look for                                    | Example insight                                                                                                               |
| -------------------------- | --------------------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------- |
| **Shared pain point**      | Same complaint appears in multiple module feedback  | "Users across modules distrust AI confidence scores — this is a platform-level trust gap, not module-specific"                |
| **Workflow bridge**        | Users do tasks in one module that feed another      | "Report assembly requires data from Module A + Module B — currently done in separate tools with manual copy-paste"            |
| **Inconsistency friction** | Users notice different AI behavior across modules   | "AI screening in one module shows reasoning but another doesn't — users lose trust in the less transparent module"            |
| **Cross-sell signal**      | Users of one module express needs solved by another | "Module A users asked for capabilities that Module B already provides — they're doing manual workarounds outside the product" |

Cross-module HMW examples:

- Good: "HMW help cross-module users combine data from Module A and Module B into a single workflow without switching tools?"
- Good: "HMW ensure AI trust mechanisms (confidence scores, reasoning, override) behave consistently across modules so cross-module users don't lose trust?"
- Good: "HMW surface relevant content from one module when a user is working in another, so they don't have to run the same search twice?"

### 4. Write Output

Present in chat:

```markdown
## insights: [topic]

based on [N] sources from research. synthesized [date].

### insight 1: [name] — confidence: [HIGH/MED/LOW]

**pattern:** [what we see happening]
**why:** [the underlying cause/need]
**evidence:**

- "[quote]" — [source with URL]
- Analytics: [event_name query result, date]
- Notion: [feedback item title — URL]
  **counter-evidence:** [anything that contradicts, or "none found"]

### insight 2: [name] — confidence: [HIGH/MED/LOW]

[same structure]

### insight 3: [name] — confidence: [HIGH/MED/LOW]

[same structure]

---

## how might we...

ranked by evidence strength + actionability:

1. **HMW [specific user role] [specific action] [specific barrier]?** (from insight [N])
   → suggested method: [from service-design-methods.md]
   → effort estimate: [time]

2. **HMW [specific user role] [specific action] [specific barrier]?** (from insight [N])
   → suggested method: [method]
   → effort estimate: [time]

3. **HMW [specific user role] [specific action] [specific barrier]?** (from insight [N])
   → suggested method: [method]
   → effort estimate: [time]

---

## reality check

### what this analysis CAN support

- [what decisions are safe to make based on this evidence]

### what this analysis CANNOT support

- [what decisions need more evidence]

### biggest blind spots

- [gap 1] — fill with: [method]
- [gap 2] — fill with: [method]

---

## recommended next steps

based on service-design-methods.md decision trees:

| Priority | Action   | Method   | Timeline | Why      |
| -------- | -------- | -------- | -------- | -------- |
| 1        | [action] | [method] | [time]   | [reason] |
| 2        | [action] | [method] | [time]   | [reason] |
| 3        | [action] | [method] | [time]   | [reason] |

---

## my take

[2-3 sentence honest assessment. what's solid, what's shaky, what would I do?]

saved to: gazelle/.state/projects/{topic}/insights.md
```

### 5. Save State

Save to: `projects/gazelle-agent/.state/projects/{topic}/insights.md`

```markdown
# Insights: [Topic]

**Date:** [date]
**Based on:** research.md ([date])
**Evidence quality:** [HIGH/MEDIUM/LOW]
**Sources:** [N] across [types]

## Insights (Prioritized)

### 1. [Insight Name] — [Confidence]

**Pattern:** [what]
**Why:** [cause]
**Evidence:** [sources]
**Counter-evidence:** [if any]

### 2. [Insight Name] — [Confidence]

[same]

### 3. [Insight Name] — [Confidence]

[same]

## HMW Questions (Prioritized)

1. HMW [question]?
2. HMW [question]?
3. HMW [question]?

## Recommended Methods

[table from output]

## Blind Spots

- [gap] — [method to fill]

## Decision Support

- CAN support: [list]
- CANNOT support: [list]
```

Update `context.md`:

```markdown
## State

- [x] Research — [date]
- [x] Insights — [date]
- [ ] Personas
- [ ] Journey map
- [ ] Spec
```

### 6. Suggest Next Command

Based on insights, recommend:

- If personas needed: "→ next: `/persona-builder [name]` to ground insights in real user data"
- If journey mapping needed: "→ next: build a journey map to see where these pain points hit"
- If enough for spec: "→ next: `/design-spec [feature]` — we have enough to write a spec"
- If gaps too big: "→ honestly? we need more research first. specifically: [what]"

## Quality Bar

Insights synthesis is "done" when:

- [ ] Themes based on 2+ sources (not just 1 interview)
- [ ] Insights explain WHY, not just WHAT
- [ ] HMW questions are actionable (not too broad, not too narrow)
- [ ] Counter-evidence checked (not just confirming hypothesis)
- [ ] Blind spots documented honestly
- [ ] Next steps are specific (method + timeline, not "do more research")

## Pattern Check

During synthesis, gut-check yourself:

- **One-sided?** — did all insights conveniently support the hypothesis? look for counter-evidence too
- **Insight vs observation** — is this genuinely a new understanding or just a restated finding?
- **HMW too broad** — "HMW improve the product?" isn't actionable. "HMW help users trust AI screening scores?" is.
- **Who's represented?** — 5 people said it but are they all the same segment? note who's missing

## Integration

- Reads from: `/research` output
- Method recommendations from: `context-training/service-design-methods.md`
- Design principles from: `context-training/design-principles.md`
- Evidence rules from: `context-training/evidence-thresholds.md`
- Feeds into: `/persona-builder`, `/journey-mapping`, `/design-spec`

---

## Appendix: Domain Context

> To customize Gazelle for your company, populate `context-training/domain.md` with your product's modules, users, key terms, competitors, and team structure.
>
> This appendix is intentionally empty in the open-source distribution. Your company-specific context lives in the context-training files, not here.
