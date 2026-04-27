---
name: flow-capture
description: "Navigate your live app (or any URL), screenshot each step, and document the current user flow. Produces numbered screenshots + flow-analysis.md. Use before journey mapping for visual evidence, or standalone for flow documentation."
when_to_use: "Use when documenting current user flows with screenshots. Examples: 'screenshot the current flow', 'document this user flow', 'capture the live app'"
argument-hint: "[url or route]"
---

# Flow Capture

**Voice:** Casual, direct, honest. Abbrevs ok (w., bc, tbh, imo, kinda).

## Usage

```
/flow-capture [flow]
/flow-capture [flow] --project [name]
/flow-capture [flow] --url [start-url]
/flow-capture [flow] --mode auto|guided
/flow-capture [flow] --depth quick|standard|deep
```

**Flags:**

- `--project [name]` — save to this project folder (default: kebab-case of flow name)
- `--url [start-url]` — starting URL (default: your app's staging environment)
- `--mode auto|guided` — `guided` (default): user directs each step. `auto`: agent navigates using flow templates.
- `--depth quick|standard|deep` — how deep to explore interactive states:
  - `quick` — happy path only, one screenshot per screen, no sub-views (~5-8 screens)
  - `standard` (default) — happy path + open key dropdowns/filters to show available options (~8-12 screens)
  - `deep` — explore interactive states: try 2-3 dropdown options, drill into sub-views, capture filtered results, pagination. Reveals data quality and edge cases (~12-20 screens)

**Examples:**

```
/gazelle-flow-capture "search workflow"
/gazelle-flow-capture "search workflow" --depth deep
/gazelle-flow-capture "item screening" --project screening-redesign
/gazelle-flow-capture "competitor: [name] reporting" --url https://competitor.com
/gazelle-flow-capture "export flow" --mode auto --depth quick
```

## Protocol

### 1. Load Context

Read before starting:

- `projects/gazelle-agent/context-training/data-sources.md` — analytics event schema for event mapping
- `projects/gazelle-agent/context-training/domain.md` — product context, feature names

Check for existing state:

- `projects/gazelle-agent/.state/projects/{project}/flow-analysis.md` — prior flow capture
- `projects/gazelle-agent/.state/projects/{project}/screenshots/` — prior screenshots

If prior capture exists, ask: "found existing flow capture from [date]. re-capture (overwrites) or skip?"

### 2. Determine Flow + Starting Point

Ask (max 2 questions if not clear from request):

1. **Which flow?** — map to known flow templates if possible
2. **Where to start?** — specific URL or "just the main app"

#### Known Flow Templates

Define your product's flow templates in `context-training/domain.md`. Use this structure as navigation guides in `auto` mode:

| Flow                 | Start Point   | Key Screens                            |
| -------------------- | ------------- | -------------------------------------- |
| [Primary Workflow]   | [entry route] | [Screen 1 → Screen 2 → Screen 3 → ...] |
| [Secondary Workflow] | [entry route] | [Screen 1 → Screen 2 → ...]            |
| [Admin / Settings]   | [entry route] | [Screen 1 → Screen 2 → ...]            |
| [Onboarding]         | [entry route] | [Screen 1 → Screen 2 → ...]            |

**Sub-flows for `deep` depth (explore when time allows):**

- **Statistics loop:** Select grouping → view grouped table → switch to 2-3 different grouping options → drill into a group row → see filtered results. This often reveals data quality issues (empty fields, normalization gaps)
- **Detail review loop:** Detail view → Metadata tab → navigation between items → evaluation sidebar
- **Export sub-flow:** Export dropdown → format options → (if safe) trigger export to see output format

If flow doesn't match a template, use `guided` mode.

### 3. Authentication

**Strategy:** Try staging first, fallback to user-assisted login.

```
Step 1: Navigate to your staging environment
  → browser_navigate to staging URL

Step 2: Check if login page appears
  → browser_snapshot to inspect page

Step 3a: If login page — attempt auth
  → Read credentials from ~/.claude/credentials.env
  → browser_fill email field
  → browser_fill password field
  → browser_click login button
  → browser_wait_for page load
  → browser_take_screenshot to confirm login

Step 3b: If auth fails or MFA required
  → Tell user: "can't auto-login. pls log in manually in the browser,
     then tell me when you're on the starting screen."
  → Wait for user confirmation
  → browser_take_screenshot to confirm starting point

Step 3c: If --url flag points to external app
  → Navigate directly, skip auth
  → If login wall appears, ask user to handle it
```

**Important:** Never store or log credentials in flow-analysis.md or screenshots. If a screenshot contains sensitive data (user emails, org names), note it but don't flag it as a blocker.

### 4. Screenshot Loop

For each screen in the flow:

```
a. Take screenshot
   → browser_take_screenshot with filename: "{NN}-{slug}.png"

   Naming: NN = zero-padded number (01, 02, ...), slug = kebab-case screen name
   Example: "01-search-list.png", "02-create-search.png", "03-results.png"

   ⚠️ IMPORTANT: cursor-ide-browser saves screenshots to a Cursor temp directory
   (e.g. /var/folders/.../T/cursor/screenshots/01-search-list.png), NOT the workspace.
   The "Saved to" path in the response tells you where the file actually is.
   After the capture loop, copy all screenshots to the project folder (see step 5).

b. Capture page structure
   → browser_snapshot (compact: true, interactive: true)
   → Record: current URL, page title, key interactive elements, data displayed

c. Analyze the screen
   - What is the user looking at?
   - What actions are available? (buttons, links, inputs, dropdowns)
   - What data is shown? (tables, lists, stats, charts)
   - Map to analytics event if known (from data-sources.md)
   - Note any UX friction (confusing labels, hidden actions, dead ends)

c2. Explore interactive states (standard + deep depth only)
   When a screen has dropdowns, filters, tabs, or grouping options:
   - **standard:** Open key dropdowns/filters to screenshot available options, then continue
   - **deep:** Actually select 2-3 different options, screenshot each result,
     drill into sub-views (e.g., click a row count to see filtered results).
     This is where you find data quality issues, empty states, and normalization gaps.

   What to explore:
   - Dropdowns: open them, screenshot options, try different selections
   - Filters: apply a filter, screenshot filtered view, then clear
   - Grouped/tabular data: click drill-down links, capture sub-views
   - Tabs: switch between tabs on the same page
   - Pagination: if multi-page, note total pages (no need to screenshot every page)

   Number sub-screenshots sequentially (08, 09, 10...) — don't use sub-letters (08a, 08b).

d. Navigate to next screen
   - guided mode: Ask user "where next? (click [element], or tell me what to do)"
   - auto mode: Follow flow template, click the primary CTA
   → browser_click the target element
   → browser_wait_for page load (1-3 seconds)
   → Repeat from (a)

e. End conditions
   - User says "done" or "that's the flow"
   - Auto mode: reached end of flow template
   - Dead end: no clear next action
```

**Tips for good captures:**

- Full page screenshots when content extends below fold: `fullPage: true`
- Element screenshots for specific UI components: use `ref` parameter
- Wait for loading states to resolve before screenshotting
- If a modal or dialog appears, capture it as a sub-screen (e.g., `03a-confirm-dialog.png`)
- Keep a list of `{filename → "Saved to" path}` during capture — needed for the copy step

### 5. Copy Screenshots to Project

Screenshots land in Cursor's temp dir. Copy them to the project folder:

```bash
mkdir -p "projects/gazelle-agent/.state/projects/{project}/screenshots"

# For each screenshot, copy from temp location to project:
cp "/var/folders/.../T/cursor/screenshots/01-search-list.png" \
   "projects/gazelle-agent/.state/projects/{project}/screenshots/01-search-list.png"
# repeat for each screenshot...
```

Use the "Saved to" paths from each `browser_take_screenshot` response. If a path is missing or the file doesn't exist, note it in flow-analysis.md as a gap.

### 6. Generate flow-analysis.md

After all screens captured, synthesize into structured document:

```markdown
# Flow Capture: [Flow Name]

**Date:** [date]
**Environment:** [Staging V X.X / Production / custom URL]
**Captured by:** Gazelle flow-capture
**Project:** gazelle/.state/projects/{name}/
**Screens captured:** [N]
**Mode:** [guided / auto]

---

## Screenshots

| #   | File                 | Screen        | URL        | Key Elements                    |
| --- | -------------------- | ------------- | ---------- | ------------------------------- |
| 01  | `01-screen-name.png` | [description] | [url path] | [primary buttons, inputs, data] |
| 02  | `02-screen-name.png` | [description] | [url path] | [primary buttons, inputs, data] |

---

## Flow Diagram
```

[Screen 1: Name] → [Screen 2: Name] → [Screen 3: Name]
↓ (alt path) ↓ (error)
[Alt Screen] [Error State]

```

---

## Per-Screen Analysis

### Screen 01: [Name]
**URL:** [full url]
**What user sees:** [description of page content, layout, information hierarchy]
**Available actions:** [buttons, links, inputs, dropdowns — what can user do here?]
**Data shown:** [tables, lists, stats, charts — what info is displayed?]
**Event mapping:** [analytics event name if known, or "unmapped"]
**UX observations:** [friction, confusion, missing info, good patterns]

### Screen 02: [Name]
[repeat structure]

---

## Flow Summary

[2-3 sentences: what the flow accomplishes, how many steps, total screen count,
where the biggest friction points are, what's missing]

## UX Observations

- [observation about navigation / information architecture]
- [observation about missing features or dead ends]
- [observation about consistency with other flows]
- [observation about mobile/responsive if relevant]

## Pain Points Observed

| Pain | Screen | Severity | Notes |
|------|--------|----------|-------|
| [pain] | [##] | High/Med/Low | [what makes it painful] |

## Event Mapping

| Screen | Analytics Event | Confidence |
|--------|----------------|------------|
| [screen name] | [event name] | ✅ mapped / ⚠️ inferred / ❌ unmapped |

## Comparison to Journey Map

[If journey-map.md exists for this project, note:
- Which journey steps have visual evidence now
- Which journey steps are still data-only
- Any discrepancies between documented journey and actual UI]
```

### 7. Save State

Save to:

```
projects/gazelle-agent/.state/projects/{project}/
├── flow-analysis.md          # Analysis document
└── screenshots/
    ├── 01-screen-name.png
    ├── 02-screen-name.png
    └── ...
```

Update `context.md`:

```markdown
- [x] Flow capture — [date] ([N] screens, [environment])
```

### 8. Summary + Next Step

Show in chat:

```
flow capture done.

**captured:** [N] screens of [flow name] on [environment]

**standouts:**
- [most interesting UX observation]
- [biggest friction point found]
- [something missing or surprising]

**screenshots saved to:** .state/projects/{name}/screenshots/

→ next: `/gazelle-journey [flow] --project {name}` to build journey map from this + data
```

## Quality Rules

Flow capture is **useful** when:

- Screenshots cover the complete happy path (start to end)
- Per-screen analysis identifies available actions (not just descriptions)
- Event mapping connects screens to analytics telemetry
- UX observations go beyond surface (not just "this is a form")
- Interactive states explored: dropdowns opened, grouping options tried, drill-downs captured
- Data quality assessed: are fields populated or 99% empty? Are values normalized or duplicated?

Flow capture is **weak** when:

- Only 2-3 screenshots of a complex flow
- No event mapping attempted
- Observations are generic ("looks clean")
- Alternative paths / error states not captured
- Dropdowns/filters left unopened — missed what options exist and what data looks like when used

**What to do with weak captures:** Ship them anyway — partial visual evidence > none. Note what's missing in the flow summary.

## Browser Environment Detection

This skill works across Cursor, Claude Code, and Claude Cowork. Detect which browser tools are available and adapt:

| Environment     | How to Detect                                                                    | Browser Tools                                                                                                                                            |
| --------------- | -------------------------------------------------------------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **Cursor**      | `cursor-ide-browser` MCP available                                               | `browser_navigate`, `browser_lock`, `browser_unlock`, `browser_snapshot`, `browser_take_screenshot`, `browser_click`, `browser_fill`, `browser_wait_for` |
| **Claude Code** | Playwright MCP available                                                         | `playwright_navigate`, `playwright_screenshot`, `playwright_click`, `playwright_fill`                                                                    |
| **Cowork**      | Cowork browser extension active (check for `computer` tool or browser tab tools) | Use Cowork's built-in browser control — navigate, click, type, screenshot via the desktop app's browser extension                                        |

**Adaptation rules:**

- Use whatever browser tools the environment provides — the protocol steps (navigate → snapshot → screenshot → analyze → click next) stay the same
- Screenshot save paths differ: Cursor uses a temp dir (copy to project after), Cowork/Claude Code may save directly to the working directory
- If no browser tools are detected, tell the user and suggest `guided` mode where they take screenshots manually

## Integration

- **Subagents used:** None — direct browser calls in main conversation
- Reads from: `data-sources.md` (event mapping), `domain.md` (product context)
- Outputs feed into: `/gazelle-journey` (visual evidence for journey map), `/gazelle-spec` (current-state reference for spec)
- State saved to: `projects/gazelle-agent/.state/projects/{project}/flow-analysis.md` + `screenshots/`

---

## Appendix: Domain Context

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
