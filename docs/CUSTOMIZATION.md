# Customizing Gazelle for Your Organization

Gazelle uses **context-training files** as its customization layer. These plain markdown files tell every skill about your company, product, users, tools, and design system.

## Quick Start

Run `/setup` — the interactive wizard will ask you questions and generate all context files automatically.

Or fill them in manually by editing the files in `context-training/`.

## Context Files

### `domain.md` — Your Company & Product

This is the most important file. It tells Gazelle:

- **Who you are:** Company name, industry, stage, size
- **What you build:** Product description, modules/feature areas
- **Who uses it:** User roles, their goals, their pain points
- **Your vocabulary:** Industry terms, product jargon, abbreviations
- **Your competition:** Who you compete with and how you're different
- **Your team:** Who makes decisions about what

**Used by:** Every skill — especially `/research`, `/persona-builder`, `/jtbd`, `/competitive-analysis`

**Example:** See `context-training/domain.example.md` for a fully filled-in version.

### `data-sources.md` — Your Tools & Data

Tells Gazelle where to look when doing research:

- **Knowledge base:** Notion, Confluence, Google Docs — where specs and decisions live
- **Communication:** Slack, Teams — where conversations happen
- **Analytics:** BigQuery, Snowflake, Amplitude — where usage data lives
- **Design:** Figma, Sketch — where designs live
- **Other:** Meeting notes, support tools, etc.

For each tool, note whether the MCP is connected — this determines which skills can auto-search.

**Used by:** `/research` (source-researcher agents), `/opportunity-sizing` (usage-analyst), `/feedback-synthesizer`

**Example:** See `context-training/data-sources.example.md`

### `design-principles.md` — Your Design System

Tells Gazelle how to evaluate and create designs:

- **Company values:** The foundation layer
- **Design principles:** What Gazelle enforces during `/design-critique`
- **AI principles:** If your product uses AI
- **Design system:** Colors, typography, spacing, component library
- **Decision makers:** Who approves design work (used by `/create-deliverable`)

**Used by:** `/design-critique`, `/explore-designs`, `/design-spec`, `design-reviewer` agent

**Example:** See `context-training/design-principles.example.md`

### `personas-reference.md` — Your User Personas

Starts empty. Populated by running `/persona-builder build`.

You can also add personas manually — follow the template in the file.

**Used by:** `/persona-builder`, `synthetic-user` agent, `/design-critique`, `/design-spec`

## Files You Don't Need to Change

These are methodology files that work for any organization:

| File                        | What it is                                        |
| --------------------------- | ------------------------------------------------- |
| `evidence-thresholds.md`    | Confidence ladder (HIGH/MEDIUM/LOW) with criteria |
| `reality-check-rules.md`    | Anti-pattern detection for research blind spots   |
| `service-design-methods.md` | Design thinking methodology reference             |
| `voice-guide.md`            | Gazelle's communication style guide               |

## MCP Connections

Gazelle works best with MCP servers connected. Here's what each enables:

| MCP               | What it enables                                           |
| ----------------- | --------------------------------------------------------- |
| **Notion**        | `/research` searches your knowledge base                  |
| **Slack**         | `/research` searches team conversations                   |
| **Figma**         | `/explore-designs`, `/design-critique`, `/figma-*` skills |
| **Omni/BigQuery** | `/opportunity-sizing`, usage-analyst queries              |
| **Circleback**    | `/research` searches meeting transcripts                  |
| **Google Drive**  | `/research` searches shared documents                     |

**No MCPs?** Gazelle still works — it'll use web search and filesystem. Some skills will be limited but most core workflows function without any MCPs.

## Refreshing Context

As your product evolves, update context files:

- `/setup --refresh` — re-run the wizard, keeping existing values as defaults
- Edit files directly — they're plain markdown
- `/persona-builder audit` — check if personas are still accurate
- Update `domain.md` when you launch new features or enter new markets

## Tips

1. **Start minimal.** You don't need to fill in every field. Gazelle works with partial context — it'll just note gaps.
2. **Use examples.** The `.example.md` files show what "good" looks like for a fictional company.
3. **Iterate.** Run `/research` on a topic, see what Gazelle gets wrong, update context files.
4. **Share context files.** If multiple team members use Gazelle, commit context files to your repo so everyone gets the same context.
