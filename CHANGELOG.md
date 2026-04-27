# Changelog

## v3.0 — April 12, 2026 (Open Source Release)

### Added

- **`/setup` skill** — Interactive wizard that configures Gazelle for any company/product. Interviews users about their company, product, users, tools, and design system, then generates context-training files. Supports `--auto` (MCP auto-detection) and `--refresh` modes.
- **Context template system** — `context-training/` files are now the customization layer. Templates with placeholders replace hardcoded company context. Example files (`*.example.md`) show a fully configured fictional company (Acme Analytics).
- **MIT License** — open source under MIT.
- **CONTRIBUTING.md** — guide for adding skills, agents, and context.
- **docs/CUSTOMIZATION.md** — deep guide on the context-training system.

### Changed

- **Removed all company-specific context** — 38 skills, 5 agents, 8 context-training files, all docs, and install script are now fully generic. Skills reference `context-training/domain.md` instead of hardcoded domain knowledge.
- **Context-training files restructured** — company-specific files replaced with templates: `domain.md`, `data-sources.md`, `design-principles.md`, and `personas-reference.md` (empty, populated by `/persona-builder`). Methodology files (evidence-thresholds, reality-check-rules, service-design-methods, voice-guide) kept and genericized.
- **Agents read from context files** — `source-researcher`, `usage-analyst`, `design-reviewer`, `synthetic-user` all reference context-training instead of hardcoded company info.
- **Install script** — added `/setup` command generation; updated messaging for generic audience.
- **README.md** — rewritten for open-source audience with quick start, architecture, and MCP setup.
- **Skill count: 37 → 38** (added `/setup`).

### Removed

- All hardcoded company context (domain, users, team names, brand colors, terminology, URLs, Jira prefixes)
- Inline domain context appendices from all skills (replaced with pointers to `context-training/domain.md`)
- Company-specific persona profiles (replaced with empty template + `/persona-builder`)
- Hardcoded analytics schema (replaced with generic `data-sources.md` template)

---

## v2.1 — April 8, 2026

### Added

- **9 Figma design skills** — complete suite for designing directly in Figma via AI. `figma-use` (foundation for all canvas ops), `figma-implement-design` (Figma → code), `figma-generate-design` (web → Figma), `figma-generate-library` (DS library builder), `figma-code-connect-components` (component mapping), `figma-create-design-system-rules`, `figma-create-new-file`, `figma-researcher`, `figma-image-downloader`. All include design system context (color tokens, typography, pre-cached component keys).
- **7 strategy & decision skills** — `idea-check` (product diagnostic with 6 forcing questions, replaces YC office-hours), `strategy-review` (strategic plan review with 4 modes, replaces plan-ceo-review), `pre-mortem` (risk assessment), `experiment-design` (A/B tests), `yes-and` (constructive expansion), `jtbd` (Jobs to Be Done), `working-backwards` (Amazon PR/FAQ).
- **`/frontend-task` awareness** — `figma-implement-design` now detects a project-local frontend-task workflow (e.g. `.ai/frontend-task/`) and defers to it for component imports, styling tokens, and testing patterns.
- **Skill chaining flow** — every skill suggests the natural next step, creating a continuous flow from idea → research → design → implementation.

### Changed

- **Skill count: 23 → 37** — README, SKILL.md orchestrator, install.sh all updated.
- **install.sh** — Claude Code command generation expanded from 10 to 37 skills.
- **Orchestrator routing** — now handles Figma, strategy, and idea validation skills.
- **Architecture section** — lists all 37 skill directories.

---

## v2.0 — April 3, 2026

### Added

- **4 simplified entry points** — `/gazelle research`, `design`, `prototype`, `meeting`. Routes to the right sub-skill automatically.
- **Role-based onboarding** — `/quick-start` with 5 paths: Designer, PM, Engineer, Sales, Leadership. Uses real teammate examples.
- **Inline domain context** — all 20 skills carry domain + design context as appendices. Works in Cowork without external files.
- **`when_to_use` on 20 skills** — critical for auto-invocation. Start with "Use when..." and include trigger phrases.
- **`allowed-tools` on 8 skills** — security restrictions (read-only skills can't write files).
- **`effort` levels on 8 skills** — high for complex (research, explore-designs), low for simple (insights, design-spec).
- **Agent enhancements** — all 5 agents now have specific model + tools frontmatter.
- **Gazelle safety hook** — PreToolUse hook warns when editing context-training or state files.
- **SKILL-REFERENCE.md** — complete guide to all frontmatter fields (verified from Claude Code source).
- **AI convergence warning** — added to the voice/style guide: "AI systems optimize toward distribution means."
- **Design Thinking enhancement** — explore-designs step 4a now includes Purpose, Differentiation, Tradeoff prompts.

### Changed

- **5 skill renames** — `discovery-research` → `research`, `discovery-insights` → `insights`, `design-exploration` → `explore-designs`, `prototype-from-live` → `prototype`, `synthesis-toolkit` → `create-deliverable`.
- **README** — expanded commands table from 10 to 23 skills, grouped by phase.
- **install.sh** — now copies hooks alongside skills and agents.
- **Checkpoint** — added Errors & Corrections + Learnings sections.
- **Skillify template** — added when_to_use, arguments, allowed-tools, per-step annotations.
- All cross-references updated across 23+ files.

### Research

- 10 colleague profiles from Slack/Circleback/Notion → 5 user segments
- Claude Code source analysis: 19 findings, 23 takeaways from 1,907 TS files
- AI Trust Patterns: 5 patterns mapped from Claude Code architecture
- CORRECTED: CLAUDE.md budget is 40K not 4K (Session Memory is the 12K system)

---

## v1.4 — February 2026

### Changed

- **Naming: removed `gazelle-` prefix** — skills and agents renamed for company-wide rollout (clearer for non–product-design users).
  - Skills: `gazelle-research` → `research`, `gazelle-insights` → `insights`, `gazelle-persona` → `persona-builder`, `gazelle-journey` → `journey-mapping`, `gazelle-flow-capture` → `flow-capture`, `gazelle-spec` → `design-spec`, `gazelle-critique` → `design-critique`. Orchestrator remains `gazelle`.
  - Agents: `gazelle-analyst` → `usage-analyst`, `gazelle-design-reviewer` → `design-reviewer`, `gazelle-source-researcher` → `source-researcher`, `gazelle-synthetic-user` → `synthetic-user`.
  - Claude Code commands: `/research`, `/discover`, `/design-critique`, etc. (see README).
- Installer globs and command list updated. Main gazelle SKILL.md command table and Discovery Sprint Protocol paths updated.
- README, ROLLOUT.md updated. See [docs/ROLLOUT.md](docs/ROLLOUT.md) for rollout checklist.

---

## v1.3 — March 2026

### Changed

- **No more duplicate commands/skills** — commands removed from Cursor and Cowork. Skills are the interface in both. Commands remain for Claude Code only (terminal needs explicit `/` entry points).
- Cowork `.zip` no longer includes `commands/` directory.
- Cursor installer no longer generates command wrappers.

---

## v1.2 — March 2026

### Added

- **Cowork plugin support** — `--cowork` flag packages gazelle as a `.zip` file for Claude Cowork (Desktop app). Includes `.claude-plugin/plugin.json` manifest and `.mcp.json` with default MCP server declarations.
- **`--all` flag** — install for Cursor + Claude Code + Cowork in one command.
- **`commands/` directory** — Cowork-compatible command files in the repo (used by Cowork plugin; Cursor/Claude Code commands are still generated by the installer).
- **Browser environment detection** in flow-capture skill — auto-detects Cursor, Claude Code, or Cowork browser tools.

---

## v1.1 — March 2026

### Changed

- **Installer: symlink mode (`--link`)** — symlinks skills/agents/context-training instead of copying. Updates land automatically via `git pull`. Command wrappers are still generated (not symlinked).
- **Fix module numbering in domain template** — corrected stale references in `domain.md`, `voice-guide.md`, `gazelle-source-researcher.md`, `gazelle-analyst.md`.
- **README: update instructions** — new section explaining symlink vs copy update flow.

---

## v1.0 — March 2026

Initial release.

### Skills (8)

- `gazelle` — orchestrator + discovery sprint protocol
- `gazelle-research` — multi-source research w/ evidence ledger
- `gazelle-insights` — synthesize research → insights + HMW questions
- `gazelle-persona` — build, refresh, or test data-grounded personas
- `gazelle-journey` — map user journey from data
- `gazelle-flow-capture` — navigate live app, screenshot + document flow
- `gazelle-spec` — write design spec from accumulated state
- `gazelle-critique` — review design against your project's design principles

### Subagents (4)

- `gazelle-analyst` — BigQuery usage analysis via Omni MCP
- `gazelle-source-researcher` — single-source deep search (parallel instances)
- `gazelle-synthetic-user` — persona-based UI/flow/copy testing
- `gazelle-design-reviewer` — design critique against principles + tokens

### Context Training (8)

- `domain.md` — company, products, users, key terms
- `design-principles.md` — design philosophy + decision matrix
- `voice-guide.md` — voice + vocabulary guide
- `personas-reference.md` — 5 data-grounded personas w/ BigQuery validation
- `reality-check-rules.md` — evidence ledger format + anti-pattern detection
- `evidence-thresholds.md` — how much evidence is "enough" per decision type
- `service-design-methods.md` — prescriptive method selection
- `data-sources.md` — BigQuery schema, Notion boards, Slack channels, Figma

### Infrastructure

- Dual-IDE installer (`install.sh`) — Cursor + Claude Code support
- Auto-generated command wrappers per IDE
- Redacted context-training for safe sharing (PII, pricing, infra IDs removed)
- Copy-based distribution (no symlinks)

### Tested With

- Multi-feature discovery sprint (full pipeline)
- User expectations research on a key feature
- Feature flow capture + design review
