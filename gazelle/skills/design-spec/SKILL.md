---
name: design-spec
description: "Write a design spec from accumulated discovery state (research, insights, personas, journey). Produces a design-level spec — not a technical spec (that's spec-machine's job downstream)."
when_to_use: "Use when writing a design spec from research. Examples: 'write a design spec', 'spec this feature', 'design requirements for'"
effort: low
argument-hint: "[feature]"
allowed-tools: Read, Grep, Glob, Write, Edit
---

# Design Spec

**Voice:** Casual, direct, honest. Abbrevs ok (w., bc, tbh, imo, kinda).
Lead w. answer, context after. Flag gaps helpfully (coach, not auditor). Cite sources always.

## Usage

```
/design-spec [feature]
/design-spec [feature] --project [name]
/design-spec [feature] --minimal              # Skip sections without data
```

**Flags:**

- `--project [name]` — specify project folder (default: kebab-case of feature name)
- `--minimal` — only include sections that have backing evidence

**Prerequisites:** At minimum, research.md must exist. The more prior phases completed (insights, personas, journey), the stronger the spec.

## Protocol

### 1. Load State

Read in this order (available → required):

1. `projects/gazelle-agent/.state/projects/{name}/research.md` — **required** (raw findings)
2. `projects/gazelle-agent/.state/projects/{name}/insights.md` — recommended
3. `projects/gazelle-agent/.state/projects/{name}/personas.md` — optional
4. `projects/gazelle-agent/.state/projects/{name}/journey-map.md` — optional
5. `projects/gazelle-agent/.state/projects/{name}/flow-analysis.md` — optional (visual flow capture + screenshots)
6. `projects/gazelle-agent/.state/projects/{name}/jtbd.md` — optional (jobs analysis — use P1 jobs to frame requirements)
7. `projects/gazelle-agent/.state/projects/{name}/yes-and.md` — optional (expanded idea — use upgraded pitch as direction)
8. `projects/gazelle-agent/.state/projects/{name}/context.md` — project context

Context training: 6. `projects/gazelle-agent/context-training/design-principles.md` — your design philosophy 7. `projects/gazelle-agent/context-training/service-design-methods.md` — method references 8. `projects/gazelle-agent/context-training/evidence-thresholds.md` — confidence criteria 9. `projects/gazelle-agent/context-training/personas-reference.md` — known personas

If no research state exists:

> "no research found for '{feature}'. run `/research {feature}` first — can't write a spec without evidence."

### 2. State Inventory

Before writing, show what you're working with:

```markdown
spec checkpoint: inputs for [feature]

| Phase        | Status | Key Content                        |
| ------------ | ------ | ---------------------------------- |
| Research     | Y/N    | [N] sources, [date]                |
| Insights     | Y/N    | [N] insights, [date]               |
| Personas     | Y/N    | [archetypes], [date]               |
| Flow Capture | Y/N    | [N] screens, [environment], [date] |
| Journey      | Y/N    | [flow name], [date]                |

gaps:

- [what's missing and how it affects the spec]

proceeding with [what we have]. sections without backing data will be flagged.
```

**Spec Quality Bar — domain-specific examples:**

User stories MUST reference your product's actual user roles (from `domain.md`), not generic "the user":

- Bad: "As a user, I want to filter results, so that I find relevant ones faster"
- Good: "As a **[specific role from domain.md]** doing [specific workflow], I want to [specific action], so that I can [specific outcome tied to their job]"

Pain points MUST be grounded in specific evidence:

- Bad: [pain] | "User" | "[some research]" | MEDIUM
- Good: "[specific observed behavior]" | "[specific role] ([specific companies/segments])" | "[source with date and link]" | HIGH

Requirements MUST trace back to a named source (insight, research finding, or quote):

- Bad: FR1 | "System must support batch screening" | P1 | "research"
- Good: FR1 | "[specific measurable requirement]" | P1 | "Insight 2: [specific finding with source and date]"

If only research exists (no insights/personas/journey), warn:

> "writing spec from research only — this'll be more hypothesis-driven. consider running insights/personas first for a stronger spec. proceed anyway?"

### 3. Write the Spec

#### Spec Template

```markdown
# Design Spec: [Feature Name]

**Date:** [date]
**Author:** Gazelle (with human review)
**Status:** Draft — needs human validation
**Project:** gazelle/.state/projects/{name}/

---

## 1. Problem Statement

### Current State

[What users do today. Grounded in research + journey map if available.]

### Pain Points

| Pain   | Who                  | Evidence | Confidence   |
| ------ | -------------------- | -------- | ------------ |
| [pain] | [persona or segment] | [source] | HIGH/MED/LOW |

### Desired State

[What "solved" looks like. From insights if available.]

---

## 2. Design Direction

### Core Idea

[1-2 sentences: what we're proposing]

### Why This Direction

[Rationale grounded in insights. Reference specific evidence.]

### Design Principles Applied

[Which design principles from context-training/design-principles.md are most relevant + how they shape the solution]

### What This Is NOT

[Explicitly scope what's excluded]

### Forced Alternatives (MANDATORY before committing to a direction)

Before finalizing the design direction, generate three distinct approaches. This prevents anchoring on the first idea.

| Approach                  | Name   | Summary                                                                                         | Ships in    | Best for                                  |
| ------------------------- | ------ | ----------------------------------------------------------------------------------------------- | ----------- | ----------------------------------------- |
| **A: Minimal Viable**     | [name] | Smallest version that delivers value. Fewest files, smallest diff, ships fastest.               | [timeframe] | Validating demand before investing        |
| **B: Ideal Architecture** | [name] | Best long-term trajectory. Most elegant. Does it right the first time.                          | [timeframe] | When you're confident in the direction    |
| **C: Lateral Reframe**    | [name] | Unexpected approach. Reframes the problem entirely. "What if we didn't build a [thing] at all?" | [timeframe] | When the obvious approach has blind spots |

For each approach, include:

- **Pros:** 2-3 bullets
- **Cons:** 2-3 bullets
- **Reuses:** existing code/patterns leveraged
- **Kills:** what you explicitly skip or defer

**RECOMMENDATION:** Choose [X] because [one-line reason]. State what evidence would change this recommendation.

**Anti-anchoring rule:** If you find yourself describing Approach A as "too minimal" and Approach C as "too weird" to justify picking B — you've anchored. The lateral option should be genuinely considered, not a strawman.

### Cross-Module Requirements (if feature spans multiple product modules)

If the feature involves users who work across modules, add this section. Refer to `context-training/domain.md` for your product's module structure.

| Requirement                     | Modules   | Why                                         | Priority |
| ------------------------------- | --------- | ------------------------------------------- | -------- |
| [cross-module consistency need] | [modules] | [why users need consistency across modules] | P1       |
| [shared data/export need]       | [modules] | [why data needs to flow between modules]    | P1       |
| [unified workflow need]         | [modules] | [why separate workflows create friction]    | P2       |

Also check: do cross-module users have a persona defined? If not, flag as a gap.

---

## 3. User Stories

[Grounded in personas if available. If no personas, use segments from research.]

| #   | As a...        | I want to... | So that... | Priority | Evidence |
| --- | -------------- | ------------ | ---------- | -------- | -------- |
| US1 | [persona/role] | [action]     | [outcome]  | P1/P2/P3 | [source] |
| US2 | [persona/role] | [action]     | [outcome]  | P1/P2/P3 | [source] |

---

## 4. Key Flows

[From journey map if available. If flow-analysis.md exists, reference screenshots and per-screen descriptions — link to specific screenshots in flow diagrams. Otherwise derive from research.]

### Flow 1: [Name]
```

[Step 1] → [Step 2] → [Step 3] → [Step 4]
↓ (error)
[Error handling]

```

**Happy path:** [description]
**Edge cases:** [what could go wrong]
**Metrics:** [how to measure success]

---

## 5. Requirements

### Functional Requirements
| ID | Requirement | Priority | From |
|----|------------|----------|------|
| FR1 | [requirement] | P1/P2/P3 | [insight/research ref] |

### Non-Functional Requirements
| ID | Requirement | Constraint |
|----|------------|------------|
| NFR1 | [requirement] | [constraint] |

### Design Requirements
| ID | Requirement | Principle |
|----|------------|-----------|
| DR1 | [requirement] | [which design principle from design-principles.md] |

---

## 6. Acceptance Criteria

| # | Criterion | Verification |
|---|-----------|-------------|
| AC1 | [criterion] | [how to verify] |

---

## 7. Evidence Summary

### What Supports This Spec
| Claim | Sources | Confidence |
|-------|---------|------------|
| [claim] | [sources] | HIGH/MED/LOW |

### Assumptions (Unvalidated)
- [assumption] — based on: [what]

### Blind Spots
- [gap] — fill with: [method]

---

## 8. Business Impact (auto-generated)

> This section is auto-generated by Gazelle. Forces every spec to connect design decisions to business outcomes.

### Revenue Impact
- **Which customer segments does this affect?** [segments]
- **Deal-closing potential:** [Is any prospect waiting for this? Name them.]
- **Churn risk if NOT built:** [Any customers at risk without this? Evidence?]
- **Upsell/expansion:** [Does this unlock upsell to existing customers?]

### Adoption Impact
| Metric | Expected direction | Confidence | How to measure |
|--------|-------------------|------------|----------------|
| New user activation | [Up/Down/Stable] | [HIGH/MED/LOW] | [analytics event or proxy] |
| Feature adoption rate | [target %] | | [analytics event] |
| Time-to-value | [Faster/Slower/Same] | | [Proxy metric] |
| Support ticket volume | [Down?] | | [support channel or tracker] |

### Effort vs Impact Assessment
- **Effort:** [S/M/L] — [1-sentence why]
- **Impact:** [S/M/L] — [1-sentence why]
- **Ratio:** [Worth it? / Needs descoping? / Consider phasing?]

### Post-Launch Measurement Plan
- **When to measure:** [2 weeks / 4 weeks / 8 weeks after launch]
- **Primary metric:** [the ONE number that tells us if this worked]
- **Success threshold:** [what "good" looks like]
- **Skill to run:** `/measure [feature-name] --since [launch-date]`

> If you can't fill this section, that's a signal — either the feature's business case is unclear, or you need to run `/opportunity-sizing` first.

---

## 9. Open Questions + Risks

| # | Question/Risk | Impact | Suggested Resolution |
|---|--------------|--------|---------------------|
| Q1 | [question] | [impact] | [how to resolve] |

---

## 10. Recommended Next Steps

| Priority | Action | Why |
|----------|--------|-----|
| 1 | [action] | [reason] |

**Handoff options:**
- → `/diverge [feature]` — explore solution space if direction isn't locked yet
- → `/design-critique [figma-url] --project {name}` — review designs against this spec
- → `/acceptance-criteria [feature]` — generate testable ACs from this spec
- → spec-machine `/gather-requirements` — turn design spec into technical spec + tasks
- → `/measure [feature] --since [date]` — check results 2-4 weeks after shipping
- → user research — if blind spots are too big to proceed
```

### 4. Reality Check

Before finalizing, self-check:

- **Evidence-backed?** Every requirement traces to research/insights?
- **Persona-grounded?** User stories reference actual user types, not generic "the user"?
- **Honest about gaps?** Assumptions and blind spots documented, not hidden?
- **Actionable?** Could someone take this spec and start designing/building?
- **Scoped?** Clear what's in and out? Not trying to solve everything?

### 5. Save State

Save to: `projects/gazelle-agent/.state/projects/{name}/spec.md`

Update `context.md`:

```markdown
## State

- [x] Research — [date]
- [x] Insights — [date]
- [x] Personas — [date] (or "skipped")
- [x] Journey map — [date] (or "skipped")
- [x] Spec — [date]
- [ ] Critique
```

### 6. Suggest Next

Based on spec quality:

- If no design yet: "→ want to explore design directions? `/explore-designs` to generate 2-3 hi-fi concepts in Figma"
- If design exists: "→ next: `/design-critique [figma-url] --project {name}` to check design against spec"
- If ready for eng: "→ next: hand off to spec-machine (`/gather-requirements`) for technical spec + implementation tasks"
- If gaps too big: "→ honestly? this spec has [N] big assumptions. recommend [specific research] before building"
- Before launch: "→ run a pre-mortem first? (`/pre-mortem [feature]`) — identifies real risks before you ship"
- To de-risk: "→ design an experiment? (`/experiment-design [hypothesis]`) — test the riskiest assumption"
- To pressure-test: "→ write a PR/FAQ? (`/working-backwards [feature]`) — force clarity on the value prop"
- To validate the job: "→ JTBD analysis? (`/jtbd [segment]`) — confirm you're solving the right problem"

## Quality Bar

Spec is "done" when:

- [ ] Every requirement has a source (research/insight/persona/journey)
- [ ] User stories reference specific personas or segments, not "the user"
- [ ] Acceptance criteria are testable (not vague "should be good")
- [ ] Assumptions are flagged, not buried
- [ ] Scope is explicit (in/out)
- [ ] Next steps are actionable

## Integration

- Reads from: `/research`, `/insights`, `/persona-builder`, `/flow-capture`, `/journey-mapping` outputs
- Design principles from: `context-training/design-principles.md`
- Evidence rules from: `context-training/evidence-thresholds.md`
- Feeds into: `/design-critique`, spec-machine `/gather-requirements`, `/pre-mortem` (before launch), `/experiment-design` (de-risk), `/working-backwards` (pressure-test)

---

## Appendix A: Domain Context

> To customize Gazelle for your company, populate `context-training/domain.md` with your product's modules, users, key terms, competitors, and team structure.
>
> This appendix is intentionally empty in the open-source distribution. Your company-specific context lives in the context-training files, not here.

---

## Appendix B: Design Context

> To customize design specs for your product, populate `context-training/design-principles.md` with your design philosophy, visual hierarchy rules, color system, typography, spacing, page skeletons, AI feature treatment, and anti-patterns.
>
> This appendix is intentionally empty in the open-source distribution.
