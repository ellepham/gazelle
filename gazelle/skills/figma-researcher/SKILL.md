---
name: "figma-researcher"
description: "WHAT: Research Figma designs using MCP server for implementation details. WHEN: Implementing UX changes, extracting design specs, auditing design tokens. KEYWORDS: figma, mcp, design, research, specs, tokens, colors, spacing"
when_to_use: "Use when extracting design specs from Figma. Examples: 'get specs from Figma', 'design tokens for X', 'what are the Figma details'"
argument-hint: "[figma-url or feature]"
---

# Figma Researcher Skill

## When to Use This Skill

- Implementing design from Figma
- Extracting design specifications
- Mapping design tokens to code
- Auditing design for compliance
- Understanding component structure

## Prerequisites

Figma MCP must be configured:

```yaml
# In settings.yml
mcpServers:
  figma:
    transport: http
    url: "https://mcp.figma.com/mcp"
```

## Core Workflow

Use official Figma MCP tool names with double-underscore format: `mcp__figma__*` or `mcp__claude_ai_Figma__*`.

### Step 1: Get File Metadata

First, understand the file structure:

```
mcp__figma__get_metadata({ fileKey: "YOUR_FILE_KEY" })
```

Returns pages, frames, and component hierarchy.

### Step 2: Get Design Context

For specific frames/components:

```
mcp__figma__get_design_context({ fileKey: "YOUR_FILE_KEY", nodeId: "123:456" })
```

Use node IDs **exactly as returned** from metadata (don't convert format — keep colons).

Returns:

- Component properties
- Styles applied
- Layout information
- Text content

### Step 3: Get Screenshots (Optional)

For visual reference:

```
mcp__figma__get_screenshot({ fileKey: "YOUR_FILE_KEY", nodeId: "123:456" })
```

Limits:

- Max 8000px total dimension
- Use scale 1 or 2 for most cases
- Prefer `get_screenshot` over `get_metadata` for initial exploration — metadata overflows on large frames

### Step 4: Get Variables

For design tokens:

```
mcp__figma__get_variable_defs({ fileKey: "YOUR_FILE_KEY" })
```

Returns:

- Color variables
- Spacing variables
- Typography variables
- Mode definitions (light/dark)

## Token Mapping

### Colors

Always map Figma colors to your project's design tokens — never hardcode hex values. Check your project's `context-training/` directory or design system docs for the canonical token list.

Example mapping pattern:

```
Primary brand color → CSS: var(--color-primary) or token: color.brand.primary
AI/accent color     → CSS: var(--color-accent)
Gray scale (majority of UI):
  Body text, secondary text, borders, backgrounds
```

### Spacing

Map Figma spacing values to your project's spacing scale. Common scales follow 4px or 8px increments:

```
4px  → tight (table cell padding)
8px  → default gap
12px → comfortable gap
16px → section gap
24px → generous (dialog padding)
32px → major section divider
```

### Typography

Map Figma text styles to your project's typography tokens. Document the font family, size, and weight for each text role (page titles, section labels, body text, buttons, captions, etc.).

## Common Patterns

### Extract Component Specs

```typescript
// From Figma design context:
{
  name: "Button",
  properties: {
    variant: "primary",
    size: "md"
  },
  styles: {
    backgroundColor: "#3B82F6",
    borderRadius: 8,
    padding: { top: 12, right: 24, bottom: 12, left: 24 }
  }
}

// Map to code:
const button = style({
  backgroundColor: 'var(--color-primary-500)',
  borderRadius: 'var(--radius-md)',
  padding: 'var(--spacing-sm) var(--spacing-lg)',
});
```

### Extract States

Look for component variants representing states:

- Default
- Hover
- Focus
- Active
- Disabled
- Loading

### Extract Responsive Behavior

Check for:

- Desktop vs Mobile variants
- Breakpoint-specific layouts
- Adaptive spacing

## Quick Reference

| Figma Concept       | Code Equivalent   |
| ------------------- | ----------------- |
| Fill color          | `backgroundColor` |
| Stroke              | `border`          |
| Corner radius       | `borderRadius`    |
| Auto layout padding | `padding`         |
| Auto layout gap     | `gap`             |
| Frame               | `div` / container |
| Component           | React component   |
| Instance            | Component usage   |
| Variant             | Prop value        |

## Design System Reference

For project-specific token and component lookups, see the DS reference appendix in the `figma-use` skill (Section 13).

Use official Figma MCP only (`mcp__figma__` or `mcp__claude_ai_Figma__`). Do NOT use TalkToFigma.

## Common Mistakes to Avoid

### DON'T

- Convert node IDs (use them as-is)
- Request screenshots > 8000px
- Ignore variant properties
- Hardcode color values

### DO

- Map all values to design tokens
- Check all component states
- Note responsive variants
- Document token gaps

## Offer Next Steps

After design specs are extracted:

> "specs extracted. next options:
>
> - ready to implement? → `/figma:implement-design` or `spec-machine:design-change-web`
> - want a design critique first? → `/design-critique`"

---

## Appendix: Domain Context

> For project-specific domain context (company info, modules, users, key terms, competitors, team), see `context-training/domain.md` in your Gazelle project.
> For design context (design philosophy, visual hierarchy, color rules, typography, spacing, page skeletons), see `context-training/style.md`.
> These files are loaded automatically when available. This skill works without them but produces better results with project-specific context.
