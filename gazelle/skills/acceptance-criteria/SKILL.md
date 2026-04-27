---
name: acceptance-criteria
description: "Generate structured acceptance criteria from a design spec. Uses Hills format (measurable user outcomes) for cross-role legibility. Outputs Given/When/Then ACs + edge cases + QA checklist."
when_to_use: "Use when generating testable acceptance criteria. Examples: 'write ACs', 'acceptance criteria for', 'Given/When/Then', 'QA checklist'"
effort: low
argument-hint: "[feature]"
allowed-tools: Read, Grep, Glob, Write, Edit
---

# Acceptance Criteria

**Voice:** Casual, direct, honest. Abbrevs ok (w/, bc, tbh, imo, kinda).
Lead w/ answer, context after. Flag gaps helpfully (coach, not auditor). Cite sources always.

## Usage

```
/acceptance-criteria [feature]
/acceptance-criteria [feature] --from path/to/spec.md
/acceptance-criteria [feature] --hills-only
```

**Flags:**

- `--from [path]` — point to specific design spec (default: reads from `.state/projects/{feature}/spec.md`)
- `--project [name]` — specify project folder name
- `--hills-only` — generate only Hills (outcome statements), skip detailed ACs
- `--include-edge-cases` — expand edge case coverage beyond happy path

## Protocol

### 1. Load State

Read in this order:

1. `projects/gazelle-agent/.state/projects/{feature}/spec.md` — design spec (required)
2. `projects/gazelle-agent/.state/projects/{feature}/research.md` — raw findings (for edge cases)
3. `projects/gazelle-agent/.state/projects/{feature}/personas.md` — if exists (for persona-specific ACs)
4. `projects/gazelle-agent/.state/projects/{feature}/jtbd.md` — if exists (use P1 jobs to frame Hills around real user outcomes)
5. `projects/gazelle-agent/.state/projects/{feature}/pre-mortem.md` — if exists (use Tigers as risk-driven edge cases and guardrail ACs)
6. `projects/gazelle-agent/context-training/personas-reference.md` — known personas
7. `projects/gazelle-agent/context-training/domain.md` — domain terms

If no spec exists:

> "no design spec found for '{feature}'. run `/design-spec {feature}` first — ACs need a spec to work from. or point me to one w/ `--from`."

### 2. Extract Requirements

Scan the spec for:

- User stories / feature descriptions
- Interaction patterns (what happens when user does X)
- Data requirements (what's shown, computed, stored)
- AI behavior (if applicable — confidence thresholds, fallbacks, human overrides)
- Edge cases mentioned
- Out-of-scope items (to generate "should NOT" ACs)

List extracted requirements:

```markdown
extracted from spec:

| #   | Requirement   | Section        | Type                  |
| --- | ------------- | -------------- | --------------------- |
| 1   | [requirement] | [spec section] | functional/AI/data/ux |
```

### 3. Generate Hills (Outcome Statements)

Hills frame requirements as measurable user outcomes — legible to engineers, PMs, designers, and QA alike.

**Format:** "A [persona] can [action] [measurable outcome]"

**Examples:**

- "A report author can narrow 500 search results to <20 relevant items in under 2 minutes"
- "A compliance manager can see which regulations changed this week without manual checking"
- "An analyst can exclude irrelevant items in bulk with <1.5% false positive rate"

**Rules:**

- Every Hill must be measurable (time, count, rate, boolean)
- Use real persona names from your project's persona reference when available
- If the spec mentions performance requirements, encode them as Hills
- 3-7 Hills per feature (more = scope is too big)

```markdown
## Hills

| #   | Hill                               | Persona | Metric       | From Spec Section |
| --- | ---------------------------------- | ------- | ------------ | ----------------- |
| H1  | A [persona] can [action] [outcome] | [name]  | [measurable] | [section]         |
```

**Hill examples:**

| #   | Hill                                                                                                 | Persona      | Metric                                        | From      |
| --- | ---------------------------------------------------------------------------------------------------- | ------------ | --------------------------------------------- | --------- |
| H1  | A data analyst can complete daily alert triage in under 20 minutes by using AI relevance pre-sorting | Power User   | Time to triage <20min (from 45min baseline)   | Spec §1.2 |
| H2  | A reviewer can see why AI excluded an item and override the decision in 1 click                      | Primary User | Override rate tracked, <3 clicks to reverse   | Spec §3.1 |
| H3  | A compliance manager can export safety data and literature evidence into a single audit-ready format | Admin User   | Export contains both data sources in one file | Spec §5.3 |

**Citation requirement:** Every Hill's "From Spec Section" column must reference a real spec section, insight, or research source — not just "spec" or "research." Include Circleback/Notion/Slack links where the requirement was first surfaced.

### 4. Generate Acceptance Criteria (Given/When/Then)

For each Hill, generate detailed ACs:

```markdown
## AC for H1: [Hill summary]

### Happy Path

**Given** [precondition — user state, data state]
**When** [user action — what they do]
**Then** [expected outcome — what happens, measurable]

### Validation Rules

- [specific validation: field limits, format requirements, data constraints]

### Error States

**Given** [error condition]
**When** [user action]
**Then** [error handling — message shown, fallback behavior, recovery path]
```

### 5. AI Behavior ACs (if feature has AI)

If the spec describes AI-powered behavior, generate specific AI ACs:

```markdown
## AI Behavior Criteria

### Confidence & Thresholds

- **Given** AI confidence is above [threshold], **Then** [auto-suggest/auto-apply/show to user]
- **Given** AI confidence is below [threshold], **Then** [flag for review/hide/show with warning]

### Human Override

- **Given** AI makes a suggestion, **When** user rejects it, **Then** [what happens — does it learn? disappear? persist?]
- **Given** AI auto-applied a change, **When** user wants to undo, **Then** [undo path]

### Failure Modes

- **Given** AI service is unavailable, **Then** [graceful degradation — feature works without AI, shows error, queues for later]
- **Given** AI returns unexpected output, **Then** [validation + fallback behavior]

### Transparency

- **Given** AI made a decision, **Then** user can see [why it decided that — source text, confidence score, reasoning]
```

### 6. Edge Cases

Scan research and spec for edge cases. Common edge case categories:

- **Multi-language:** Content in one language, interface in another. Search terms vs. result language mismatch.
- **Large datasets:** 500+ results, 1000+ items in library, high-volume queries.
- **Concurrent users:** Multiple team members working on same project/resource.
- **Regulatory/compliance context:** Different rules by region or standard. Regional requirements.
- **Customer scale:** Small org (1 user) vs. enterprise (50+ users, SSO, compliance requirements).
- **Data source deduplication:** Same event from multiple sources, sync timing/freshness, name variants.
- **Cross-module:** User works across multiple modules, expects consistent AI behavior. State persistence when switching modules mid-session.

```markdown
## Edge Cases

| #   | Scenario    | Expected Behavior    | Priority               |
| --- | ----------- | -------------------- | ---------------------- |
| E1  | [edge case] | [what should happen] | must-have/nice-to-have |
```

### 7. QA Checklist

Generate a testable checklist for QA:

```markdown
## QA Checklist

### Functional

- [ ] [testable item derived from AC]
- [ ] [testable item]

### AI Behavior (if applicable)

- [ ] AI suggestions appear when confidence > threshold
- [ ] User can override AI suggestions
- [ ] AI unavailable → graceful degradation
- [ ] AI reasoning is visible to user

### Cross-Browser / Responsive

- [ ] Works in Chrome, Firefox, Safari
- [ ] Responsive at common breakpoints

### Accessibility

- [ ] Keyboard navigable
- [ ] Screen reader compatible
- [ ] Sufficient color contrast (WCAG AA)

### Performance

- [ ] [specific performance requirement from Hills]
```

### Anti-Hallucination Rules

- **ACs must reference spec, not imagination.** Every AC must trace to a requirement in the design spec. Don't invent features ("AI should auto-classify complaints") that the spec doesn't mention.
- **Never assume AI capabilities exist.** If the spec proposes new AI behavior, write ACs for it. But don't assume the product already has NLP search, auto-triage, predictive analytics, etc. unless the spec explicitly says so.
- **Edge cases must be grounded.** Don't invent edge cases that aren't relevant to the feature. Focus on the domain-specific edges listed in the Edge Cases section above.
- **User quotes in Hills must be real or clearly hypothetical.** If a Hill includes a user outcome, it should come from the spec or research — not fabricated user needs.

### 8. Save Output

Save to: `projects/gazelle-agent/.state/projects/{feature}/acceptance-criteria.md`

### 9. Offer Next Steps

> "ACs saved to [path]. [N] hills, [N] acceptance criteria, [N] edge cases.
>
> next options:
>
> - create jira tickets from these? (one per hill or one per AC group)
> - run design QA against these? (`/design-qa`)
> - refine specific ACs? (tell me which ones need adjustment)
> - run a pre-mortem first? (`/pre-mortem [feature]`) — surface risks that become edge case ACs
> - design an experiment to validate? (`/experiment-design [hypothesis]`) — test before full build"

## Integration

- Reads from: spec (required), research, personas, JTBD (P1 jobs → Hills), pre-mortem (Tigers → risk-driven edge cases)
- Feeds into: Jira ticket creation, design QA, spec-machine implementation

---

## Appendix: Domain Context

> For project-specific domain context (company info, modules, users, key terms, competitors, team), see `context-training/domain.md` in your Gazelle project.
> For design context (design philosophy, visual hierarchy, color rules, typography, spacing, page skeletons), see `context-training/style.md`.
> These files are loaded automatically when available. This skill works without them but produces better results with project-specific context.
