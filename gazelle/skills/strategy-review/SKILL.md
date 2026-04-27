---
name: strategy-review
description: >
  Strategic plan review — rethink the problem, find the 10-star version,
  challenge premises, expand or reduce scope. Four modes: SCOPE EXPANSION
  (dream big), SELECTIVE EXPANSION (hold scope + cherry-pick), HOLD SCOPE
  (maximum rigor), SCOPE REDUCTION (strip to essentials). Use when asked to
  "think bigger", "expand scope", "strategy review", "rethink this",
  "is this ambitious enough", or "challenge this plan".
when_to_use: User is questioning scope or ambition of a plan, or plan feels like it could think bigger
effort: high
benefits-from: [idea-check]
allowed-tools:
  - Read
  - Grep
  - Glob
  - Bash
  - WebSearch
---

# Strategy Review

Review a plan with strategic rigor. Challenge premises, expand ambition where warranted, reduce scope where bloated.

---

## Step 1: Read the Plan

1. Read the plan file (user provides path or you find it)
2. Read `CLAUDE.md` for project context
3. Identify: what's the goal, who's it for, what's the timeline, what's been decided

---

## Step 2: Choose Mode

Ask the user:

> How should I approach this review?
>
> A) **Scope Expansion** — dream big. What's the 10-star version? What would make this a category-defining feature?
> B) **Selective Expansion** — hold current scope, but cherry-pick 1-2 expansions that disproportionately increase impact
> C) **Hold Scope** — maximum rigor on what's already planned. Find gaps, risks, and weak assumptions
> D) **Scope Reduction** — strip to essentials. What can we cut without losing the core value?

---

## Step 3: Review

### For all modes, answer these:

1. **Problem clarity:** Is the problem statement specific enough to act on? Could two engineers read this and build the same thing?
2. **User specificity:** Is there a named user/customer with evidence of the pain? Or is this built on assumptions?
3. **Status quo challenge:** Why hasn't Excel/email/nothing been good enough? What changed?
4. **Competitive context:** Does this exist elsewhere? What do your closest competitors and generic AI tools (e.g. Copilot, ChatGPT) already do here?
5. **Narrowest wedge:** Could we ship something smaller first and learn?
6. **Dependencies:** What has to be true for this to work? (Tech, data, regulatory, organizational)
7. **Kill criteria:** What evidence would tell us to stop building this?

### Mode-specific additions:

**Scope Expansion:**

- What's the 10-star version? (Airbnb-style: if this worked perfectly, what would it look like?)
- What adjacent problems could this solve?
- What would make a customer tell their peers about this?

**Selective Expansion:**

- Which single addition would 2x the impact for <50% more effort?
- What's the "while we're here" opportunity?

**Hold Scope:**

- What's underspecified? Where will engineers get stuck?
- What edge cases are missing?
- Is the timeline realistic given what you know about the team?

**Scope Reduction:**

- What can be cut without customers noticing?
- What can be deferred to v2?
- What's in the plan because it's interesting vs because it's necessary?

---

## Step 4: Verdict

Write a structured review:

```markdown
## Strategy Review — [Plan Name]

**Mode:** [Expansion / Selective / Hold / Reduction]
**Reviewer:** Strategy Review (Gazelle)

### Strengths

[What's solid about this plan — be specific]

### Concerns

[Ranked by severity. For each: what's the concern, why it matters, what to do about it]

### Recommendations

[Numbered, actionable. Each one is a decision or action, not a suggestion to "consider"]

### Verdict

[Ship as-is / Ship with changes / Needs more investigation / Rethink]
```

Be direct. If the plan is good, say so briefly and focus on the 1-2 things that would make it great. If the plan has problems, name them plainly.
