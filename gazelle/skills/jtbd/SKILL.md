---
name: jtbd
description: "Jobs to Be Done analysis: functional, social, and emotional layers. Maps current solutions, pain points, switching costs, and prioritizes jobs by Intensity x Frequency x Underserved."
when_to_use: "Use when analyzing what job a product/feature solves. Examples: 'jobs to be done', 'JTBD', 'what job does this solve', 'why do users hire this', 'what are users trying to accomplish'"
effort: medium
argument-hint: "[product/feature/user segment]"
allowed-tools: Read, Grep, Glob, Write, Edit
---

# Jobs to Be Done

**Voice:** Casual, direct, honest. Abbrevs ok (w/, bc, tbh, imo, kinda).
Lead w/ answer, context after. Flag gaps helpfully (coach, not auditor). Cite sources always.

**Source:** Adapted from Amplitude Builder Skills' JTBD framework. Three-layer analysis with prioritization matrix.

## Usage

```
/jtbd [product, feature, or user segment]
/jtbd "AI screening for compliance specialists"
/jtbd "report export workflow" --project data-pipeline
```

**Flags:**

- `--project [name]` — save to specific project state folder
- `--quick` — skip data gathering, use only conversation context
- `--deep` — pull signals from Slack/Notion/Circleback/BigQuery for evidence-backed jobs

## Protocol

### 1. Load Context

Read these if available:

- `projects/gazelle-agent/.state/projects/{name}/research.md` — raw findings
- `projects/gazelle-agent/.state/projects/{name}/personas.md` — user archetypes
- `projects/gazelle-agent/.state/projects/{name}/journey-map.md` — pain points
- `projects/gazelle-agent/context-training/domain.md` — products, modules, users
- `projects/gazelle-agent/context-training/personas-reference.md` — known personas

If `--deep`: launch source-researcher subagents for:

- Circleback: customer descriptions of their workflows and frustrations
- Slack: internal discussions about user needs and workarounds
- Notion: user research database, feedback board entries
- BigQuery: behavioral patterns that reveal what users actually do (not what they say)

### 2. Identify the User

Before mapping jobs, be specific about WHO:

```markdown
## Target User

**Persona:** [specific role — e.g., "Senior Analyst at a mid-size company"]
**Context:** [when/where they encounter this — e.g., "during quarterly report preparation"]
**Current tools:** [what they use today — e.g., "your product + Excel + manual workflows"]
```

If multiple user segments exist, analyze each separately. Cross-segment jobs should be flagged.

### 3. Map the Three Layers

For each job identified, analyze all three layers:

#### Functional Jobs (What they need to DO)

The practical tasks and outcomes. These are observable and measurable.

```markdown
### Functional Job [N]: [Job statement — "When [situation], I want to [motivation], so I can [outcome]"]

**Current solution:** [What they do today to get this job done]
**Pain with current:** [Specific friction — time, effort, errors, cost]
**Switching cost:** [What it would take to change — data migration, retraining, workflow disruption]
**Frequency:** [How often this job occurs — daily/weekly/monthly/quarterly]
**Evidence:** [Source — Circleback quote, BigQuery data, Slack thread, research finding]
```

**Example functional jobs** (adapt to your product's users from `context-training/domain.md`):

| User              | Common functional jobs                                                                          |
| ----------------- | ----------------------------------------------------------------------------------------------- |
| Power user        | Complete core workflow efficiently, track progress, generate reports, export results            |
| Reviewer/Approver | Review submissions, determine quality/relevance, document rationale, approve or reject          |
| Admin/Manager     | Configure team settings, ensure compliance, monitor team activity, manage permissions           |
| Analyst           | Extract insights from data, build dashboards, identify trends, share findings with stakeholders |

#### Social Jobs (How they want to be PERCEIVED)

How completing this job affects their standing with colleagues, regulators, and management.

```markdown
### Social Job [N]: [Job statement]

**What they want others to think:** [perception goal]
**What they fear others will think:** [reputation risk]
**How current solution affects perception:** [status quo social impact]
**Evidence:** [Source]
```

**Example social jobs** (adapt to your domain):

- "I want my output to be review-proof so I'm seen as thorough and reliable"
- "I don't want to be the person who missed something critical — it reflects on my professional judgment"
- "I need to demonstrate I used systematic methods, not just gut feel"
- "I want to show management I can handle the workload efficiently"

#### Emotional Jobs (How they want to FEEL)

The internal emotional experience of getting the job done.

```markdown
### Emotional Job [N]: [Job statement]

**Desired feeling:** [what they want to feel — confidence, relief, control]
**Current feeling:** [what they actually feel — anxiety, frustration, overwhelm]
**Trigger moments:** [when the emotional gap is worst]
**Evidence:** [Source]
```

**Example emotional jobs** (adapt to your domain):

- "I want to feel confident that nothing slipped through the cracks" (review workflows)
- "I want to feel in control of the AI, not controlled by it" (AI-powered features)
- "I want to feel like I'm doing meaningful work, not manual busywork" (data entry, formatting)
- "I want to feel safe that my work product won't be questioned" (high-stakes outputs)

### 4. Job Prioritization Matrix

Score each job on three dimensions:

```markdown
## Job Prioritization

| Job   | Type       | Intensity (1-5) | Frequency (1-5) | Underserved (1-5) |   Score   |  Priority  |
| ----- | ---------- | :-------------: | :-------------: | :---------------: | :-------: | :--------: |
| [job] | Functional |     [score]     |     [score]     |      [score]      | [product] | [P1/P2/P3] |
| [job] | Social     |     [score]     |     [score]     |      [score]      | [product] | [P1/P2/P3] |
| [job] | Emotional  |     [score]     |     [score]     |      [score]      | [product] | [P1/P2/P3] |
```

**Scoring guide:**

| Dimension       | 1                                 | 3                             | 5                                          |
| --------------- | --------------------------------- | ----------------------------- | ------------------------------------------ |
| **Intensity**   | Mild inconvenience                | Real pain, workarounds exist  | Desperate — willing to pay/switch to solve |
| **Frequency**   | Yearly                            | Monthly                       | Daily                                      |
| **Underserved** | Well-served by existing solutions | Partially served, gaps remain | No good solution exists                    |

**Priority = Intensity x Frequency x Underserved** (max 125)

- P1: Score > 60 — high-value, build for this
- P2: Score 25-60 — worth addressing if effort is low
- P3: Score < 25 — deprioritize unless strategic

### 5. Switching Cost Analysis

For each P1 job, analyze what prevents users from adopting a better solution:

```markdown
## Switching Costs

| Job   | Current solution | Switching cost type    | Magnitude | Implication                       |
| ----- | ---------------- | ---------------------- | --------- | --------------------------------- |
| [job] | [current]        | Data migration         | HIGH      | Need import tool or CSV bridge    |
| [job] | [current]        | Workflow retraining    | MEDIUM    | Need onboarding flow, not docs    |
| [job] | [current]        | Organizational inertia | HIGH      | Need champion + pilot program     |
| [job] | [current]        | Regulatory risk        | HIGH      | Need audit trail continuity proof |
```

**Common switching costs to consider** (adapt to your domain):

- **Data migration** — users can't switch tools mid-project without proving data integrity
- **Team retraining** — SOPs and workflows need updating when tools change
- **Data format lock-in** — years of structured data in existing tools/formats
- **External stakeholder familiarity** — clients/auditors expect certain tool outputs

### 6. Output Format

```markdown
# JTBD Analysis: [Product/Feature/Segment]

**Date:** [date]
**Target user:** [persona]
**Confidence:** [HIGH/MEDIUM/LOW]

## Key Insight

[1-2 sentences: the most important finding — what job matters most and why current solutions fail]

## Jobs Map

[Three-layer analysis from Step 3]

## Prioritization

[Matrix from Step 4]

## Switching Costs

[Analysis from Step 5]

## Recommendations

| Priority | Action   | Job it serves | Evidence |
| -------- | -------- | ------------- | -------- |
| 1        | [action] | [job]         | [source] |

## What NOT to Build

[Jobs that scored low or are well-served — explicitly name what to skip]
```

### 7. Anti-Plays

- Don't conflate functional and emotional jobs — "users want faster screening" is functional, "users want to feel confident" is emotional. Both matter, differently.
- Don't invent social/emotional jobs without evidence — if you can't cite a source, mark it [HYPOTHESIS]
- Don't prioritize based on emotional resonance alone — a deeply-felt job that occurs once a year scores lower than a mild daily friction
- Don't ignore switching costs — a P1 job with HIGH switching costs needs a migration strategy, not just a better product
- "Number of features used" is almost always a false friend for job completion — measure outcomes, not clicks
- Don't force a JTBD analysis when the answer is obvious — if the top job is already well-served and the product is clearly meeting it, say so: "tbh the JTBD analysis confirms the current direction. the real question isn't 'what job?' — it's 'how much better can we serve it?' consider `/opportunity-sizing` or `/experiment-design` instead."
- Don't list jobs you can't connect to a real user situation — every job needs a "When [situation]" trigger. If you can't name the situation, the job is too abstract.

### 8. Save Output

Save to: `projects/gazelle-agent/.state/projects/{topic}/jtbd.md`

### 9. Offer Next Steps

> "jtbd analysis complete. [N] jobs mapped, [N] P1 priorities.
>
> next options:
>
> - build personas from these jobs? (`/persona-builder [segment]`)
> - write a spec for the top job? (`/design-spec [feature]`)
> - pressure-test with a PR/FAQ? (`/working-backwards [feature]`)
> - yes-and the top opportunity? (`/yes-and [idea]`)
> - size the opportunity? (`/opportunity-sizing [feature]`)
> - run a pre-mortem before launch? (`/pre-mortem [feature]`)
> - design an experiment to validate? (`/experiment-design [hypothesis]`)"

## Integration

- Pairs with: `/persona-builder` (personas from jobs), `/design-spec` (spec for top jobs), `/working-backwards` (pressure-test the top job), `/experiment-design` (validate uncertain jobs)
- Reads from: research, personas, journey map state
- Feeds into: design spec, opportunity sizing, yes-and, working-backwards, pre-mortem

---

## Appendix: Domain Context

> For company-specific modules, users, and JTBD context, read `context-training/domain.md`.
> Run `/setup` if that file hasn't been configured yet.
