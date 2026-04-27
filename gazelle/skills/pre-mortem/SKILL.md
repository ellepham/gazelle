---
name: pre-mortem
description: "Pre-mortem risk assessment using Tigers/Paper Tigers/Elephants framework. Identifies real risks, dismisses overblown fears, and surfaces unspoken dangers before launch or major decisions."
when_to_use: "Use before launches or major decisions. Examples: 'pre-mortem', 'what could go wrong', 'risk assessment', 'before we launch', 'identify risks'"
effort: medium
argument-hint: "[feature/launch/decision]"
allowed-tools: Read, Grep, Glob, Write, Edit
---

# Pre-Mortem

**Voice:** Casual, direct, honest. Abbrevs ok (w/, bc, tbh, imo, kinda).
Lead w/ answer, context after. Flag gaps helpfully (coach, not auditor). Cite sources always.

**Source:** Adapted from Amplitude Builder Skills' pre-mortem framework (Tigers/Paper Tigers/Elephants taxonomy).

## Usage

```
/pre-mortem [feature or decision]
/pre-mortem "AI recommendation engine launch"
/pre-mortem "migrating export to new format" --project data-pipeline
```

**Flags:**

- `--project [name]` — save to specific project state folder
- `--quick` — skip data gathering, use only conversation context. ~10 min.
- `--deep` — pull signals from Slack/Notion/Circleback for evidence-backed risks. ~30 min.

## Protocol

### 1. Load Context

Read these if available:

- `projects/gazelle-agent/.state/projects/{name}/spec.md` — what's being shipped
- `projects/gazelle-agent/.state/projects/{name}/opportunity-sizing.md` — demand/risk data
- `projects/gazelle-agent/.state/projects/{name}/competitive-analysis.md` — competitor context
- `projects/gazelle-agent/.state/projects/{name}/jtbd.md` — jobs analysis (ground risks in validated user needs)
- `projects/gazelle-agent/.state/projects/{name}/working-backwards.md` — PR/FAQ (use internal FAQ answers as risk signals)
- `projects/gazelle-agent/context-training/domain.md` — products, modules, users
- `CLAUDE.md` — project context

If `--deep`: launch source-researcher subagents to search Slack, Notion, Circleback for:

- Past failures or near-misses in similar launches
- Customer complaints about related features
- Engineering concerns raised in threads
- Competitor incidents in this space

### 2. Set the Scene

Frame the pre-mortem:

> "it's [date + 3 months]. [feature/decision] launched and it failed. not a small stumble — a real failure. customers are upset, internal trust is damaged, and the team is doing a retro asking 'how did we miss this?'"
>
> "let's work backwards from that failure."

### 3. Risk Identification

Generate risks across these dimensions:

**Risk categories** (adapt to your domain — check `context-training/domain.md` for industry-specific risks):

| Category            | What to check                                        | Example                                                           |
| ------------------- | ---------------------------------------------------- | ----------------------------------------------------------------- |
| **Regulatory**      | Compliance gaps, audit trail, certification impact   | AI decisions not traceable, export missing required fields        |
| **Data integrity**  | Wrong results, missing data, silent failures         | False negatives in alerts, screening dropping valid items         |
| **User trust**      | Workflow disruption, AI overreach, loss of control   | Auto-actions without review, confidence scores users can't verify |
| **Technical**       | Performance, scale, integration, migration           | Slow queries at enterprise scale, breaking existing API consumers |
| **Adoption**        | Change resistance, training gaps, workflow mismatch  | Power users bypassing new feature, CS team can't support it       |
| **Competitive**     | Timing, feature parity, positioning                  | Competitor ships similar feature first, undercuts pricing         |
| **Organizational**  | Resourcing, cross-team dependencies, priority shifts | Key engineer leaves mid-build, priorities shift away              |
| **Customer impact** | Enterprise contracts, SLA violations, data loss      | Major customer workflows break, export format incompatible        |

### 4. Classify Into Three Categories

#### Tigers (Real Threats)

Legitimate risks with real probability and real impact. Each Tiger gets:

- **What happens:** specific failure scenario — not vague, concrete
- **Probability:** HIGH/MEDIUM/LOW with reasoning
- **Impact:** CRITICAL/HIGH/MEDIUM with what breaks
- **Evidence:** past incidents, data, signals that make this real
- **Mitigation plan:** specific actions with owners and timelines
- **Detection:** how to know it's happening before it's too late
- **Urgency:** Launch-Blocking / Fast-Follow / Track

Rules:

- Every Tiger MUST have a mitigation plan with named owners and timelines
- "We'll deal with it if it happens" is not a mitigation plan
- If Launch-Blocking with no mitigation, say so: "this blocks launch until [condition]"

#### Paper Tigers (Overblown Fears)

Risks that feel scary but aren't real threats. Dismiss explicitly so the team doesn't waste energy:

- **The fear:** what people worry about
- **Why it's not real:** specific evidence or reasoning — not hand-waving
- **What to say when someone raises it:** 1-sentence reframe

Rules:

- Only classify as Paper Tiger if you can articulate WHY it's overblown
- "It probably won't happen" is not sufficient — explain the mechanism
- Common Paper Tigers: "competitor will copy us" (they're slow), "users won't adopt" (when demand signals are strong), "it's too complex" (when similar complexity shipped before)

#### Elephants (Unspoken Risks)

Risks everyone knows about but nobody wants to raise — the most dangerous category:

- **What everyone knows but won't say:** the thing
- **Why it's being avoided:** political, emotional, or structural reason
- **What happens if we keep ignoring it:** consequences
- **How to address it:** who needs to say what to whom

Rules:

- These are often organizational, not technical
- "The PM left and nobody owns this" is an Elephant
- "The design wasn't validated with real users" is an Elephant
- "We're shipping this to hit a deadline, not bc it's ready" is an Elephant
- Be direct. The value of this category is saying the unsaid.

### 5. Output Format

```markdown
# Pre-Mortem: [Feature/Decision]

**Date:** [date]
**Confidence:** [HIGH/MEDIUM/LOW — based on evidence quality]

## Summary

[2-3 sentences: overall risk posture. is this ready to ship? what's the biggest concern?]

## Ranked Risks

| #   | Risk               | Type     | Probability | Impact   | Urgency         | Mitigation Status       |
| --- | ------------------ | -------- | ----------- | -------- | --------------- | ----------------------- |
| 1   | [highest priority] | Tiger    | HIGH        | CRITICAL | Launch-Blocking | [has plan / needs plan] |
| 2   | [next risk]        | Tiger    | MEDIUM      | HIGH     | Fast-Follow     | [has plan]              |
| 3   | [elephant]         | Elephant | —           | HIGH     | Launch-Blocking | [needs conversation]    |

## Launch-Blocking Items

1. [item] — mitigation: [plan] — owner: [who] — deadline: [when]

## Paper Tigers (Dismissed)

1. [fear] — dismissed bc: [reason]

## Detection Plan

| Signal         | What it means    | Check frequency | Owner |
| -------------- | ---------------- | --------------- | ----- |
| [metric/alert] | [interpretation] | [daily/weekly]  | [who] |

## Open Questions

- [Unresolved items needing input from specific people]
```

### 6. Anti-Plays (Where NOT to Focus)

- Don't spend time on risks with <1% probability AND low impact — that's anxiety, not analysis
- Don't list "user doesn't adopt" as a risk without specific evidence of adoption barriers
- Don't treat regulatory risks as Paper Tigers unless you've verified with legal/RA
- Don't ignore Elephants bc they're uncomfortable — that's the whole point
- Don't create mitigation plans bigger than the feature itself
- Challenge the premise: if the pre-mortem surfaces mostly Paper Tigers and no real Tigers, say so — "tbh this looks pretty safe. the pre-mortem isn't surfacing real blockers, which means either (a) you've already de-risked well, or (b) we're not being honest enough about the Elephants. which is it?"

### 7. Save Output

Save to: `projects/gazelle-agent/.state/projects/{topic}/pre-mortem.md`

### 8. Offer Next Steps

> "pre-mortem complete. [N] tigers, [N] paper tigers, [N] elephants. [N] launch-blockers.
>
> next options:
>
> - address launch-blockers and re-run? (`/pre-mortem [feature] --quick`)
> - design an experiment to de-risk a specific tiger? (`/experiment-design [hypothesis]`)
> - size the opportunity to weigh risk vs reward? (`/opportunity-sizing [feature]`)
> - validate the underlying job still holds? (`/jtbd [segment]`)
> - pressure-test the idea with a PR/FAQ? (`/working-backwards [feature]`)
> - write the spec? (`/design-spec [feature]`)"

## Integration

- Pairs with: `/experiment-design` (de-risk specific tigers), `/opportunity-sizing` (weigh risk vs reward), `/jtbd` (validate the underlying need), `/working-backwards` (pressure-test before investing in mitigation)
- Reads from: spec, competitive analysis, opportunity sizing, JTBD state
- Feeds into: launch decisions, experiment design, working-backwards

---

## Appendix: Domain Context

> For company-specific risk categories, modules, and team structure, read `context-training/domain.md`.
> Run `/setup` if that file hasn't been configured yet.
