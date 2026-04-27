# Gazelle Architecture

How skills, agents, state, and context work together.

---

## Skill System

Every Gazelle capability is a **skill** — a markdown file (`SKILL.md`) that tells the AI how to perform a specific task.

### Skill Structure

```
gazelle/skills/research/
  SKILL.md          # The skill definition
```

Some skills have additional reference files:

```
gazelle/skills/figma-use/
  SKILL.md
  references/
    api-reference.md
    common-patterns.md
    component-patterns.md
```

### SKILL.md Anatomy

Every skill has YAML frontmatter + a protocol body:

```yaml
---
name: research
description: "Multi-source research with evidence ledger..."
when_to_use: "Use when investigating a topic..."
effort: high
argument-hint: "[topic] [--quick] [--deep]"
context: "fork"           # Optional: run in isolated subprocess
allowed-tools: Read, Grep, Glob, Write, WebSearch
---

# Discovery Research

**Voice:** Casual, direct, honest...

## Protocol

### 1. Load Context
Read context-training/domain.md...

### 2. Do the Work
...

### 3. Save Output
Save to: projects/gazelle-agent/.state/projects/{topic}/research.md
```

### Key Frontmatter Fields

| Field           | Purpose                                                            | Example                       |
| --------------- | ------------------------------------------------------------------ | ----------------------------- |
| `name`          | Skill identifier                                                   | `research`                    |
| `description`   | What it does + trigger phrases (used for auto-invocation)          | `"Multi-source research..."`  |
| `when_to_use`   | When the AI should suggest this skill                              | `"Use when investigating..."` |
| `effort`        | Reasoning depth hint                                               | `low`, `medium`, `high`       |
| `argument-hint` | What arguments it accepts                                          | `"[topic] [--quick]"`         |
| `context`       | `"fork"` runs in isolated subprocess (no mid-run user interaction) | `"fork"`                      |
| `allowed-tools` | Security boundary — which tools the skill can use                  | `Read, Grep, Write`           |

### How Skills Are Discovered

- **Claude Code:** Skills are installed to `.claude/skills/`. Commands (`.claude/commands/`) are thin wrappers that point to skills.
- **Cursor:** Skills are installed to `.cursor/skills/`. Auto-discovered by name or natural language.
- **Cowork:** Skills are packaged in the `.zip` plugin. Auto-discovered.

---

## State Management

Skills save their output to a shared state directory. This is how skills chain — each reads the previous skill's output.

### State Directory

```
projects/gazelle-agent/.state/projects/{topic}/
  context.md          # Who, what, why (set by first skill)
  research.md         # Raw findings + source links
  insights.md         # Synthesized insights + confidence
  personas.md         # Data-grounded persona cards
  flow-analysis.md    # Visual flow capture + per-screen analysis
  screenshots/        # Numbered PNGs from flow capture
  journey-map.md      # Current-state journey + metrics
  spec.md             # Design specification
  pre-mortem.md       # Risk assessment
  experiment-plan.md  # A/B test design
  jtbd.md             # Jobs to Be Done analysis
  competitive.md      # Competitive analysis
  session-log.md      # What happened, when
```

### How Chaining Works

1. You run `/research "onboarding"` — saves to `.state/projects/onboarding/research.md`
2. You run `/insights "onboarding"` — reads `research.md`, saves `insights.md`
3. You run `/design-spec "onboarding"` — reads `research.md` + `insights.md`, saves `spec.md`
4. You run `/explore-designs "onboarding"` — reads `spec.md`, generates Figma concepts

Each skill checks for existing state before starting. If state exists, it resumes from where the last skill left off. If not, it starts fresh.

### State is Per-User

The `.state/` directory is gitignored. Each team member has their own state. This means two people can research the same topic independently without conflicts.

---

## Subagents

Skills can spawn **subagents** — focused sub-processes that handle a specific task and return results.

### Available Agents

| Agent               | File                          | Purpose                                   | Spawned by                                        |
| ------------------- | ----------------------------- | ----------------------------------------- | ------------------------------------------------- |
| `source-researcher` | `agents/source-researcher.md` | Search ONE data source thoroughly         | `/research` (launched in parallel — one per tool) |
| `usage-analyst`     | `agents/usage-analyst.md`     | Query analytics tool for metrics          | `/opportunity-sizing`, `/measure`                 |
| `design-reviewer`   | `agents/design-reviewer.md`   | Review designs against principles         | `/design-critique`                                |
| `synthetic-user`    | `agents/synthetic-user.md`    | Role-play as a persona for testing        | `/persona-builder test`                           |
| `verifier`          | `agents/verifier.md`          | Read-only verification of implementations | Post-implementation QA                            |

### How Parallel Research Works

When `/research` runs, it launches up to 5 source-researcher agents simultaneously:

```
/research "onboarding drop-off"
  ├── source-researcher → Notion (searches specs, feedback, decisions)
  ├── source-researcher → Slack (searches team conversations)
  ├── source-researcher → Circleback (searches meeting transcripts)
  ├── source-researcher → Google Drive (searches shared docs)
  └── source-researcher → Filesystem (searches local project files)
```

Each agent returns structured findings. The orchestrator merges them, deduplicates, checks source diversity (catches echo chamber bias), and produces the final evidence ledger.

### Agent Anatomy

Agents use the same frontmatter format as skills, plus agent-specific fields:

```yaml
---
name: source-researcher
description: "Searches ONE data source thoroughly..."
tools: Read, Glob, Grep, WebFetch, WebSearch
maxTurns: 30
readonly: true
---
```

Key agent fields:

- `tools` — which tools the agent can use
- `maxTurns` — safety limit on how many tool calls
- `readonly` — if true, agent cannot edit files

---

## Context-Training System

Context-training files are the customization layer — they tell every skill about your company, product, and tools.

### Files

```
context-training/
  domain.md              # Your company, product, users, terminology
  data-sources.md        # Connected tools and where to search
  design-principles.md   # Design system, brand, principles
  personas-reference.md  # User personas (populated by /persona-builder)
  evidence-thresholds.md # Confidence criteria (methodology — don't edit)
  reality-check-rules.md # Anti-pattern detection (methodology — don't edit)
  service-design-methods.md  # Design thinking reference (methodology — don't edit)
  voice-guide.md         # Gazelle's communication style (methodology — don't edit)
```

### How Skills Load Context

Every skill's protocol starts with a "Load Context" step:

```markdown
### 1. Load Context

Read these before starting:

- context-training/domain.md — your company, product, users
- context-training/data-sources.md — where to search
- context-training/evidence-thresholds.md — confidence criteria
```

The skill reads these files at the start of every run. This means you can update context files and every subsequent skill run picks up the changes — no reinstall needed.

### Template vs Methodology Files

**Template files** (4) — generated by `/setup`, customized per company:

- `domain.md`, `data-sources.md`, `design-principles.md`, `personas-reference.md`

**Methodology files** (4) — universal, work for any company:

- `evidence-thresholds.md`, `reality-check-rules.md`, `service-design-methods.md`, `voice-guide.md`

---

## Skill Chaining Flow

Skills suggest the natural next step, creating a directed workflow:

```
/idea-check → /research → /insights → /persona-builder → /journey-mapping
    ↓              ↓           ↓              ↓                  ↓
/strategy-review  /competitive-analysis  /design-spec → /explore-designs → /figma-use
                                              ↓                                  ↓
                                    /acceptance-criteria          /figma-implement-design
                                              ↓                          ↓
                                        /pre-mortem              /design-critique
                                              ↓
                                    /create-deliverable
```

You can enter at any point. You can skip steps. You can jump ahead. The state system handles it — skills use what's available and flag what's missing.

---

## Installation Targets

The installer (`install.sh`) copies skills, agents, and context to the right locations for each IDE:

| Component | Claude Code                                | Cursor                | Cowork                |
| --------- | ------------------------------------------ | --------------------- | --------------------- |
| Skills    | `.claude/skills/`                          | `.cursor/skills/`     | In `.zip` plugin      |
| Agents    | `.claude/agents/`                          | `.cursor/agents/`     | In `.zip` plugin      |
| Commands  | `.claude/commands/` (generated)            | N/A (auto-discovered) | N/A                   |
| Context   | `projects/gazelle-agent/context-training/` | Same                  | In `.zip` references/ |
| State     | `projects/gazelle-agent/.state/`           | Same                  | Session-scoped        |
| Hooks     | `.claude/hooks/`                           | `.cursor/hooks/`      | In `.zip` plugin      |

---

## Adding Your Own Skills

1. Create `gazelle/skills/your-skill/SKILL.md`
2. Add YAML frontmatter (`name`, `description`, `when_to_use`)
3. Write a protocol that reads context-training files and saves to `.state/projects/`
4. Run `./install.sh --force` to redistribute

See [CONTRIBUTING.md](../CONTRIBUTING.md) for the full guide.
