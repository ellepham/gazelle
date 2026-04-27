---
name: measure
description: "Post-launch measurement: check adoption metrics against experiment predictions. Closes the build-measure-learn loop. Use 2-4 weeks after shipping a feature."
when_to_use: "Use after shipping a feature to check if it's working. Examples: 'measure this feature', 'how is X performing', 'check adoption', 'post-launch metrics', 'did it work', 'measure impact'"
effort: medium
argument-hint: "[feature name or ticket]"
allowed-tools: Read, Grep, Glob, Write, Edit, Agent, Bash
---

# Measure

**Voice:** Casual, direct, honest. Abbrevs ok (w/, bc, tbh, imo, kinda).
Data-first energy — show the numbers, then interpret.

**Purpose:** Close the build-measure-learn loop. After shipping a feature, check if it's actually being used, if it solved the problem, and what to do next. This is the "measure" that most design processes skip.

**When to use:**

- 2-4 weeks after a feature ships to production
- When a stakeholder asks "is X working?"
- During sprint retros to check shipped feature performance
- Before deciding to iterate vs move on
- When `/experiment-design` was used pre-launch — now check the results

**Distinct from:**

- `/experiment-design` — designs the experiment BEFORE launch. `/measure` checks results AFTER.
- `/retro` — engineering retrospective (what shipped, code quality). `/measure` is product outcome focused.
- `/opportunity-sizing` — estimates potential impact. `/measure` checks actual impact.
- `/feedback-synthesizer` — collects qualitative feedback. `/measure` starts with quantitative data, then enriches with qualitative.

## Usage

```
/measure [feature name]
/measure "extraction template selection"
/measure PROJ-1234                         # by Jira ticket/epic
/measure --against experiment.md           # compare to experiment design predictions
/measure --since 2026-03-15               # custom measurement start date
```

**Flags:**

- `--against [path]` — compare results to an experiment design doc
- `--since [date]` — measurement window start (default: feature release date from Jira)
- `--period [days]` — measurement window length (default: 30 days)
- `--project [name]` — save to specific project state folder
- `--quick` — skip qualitative enrichment, numbers only

## Protocol

### 1. Identify What to Measure

Read available context:

- Jira ticket/epic — find the release date, acceptance criteria, related tickets
- `projects/gazelle-agent/.state/projects/{name}/spec.md` — design spec (what was the intended outcome?)
- `projects/gazelle-agent/.state/projects/{name}/experiment.md` — experiment design (what metrics were defined?)
- `projects/gazelle-agent/.state/projects/{name}/acceptance-criteria.md` — ACs (what "done" looks like)

**Extract the measurement plan:**

```markdown
## What we shipped

[Feature name, release date, Jira ticket]

## What we expected

[From the spec/experiment: what behavior change should we see?]

## Metrics to check

| Metric     | How to measure          | Expected direction | Baseline (pre-launch) |
| ---------- | ----------------------- | ------------------ | --------------------- |
| [metric 1] | [analytics event/query] | Up/Down/Stable     | [value if known]      |
```

If no experiment design exists, derive metrics from the spec's user stories:

- User story = "I want to X" → metric = "% of users who do X"
- Acceptance criteria = "user sees Y" → metric = "Y display events"

### 2. Pull the Numbers

Launch a `usage-analyst` subagent with specific queries:

```
usage-analyst → "Query analytics for [feature] adoption metrics.
  Dataset: [your analytics dataset — see context-training/data-sources.md]
  Time range: [release_date] to [now]

  Metrics needed:
  1. Feature adoption: How many unique users/orgs have used [feature]?
  2. Frequency: How often is it used per user per week?
  3. Retention: Of users who tried it in week 1, how many used it in week 2/3/4?
  4. Before/after: Compare [related metric] in the 30 days before vs after launch
  5. Segment: Break down by org size, module, user role if possible

  Return raw numbers + week-over-week trends."
```

**If analytics tool is unavailable:** Fall back to proxy metrics from other sources:

- Jira: how many support tickets related to the feature?
- Slack #ask-customer-success: any questions about the feature?
- Notion feedback board: any entries mentioning the feature?

### 3. Interpret the Numbers

Produce a structured readout:

```markdown
## Results

### Headline

[One sentence: is it working or not?]

### Adoption

- **Users:** [N] unique users have used [feature] ([X]% of eligible users)
- **Orgs:** [N] orgs ([X]% of eligible orgs)
- **Trend:** [Growing/Flat/Declining] week over week

### Engagement

- **Frequency:** [N] uses per user per week (vs [expected])
- **Retention:** [X]% of week-1 users returned in week 4
- **Depth:** [How deeply are they using it? Power features vs surface?]

### Impact on Target Metric

- **Before launch:** [baseline]
- **After launch:** [current]
- **Delta:** [+/-X%]
- **Statistical confidence:** [if enough data: significant/not significant/too early]

### Segments

| Segment                | Adoption | Engagement | Notes |
| ---------------------- | -------- | ---------- | ----- |
| Large orgs (50+ users) | [X]%     | [N]/week   |       |
| Small orgs (<10 users) | [X]%     | [N]/week   |       |
| Module A users         | [X]%     |            |       |
| Module B users         | [X]%     |            |       |
```

### 4. Enrich with Qualitative (skip if `--quick`)

Search for qualitative signal to explain the numbers:

```
source-researcher → "Search Slack for feedback about [feature] since [release_date].
  Check channels listed in context-training/data-sources.md.
  Look for: complaints, praise, confusion, workarounds, feature requests."

source-researcher → "Search Circleback for customer calls mentioning [feature] since [release_date].
  Look for: adoption blockers, positive reactions, training gaps."
```

Map qualitative findings to the quantitative story:

- **High adoption + positive feedback** = working as designed
- **High adoption + negative feedback** = used but painful (iterate)
- **Low adoption + no feedback** = not discovered (discoverability problem)
- **Low adoption + negative feedback** = tried and rejected (design problem)

### 5. Recommendation

```markdown
## What to Do Next

**Verdict:** [Ship and move on / Iterate / Investigate further / Roll back]

**Based on:**

- [Key metric 1]: [value] vs [expected] → [interpretation]
- [Key metric 2]: [value] vs [expected] → [interpretation]
- [Qualitative signal]: [summary]

**If iterating, focus on:**

1. [Specific issue from data]
2. [Specific issue from feedback]

**If investigating further:**

- [ ] [Specific question that needs answering]
- [ ] [User interview needed with [segment]]
```

### 6. Save Output

Save to: `projects/gazelle-agent/.state/projects/{name}/measure-{date}.md`

Also update the project's `session-log.md` with the measurement results.

**If `/experiment-design` was used:** Update the experiment doc with "Results" section linking to this measurement.

## What to Measure Per Feature Type

| Feature Type                                            | Primary Metric                                | Secondary Metrics                    |
| ------------------------------------------------------- | --------------------------------------------- | ------------------------------------ |
| **New UI element** (button, filter, tab)                | Click rate / use rate                         | Task completion time, error rate     |
| **New workflow** (search setup, bulk extraction)        | Completion rate                               | Drop-off point, time to complete     |
| **AI feature** (screening, extraction, recommendations) | Acceptance rate (AI suggestion → user action) | Override rate, accuracy feedback     |
| **Settings/config**                                     | Configuration rate                            | Default vs custom ratio              |
| **Performance improvement**                             | Task time before/after                        | User satisfaction (if NPS exists)    |
| **Navigation change**                                   | Time to target page                           | Support tickets about "can't find X" |

## Analytics Event Reference

Check `context-training/data-sources.md` for your product's event taxonomy and key tables.

For feature-specific events, check the feature's PR or implementation doc for new events added.

## Integration

- **After `/experiment-design`:** Run `/measure` when the experiment period ends
- **During `/retro`:** Reference `/measure` results for shipped features
- **Feeds `/feedback-synthesizer`:** Quantitative baseline for qualitative synthesis
- **Informs next `/research`:** If metrics show unexpected patterns, kick off targeted research

## Skill Chaining

```
/experiment-design → [ship feature] → [wait 2-4 weeks] → /measure → /research (if needed) → iterate
```

`/measure` closes the loop. Without it, you're designing blind.
