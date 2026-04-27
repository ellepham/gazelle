---
name: wireframe
description: "Create wireframes using Figma (via MCP) or Pencil (free, no account needed). Detects available canvas automatically. Supports lo-fi (gray boxes) and mid-fi (design system components) fidelity levels."
when_to_use: "Use when creating wireframes in Figma or Pencil. Examples: 'wireframe this', 'create a wireframe', 'sketch this feature'"
argument-hint: "[feature] [--fidelity lo/mid]"
---

# Wireframe

**Voice:** Casual, direct, honest. Abbrevs ok (w., bc, tbh, imo, kinda).
Lead w. answer, context after. Flag gaps helpfully (coach, not auditor).

> **Exploring multiple directions?** Use `/explore-designs` first — it generates 2-3 distinct hi-fi concepts from your spec. `/wireframe` is for quick single-screen sketches when you already know the direction.

## Usage

```
/wireframe [description]
/wireframe [description] --canvas figma|pencil
/wireframe [description] --fidelity lo|mid
/wireframe [description] --project [name]
/wireframe [description] --screens [N]
```

**Flags:**

- `--canvas figma|pencil` — force a specific canvas (default: auto-detect)
- `--fidelity lo|mid` — lo = gray boxes, placeholder text. mid = design system components, real tokens (default: lo)
- `--project [name]` — project folder name for saving screenshots
- `--screens [N]` — number of screens to wireframe (default: 1)

## Protocol

### 1. Detect Canvas

Check which design tools are available:

1. **Figma MCP** — check if `mcp__figma__use_figma` or `mcp__claude_ai_Figma__use_figma` is available
2. **Pencil MCP** — check if Pencil MCP tools are available

Decision logic:

- If `--canvas` flag specified → use that canvas
- If both available → prefer Figma (more capable, DS-integrated)
- If only one available → use that one
- If neither available → inform user and suggest setup

> "using **[figma/pencil]** as canvas. [fidelity] fidelity. describe what you want to wireframe."

### 2. Gather Requirements

If the user's description is vague, ask clarifying questions:

- What screens/views are needed?
- What are the key interactions?
- Any reference designs or existing screens to match?

Check for existing project state:

- `projects/gazelle-agent/.state/projects/{name}/spec.md` — design spec
- `projects/gazelle-agent/.state/projects/{name}/flow-analysis.md` — existing flow screenshots
- `projects/gazelle-agent/.state/projects/{name}/screenshots/` — reference images

### 3. Create Wireframes

#### Figma Path

**Lo-fi (gray boxes):**

1. Load the `figma-use` skill (MANDATORY before any `use_figma` call)
2. Create a new frame in the Figma file with the project name (standard frame: 1440 × 900px)
3. Build wireframes using basic shapes with your product's standard chrome structure:

   **Standard page structure for lo-fi wireframes:**

   ```
   ┌─ Nav Header (full width, ~48px) ─────────────────────────────┐
   │  [Logo]  [Nav1] [Nav2] [Nav3]   [Search]  [User avatar]       │
   ├─ Page Header (~60px) ─────────────────────────────────────────┤
   │  [Page Title]              [Primary Action Button]            │
   ├─ Content Area ─────────────────────────────────────────────────┤
   │                                                               │
   │  [Main content — table / cards / form / stepper]              │
   │                           [Optional sidebar ~320px]           │
   │                                                               │
   └───────────────────────────────────────────────────────────────┘
   ```

   Use gray rectangles to block out each section. Label with text:
   - "Nav Header" / "Page Title" / "Primary CTA"
   - Content area: "[Table: N rows × M cols]" or "[Card grid]" or "[Form: N fields]"
   - Sidebar (if applicable): "[Filter panel]" or "[AI suggestions panel]"
   - No colors, no DS components — pure structure

   **Domain-Specific Wireframe Patterns:**

   Use the right domain pattern based on what's being wireframed. Check `context-training/domain.md` for your product's modules and terminology. Common patterns:

   **Data Table + AI Sidebar:**

   ```
   ┌─ Results Table ────────────────────────────────────────────┐
   │ [Checkbox] [Item Title]  [Source/Category Badge]           │
   │           [Metadata]     [AI Score: ●●●○○]  [Date]        │
   │ ... (40px rows, tight)                                     │
   ├─ AI Detail Sidebar (~320px) ──────────────────────────────┤
   │ [AI Confidence Score: 85%]                                 │
   │ [Reasoning: "Matched criteria X, Y, Z"]                    │
   │ [Override: Accept / Reject]                                │
   │ [Similar items: 3 found]                                   │
   └────────────────────────────────────────────────────────────┘
   ```

   Key elements: confidence score, override buttons, source badge, batch actions

   **Intake Form with AI Suggestions:**

   ```
   ┌─ Intake Form ─────────────────────────────────────────────┐
   │ [Category selector]  [Type dropdown]                       │
   │ [Description textarea]                                     │
   │ [AI Suggestion: "Category A — Type 1"] [Accept/Edit]      │
   │ [Trending indicator: "3 similar items this month"]         │
   └────────────────────────────────────────────────────────────┘
   ```

   Key elements: AI auto-classification with accept/edit, trending sidebar

   **Cross-Module Dashboard:**

   ```
   ┌─ Dashboard ───────────────────────────────────────────────┐
   │ [Stats: Module A Pending | Module B Due | Exports]         │
   ├─ Split View ──────────────────────────────────────────────┤
   │ [Module A: Recent Items]    │ [Module B: Active Progress]  │
   │ [Key metric]                │ [Completion: 85%]             │
   │ [3 new, 12 in review]      │ [Due: Apr 30]                 │
   └────────────────────────────────────────────────────────────┘
   ```

   Key elements: module status cards, cross-module activity feed, shared timeline

4. Use `get_screenshot` to capture and show the result

**Mid-fi (DS components):**

1. Load the `figma-use` skill (MANDATORY before any `use_figma` call)
2. Reference the DS appendix in `figma-use` (Section 12) for cached component keys
3. Import DS components using cached keys (Button-v.2, icons, etc.)
4. Apply real color tokens (primary for accents, gray-800 for text, etc.)
5. Use proper typography (your brand font, correct font sizes from scale)
6. Use real spacing values from the spacing scale
7. Use `get_screenshot` to capture and show the result

**Figma MCP policy:** Use ONLY official Figma MCP (`mcp__figma__*` or `mcp__claude_ai_Figma__*`). Do NOT use TalkToFigma.

#### Pencil Path

**Lo-fi only** (Pencil is inherently lo-fi):

1. Create a new `.pen` file for this project
2. Build wireframes using Pencil's shape tools
3. Use placeholder text and gray boxes
4. Export as PNG + PDF to project folder

**Pencil conventions:**

- Create new `.pen` files per project — never edit another project's files
- Pencil has no save-as — when done, export nodes as PNG + PDF
- Save exports to `projects/{name}/design/wireframes/`

### 4. Capture & Save

Save wireframe artifacts:

1. **Screenshots** — save to `projects/gazelle-agent/.state/projects/{name}/screenshots/wireframe-{N}.png`
2. **Wireframe notes** — append to `projects/gazelle-agent/.state/projects/{name}/wireframe-notes.md`:

   ```markdown
   ## Wireframe Notes — [date]

   **Canvas:** [figma/pencil]
   **Fidelity:** [lo/mid]
   **Screens:** [N]

   ### Screen 1: [name]

   - Layout: [description]
   - Key elements: [list]
   - Figma node ID: [if Figma] or export path: [if Pencil]
   - Figma link: https://www.figma.com/design/{fileKey}/?node-id={nodeId with - not :} [if Figma]

   ### Screen 2: [name]

   ...
   ```

### Anti-Hallucination Rules

- **Never add UI elements not in the spec.** If the spec doesn't mention "AI confidence panel" or "batch triage sidebar," don't wireframe it. Ask first: "spec doesn't mention X — want me to include it?"
- **Never invent product capabilities.** Use the module-specific patterns above, but only include features that exist or are proposed in the spec. Don't wireframe capabilities that aren't in the spec unless explicitly requested.
- **Mock labels must be accurate.** Use real terminology from your project's `context-training/domain.md` — not generic labels like "Database 1", "AI Feature", "Smart Filter."

### 5. Review & Iterate

Show the wireframes to the user and ask:

- "does this layout capture what you had in mind?"
- "anything to add/remove/rearrange?"

Iterate based on feedback. For Figma: edit in place. For Pencil: create new exports.

### 6. Offer Next Steps

Based on what's done:

- **Has wireframes, no spec** → "want me to write a design spec from these? `/design-spec`"
- **Has wireframes + spec** → "ready for hi-fi? load `figma-generate-design` to build the full screen in Figma, or `/prototype` to capture the live app and overlay changes"
- **Has wireframes, needs feedback** → "want to run these by a synthetic user? `/persona-builder --test`"
- **Has wireframes, needs critique** → "want a design review? `/design-critique`"

---

## Appendix: Domain Context

> For project-specific domain context (company info, modules, users, key terms, competitors, team), see `context-training/domain.md` in your Gazelle project.
> For design context (design philosophy, visual hierarchy, color rules, typography, spacing, page skeletons), see `context-training/style.md`.
> These files are loaded automatically when available. This skill works without them but produces better results with project-specific context.
