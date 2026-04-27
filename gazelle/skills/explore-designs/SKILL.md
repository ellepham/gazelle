---
name: explore-designs
description: "Generate 2-3 distinct hi-fi design concepts in Figma from a design spec. Each concept explores a different layout approach using real DS components. Fills the gap between text spec and wireframing — the 'explore multiple directions' phase."
when_to_use: "Use when generating visual design directions in Figma. Examples: 'explore design directions', 'generate concepts', 'design options from spec', 'create Figma explorations'"
effort: high
argument-hint: "[feature] [--concepts N] [--project name]"
---

# Design Exploration

**Voice:** Casual, direct, honest. Abbrevs ok (w., bc, tbh, imo, kinda).
Lead w. answer, context after. Flag gaps helpfully (coach, not auditor). Cite sources always.

## Usage

```
/explore-designs [feature]
/explore-designs [feature] --project [name]
/explore-designs [feature] --concepts 2
/explore-designs [feature] --from-spec [path]
/explore-designs [feature] --figma-file [key]
/explore-designs [feature] --strategy clone|compose|auto
```

**Flags:**

- `--project [name]` — specify project folder (default: kebab-case of feature name)
- `--concepts [N]` — number of concepts to generate (default: 3, max: 5)
- `--from-spec [path]` — explicit path to spec file (default: auto-detect from project state)
- `--figma-file [key]` — Figma file key to build in (default: your team's primary design file)
- `--strategy clone|compose|auto` — force a generation strategy (default: auto — picks per concept)

**Prerequisites:** `spec.md` must exist. The more prior phases completed (insights, personas, flow capture), the stronger the explorations. Figma MCP must be connected.

## Pipeline Position

```
Research → Insights → Personas → Journey → Spec → DESIGN EXPLORATION → Wireframe → Critique
```

This skill is the bridge from text requirements to visual design directions. It generates multiple hi-fi concepts for the team to react to, then the selected direction feeds into wireframing, critique, and implementation.

## Protocol

### 1. Load State

Read in this order (available → required):

1. `projects/gazelle-agent/.state/projects/{name}/spec.md` — **required**
2. `projects/gazelle-agent/.state/projects/{name}/context.md` — project context
3. `projects/gazelle-agent/.state/projects/{name}/personas.md` — optional
4. `projects/gazelle-agent/.state/projects/{name}/insights.md` — optional
5. `projects/gazelle-agent/.state/projects/{name}/flow-analysis.md` — optional (existing app screenshots)
6. `projects/gazelle-agent/.state/projects/{name}/screenshots/` — reference images
7. `projects/gazelle-agent/context-training/design-system.md` — DS tokens + component keys
8. `projects/gazelle-agent/context-training/design-principles.md` — your design philosophy
9. `projects/gazelle-agent/context-training/style-guide.md` — **CRITICAL: Visual taste guide** — hierarchy rules, spacing rhythm, color usage, AI treatment, anti-patterns, squint test. Read this BEFORE generating any UI.

If no spec exists:

> "no spec found for '{feature}'. run `/design-spec {feature}` first — can't explore designs without requirements."

### 2. Scan Existing UI

Before designing anything, understand what exists:

1. **Load the `figma-use` skill** (MANDATORY before any `use_figma` call)
2. **Search the Figma file** for pages/frames related to this feature area:
   - List all pages, filter by area name
   - Take `get_screenshot` of 2-3 closest existing hi-fi frames
3. **Identify cloneable SECTIONS** — not just full frames, but individual parts:
   - A nav bar from one frame, a table from another, a sidebar from a third
   - A form section, a stepper, a footer — note which source each comes from
   - You may harvest sections from 3+ different source frames across different pages
4. **Discover the component palette** in those frames:
   - Run `use_figma` to walk component instances in the reference frames
   - Collect mainComponent keys, variant names, layout patterns
   - This is the "palette" — the real components already in use
5. **Cross-reference with DS reference** (figma-use Section 13) for any components not found in the scan

Present what you found:

```markdown
existing ui scan:

- [N] relevant frames found in figma
- key patterns: [table + sidebar, card grid, stepper, etc.]
- components available: [Button, Tab, Table, icons, etc.]
- [screenshot thumbnails of reference frames]
```

**Figma MCP policy:** Use ONLY official Figma MCP (`mcp__figma__*` or `mcp__claude_ai_Figma__*`). Do NOT use TalkToFigma.

### 3. Extract Design Constraints

Parse the spec and distill into a constraint card:

```markdown
constraints for [feature]:

**core problem:** [1 sentence from Problem Statement]

**must have:**

- [from Requirements — functional]
- [from Requirements — design]
- [from Key Flows — essential steps]

**must not:**

- [from "What This Is NOT" section]
- [from design principles — anti-patterns]

**user needs:**

- [persona 1]: [key need]
- [persona 2]: [key need]

**existing patterns to leverage:**

- [from Figma scan — what can be cloned/reused]

**design principles:**

- [from context-training — which principles apply most]
```

Ask for confirmation: "these are the constraints i'll design against. anything to add or adjust?"

### 4. Generate Concepts

For each concept (default 3):

#### 4a. Ideate the approach

Before building, think through the approach (adapted from Anthropic's Design Thinking framework):

- **Purpose:** What problem does this concept solve? Who benefits most?
- **Pick a page skeleton** from your style-guide.md — each concept MUST use a **different** skeleton
- **Differentiation:** What makes THIS concept memorable vs the others? What's the one thing a user would notice? (The key is intentionality — every layout choice should serve a purpose)
- **Tradeoff:** What does this concept optimize for? What does it sacrifice?
- **Persona fit:** Which user persona does this concept serve best?
- **Build plan:** Which sections will you harvest from existing frames vs compose from imported DS components?

#### 4b. Build strategy: Informed Composition

> **RULE:** Every exploration MUST contain real DS component instances (post-build audit > 0). But the LAYOUT must be original — don't clone an entire page. `figma.createFrame()` + `figma.createText()` alone is NOT acceptable.

**Use these three tactics together — mix and match per concept:**

**Tactic 1: Harvest Sections** (clone individual sections from existing frames)

Clone SECTIONS, not pages. Pick the best source for each part of your layout:

- Clone just the NavHeader from one frame
- Clone just the table from another frame
- Clone just the sidebar from another
- Clone a form section, a stepper, a footer — each from wherever it exists in the file
- Move each cloned section to your new frame and rearrange into a new layout

```js
// Example: harvest a sidebar from one frame, a table from another
const sourcePage = figma.root.children.find((p) =>
  p.name.includes("Feature Area"),
);
await figma.setCurrentPageAsync(sourcePage);
const sourceFrame = figma.getNodeById("SOURCE_FRAME_ID");

// Find and clone just the sidebar section
const sidebar = sourceFrame.findOne((n) => n.name === "Frame 3834"); // the sidebar
const sidebarClone = sidebar.clone();

// Move to target page
const targetPage = figma.root.children.find((p) => p.id === "TARGET_PAGE_ID");
targetPage.appendChild(sidebarClone);
```

**Tactic 2: Import DS Components** (for sections that don't exist to clone)

For novel sections that don't exist anywhere in the file, import DS components and compose. Reference your design system component keys from `context-training/design-system.md`:

```js
// Import component sets — replace keys with your actual DS component keys
const buttonSet = await figma.importComponentSetByKeyAsync("YOUR_BUTTON_KEY");
const tabSet = await figma.importComponentSetByKeyAsync("YOUR_TAB_KEY");
const inputSet = await figma.importComponentSetByKeyAsync("YOUR_INPUT_KEY");
const tableHeaderSet = await figma.importComponentSetByKeyAsync(
  "YOUR_TABLE_HEADER_KEY",
);
const tableCellSet = await figma.importComponentSetByKeyAsync(
  "YOUR_TABLE_CELL_KEY",
);
const tagSet = await figma.importComponentSetByKeyAsync("YOUR_TAG_KEY");

// Create instances from variants
const filledAccent = buttonSet.children.find(
  (v) => v.name.includes("Filled") && v.name.includes("Accent"),
);
const btn = filledAccent.createInstance();
```

See figma-use Section 13 for all cached component keys.

**Tactic 3: Structural Frames** (layout scaffolding only)

Use `createFrame()` ONLY for invisible layout containers that hold harvested + imported pieces together:

- Page-level container, section wrappers, grid rows/columns
- No fills, no strokes, no visual presence — purely structural

**What MUST be DS instances:** Buttons, tabs, inputs, table headers, table cells, tags, icons, dividers, tooltips, checkboxes, infoboxes, navheader, footer.

**The mix per concept:**

- Concept extending existing patterns → Harvest nav/table/footer (70%) + Import novel section (20%) + Layout scaffolding (10%)
- Concept with novel IA → Import DS components (50%) + Harvest nav/footer only (30%) + Layout scaffolding (20%)
- **Each concept MUST use a different page skeleton** from your style-guide.md

#### 4c. Build in Figma

For each concept:

1. Create a new frame on the target page: `Exploration {N} — {concept name}`
2. Set up the layout scaffolding (outer frame + section containers)
3. Harvest sections from existing frames — clone and move individual sections
4. Import DS components for novel sections — build incrementally
5. Update text content to match the feature (load fonts first)
6. Take `get_screenshot` after completion to verify visual quality
7. Fix any issues before moving to the next concept

#### 4d. Quality checks per concept

- [ ] **Squint test passes** — hierarchy reads at 3 levels when blurred (style-guide.md)
- [ ] **DS component audit passes** — run step 4e, must have >0 INSTANCE nodes
- [ ] **Layout is different from other concepts** — each uses a different page skeleton
- [ ] Text uses your product's designated font at correct scale sizes
- [ ] Colors follow hierarchy rules from your style guide
- [ ] Spacing varies by context: tight tables, airy panels, generous dialogs (style-guide.md)
- [ ] Only ONE filled primary button visible per section
- [ ] AI elements are visually distinguished from non-AI elements (style-guide.md)
- [ ] Content is realistic (not "Lorem ipsum" — use domain-specific mock data)
- [ ] No banned patterns (style-guide.md)

#### 4e. Post-build audit (MANDATORY)

After building each exploration, run this audit:

```js
const frame = figma.getNodeById("FRAME_ID");
let instances = 0,
  frames = 0,
  texts = 0;
function walk(n) {
  if (n.type === "INSTANCE") instances++;
  else if (n.type === "FRAME") frames++;
  else if (n.type === "TEXT") texts++;
  if ("children" in n) for (const c of n.children) walk(c);
}
walk(frame);
const pct = Math.round((instances / (instances + frames)) * 100);
return { instances, frames, texts, dsPercentage: pct + "%" };
```

**Pass criteria:** instances > 0. If instances = 0, the exploration FAILED — rebuild using Harvest or Import tactics. Do NOT present explorations with 0 DS instances.

**If the audit fails:**

1. Identify which visible elements are plain frames that should be DS instances
2. Replace them: harvest from an existing frame or import the correct DS component
3. Re-run the audit until it passes

### 5. Present for Selection

**Mandatory before presenting:** Run `get_screenshot` for each concept frame. Get the direct Figma URL using:
`https://www.figma.com/design/{fileKey}/?node-id={nodeId}` — replace `{fileKey}` with the file key and `{nodeId}` with the frame's node ID (replace `:` with `-` for URL format).

Every concept presentation MUST include: screenshot + Figma link + tradeoff. Missing any of these = incomplete.

Show all concepts with screenshots and tradeoff analysis:

```markdown
## exploration 1: [name]

[screenshot from get_screenshot]
**figma:** https://www.figma.com/design/{fileKey}/?node-id={nodeId}
**approach:** [2-3 sentences]
**tradeoff:** optimizes [X], sacrifices [Y]
**best for:** [persona or use case]
**strategy used:** clone+remix from [source frame name] / compose
**ds audit:** [N] instances / [M] frames ([P]% DS)

## exploration 2: [name]

[screenshot]
**figma:** https://www.figma.com/design/{fileKey}/?node-id={nodeId}
**approach:** [2-3 sentences]
**tradeoff:** optimizes [X], sacrifices [Y]
**best for:** [persona or use case]
**strategy used:** clone+remix / compose
**ds audit:** [N] instances / [M] frames ([P]% DS)

## exploration 3: [name]

[screenshot]
**figma:** https://www.figma.com/design/{fileKey}/?node-id={nodeId}
**approach:** [2-3 sentences]
**tradeoff:** optimizes [X], sacrifices [Y]
**best for:** [persona or use case]
**strategy used:** clone+remix / compose
**ds audit:** [N] instances / [M] frames ([P]% DS)

which direction resonates? i can:

- iterate on any concept
- combine elements from multiple concepts
- run a design critique on the selected one
- test it with a synthetic user persona
```

**Use realistic mock data in designs instead of placeholders.** Define your domain-specific mock data in `context-training/domain.md`. Examples of what to include:

| Element         | What to define                                 |
| --------------- | ---------------------------------------------- |
| Content titles  | Realistic titles from your domain              |
| Entity names    | Real-world examples your users would recognize |
| Company names   | Representative customer/company names          |
| ID formats      | Your product's ID formats                      |
| Decision labels | Domain-specific status labels and decisions    |
| Section names   | Key sections/categories in your product        |
| Scores/metrics  | Realistic scoring formats                      |

### 6. Save Output

Save exploration artifacts:

1. **Figma links** — always include direct URLs for every frame
2. **Exploration notes** — save to `projects/gazelle-agent/.state/projects/{name}/explorations.md`:

```markdown
## Design Explorations — [date]

**Feature:** [name]
**Spec:** [link to spec.md]
**Figma page:** [page name + link]
**Concepts generated:** [N]

### Concept 1: [name]

- **Figma link:** https://www.figma.com/design/{fileKey}/?node-id={nodeId}
- **Strategy:** clone+remix from [source] / compose
- **Approach:** [description]
- **Tradeoff:** [description]
- **Status:** proposed / selected / rejected
- **Feedback:** [user's reaction, if given]

### Concept 2: [name]

...
```

3. **Update context.md** state table:

```
- [x] Explorations — [date], [N] concepts
```

### 7. Offer Next Steps

Based on what happened:

- **User selected a concept** → "want me to refine it? or run `/design-critique` on it?"
- **User wants to combine elements** → iterate in Figma, create a new "Concept 4: Hybrid" frame
- **User wants more options** → generate additional concepts
- **User wants persona feedback** → "want to test with a synthetic user? `/persona-builder --test`"
- **User wants to proceed** → "next steps: `/wireframe` for detailed screens, or `/acceptance-criteria` for implementation handoff"
- **Ready to share with team** → "want me to export screenshots and write a 1-pager? `/create-deliverable --type one-pager`"

## Anti-Hallucination Rules

- **Never invent product features.** If the spec doesn't mention a capability (e.g., "AI auto-triage", "natural language search"), don't design it into a concept. If you think a feature should exist, frame it as a question: "spec doesn't mention X — worth exploring?"
- **Never fabricate user quotes.** Don't write "users said they want X" unless citing a real Circleback/Notion/Slack source. Use [UNVERIFIED] if you're inferring a need.
- **Never present AI capabilities as existing.** Design for what exists or what the spec proposes — not imagined features. Check your product's actual AI capabilities in `context-training/domain.md`.
- **Never use generic AI buzzwords** ("intelligent automation", "seamless experience", "smart suggestions") without specific grounding. Say exactly what the AI does: "AI relevance score per item" not "AI-powered processing."
- **Mock data must be realistic.** Use domain-specific content from `context-training/domain.md` — not "Device A", "Sample Article", "AI Feature 1."

## Notes

- **Always include Figma links** in all output docs — node IDs alone are useless
- **Realistic mock data** — use domain-specific content, not placeholders
- **Each concept must be visually distinct** — don't generate 3 variations of the same layout with different colors. Different layouts, different information hierarchy, different interaction models
- **Respect the spec constraints** — creativity is in the layout approach, not in ignoring requirements
- **Clone+Remix is the default for mature products** — if your app has established patterns, most concepts should extend what exists rather than reinvent

---

## Appendix A: Domain Context

> Inline reference so this skill works in any environment (Cowork, Cursor, Claude Code) without external context files.
> **Replace this section with your own company/product context.** See `context-training/domain.md` for the full template.

## Your Product

Describe your company and product here. Include: what you do, who your customers are, your key modules/features, and your market position.

## Modules / Product Areas

| Area       | Name   | What it does  | Owner      |
| ---------- | ------ | ------------- | ---------- |
| **Area 1** | [Name] | [Description] | [PM/Owner] |
| **Area 2** | [Name] | [Description] | [PM/Owner] |

## Users

| Persona  | Does            | Product Area |
| -------- | --------------- | ------------ |
| [Role 1] | [Primary tasks] | [Area]       |
| [Role 2] | [Primary tasks] | [Area]       |

**User context:** Describe your users' general context — their industry, expectations, trust level with AI, tool familiarity, etc.

## Key Terms

Define your domain-specific terminology here.

## Competitors

| Competitor         | vs. Your Product   |
| ------------------ | ------------------ |
| **[Competitor 1]** | [How they compare] |

## Design Principles

Reference your design principles from `context-training/design-principles.md`.

## Team

List your team structure here: Design, PM, Engineering, CS, Leadership roles.

---

## Appendix B: Design Context

> Inline reference for design decisions. Source of truth: `context-training/style-guide.md`
> **Replace this section with your own design system context.**

## Design Philosophy

**One-sentence:** [Describe your product's visual identity in one sentence]

**What your product IS:** [Key design attributes]
**What your product is NOT:** [Anti-patterns to avoid]

**Core tension:** [The key UX tension your design must balance, e.g. "Trust vs efficiency"]

## Visual Hierarchy (The Squint Test)

Blur your vision. Can you identify: (1) what page, (2) where in workflow, (3) primary content, (4) what to act on, (5) what's AI? If any is ambiguous, hierarchy is broken.

- Max 3 visual weights per screen (SemiBold heading + Regular body + subtle caption)
- One filled primary button per screen — everything else outlined or text
- White space IS hierarchy — more padding = more importance

## Color System

Define your color usage rules. Example structure:

- **80% neutral** — backgrounds, text, borders, table rows
- **15% primary** — interactive elements, selected states, primary actions
- **5% accent / semantic** — AI markers, status colors, alerts

## Typography

Define your font stack and size scale here. Reference `context-training/design-system.md`.

## Spacing

Define your spacing system. Example: 8px grid with defined gaps for tight/default/comfortable/section/generous/major contexts.

## Page Skeletons

Every concept should use a DIFFERENT skeleton. Define your common layouts:

- **A: Table + Sidebar** — data browsing with contextual panel
- **B: Full-width Dashboard** — stats row → summary → table
- **C: Component Augmentation** — add functionality inline to existing section
- **D: Split Comparison** — two panels side by side
- **E: Wizard/Stepper** — one step per screen

## AI Feature Treatment

Define how AI elements are visually distinguished in your product. Include: AI button styles, AI panel styling, AI content markers, trust mechanisms.

## Anti-Patterns (Banned)

List your product's banned design patterns here.

## Design Critique Framework

Define your team's feedback format. Example: "I like..." / "I don't get..." / "I wonder if..."
