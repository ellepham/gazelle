---
name: journey-mapping
description: "Map user journeys from data — analytics events, Notion feedback, Circleback interviews, and Slack. Produces current-state journey maps with metrics, pain points, and opportunities."
when_to_use: "Use when mapping user journeys from data. Examples: 'map the user journey', 'journey map for X', 'what does the user flow look like'"
argument-hint: "[flow-name]"
context: "fork"
---

# Journey Mapping

**Voice:** Casual, direct, honest. Abbrevs ok (w., bc, tbh, imo, kinda).
Lead w. answer, context after. Flag gaps helpfully (coach, not auditor). Cite sources always.

## Usage

```
/journey-mapping [flow]               # Map a user journey/workflow
/journey-mapping [flow] --persona [name]  # Journey through a specific persona's lens
```

**Flags:**

- `--persona [name]` — filter through persona's perspective (loads from personas-reference.md)
- `--sources [list]` — restrict data sources
- `--scope [narrow|broad]` — narrow = one feature flow, broad = end-to-end workflow
- `--project [name]` — save to project state folder

**Examples:**

```
/journey-mapping "document review workflow"
/journey-mapping "report export" --persona power-user
/journey-mapping "onboarding" --scope narrow
```

## Protocol

### 1. Load Context

Read before starting:

- `projects/gazelle-agent/context-training/data-sources.md` — analytics event schema + query patterns
- `projects/gazelle-agent/context-training/domain.md` — product context
- `projects/gazelle-agent/context-training/personas-reference.md` — if persona filter requested

Check for existing state:

- `projects/gazelle-agent/.state/projects/{project}/journey-map.md` — prior journey work
- `projects/gazelle-agent/.state/projects/{project}/research.md` — related research
- `projects/gazelle-agent/.state/projects/{project}/personas.md` — project-specific personas (if exists — use pain points to inform journey stages)
- `projects/gazelle-agent/.state/projects/{project}/flow-analysis.md` — visual flow capture (if exists, use as ground truth for current-state screens)
- `projects/gazelle-agent/.state/projects/{project}/screenshots/` — numbered screenshots from flow capture

### 2. Define the Journey Scope

Ask (max 2 questions):

1. **Which flow?** — if not clear from the request
2. **Current state or desired state?** — mapping what IS or what SHOULD BE?

Default: current state. Most useful for identifying where things break.

### 3. Gather Data (Using Subagents in Parallel)

Launch subagents to build the journey from multiple angles simultaneously:

```
gazelle-analyst → "Query analytics for [flow] events. Map these events to journey steps.

  Define your product's event taxonomy in context-training/data-sources.md. Example structure:

  Feature Area A:
  - SEARCH_CREATED, SEARCH_EXECUTED, RESULTS_VIEWED
  - ITEM_REVIEWED, ITEM_APPROVED, ITEM_REJECTED

  Feature Area B:
  - ALERT_CREATED, ALERT_VIEWED, ALERT_REVIEWED
  - REPORT_STARTED, REPORT_COMPLETED, REPORT_EXPORTED

  For each step: volume, drop-off %, time between steps, error rate, segmentation by org size. Filter internal users."

gazelle-source-researcher → "Search Notion for feedback about [flow]. User feedback board
  entries mentioning this workflow, CS escalations, past research notes."

gazelle-source-researcher → "Search Slack for [flow]. CS channels: customer complaints.
  Product channels: discussions about this workflow. Engineering: known bugs/limitations."

gazelle-source-researcher → "Search Circleback for customer meetings about [flow].
  Demo sessions, feedback sessions where users described this workflow."

gazelle-source-researcher → "Search filesystem for existing journey maps, research,
  specs, gap analyses related to [flow]."
```

If analytics aren't accessible or events don't exist, note it as a gap — don't skip the step.

Collect all subagent results, then build the journey map in main context.

### 4. Build the Journey Map

**If `flow-analysis.md` exists:** Use it as ground truth for the current-state UI. The per-screen analysis provides exact actions available, data shown, and UX friction at each step. Cross-reference screenshots with analytics events and qualitative feedback to build a richer journey. Journey maps with flow capture are higher quality — visual evidence + usage data + user feedback.

**If no flow capture:** Build from data only (analytics + qualitative). Note in blind spots that visual evidence is missing — recommend running `/gazelle-flow-capture` to fill the gap.

Structure as a timeline of stages → steps → touchpoints:

```markdown
## journey: [flow name]

**Persona:** [if specified, or "general"]
**Scope:** [narrow/broad]
**Data sources:** [what we searched]

---

### Stage 1: [Stage Name]

**User goal:** [what user is trying to accomplish]
**Entry point:** [how they get here]

| Step       | What Happens               | User Feeling | Data                           |
| ---------- | -------------------------- | ------------ | ------------------------------ |
| 1.1 [step] | [action + system response] | [emotion]    | [Analytics: N users, Xmin avg] |
| 1.2 [step] | [action + system response] | [emotion]    | [Notion: 3 complaints]         |

**Pain points:**

- 😤 [pain] — source: [link] — severity: [how many affected]
- 😤 [pain] — source: [link] — severity: [how many affected]

**Bright spots:**

- ✨ [what works well] — source: [link]

**Drop-off:** [X% don't proceed. possible reasons from data.]

---

### Stage 2: [Stage Name]

[repeat structure]

---

## metrics summary

| Metric                    | Value       | Source                      | Confidence |
| ------------------------- | ----------- | --------------------------- | ---------- |
| Users who start this flow | [N]/month   | Analytics                   | ✅/⚠️/❌   |
| Completion rate           | [X%]        | Analytics                   | ✅/⚠️/❌   |
| Avg time to complete      | [X min/hrs] | Analytics                   | ✅/⚠️/❌   |
| Top pain point            | [pain]      | Notion/Slack ([N] mentions) | ✅/⚠️/❌   |

## biggest pain points (ranked by evidence)

1. **[pain]** — [N] sources, [N] customers, [confidence]
2. **[pain]** — [N] sources, [N] customers, [confidence]
3. **[pain]** — [N] sources, [N] customers, [confidence]

## opportunities

| Opportunity | Pain It Solves | Effort Guess | Evidence Strength |
| ----------- | -------------- | ------------ | ----------------- |
| [idea]      | [pain #]       | S/M/L        | ✅/⚠️/❌          |

## 🔍 blind spots

- ❓ [step we have no data on — how to fill]
- ❓ [user segment not represented — how to include]
- ❓ [metric we couldn't get — what would help]

## my take

[honest 2-3 sentence assessment of journey health + biggest lever for improvement]
```

### 5. Persona Overlay (if --persona flag)

When filtering through a persona's lens:

- Load persona from `personas-reference.md`
- At each step, note how THIS persona specifically experiences it
- Reference persona's tools (comparisons to familiar tools like Excel, etc.)
- Use persona's vocabulary in the "user feeling" column
- Flag steps where persona's experience likely differs from average
- Note which persona attributes are 🔮 assumed — these journey points are less reliable

### 6. Save State

Save to:

```
projects/gazelle-agent/.state/projects/{project}/journey-map.md
```

Also update `context.md` with journey status.

## Journey Map Quality Rules

A journey map is **useful** when:

- At least 2 data source types contribute (quant + qual)
- Drop-off points are identified with data, not guessed
- Pain points cite specific feedback, not assumed
- Metrics have confidence tags
- Blind spots are explicitly listed

A journey map is **weak** when:

- Only qualitative data (no usage numbers)
- All pain points are assumed from one source
- No drop-off or timing data
- Missing key stages of the flow

**What to do with weak journeys:** Ship them anyway — a journey map with gaps and honest confidence tags is better than no journey map. Flag what would make it stronger.

## Common Journey Templates

Define your product's common journey templates below. Here are example patterns:

### End-to-End Workflow

```
Setup → Configuration → Execution →
Review → Approval → Export → Reporting
```

### Content Management

```
Upload → Metadata Entry → Tagging/Categorization →
Search/Filter → AI Analysis → Export
```

### Monitoring / Alerting

```
Source Setup → Alert Configuration → Alert Triage →
Investigation → Reporting → Trend Analysis
```

### Onboarding

```
First Login → Core Feature Discovery → First Workflow →
First Export → Return Visit → Power User (or Churn)
```

### Cross-Area Workflow (spanning multiple product areas)

```
Area A: Review Items → Export Relevant Data →
Area B: Search Related Content → Process & Extract →
Combine: Merge data from both areas →
Export: Generate combined output
```

Key cross-area touchpoints to map:

- Where does the user switch between areas? What triggers it?
- Is there data handoff between areas or manual copy-paste?
- Do signals in one area inform queries in another?
- How much time is spent reconciling data from both areas?

### Cross-Area: Audit Preparation (spanning all areas)

```
Audit Notice → Gather Area A records → Gather Area B evidence →
Gather Area C data → Cross-reference → Package audit bundle →
Review trail completeness → Submit
```

When mapping cross-area journeys, use analytics events from ALL relevant areas and look for users with activity in multiple areas within the same time window.

## Offer Next Steps

After the journey map is saved:

> "journey map saved. next options:
>
> - ready to write the design spec? → `/design-spec [feature]`
> - want to capture the current app flow first? → `/flow-capture [route]`
> - need more research on a pain point? → `/research [pain point] --quick`"

## Integration

- **Subagents used:**
  - `gazelle-source-researcher` (parallel) — qualitative data from Notion, Slack, Circleback, filesystem
  - `gazelle-analyst` — analytics quantitative data (volumes, drop-offs, timing)
- Reads from: `personas-reference.md`, `data-sources.md`
- Outputs feed into: `/gazelle-insights`, `/gazelle-spec`
- State saved to: `projects/gazelle-agent/.state/projects/{project}/journey-map.md`
- Method guidance from: `context-training/service-design-methods.md`

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
| **Area 3** | [Name] | [Description] | [PM/Owner] |

## Users

| Persona  | Does            | Product Area |
| -------- | --------------- | ------------ |
| [Role 1] | [Primary tasks] | [Area]       |
| [Role 2] | [Primary tasks] | [Area]       |
| [Role 3] | [Primary tasks] | [Area]       |

**User context:** Describe your users' general context — their industry, expectations, trust level with AI, tool familiarity, etc.

## Key Terms

Define your domain-specific terminology here. Include acronyms, product-specific concepts, and industry jargon that users would encounter.

## Competitors

| Competitor         | vs. Your Product   |
| ------------------ | ------------------ |
| **[Competitor 1]** | [How they compare] |
| **[Competitor 2]** | [How they compare] |

## Design Principles

Reference your design principles from `context-training/design-principles.md`. These guide journey-driven design decisions.

## Team

List your team structure here: Design, PM, Engineering, CS, Leadership roles.
