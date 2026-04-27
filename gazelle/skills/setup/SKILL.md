---
name: setup
description: "Interactive setup wizard for Gazelle. Interviews the user about their company, product, tools, and design system — then generates context-training files so all Gazelle skills work for their org."
when_to_use: "Use on first run, when context-training files are empty/missing, or when user says 'setup', 'configure gazelle', 'set up gazelle', 'initialize', 'onboard my company'."
effort: medium
argument-hint: "[--auto] [--refresh]"
allowed-tools: Read, Write, Glob, Grep, WebSearch, AskUserQuestion
---

# Gazelle Setup Wizard

**Voice:** Friendly, direct, helpful. This is the first interaction a new user has with Gazelle — make it feel welcoming and low-friction.

## Usage

```
/setup              # Full interactive setup
/setup --auto       # Try to auto-detect from connected MCPs first, then ask for gaps
/setup --refresh    # Re-run setup, updating existing context files
```

## What This Skill Does

Gazelle skills rely on **context-training files** that describe your company, product, users, tools, and design principles. This wizard generates those files by asking you questions (or auto-detecting from your connected tools).

After setup, every Gazelle skill — `/research`, `/persona-builder`, `/design-spec`, etc. — will understand your product context automatically.

## Protocol

### 0. Check Existing State

First, check if context-training files already exist. Search for them in these locations (the installer puts them in different places depending on the IDE):

```
# Claude Code
projects/gazelle-agent/context-training/domain.md

# Cursor
projects/gazelle-agent/context-training/domain.md

# Or relative to workspace
context-training/domain.md
```

Check all 4 files: `domain.md`, `data-sources.md`, `design-principles.md`, `personas-reference.md`.

- If ALL exist and are populated (not just templates): ask if the user wants to `--refresh` or skip
- If ANY are missing or contain only template placeholders: proceed with setup
- If `--refresh` flag: proceed with setup, showing current values as defaults

### 1. Company & Product (→ domain.md)

Ask these questions one at a time. Be conversational, not form-like.

**Required:**

1. "What's your company name?"
2. "What does your product do? (one sentence is fine)"
3. "What industry/domain are you in?" (e.g., fintech, healthcare, developer tools, e-commerce)
4. "Who are your primary users? What are their roles/titles?"
5. "What's your product's current stage?" (early, growth, mature, enterprise)

**Optional (ask if user seems engaged, skip if they want to move fast):** 6. "Any key product modules or feature areas?" (helps with research scoping) 7. "Any industry-specific terminology Gazelle should know?" (glossary terms) 8. "Who are your main competitors?" 9. "What's your company size / team structure?"

### 2. Auto-Detection (if --auto or MCPs available)

If the user has MCPs connected, try to enrich context automatically:

**Notion MCP available?**

- Search for pages matching: "company overview", "product strategy", "team", "values"
- Extract: company description, product modules, team roles
- Show findings: "i found some context in your Notion. here's what i picked up — correct anything that's off:"

**Slack MCP available?**

- List channels to understand team structure (e.g., #product, #engineering, #design, #sales)
- Note: don't read messages, just channel names for context

**Figma MCP available?**

- Check for design system files, component libraries
- Note component naming patterns, design tokens

**BigQuery/Omni MCP available?**

- List available datasets/tables
- Note event schema patterns

Show a summary of everything auto-detected and ask the user to confirm/correct.

### 3. Tools & Data Sources (→ data-sources.md)

Ask about their data landscape:

1. "Where does your team track work and decisions?" (Notion, Confluence, Linear, Jira, Google Docs, etc.)
2. "Where do team conversations happen?" (Slack, Teams, Discord)
3. "Do you have product analytics / a data warehouse?" (BigQuery, Snowflake, Amplitude, Mixpanel, PostHog)
4. "Do you use Figma for design?"
5. "Any other tools Gazelle should search when doing research?" (Drive, Circleback for meeting notes, etc.)

For each tool, ask:

- "Is the MCP connected?" (check by trying a simple operation)
- "Any specific workspaces, channels, or projects to focus on?"

### 4. Design System (→ design-principles.md)

1. "Does your team have documented design principles or values?"
2. "Do you have a design system or component library?" (name it — e.g., "our DS is called Orbit, built in Radix + Tailwind")
3. "What's your frontend stack?" (React, Vue, Svelte, etc. + styling: Tailwind, CSS modules, styled-components, vanilla-extract)
4. "Any brand colors or typography Gazelle should know about?" (primary color, font family)
5. "Who makes design decisions on your team?" (helps with `/create-deliverable` targeting)

### 5. Generate Context Files

From the answers, generate these files:

#### `context-training/domain.md`

```markdown
# Gazelle — Domain Context

> Your company, product, users, and terminology. Auto-generated by `/setup`.
> Edit this file anytime — it's the source of truth for all Gazelle skills.

**Last updated:** {date}

---

## Company

**{company_name}** — {one_line_description}
**Domain:** {industry}
**Stage:** {stage}
**Size:** {size_if_provided}

---

## Product

{product_description}

### Modules / Feature Areas

{modules_list_or_note_that_none_defined}

---

## Users

| Role | Description |
| ---- | ----------- |

{user_roles_table}

---

## Terminology

| Term | Meaning |
| ---- | ------- |

{glossary_or_note_to_add_terms_as_you_go}

---

## Competitors

{competitors_or_unknown}

---

## Team

{team_structure_or_note}
```

#### `context-training/data-sources.md`

```markdown
# Gazelle — Data Sources Reference

> Where your data lives and how to access it. Auto-generated by `/setup`.

---

## Connected Tools

| Tool | MCP Status | What to Search |
| ---- | ---------- | -------------- |

{tools_table}

---

## Knowledge Base ({notion_or_confluence_etc})

{knowledge_base_details_or_not_connected}

---

## Team Communication ({slack_or_teams_etc})

{communication_details_or_not_connected}

---

## Analytics ({bigquery_or_amplitude_etc})

{analytics_details_or_not_connected}

---

## Design ({figma_etc})

{design_tool_details_or_not_connected}

---

## Other Sources

{other_sources_or_none}
```

#### `context-training/design-principles.md`

```markdown
# Gazelle — Design Principles

> Your team's design philosophy. Auto-generated by `/setup`.
> Edit and expand this as your design system evolves.

**Last updated:** {date}

---

## Company Values

{values_if_provided_or_placeholder}

---

## Product & Design Principles

{principles_if_provided_or_universal_defaults}

---

## Design System

**Name:** {ds_name_or_none}
**Frontend stack:** {stack}
**Component library:** {component_lib}
**Styling:** {styling_approach}

### Brand

**Primary color:** {color_or_unknown}
**Typography:** {fonts_or_unknown}

---

## Design Decision Makers

{who_approves_designs_or_unknown}
```

#### `context-training/personas-reference.md`

```markdown
# Gazelle — Personas Reference

> Known user personas. Start empty — populated by `/persona-builder`.
> You can also add personas manually here.

**Last updated:** {date}

---

## Personas

No personas built yet. Run `/persona-builder build` to create data-grounded personas.

---

## Persona Template

When building personas, each should include:

- **Name & archetype** (fictional name + role descriptor)
- **Demographics** (role, seniority, company type)
- **Goals** (what they're trying to achieve)
- **Pain points** (what frustrates them today)
- **Behaviors** (how they use the product, frequency, patterns)
- **Quotes** (real if available, representative if not — always labeled)
- **Data sources** (where the persona evidence came from)
- **Freshness date** (when last validated)
```

### 6. Summary & Next Steps

After generating files, show:

```
setup complete! here's what i configured:

**Company:** {name} ({domain})
**Product:** {description}
**Users:** {count} roles defined
**Tools:** {connected_tools_list}
**Design system:** {ds_summary}

context-training files written:
  - context-training/domain.md
  - context-training/data-sources.md
  - context-training/design-principles.md
  - context-training/personas-reference.md

**what to try next:**
- `/research [topic]` — research any topic across your connected sources
- `/persona-builder build` — create data-grounded personas from your data
- `/quick-start` — guided tour of all Gazelle skills for your role
- edit any context-training file anytime — they're plain markdown
```

### 7. Validation

Before finishing, verify:

- All 4 files were written successfully
- No placeholder tokens remain (all `{...}` replaced with real values or "not configured")
- Files are valid markdown
- Suggest the user review and edit the files — they're the source of truth

## Edge Cases

- **No MCPs connected:** That's fine! Gazelle works with web search + filesystem. Note which skills will be limited.
- **User wants minimal setup:** Accept one-line answers. Generate files with defaults + TODOs.
- **User provides a URL to their docs:** Fetch it and extract context.
- **Refresh mode:** Show current values, ask what changed, update incrementally.
