---
name: experiment-design
description: "Design rigorous experiments: hypothesis, metrics, holdout strategy, sample size, duration, and readout template. For A/B tests, feature experiments, pricing tests, and de-risking before full launch."
when_to_use: "Use when designing experiments or A/B tests. Examples: 'design an experiment', 'A/B test', 'how do we test this', 'experiment plan', 'should we run an experiment'"
effort: medium
argument-hint: "[feature/change to test]"
allowed-tools: Read, Grep, Glob, Write, Edit
---

# Experiment Design

**Voice:** Casual, direct, honest. Abbrevs ok (w/, bc, tbh, imo, kinda).
Lead w/ answer, context after. Flag gaps helpfully (coach, not auditor). Cite sources always.

**Source:** Adapted from Amplitude Builder Skills' craft-experiment-design + craft-experiment-readout.

## Usage

```
/experiment-design [what you want to test]
/experiment-design "AI confidence scores in screening"
/experiment-design "new export format" --readout
```

**Flags:**

- `--readout` — include a readout template for post-experiment analysis
- `--project [name]` — save to specific project state folder
- `--quick` — skip sample size calculations, produce framework only

## Protocol

### 1. Load Context

Read these if available:

- `projects/gazelle-agent/.state/projects/{name}/spec.md` — what's being tested
- `projects/gazelle-agent/.state/projects/{name}/opportunity-sizing.md` — baseline metrics
- `projects/gazelle-agent/.state/projects/{name}/pre-mortem.md` — risks to test against
- `projects/gazelle-agent/.state/projects/{name}/jtbd.md` — jobs analysis (ground hypothesis in validated jobs)
- `projects/gazelle-agent/.state/projects/{name}/working-backwards.md` — PR/FAQ (use Kill Test results to validate experiment necessity)
- `projects/gazelle-agent/context-training/domain.md` — products, modules, users
- `projects/gazelle-agent/context-training/data-sources.md` — BigQuery tables, event schema

### 2. Gate Check: Do You Even Need an Experiment?

Before designing anything, challenge whether an experiment is the right move:

> "before we design this experiment — let me check if we actually need one."

**Skip the experiment if:**

- The evidence is already clear (3+ sources pointing the same direction, high confidence) → "evidence is strong enough to just ship. an experiment would delay value for statistical comfort."
- The change is easily reversible AND low-risk → "just ship it behind a feature flag. if metrics drop, roll back. faster than waiting 4 weeks for significance."
- The sample size math won't work (too few users, too small an effect) → "with [N] eligible users, you'd need [X] weeks to detect a [Y]% change. that's not practical — consider a qualitative study or phased rollout instead."
- The feature is table stakes (customers are asking for it, competitors have it) → "this isn't a hypothesis to test — it's a gap to close."

**Do experiment if:**

- The change is risky or irreversible (affects compliance workflows, data integrity, enterprise contracts)
- There's genuine uncertainty about user behavior (not just internal debate)
- The cost of being wrong is high (patient safety, audit trail, data accuracy)
- You're choosing between meaningfully different approaches

If the gate check says "don't experiment," suggest alternatives:

- "just ship behind a feature flag" → `/design-spec [feature]`
- "need more evidence first" → `/research [topic] --deep` or `/jtbd [segment]`
- "pressure-test the idea before investing in experimentation" → `/working-backwards [feature]`

### 3. Hypothesis Formation

Every experiment starts with a falsifiable hypothesis. No hypothesis = no experiment.

```markdown
## Hypothesis

**If** [specific change we're making]
**Then** [specific measurable outcome]
**Because** [mechanism — why we believe this will happen]

**Null hypothesis:** [What we expect if the change has no effect]
**Minimum detectable effect (MDE):** [Smallest change worth detecting — e.g., 5% improvement]
```

Rules for good hypotheses:

- "Users will like it more" is not a hypothesis — what behavior changes?
- The "because" must reference a mechanism, not a wish
- MDE must be grounded in business impact: "5% improvement in screening speed saves ~2 hrs/week per Clinical Affairs Specialist"

**Example hypothesis patterns** (adapt to your product using `context-training/domain.md`):

| Feature area | Good hypothesis example                                                                                                                                             |
| ------------ | ------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| AI screening | "If we show confidence scores per item, then manual re-screening rate drops by 20%, because users currently re-screen all AI decisions due to lack of transparency" |
| Alert triage | "If we pre-sort alerts by relevance, then daily review time drops from 45min to 25min, because reviewers currently scan all alerts sequentially"                    |
| Export       | "If we add structured sections to the export, then export-to-submission time drops by 30%, because users currently restructure exports manually"                    |

### 3. Metrics Definition

Define three tiers of metrics:

```markdown
### Primary metric (ONE — the decision metric)

| Metric        | Current baseline | Target   | MDE                         | Measurement    |
| ------------- | ---------------- | -------- | --------------------------- | -------------- |
| [metric name] | [current value]  | [target] | [minimum meaningful change] | [how measured] |

### Secondary metrics (2-3 — supporting evidence)

| Metric   | Why it matters     | Measurement    |
| -------- | ------------------ | -------------- |
| [metric] | [what it tells us] | [how measured] |

### Guardrail metrics (2-3 — things that must NOT get worse)

| Metric   | Current baseline | Red line                              | Measurement    |
| -------- | ---------------- | ------------------------------------- | -------------- |
| [metric] | [current]        | [threshold that kills the experiment] | [how measured] |
```

Rules:

- ONE primary metric. Not two. Not "primary and co-primary." One.
- Guardrail metrics are non-negotiable — if a guardrail trips, the experiment stops regardless of primary metric
- Consider domain-specific guardrails (e.g., "data accuracy" and "audit trail completeness" in regulated industries)

### 4. Audience & Holdout Strategy

```markdown
## Audience

**Eligible population:** [Who can be in this experiment]
**Exclusions:** [Who must be excluded — e.g., "enterprise accounts with custom contracts, trial accounts"]

### Allocation

| Group     | %     | Size (est.) | What they see        |
| --------- | ----- | ----------- | -------------------- |
| Control   | [50%] | [N users]   | [Current experience] |
| Treatment | [50%] | [N users]   | [New experience]     |

### Randomization unit

[user / org / session — and why]
```

**B2B consideration:** Randomize by ORG, not user, for enterprise features. Users within the same org seeing different experiences creates confusion in collaborative workflows.

### 5. Sample Size & Duration

```markdown
## Duration

**Minimum runtime:** [N] weeks
**Rationale:**

- Statistical: need [N] events per variant at [power]% power, [significance]% significance
- Practical: need [N] business cycles (e.g., "report updates are monthly — need 2 cycles minimum")
- Novelty: add [1 week] buffer for novelty effect to wear off

### Early stopping rules

| Condition                                        | Action                                      |
| ------------------------------------------------ | ------------------------------------------- |
| Guardrail metric crosses red line                | Stop experiment, roll back                  |
| Primary metric is [3x MDE] better at 50% runtime | Consider calling early (but check novelty)  |
| <10% of expected traffic after 1 week            | Investigate — instrumentation may be broken |
```

**Show the math:** "With [N] eligible users, [X]% conversion baseline, and [Y]% MDE, we need ~[Z] users per variant. At current traffic of [W] users/week, that's [N] weeks minimum."

### 6. Risk Assessment

```markdown
## Risks

| Risk   | Probability | Impact  | Mitigation |
| ------ | ----------- | ------- | ---------- |
| [risk] | [H/M/L]     | [H/M/L] | [plan]     |

### What could invalidate results

- [Confounding factors]
- [Selection bias]
- [External events — e.g., regulatory deadline weeks, end-of-quarter]
```

### 7. Readout Template (if --readout or always include)

```markdown
## Experiment Readout

### TL;DR

[1-2 sentences: what we tested, what happened, what we're doing]
**Decision:** [SHIP / ITERATE / KILL]

### Results

| Metric    | Control | Treatment | Delta   | Confidence | Significant? |
| --------- | ------- | --------- | ------- | ---------- | ------------ |
| [primary] | [value] | [value]   | [+/-X%] | [CI]       | [YES/NO]     |

### Show the math

"[Primary metric] improved from [X] to [Y], a [Z]% lift. On [N] eligible users, that means [concrete impact]."

### Segment analysis

| Segment                | Control | Treatment | Delta   | Notes            |
| ---------------------- | ------- | --------- | ------- | ---------------- |
| Enterprise (>50 users) | [value] | [value]   | [+/-X%] | [interpretation] |

### Stakeholder comms

**For PM:** [2-3 sentences: roadmap impact]
**For CEO:** [2-3 sentences: business impact]
**For Engineering:** [2-3 sentences: what to ship/clean up]
```

### 8. Anti-Plays (Common Experiment Mistakes)

- Don't peek at results before minimum runtime — leads to false positives
- Don't change the primary metric mid-experiment — that's p-hacking
- Don't run on <5% of traffic "to be safe" — you'll never reach significance
- Don't skip guardrails bc "we're pretty sure it's safe" — that's how you break things
- Don't call a winner on secondary metrics when primary is flat
- Don't run during peak deadline periods — unusual traffic patterns confound results
- Don't experiment when the answer is already clear — if 3+ customer interviews say "yes, we need this" and usage data confirms the pain point, just ship it. Experiments are for genuine uncertainty, not for deferring decisions
- Don't design an experiment with an MDE larger than the realistic effect — if you need a 50% lift to reach significance but the realistic effect is 10%, the experiment will waste weeks and end inconclusive

### 9. Checklist Before Launch

- [ ] Hypothesis reviewed by PM
- [ ] Primary metric baseline confirmed in analytics
- [ ] Guardrail metrics instrumented and baselined
- [ ] Randomization unit confirmed (user vs org)
- [ ] Enterprise exclusions configured
- [ ] Feature flag set up
- [ ] Minimum runtime communicated to stakeholders (no peeking!)
- [ ] Readout template prepared
- [ ] Early stopping rules agreed upon

### 10. Save Output

Save to: `projects/gazelle-agent/.state/projects/{topic}/experiment-plan.md`

### 11. Offer Next Steps

> "experiment plan ready. hypothesis: [summary]. duration: ~[N] weeks.
>
> next options:
>
> - run a pre-mortem on this experiment? (`/pre-mortem [experiment name]`)
> - size the opportunity first? (`/opportunity-sizing [feature]`)
> - validate what job this serves? (`/jtbd [segment]`)
> - pressure-test the idea with a PR/FAQ? (`/working-backwards [feature]`)
> - need the spec before experimenting? (`/design-spec [feature]`)"

## Integration

- Pairs with: `/pre-mortem` (risk assessment), `/opportunity-sizing` (is it worth testing?), `/jtbd` (validate the underlying job), `/working-backwards` (pressure-test the idea)
- Reads from: spec, opportunity sizing, pre-mortem, JTBD state
- Feeds into: experiment execution, readout, ship/kill decisions

---

## Appendix: Domain Context

> For company-specific modules, users, and experiment context, read `context-training/domain.md`.
> Run `/setup` if that file hasn't been configured yet.
