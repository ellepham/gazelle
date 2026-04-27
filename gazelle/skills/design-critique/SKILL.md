---
name: design-critique
description: "Review designs against your design principles + optionally against accumulated discovery project state (spec, personas, insights). Delegates to design-reviewer subagent."
when_to_use: "Use when reviewing designs against your design principles. Examples: 'critique this design', 'review against design principles', 'design feedback on'"
argument-hint: "[design-url or feature]"
---

# Design Critique

**Voice:** Casual, direct, honest. Abbrevs ok (w., bc, tbh, imo, kinda).
Lead w. answer, context after. Flag gaps helpfully (coach, not auditor). Cite sources always.

## Usage

```
/design-critique [figma-url]                          # Standalone review
/design-critique [figma-url] --project [name]         # Project-aware review
/design-critique [screenshot-path]                    # From screenshot
/design-critique [figma-url] --project [name] --focus [area]   # Focus on specific area
```

**Flags:**

- `--project [name]` — load discovery project state for spec/persona/insight alignment check
- `--focus [area]` — narrow review (e.g., "a11y", "flow", "copy", "tokens")

## Protocol

### 1. Determine Mode

**Standalone** (no `--project`):

- Review Figma design against your design principles, brand tokens, and accessibility
- No project state needed

**Project-aware** (`--project` provided):

- Load all available project state
- Review against principles AND check spec/persona/insight alignment

### 2. Load Context

Always load:

1. `projects/gazelle-agent/context-training/design-principles.md` — your design philosophy + tokens

If `--project` provided, also load: 2. `projects/gazelle-agent/.state/projects/{name}/spec.md` — design spec 3. `projects/gazelle-agent/.state/projects/{name}/insights.md` — insights 4. `projects/gazelle-agent/.state/projects/{name}/personas.md` — personas 5. `projects/gazelle-agent/.state/projects/{name}/journey-map.md` — journey 6. `projects/gazelle-agent/.state/projects/{name}/context.md` — project context

### 3. Determine Design Source

Identify what to review — don't take screenshots yourself. The subagent has MCP access and will fetch them directly.

**If Pencil (.pen file):**

- Find the `.pen` file path in the project dir (e.g., `.state/projects/{name}/{name}-wireframes.pen`)
- Pass the file path to the subagent — it will call Pencil MCP tools (`get_screenshot`, `batch_get`) itself

**If Figma URL:**

- Pass the URL to the subagent — it will call Figma MCP tools itself

**If no input specified:**

1. Check project dir for `.pen` files — if found, use that path
2. If no `.pen` files, ask user for Figma URL or screenshot

### 4. Delegate to Subagent

Launch `gazelle-design-reviewer` subagent with:

**Standalone prompt:**

```
Review this design against our design principles and tokens.
Design source: [Figma URL or Pencil file path: /absolute/path/to/wireframes.pen]
You have direct MCP access — call Pencil or Figma tools yourself to get screenshots and inspect structure.
[Include design-principles.md content as context]
Mode: Standalone (no project context)
```

**Project-aware prompt:**

```
Review this design against our design principles AND the accumulated project state below.
Design source: [Figma URL or Pencil file path: /absolute/path/to/wireframes.pen]
You have direct MCP access — call Pencil or Figma tools yourself to get screenshots and inspect structure.
Mode: Project-aware

[Include design-principles.md content]

--- PROJECT STATE ---
[Include spec.md content if exists]
[Include insights.md content if exists]
[Include personas.md or personas-reference.md relevant sections]
[Include journey-map.md content if exists]
---

Check:
1. Does this design address the problem statement and requirements from the spec?
2. Does it work for the identified personas?
3. Which insights does it address vs miss?
4. Design principle alignment
5. Token/brand alignment
6. Accessibility basics
```

### 5. Present Results

Show the subagent's review, then add orchestrator summary:

```markdown
## critique summary: [feature/component]

**reviewed:** [figma url or screenshot]
**against:** design principles [+ project: {name}]
**verdict:** [ALIGNED / MINOR GAPS / NEEDS REVISION]

### tl;dr

[2-3 sentence honest take]

### top actions

1. [P1 — must fix]
2. [P2 — should fix]
3. [P3 — nice to have]

### spec coverage (project-aware only)

[N/M] requirements addressed
blind spots: [what the design doesn't cover]

saved to: gazelle/.state/projects/{name}/critique.md (if project)
```

### 6. Save State (project-aware only)

Save to: `projects/gazelle-agent/.state/projects/{name}/critique.md`

Update `context.md`:

```markdown
## State

- [x] Research — [date]
- [x] Insights — [date]
- [x] Personas — [date]
- [x] Journey map — [date]
- [x] Spec — [date]
- [x] Critique — [date]
```

### 7. Suggest Next

- If design needs revision: "→ update design to address [top issues], then re-run critique"
- If design is aligned: "→ ready to hand off to spec-machine (`/gather-requirements`) for technical implementation"
- If spec gaps found: "→ spec needs updating first — run `/design-spec` to address: [gaps]"

## Input Types

| Input                  | How It's Handled                                                                                                                                                           |
| ---------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Figma URL              | Fetched via Figma MCP (`get_screenshot` + `get_design_context`)                                                                                                            |
| Pencil (.pen file)     | Fetched via Pencil MCP (`get_screenshot` + `batch_get`). Check `get_editor_state` first to find open file + node IDs. Don't read `.pen` files directly — they're encrypted |
| Screenshot path        | Read image directly, no Figma/Pencil MCP needed                                                                                                                            |
| Description (text)     | Review is conceptual — flag that it's not pixel-level                                                                                                                      |
| No input (auto-detect) | Check project dir for `.pen` files first, then ask about Figma URL                                                                                                         |

## Quality Bar

Critique is "done" when:

- [ ] Design tokens checked against actual design system values from `context-training/design-principles.md`
- [ ] Color usage checked against your design system's color distribution rules
- [ ] Font check: correct typeface per your design system
- [ ] Accessibility basics covered (contrast, targets, keyboard)
- [ ] Honest about what works AND what doesn't
- [ ] Suggestions are actionable (not just "improve this")
- [ ] Project alignment checked (if project-aware mode)
- [ ] Prioritized recommendations (P1/P2/P3)
- [ ] Recommendations only reference what's in the spec — no unsolicited feature additions

**Common token violations to flag:**

Refer to `context-training/design-principles.md` for your specific design system tokens. Common violations include:

- Using accent colors as primary action colors
- Using non-standard typefaces
- Using incorrect font weights for body text
- AI content not visually differentiated from human content
- Multiple filled primary buttons on same screen

**Module-Specific Design Pattern Checks:**

When critiquing designs for a specific product module, also check the domain-specific patterns defined in `context-training/domain.md`. Common patterns to verify per module type:

- **Data monitoring modules:** AI relevance scores visible, human override controls accessible, source attribution, batch action support, reversible language ("hidden" not "deleted")
- **Search/screening modules:** Match indicators for why AI included/excluded items, bulk actions, AI reasoning visible, completeness indicators, export preview matching expected format
- **Intake/classification modules:** Auto-classification with explicit accept/edit affordance, trending visualization, audit trail
- **Cross-module views:** Module status at a glance, consistent AI trust treatment, shared navigation patterns

## Rules

- **Only suggest what's in scope.** If the spec doesn't mention a feature (confidence scores, new UI patterns, extra widgets), don't add it to the design during P1/P2 fixes. If you think something should be added, surface it as a question: "spec doesn't mention X — worth adding?"
- **Justify every design element.** If asked "what is this for?", every element in the design should trace back to a spec requirement, persona need, or design principle.

## Integration

- Uses subagent: `gazelle-design-reviewer`
- Design tool: **Pencil MCP** (`.pen` files) for wireframes — use `get_screenshot`, `batch_get`, `get_editor_state`. Never read `.pen` files directly
- Design system reference: **Figma MCP** for production design tokens/components. For Figma designs, use official Figma MCP only (`mcp__figma__` or `mcp__claude_ai_Figma__`). Do NOT use TalkToFigma.
- Design principles from: `context-training/design-principles.md`
- Project state from: `.state/projects/{name}/`
- Feeds into: design iteration, spec-machine handoff
- Reads from: `/design-spec`, `/persona-builder`, `/insights`, `/journey-mapping`

---

## Appendix A: Domain Context

> To customize Gazelle for your company, populate `context-training/domain.md` with your product's modules, users, key terms, competitors, and team structure.
>
> This appendix is intentionally empty in the open-source distribution. Your company-specific context lives in the context-training files, not here.

---

## Appendix B: Design Context

> To customize design critique for your product, populate `context-training/design-principles.md` with your design philosophy, visual hierarchy rules, color system, typography, spacing, page skeletons, AI feature treatment, and anti-patterns.
>
> The design critique skill will load these principles at runtime and use them to evaluate designs. This appendix is intentionally empty in the open-source distribution.
