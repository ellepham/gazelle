# Example: Write a Design Spec

**Skill:** `/design-spec`
**Time:** 20-40 minutes
**Prerequisite:** Run `/research` first (the spec builds on your research state)

## Scenario

You've done research on a new AI recommendation engine. Now you need a design spec before the team starts building.

## Run it

```
/design-spec "AI recommendation engine"
```

## What happens

1. **Loads prior state** — reads your research findings, insights, and personas from `projects/gazelle-agent/.state/projects/ai-recommendation-engine/`
2. **Reads your design principles** from `context-training/design-principles.md`
3. **Generates a structured spec** with user stories, requirements, edge cases, and acceptance criteria — all grounded in the evidence you gathered

## Example output

```markdown
# Design Spec: AI Recommendation Engine

**Date:** 2026-04-13
**Author:** Gazelle (from research state)
**Confidence:** MEDIUM — strong user demand signal, implementation approach needs validation

## Problem Statement

Users spend 45+ minutes manually browsing content to find relevant items.
3 enterprise customers and 2 mid-market accounts raised this in the last quarter.
Current workaround: bookmarks + manual curation (evidence: Slack #feedback, 5 threads).

## User Stories

### Primary

As a **Data Analyst** (see personas-reference.md),
I want the system to surface relevant content based on my history,
so I can find what I need in under 5 minutes instead of 45.

**Evidence:** 4 interview mentions of "too much time browsing" (Circleback Q1 2026)

### Secondary

As a **Team Lead**,
I want to see what my team members are finding useful,
so I can identify shared interests and avoid duplicate work.

**Evidence:** 2 Slack threads requesting "team activity feed" (MEDIUM confidence — small sample)

## Requirements

### Functional

| ID    | Requirement                                    | Priority | Evidence                       |
| ----- | ---------------------------------------------- | -------- | ------------------------------ |
| FR-01 | Show personalized recommendations on dashboard | P0       | 4 customer interviews          |
| FR-02 | Allow dismissing irrelevant recommendations    | P0       | Design principle: user control |
| FR-03 | Show reasoning for each recommendation         | P1       | Design principle: transparency |
| FR-04 | Team activity feed                             | P2       | 2 Slack threads (thin)         |

### Non-Functional

| ID     | Requirement                         | Rationale                         |
| ------ | ----------------------------------- | --------------------------------- |
| NFR-01 | Recommendations load in < 2 seconds | Power users check dashboard daily |
| NFR-02 | Works with < 10 items of history    | New users need onboarding path    |

### Design Requirements

| ID    | Requirement                                     | Source                             |
| ----- | ----------------------------------------------- | ---------------------------------- |
| DR-01 | Follow progressive disclosure (don't overwhelm) | design-principles.md               |
| DR-02 | AI confidence visible but not intrusive         | design-principles.md: transparency |
| DR-03 | Consistent with existing card patterns          | design-principles.md: consistency  |

## Edge Cases

1. **New user with no history** — show popular/trending instead, with clear "we're learning your preferences" message
2. **User dismisses everything** — don't keep showing dismissed types; adapt within 3 dismissals
3. **Recommendation is wrong** — feedback mechanism ("not relevant") that improves future suggestions
4. **Same item recommended twice** — deduplicate across sessions

## Open Questions

- [ ] How many recommendations per page? (needs user testing)
- [ ] Should recommendations refresh in real-time or on page load?
- [ ] Privacy: can team leads see individual browsing patterns? (check with legal)

## What's Missing (Honest Gaps)

- No A/B test baseline for "time to find content" — need to instrument before launch
- FR-04 (team feed) based on 2 data points — validate before building
- No competitive analysis on recommendation approaches — consider `/competitive-analysis`
```

## Key things to notice

- **Every requirement traces to evidence** — no requirements from thin air
- **Priority tied to signal strength** — P0 has strong evidence, P2 is thin
- **Design requirements reference your design system** — reads from `context-training/design-principles.md`
- **Open questions are explicit** — doesn't pretend to know what it doesn't
- **Edge cases are practical** — real scenarios, not theoretical
