---
name: prototype
description: High-fidelity prototype builder — builds standalone HTML prototypes. Works from live/staging app HTML (best), Figma designs, wireframes, or memory. Prefers live HTML when available.
when_to_use: "Use when building a clickable HTML prototype. Examples: 'build prototype', 'create clickable prototype', 'html prototype from live app'"
argument-hint: "[feature or route]"
---

# Prototype From Live — High-Fidelity Prototype Builder

Build a standalone HTML prototype by capturing the live or staging app. The prototype must look exactly like the real app.

## Usage

Invoke with: `/prototype [url-or-route]`

Also triggers on: "build prototype", "create prototype", "html prototype", "clickable prototype", "build from live app", "prototype this flow"

Examples:

- `/prototype https://staging.yourapp.com/literature`
- `/prototype /literature/search` (relative to staging base)
- "build a prototype of the screening flow"

## Source Priority

Build from the best available source, in this order:

1. **Live/staging app HTML** ← strongly preferred. Captures exact styles, components, and layout.
2. **Figma designs** — use `mcp__claude_ai_Figma__get_design_context` to extract specs and build from those.
3. **Wireframes or screenshots** — extract layout and structure, apply your project's design tokens manually.
4. **Memory / spec description** — last resort for greenfield features with nothing live yet.

**Why live HTML wins:** During user testing, users are skeptical of anything that doesn't look exactly like the real app. If the prototype has fidelity gaps, they comment on those instead of the feature — which ruins the research signal. Live HTML eliminates this problem entirely.

## Protocol

### 1. Get the URL

If not provided, ask:
"What URL or route should I capture? (staging URL or local dev URL like `http://localhost:3000/...`)"

Common staging base: check project CLAUDE.md or `.env` files for `STAGING_URL`.
Local dev: usually `http://localhost:3000` for webapp.

### 2. Open the Page

Detect environment and use the right browser tool:

| Environment              | Tool                                |
| ------------------------ | ----------------------------------- |
| **Claude Code**          | `mcp__claude-in-chrome` (preferred) |
| **Claude Code fallback** | `mcp__chrome-devtools`              |
| **Cursor**               | `cursor-ide-browser` built-in       |
| **Playwright**           | `mcp__plugin_playwright_playwright` |

**Claude Code (preferred — claude-in-chrome):**

```
mcp__claude-in-chrome__tabs_context_mcp → check if app already open in a tab
mcp__claude-in-chrome__navigate → {url, tabId}
```

If auth wall appears: ask user to log in first, or use `/setup-browser-cookies` to import session cookies.

**Fallback (chrome-devtools):**

```
mcp__chrome-devtools__navigate_page → {url}
mcp__chrome-devtools__take_screenshot → verify page loaded
```

### 3. Capture Full HTML + CSS

Extract the full page source:

**Claude Code (claude-in-chrome):**

```javascript
// via mcp__claude-in-chrome__javascript_tool:
document.documentElement.outerHTML;
```

**Chrome devtools fallback:**

```javascript
// via mcp__chrome-devtools__evaluate_script:
document.documentElement.outerHTML;
```

**Playwright:**

```
mcp__plugin_playwright_playwright__browser_evaluate → document.documentElement.outerHTML
```

Also capture:

- All `<style>` tags and `<link rel="stylesheet">` hrefs
- CSS custom properties (design tokens)
- Any inline `style` attributes

### 4. Build Standalone HTML File

Transform the captured HTML into a self-contained prototype:

**Inline all CSS:**

- Replace `<link rel="stylesheet" href="...">` with `<style>` blocks
- Fetch referenced CSS files and embed them
- Preserve CSS custom properties (`:root { --color-primary: #...; }`)

**Remove auth barriers:**

- Strip redirect logic (`if (!user) redirect(...)`)
- Replace `window.location` auth checks with no-ops
- Keep the visual DOM intact

**Replace API calls with static data:**

- Intercept fetch/XHR calls
- Return mock JSON that matches the current visible data
- Goal: page renders without network requests

**Make it clickable (if prototyping a flow):**

- Replace `<a href="/route">` with prototype page links
- Add basic JS for tab switching, modal open/close, accordion — keep it minimal

**Brand color sanity check:**

- Verify the primary brand color from your project's design tokens is used in CSS tokens
- Flag any accent colors that incorrectly appear as primary/background colors

### 5. Save the File

Determine save location:

- **Product Design workspace:** `~/Development/Product Design/projects/{project-name}/design/wireframes/prototype/`
- **Webapp project:** `./.prototype/` in project root
- **If unclear:** ask where to save

Filename: `{feature-name}-{YYYY-MM-DD}.html`

Example: `literature-screening-flow-2025-03-20.html`

```bash
mkdir -p {save-path}
# Write the standalone HTML file
```

### 6. Verify in Browser

Open the saved file in browser to confirm it renders correctly:

```
mcp__chrome-devtools__navigate_page → file://{absolute-path}
mcp__chrome-devtools__take_screenshot → verify it looks right
```

Compare screenshot to original. If major visual differences: note them and fix before confirming.

### 7. Apply Design Changes (if requested)

If the user wants to modify the prototype (e.g., testing a new design direction):

- Apply changes on top of the captured baseline
- Note every change made vs the original
- Keep original as reference (don't overwrite it)

Save modified version as: `{feature-name}-{YYYY-MM-DD}-v2.html`

### 8. Confirm

Output:

```
Prototype saved: {absolute-path}

Captured from: {source-url}
Pages: {list of routes captured}
Changes applied: {none / list of modifications}

Open with: open "{path}"
```

## Rules

- **Prefer live/staging HTML** — see Source Priority above. Fallback to Figma, then wireframes, then memory.
- **Use your project's primary brand color.** Check `context-training/style.md` for the correct color tokens
- **No external dependencies** in final file — everything must be inlined
- **Keep mock data realistic** — use actual content from the captured page, not placeholder text
- **Don't strip intentional UX** — keep loading states, error states, empty states visible via static mock
- **If auth blocks capture:** don't try to bypass auth programmatically. Ask user to log in first, then capture

**Domain-Specific Mock Data (when building without live HTML):**

When building prototypes from Figma/wireframes/spec (not live HTML), use realistic domain data from your project's `context-training/domain.md`. Pull real terminology, product names, and workflow-specific content from your domain context.

Never use generic placeholder data like "Lorem ipsum", "Test Item 1", "Product ABC", or "John Doe" in prototypes — domain experts immediately lose trust in prototypes that don't look like their real workflow.

## Offer Next Steps

After the prototype is saved:

> "prototype saved. next options:
>
> - want a design critique? → `/design-critique`
> - want to QA test it? → `/qa`
> - want to test with a persona? → launch `synthetic-user` subagent"

## Integration

- Pairs with `/design-qa` — prototype the flow before QA testing
- Save prototypes to `~/Development/Product Design/projects/{name}/design/wireframes/prototype/` when doing user testing
- Works best with a running local dev server — start it first if not running

---

## Appendix: Domain Context

> For project-specific domain context (company info, modules, users, key terms, competitors, team), see `context-training/domain.md` in your Gazelle project.
> For design context (design philosophy, visual hierarchy, color rules, typography, spacing, page skeletons), see `context-training/style.md`.
> These files are loaded automatically when available. This skill works without them but produces better results with project-specific context.
