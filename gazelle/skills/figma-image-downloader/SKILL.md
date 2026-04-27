---
name: "figma-image-downloader"
description: "WHAT: Download screen screenshots from Figma files. WHEN: Extracting visual assets, creating screenshot references. KEYWORDS: figma, download, screenshot, images, frames, png, export"
when_to_use: "Use when downloading screenshots from Figma. Examples: 'download Figma frames', 'export screenshots from Figma'"
argument-hint: "[figma-url]"
---

# Figma Image Downloader Skill

## When to Use This Skill

- Downloading design assets
- Creating screenshot references
- Extracting icons or images
- Documenting designs visually

## Prerequisites

Figma MCP configured with API access. Use official Figma MCP only (`mcp__figma__` or `mcp__claude_ai_Figma__`). Do NOT use TalkToFigma.

## Core Workflow

Use official Figma MCP tool names with double-underscore format: `mcp__figma__*` or `mcp__claude_ai_Figma__*`.

### Step 1: Identify Frames

Get file structure first:

```
mcp__figma__get_metadata({ fileKey: "YOUR_FILE_KEY" })
```

List pages and frames, identify which node IDs to download. For exploration, use `get_screenshot` first — `get_metadata` can overflow on large section nodes.

### Step 2: Download Screenshots

```
mcp__figma__get_screenshot({ fileKey: "YOUR_FILE_KEY", nodeId: "123:456" })
```

Options:

- `scale`: 1, 2, or 3 (default 2)
- Format is always PNG for screenshots

### Step 3: Save to Disk

Screenshots are returned as base64 or URLs.
Save to appropriate location:

- `assets/screenshots/`
- `docs/images/`
- `spec-machine/.state/artifacts/`

## Size Limits

- Maximum total dimension: 8000px
- For large frames, use scale 1
- Break into multiple requests if needed

## Common Use Cases

### Export Component Screenshot

```javascript
// Get single component
const screenshot = await figma.getScreenshot(fileKey, ["node-id"], {
  scale: 2,
});
```

### Export Multiple Frames

```javascript
// Get multiple frames at once
const screenshots = await figma.getScreenshot(
  fileKey,
  ["node-id-1", "node-id-2", "node-id-3"],
  { scale: 1 },
);
```

### Export for Documentation

Best practices:

- Use scale 2 for retina display
- PNG for screenshots
- SVG for icons/illustrations

## File Naming Convention

```
{module}-{feature}-{screen}-{state}.png

Examples:
- dashboard-overview-default.png
- search-results-list-filtered.png
- settings-profile-edit-error.png
- onboarding-step2-form-filled.png
```

Save to Gazelle project state: `projects/gazelle-agent/.state/projects/{name}/screenshots/`

## Quick Reference

| Scale | Use Case                      |
| ----- | ----------------------------- |
| 1     | Large frames, documentation   |
| 2     | Standard screenshots, retina  |
| 3     | High-res assets, zoom details |

## Common Mistakes to Avoid

### DON'T

- Request frames > 8000px at scale 2+
- Forget to check node IDs first
- Save without meaningful names

### DO

- Use appropriate scale for use case
- Organize in proper folders
- Include state in filename

## Offer Next Steps

After images are downloaded:

> "screenshots saved. next options:
>
> - want to document the flow? → save to `.state/projects/{name}/screenshots/` for reference
> - want a design critique? → `/design-critique`"

---

## Appendix: Domain Context

> For project-specific domain context (company info, modules, users, key terms, competitors, team), see `context-training/domain.md` in your Gazelle project.
> For design context (design philosophy, visual hierarchy, color rules, typography, spacing, page skeletons), see `context-training/style.md`.
> These files are loaded automatically when available. This skill works without them but produces better results with project-specific context.
