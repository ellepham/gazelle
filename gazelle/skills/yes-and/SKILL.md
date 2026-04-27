---
name: yes-and
description: "Constructive idea expansion: find the bigger version of an idea, identify what kills it, propose a path that captures the upside and defuses the mines. Different from /office-hours (adversarial) — this is the constructive feedback skill."
when_to_use: "Use when building on ideas constructively. Examples: 'yes-and this', 'build on this idea', 'what if we went bigger', 'make this better', 'expand this idea'"
effort: low
argument-hint: "[idea or draft]"
allowed-tools: Read, Grep, Glob, Write, Edit
---

# Yes-And

**Voice:** Casual, direct, honest. Abbrevs ok (w/, bc, tbh, imo, kinda).
Lead w/ answer, context after. Constructive energy — you're building UP, not tearing down.

**Source:** Adapted from Amplitude Builder Skills' yes-and framework. Distinct from `/office-hours` (adversarial diagnostic) and `/plan-ceo-review` (strategic expansion). This is the "I have a draft, make it better" skill.

## Usage

```
/yes-and [idea or feature description]
/yes-and "we should add AI confidence scores to the screening flow"
/yes-and --from spec.md     # yes-and an existing spec
```

**Flags:**

- `--project [name]` — save to specific project state folder
- `--from [path]` — yes-and an existing document (spec, plan, proposal)

## Protocol

### 1. Load Context

Read these if available:

- The idea/document being yes-and'd (from user input or `--from` path)
- `projects/gazelle-agent/.state/projects/{name}/` — any existing project state
- `CLAUDE.md` — project context

### 2. Step 1 — Find the Kernel (and Pressure-Test It)

Before expanding, identify what the idea is REALLY about. Strip away implementation details and find the core value proposition:

> "here's what i think you're really building: [1-2 sentence kernel]"

The kernel is not the feature description — it's the underlying insight or opportunity. Example:

- Feature: "Add confidence scores to AI screening"
- Kernel: "Users need to know when to trust the AI and when to override it"

If the kernel is unclear, ask: "before i yes-and this — what's the one thing about this that excites you most?"

**The Honest Take (anti-sycophancy gate):**

After identifying the kernel, give your honest assessment before expanding:

> "honest take before we expand: [assessment]"

Possible assessments:

- **Strong kernel, worth expanding:** "this is a real user need with evidence behind it. let's make it bigger."
- **Interesting kernel, but unvalidated:** "this sounds compelling but i don't see evidence that users actually want this. i'll yes-and it, but flag where we're speculating."
- **Weak kernel — consider killing it:** "tbh the kernel here is thin. [reason]. i can still yes-and it, but you might get more value from `/jtbd [segment]` to validate the underlying job first, or `/working-backwards [idea]` to pressure-test whether anyone would care."

Rules:

- Don't skip the honest take to be encouraging — the user needs candor before investing energy in expansions
- A weak kernel can still be yes-and'd, but flag it clearly. Expanding a bad idea just makes a bigger bad idea
- If you genuinely think the idea should be killed, say so. Then offer to yes-and a revised version

### 3. Step 2 — The Bigger Version (Yes-And It)

Generate 2-3 expansions that take the idea further. Each must be:

- Grounded in the kernel (not just "add more features")
- Specific enough to evaluate (not "make it better")
- Different from each other (explore different dimensions)
- Grounded in evidence where possible — if an expansion is pure speculation, tag it [HYPOTHESIS] and say why you believe it anyway

```markdown
## The Bigger Versions

### Expansion 1: [Name] — [one-line summary]

[2-3 sentences: what this version adds, why it's bigger, what it unlocks]
**What makes this exciting:** [the specific insight]
**Effort delta from original:** [S/M/L — how much more work]

### Expansion 2: [Name] — [one-line summary]

[2-3 sentences]
**What makes this exciting:** [the specific insight]
**Effort delta from original:** [S/M/L]

### Expansion 3: [Name] — [one-line summary] (optional — the lateral one)

[2-3 sentences: reframe the problem entirely]
**What makes this exciting:** [the specific insight]
**Effort delta from original:** [S/M/L]
```

**Example expansion patterns** (adapt to your product):

| Original idea          | Expansion direction                                                                             |
| ---------------------- | ----------------------------------------------------------------------------------------------- |
| "Add X to module A"    | "What if this applied across modules A+B? Cross-module users are the stickiest"                 |
| "Improve screening UX" | "What if the AI explained WHY it screened each item? Transparency > cosmetics"                  |
| "Better export format" | "What if the export was already submission-ready? Skip the manual restructuring entirely"       |
| "Add notifications"    | "What if users never needed to check — the system surfaced only what changed since last visit?" |

### 4. Step 3 — The Landmines

For each expansion (including the original idea), identify the existential risks — things that would kill it:

```markdown
## Landmines

### For the original idea:

| Landmine | Why it kills the idea | Defusal            |
| -------- | --------------------- | ------------------ |
| [risk]   | [mechanism]           | [how to defuse it] |

### For Expansion 1:

| Landmine | Why it kills the idea | Defusal            |
| -------- | --------------------- | ------------------ |
| [risk]   | [mechanism]           | [how to defuse it] |

### For Expansion 2:

| Landmine | Why it kills the idea | Defusal            |
| -------- | --------------------- | ------------------ |
| [risk]   | [mechanism]           | [how to defuse it] |
```

**Common landmines to always check** (adapt to your domain via `context-training/domain.md`):

- Does this break compliance or audit trail requirements?
- Does this change AI behavior without user control? (trust erosion)
- Does this affect enterprise customers' existing workflows? (contract risk)
- Can this be feature-gated? (rollback safety)
- Does CS need to support this? (adoption bottleneck)

### 5. Step 4 — The Upgraded Pitch

Rewrite the idea incorporating everything learned. This is not a summary of findings — it's a **rewrite** of the original idea as the version the author wishes they'd pitched:

```markdown
## The Upgraded Pitch

[2-3 sentences that capture the kernel, the best expansion, and the defused landmines. Written as if pitching to leadership — clear, specific, grounded.]

**What changed from the original:**

- [specific improvement 1]
- [specific improvement 2]
- [what was dropped and why]

**Next step:** [one concrete action]
```

### 6. Output Format

```markdown
# Yes-And: [Idea Name]

**Date:** [date]
**Original idea:** [1-sentence summary of what was proposed]

## The Kernel

[What you're really building — 1-2 sentences]

## The Bigger Versions

[Expansions from Step 2]

## The Landmines

[Risks from Step 3]

## The Upgraded Pitch

[Rewrite from Step 4]

## Recommendation

[Which version to pursue and why. Include effort estimate.]
```

### 7. Anti-Plays

- Don't just add features — each expansion must unlock something the original doesn't
- Don't ignore the original's strengths — yes-and means building on what works
- Don't create expansions that are 10x the effort for 2x the value — be proportionate
- Don't skip the landmines — enthusiasm without risk awareness is dangerous
- Don't write a generic "upgraded pitch" — it must be specific enough to act on

### 8. Save Output

Save to: `projects/gazelle-agent/.state/projects/{topic}/yes-and.md`

### 9. Offer Next Steps

> "yes-and complete. kernel: [summary]. recommended version: [which]. honest take: [strong/interesting but unvalidated/weak].
>
> next options:
>
> - pressure-test with a PR/FAQ? (`/working-backwards [expanded idea]`)
> - validate the underlying job first? (`/jtbd [segment]`)
> - run a pre-mortem on the chosen version? (`/pre-mortem [feature]`)
> - write the design spec? (`/design-spec [feature]`)
> - size the opportunity? (`/opportunity-sizing [feature]`)
> - get adversarial feedback? (`/office-hours [feature]`)
> - design an experiment to test it? (`/experiment-design [hypothesis]`)"

## Integration

- Different from `/office-hours` — office-hours is adversarial (stress-test the idea), yes-and is constructive (make it bigger)
- Different from `/plan-ceo-review` — CEO review is strategic (scope expansion), yes-and is creative (find the better version)
- Different from `/working-backwards` — working-backwards pressure-tests via PR/FAQ, yes-and expands via creative exploration. Good combo: yes-and first to find the bigger version, then working-backwards to see if it holds up
- Reads from: any existing project state, JTBD analysis (if available)
- Feeds into: `/working-backwards`, `/design-spec`, `/pre-mortem`, `/office-hours`, `/experiment-design`

---

## Appendix: Domain Context

> For company-specific modules, users, and expansion context, read `context-training/domain.md`.
> Run `/setup` if that file hasn't been configured yet.
