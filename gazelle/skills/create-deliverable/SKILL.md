---
name: create-deliverable
description: "Generate stakeholder-ready analysis artifacts: voice cards, debates, critic reviews, decision matrices, and 1-pagers. Use after research when you need structured analysis for presenting to stakeholders, not just raw findings."
when_to_use: "Use when creating stakeholder-ready artifacts. Examples: 'create voice cards', 'run a debate', 'write a 1-pager for [stakeholder]', 'decision matrix', 'prepare for stakeholder meeting'"
effort: low
argument-hint: "[topic] [--type voice-cards/debate/one-pager] [--for name]"
allowed-tools: Read, Grep, Glob, Write, Edit
---

# Synthesis Toolkit

**Voice:** Casual, direct, honest. Abbrevs ok (w/, bc, tbh, imo, kinda).
Lead w/ answer, context after. Flag gaps helpfully (coach, not auditor). Cite sources always.

## Usage

```
/create-deliverable [topic] --type [voice-cards|debate|critic-review|decision-matrix|one-pager]
/create-deliverable [topic] --type voice-cards --for [stakeholder-name]
/create-deliverable [topic] --type debate --positions "option-a,option-b"
```

**Flags:**

- `--type [type]` — which artifact to generate (required). Options: `voice-cards`, `debate`, `critic-review`, `decision-matrix`, `one-pager`
- `--for [stakeholder]` — tailor output for specific person (uses stakeholder profiles from memory or `context-training/domain.md`)
- `--from [path]` — point to specific research files (default: reads from `.state/projects/{topic}/`)
- `--project [name]` — specify project folder name
- `--positions [csv]` — for debates: comma-separated positions to argue

## Protocol

### 1. Load State

Read in this order:

1. `projects/gazelle-agent/.state/projects/{topic}/research.md` — raw findings (required)
2. `projects/gazelle-agent/.state/projects/{topic}/insights.md` — synthesized insights (if exists)
3. `projects/gazelle-agent/.state/projects/{topic}/context.md` — project context
4. `projects/gazelle-agent/.state/projects/{topic}/competitive-analysis.md` — competitor intel (if exists — use for voice cards and debates)
5. `projects/gazelle-agent/.state/feedback/synthesis-*.md` — most recent feedback synthesis (if exists — use for voice cards and customer health alerts)
6. `projects/gazelle-agent/context-training/evidence-thresholds.md` — confidence criteria
7. `projects/gazelle-agent/context-training/domain.md` — terms, products, users

If `--for` is specified, also load the stakeholder profile. Stakeholder profiles can be defined in `context-training/domain.md` under the Team section, noting each person's decision-making style (e.g., revenue-first, discovery-driven, vision-scale).

If no research state exists:

> "no research found for '{topic}'. run `/research {topic}` first — can't synthesize without evidence."

### 2. Evidence Inventory

Before generating any artifact, take stock:

```markdown
synthesis inputs for [topic]:

- [N] sources across [types]
- [N] unique voices represented
- evidence strength: [strong/moderate/thin]
- gaps: [what's missing]
```

If evidence is thin (1 source type, <3 voices), flag it:

> "heads up — evidence is thin here. generating anyway but flagging low-confidence claims."

### 3. Generate Artifact

#### Voice Cards (`--type voice-cards`)

A voice card captures ONE stakeholder perspective on a topic. Generate 3-5 cards depending on scope.

**Template per card:**

````markdown
## Voice Card: [Perspective Name]

**Stakeholder lens:** [whose perspective — use domain-specific lenses from domain.md]

**Voice card perspectives should reflect your product's actual user roles and internal teams.** Load these from `context-training/domain.md`. Common lens types include:

| Lens type             | Who                   | What they care about                                        |
| --------------------- | --------------------- | ----------------------------------------------------------- |
| Power user            | Primary product user  | Speed, AI trust, output quality, export format              |
| Daily user            | Regular product user  | Relevance, noise reduction, coverage, batch operations      |
| Cross-module user     | Multi-module user     | Audit trail, consistency, compliance, report assembly       |
| Customer success team | Customer-facing       | Onboarding friction, common support tickets, churn signals  |
| Sales team            | Revenue-facing        | Competitive positioning, pricing, feature gaps losing deals |
| Engineering team      | Technical constraints | Feasibility, data quality, API limits, migration risk       |

**Core position:** [1 sentence summary of what this perspective says]

### Evidence

| Signal                | Source                                   | Confidence   |
| --------------------- | ---------------------------------------- | ------------ |
| [specific data point] | [Slack/Circleback/Analytics/Notion link] | HIGH/MED/LOW |

### Key quote

> "[verbatim or near-verbatim quote]" — [person], [context]

### Implication for [topic]

[1-2 sentences: what this means for the decision]

### Tension with other voices

**Example voice card (use as quality benchmark):**

```markdown
## Voice Card: [Role Name] ([Module] Daily User)

**Stakeholder lens:** [Role] — [brief description of what they do and in what context]
**Core position:** "AI relevance filtering is the only way to handle the volume, but I need to see WHY it scored an item as irrelevant before I trust it."

### Evidence

| Signal                                                        | Source                                     | Confidence |
| ------------------------------------------------------------- | ------------------------------------------ | ---------- |
| 45+ min daily on triage, 78% false positives                  | Analytics: ITEM_REVIEWED events, [quarter] | HIGH       |
| "I go through every excluded item — I can't risk missing one" | Circleback: [Customer Name], [date]        | HIGH       |
| 3 support tickets about missing AI reasoning                  | Notion: feedback board, [date range]       | MED        |

### Key quote

> "If I can't see why AI excluded it, I just re-review everything. That defeats the purpose." — [Customer], [Company]

### Implication for [topic]

AI trust mechanisms aren't optional nice-to-haves — without visible reasoning, users revert to manual review, eliminating the AI's value entirely.

### Tension with other voices

Conflicts with Engineering voice (adding reasoning UI adds complexity) and Sales voice (customers buy on "AI handles it" promise, not "AI shows its work").
```
````

[Which other voice cards conflict with this one, and why]

````

**Rules:**

- Each card must cite specific evidence, not vibes
- Include at least 1 direct quote per card
- Always identify tensions between cards — that's where the insight lives
- If a perspective has thin evidence, say so: "this voice is underrepresented — 1 signal only"

#### Debate (`--type debate`)

Structured argument between 2-3 positions. Useful before making a binary decision.

**Structure:**

```markdown
# Debate: [Topic]

## Position A: [Name] — ADVOCATE

**Core argument:** [2-3 sentences]

### Evidence FOR

| #   | Claim | Evidence | Source | Confidence |
| --- | ----- | -------- | ------ | ---------- |

### Strongest case

[3-4 sentence steel-man of this position]

---

## Position B: [Name] — ADVOCATE

[same structure]

---

## Cross-Examination

### A challenges B:

- [specific weakness in B's evidence]
- [counter-argument with evidence]

### B challenges A:

- [specific weakness in A's evidence]
- [counter-argument with evidence]

## Key Tension

[1-2 sentences: the fundamental tradeoff or uncertainty that makes this a real debate, not an obvious choice]

## Recommendation

[which position has stronger evidence, with confidence level. or: "genuinely uncertain — needs [specific data] to resolve"]
````

**Rules:**

- Steel-man both sides. Don't strawman the weaker position.
- Cross-examination must cite specific evidence gaps, not just opinions
- Key tension is the most important section — it's what the stakeholder needs to decide on
- If `--positions` not specified, infer the 2 strongest opposing positions from research

#### Critic Review (`--type critic-review`)

Structured critique of a plan, spec, or research finding. Identifies blind spots and strengthens the work.

**Structure:**

```markdown
# Critic Review: [What's Being Reviewed]

## Summary of Claims

| #   | Claim | Evidence Strength | Verified? |
| --- | ----- | ----------------- | --------- |

## What Holds Up

[claims with strong multi-source evidence]

## What's Shaky

[claims with thin evidence, single-source, or contradicted signals]

## Blind Spots

[what the work doesn't address but should — questions not asked, sources not checked, perspectives not represented]

## Fact-Check Corrections

[any claims that are wrong or misleading, with correct information and source]

## Suggested Follow-Ups

| #   | Action | Why | Priority |
| --- | ------ | --- | -------- |
```

**Rules:**

- Actually verify claims against sources when possible (re-check links, re-read transcripts)
- "Blind spots" should be specific, not generic ("you didn't talk to CS" not "more research needed")
- Be direct: "this claim is wrong bc..." not "this claim could perhaps be reconsidered"

#### Decision Matrix (`--type decision-matrix`)

Structured comparison of options against weighted criteria. Useful for prioritization.

**Structure:**

```markdown
# Decision Matrix: [What We're Deciding]

## Options

| Option | 1-Line Description |
| ------ | ------------------ |

## Criteria (weighted)

| Criterion | Weight | Why This Weight |
| --------- | ------ | --------------- |

## Scoring

| Option | Criterion 1 (W%) | Criterion 2 (W%) | ... | Weighted Total |
| ------ | :--------------: | :--------------: | :-: | :------------: |

## Evidence Behind Scores

[For any score that isn't obvious, cite the evidence that informed it]

## Recommendation

[top option + confidence level + what could change the answer]
```

**Rules:**

- Criteria weights must be justified, not arbitrary
- Scores must tie to evidence, not gut feel
- Always include "what could change the answer" — decisions decay

#### One-Pager (`--type one-pager`)

Single-page decision brief for a specific stakeholder. The "so what" of research.

**Structure:**

```markdown
# [Topic]: [Recommendation in <=10 words]

**For:** [stakeholder name]
**Date:** [date]
**Confidence:** [HIGH/MEDIUM/LOW]

## The Question

[What we're trying to decide, in 1 sentence]

## Recommendation

[Binary: do this / don't do this. Then 2-3 sentences of why.]

## Key Evidence

| #   | Finding | Source | Weight |
| --- | ------- | ------ | ------ |

## Risks of This Recommendation

[What could go wrong. Be honest.]

## Alternative Considered

[What the other option was and why it lost]

## Cross-Module Impact (if comparing multi-module features)

| Module     | Current ARR at stake | Users affected | Lock-in effect                               |
| ---------- | -------------------- | -------------- | -------------------------------------------- |
| [Module A] | [amount]             | [N]            | [what happens if this module weakens]        |
| [Module B] | [amount]             | [N]            | [what happens if this module weakens]        |
| [A+B]      | [amount]             | [N]            | [cross-module integration as strategic moat] |

**Strategic moat question:** Does building this increase cross-module lock-in? If a customer uses multiple modules together, they're much harder to churn than single-module customers. Quantify this.

## Next Step

[Exactly 1 action item with owner suggestion]
```

**Rules:**

- When `--for` is specified, tailor the framing to that stakeholder's decision-making style. Define stakeholder profiles in `context-training/domain.md` under the Team section. Common archetypes:
  - Revenue-focused leaders: binary recommendation, 1 page max, no hedging
  - Discovery-driven PMs: categorize first, then prioritize, include breadth
  - Vision-scale leadership: strategic framing, market-level implications
- If no `--for`: default to neutral, evidence-forward.

### 4. Save Output

Save to: `projects/gazelle-agent/.state/projects/{topic}/synthesis-{type}.md`

If multiple artifacts generated, save each separately.

### 5. Offer Next Steps

After generating:

> "artifact saved to [path]. next options:
>
> - generate another type? (voice-cards → debate → one-pager is a common flow)
> - refine this one? (adjust for different stakeholder, add evidence, sharpen)
> - proceed to design-spec? (if ready to move to definition)"

---

## Appendix: Domain Context

> To customize Gazelle for your company, populate `context-training/domain.md` with your product's modules, users, key terms, competitors, and team structure.
>
> Stakeholder profiles for the `--for` flag should also be defined in `domain.md` under the Team section.
>
> This appendix is intentionally empty in the open-source distribution. Your company-specific context lives in the context-training files, not here.
