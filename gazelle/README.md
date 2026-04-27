# Gazelle Toolkit

Product design & service design agent. Runs discovery sprints, researches across your connected data sources (Notion, Slack, analytics, Figma), builds data-grounded personas, maps user journeys, writes specs, and critiques designs — with honest confidence ratings throughout.

Works in **Cursor**, **Claude Code**, and **Claude Cowork**.

**Rolling out company-wide?** See [docs/ROLLOUT.md](../docs/ROLLOUT.md) for checklist and naming notes.

---

## Prerequisites

- **Cursor** (latest) with Max Mode enabled (for subagent model inheritance), and/or
- **Claude Code** (latest), and/or
- **Claude Cowork** (Claude Desktop app, Max/Team/Enterprise plan)
- At least **Notion + Slack + Circleback MCPs** configured (see MCP Setup below)

---

## Install

```bash
git clone git@github.com:your-org/gazelle-toolkit.git
cd gazelle-toolkit

# Install for Cursor + Claude Code (copy mode — default)
./install.sh --target /path/to/your/workspace

# Install with symlinks (recommended — auto-updates via git pull)
./install.sh --link --target /path/to/your/workspace

# Or just one target
./install.sh --link --cursor --target /path/to/workspace
./install.sh --link --claude --target /path/to/workspace

# Package as Cowork plugin (then upload gazelle.zip in Cowork)
./install.sh --cowork

# All 3 targets at once
./install.sh --all --link --target /path/to/workspace

# Use custom context-training files from a local path
./install.sh --link --full /path/to/custom/context-training --target /path/to/workspace
```

The installer:

- **Copy mode** (default): copies files into your workspace
- **Symlink mode** (`--link`): symlinks to the repo — updates land automatically via `git pull`
- **Cowork mode** (`--cowork`): packages everything into `gazelle.zip` for drag-and-drop install
- Generates command wrappers for Claude Code only (Cursor/Cowork use skills directly)
- Creates project state directory
- Prints MCP checklist

**We recommend `--link`** for Cursor/Claude Code so you get updates without re-running the installer.

---

## Update

How you update depends on how you installed:

### Symlink mode (`--link`) — recommended

```bash
cd gazelle-toolkit
git pull
```

That's it. Skills, agents, and context-training update automatically since they're symlinked. If you use Claude Code and a new command was added, re-run the installer to generate its wrapper:

```bash
./install.sh --link --target /path/to/your/workspace
```

### Copy mode (default)

```bash
cd gazelle-toolkit
git pull
./install.sh --force --target /path/to/your/workspace
```

`--force` overwrites existing files with the latest versions.

### Cowork

```bash
cd gazelle-toolkit
git pull
./install.sh --cowork --force
```

1. **Delete the old plugin** in Cowork first (Customize → Gazelle → `...` menu → Delete)
2. Drag the new `gazelle.zip` into a Cowork session (or Customize → Personal plugins → + → Upload)
3. Go to **Customize → Connectors** and click **Install** on each connector (one-time OAuth per connector)

> **Tip:** You can click the **Customize** button on the plugin to have Cowork help you set up connectors and explore available skills.

---

## Quick Start

**First time?** Run `/setup` to configure Gazelle for your company, then `/quick-start` for a guided tour.

**4 entry points** — don't need to know which specific skill to use:

```
/gazelle research "onboarding drop-off"          # Research any topic
/gazelle design "AI recommendation engine"      # Design spec + Figma concepts
/gazelle prototype "dashboard overview"         # HTML prototype from live app
/gazelle meeting [circleback-link]              # Structured meeting summary
```

**Or use skills directly:**

```
/research "onboarding drop-off"                 # Multi-source research
/insights onboarding                            # Synthesize findings
/competitive-analysis "CompetitorX"             # Competitive intelligence
/create-deliverable topic --type one-pager      # Stakeholder 1-pager
/discover "AI recommendation engine"            # Full discovery sprint
```

Each command saves state to `projects/gazelle-agent/.state/projects/{topic}/`. Subsequent commands pick up where the last one left off.

---

## Commands (Claude Code only)

> In Cursor and Cowork, skills are auto-discovered — just mention the skill name or ask naturally. Commands are only needed in Claude Code's terminal where `/` is the explicit entry point.

| Command                                               | What                                                  | Time      |
| ----------------------------------------------------- | ----------------------------------------------------- | --------- |
| **Entry Points**                                      |                                                       |           |
| `/gazelle research [topic]`                           | Research any topic across internal data               | 15-60 min |
| `/gazelle design [feature]`                           | Design spec + hi-fi Figma concepts                    | 30-60 min |
| `/gazelle prototype [feature]`                        | HTML prototype from live app                          | 15-30 min |
| `/gazelle meeting [link]`                             | Structured meeting summary                            | 10-20 min |
| **Research & Analysis**                               |                                                       |           |
| `/research [topic]`                                   | Multi-source research w/ evidence ledger              | 15-30 min |
| `/insights [topic]`                                   | Synthesize research → insights + HMW                  | 10 min    |
| `/competitive-analysis [competitor]`                  | Competitive intelligence                              | 20-60 min |
| `/opportunity-sizing [opportunity]`                   | Evidence-backed opportunity scoring                   | 15-30 min |
| `/feedback-synthesizer [topic]`                       | Feedback synthesis + trends                           | 15-30 min |
| **Design & Prototyping**                              |                                                       |           |
| `/explore-designs [feature]`                          | 2-3 hi-fi Figma concepts from spec                    | 30-60 min |
| `/design-spec [feature]`                              | Design spec from research state                       | 20-40 min |
| `/design-critique [design]`                           | Review against your design principles                 | 10-20 min |
| `/wireframe [feature]`                                | Wireframes in Figma/Pencil                            | 20-40 min |
| `/prototype [feature]`                                | HTML prototype from live app                          | 15-30 min |
| **Figma Design Tools**                                |                                                       |           |
| `/figma-use`                                          | Direct Figma canvas ops (frames, colors, auto-layout) | varies    |
| `/figma-implement-design [url]`                       | Translate Figma design → production code              | 20-60 min |
| `/figma-generate-design [url]`                        | Capture web page → recreate in Figma                  | 15-30 min |
| `/figma-generate-library`                             | Build/update DS libraries in Figma                    | 30-60 min |
| `/figma-code-connect-components`                      | Map Figma components → codebase                       | 15-30 min |
| `/figma-create-design-system-rules`                   | Generate project-specific DS rules                    | 10-20 min |
| `/figma-create-new-file`                              | Create new Figma file                                 | 2 min     |
| `/figma-researcher [url]`                             | Extract design specs + tokens from Figma              | 10-20 min |
| `/figma-image-downloader [url]`                       | Download Figma frames as PNG/PDF                      | 5 min     |
| **Strategy & Decision-Making**                        |                                                       |           |
| `/idea-check [idea]`                                  | Product diagnostic — 6 forcing questions              | 15-30 min |
| `/strategy-review [plan]`                             | Strategic plan review (4 modes)                       | 15-30 min |
| `/pre-mortem [feature]`                               | Risk assessment before launch                         | 10-20 min |
| `/experiment-design [hypothesis]`                     | A/B test design + sample size                         | 10-20 min |
| `/yes-and [idea]`                                     | Constructive idea expansion                           | 10-15 min |
| `/jtbd [product/feature]`                             | Jobs to Be Done analysis                              | 10-20 min |
| `/working-backwards [idea]`                           | Amazon-style PR/FAQ                                   | 15-30 min |
| **People & Journeys**                                 |                                                       |           |
| `/persona-builder build\|test`                        | Data-grounded personas                                | 15-20 min |
| `/journey-mapping [flow]`                             | User journey from data                                | 15 min    |
| `/flow-capture [flow]`                                | Screenshot + document live flow                       | 10-20 min |
| **Deliverables**                                      |                                                       |           |
| `/create-deliverable [topic]`                         | Voice cards, debates, 1-pagers                        | 10-30 min |
| `/acceptance-criteria [feature]`                      | Hills ACs + QA checklist                              | 10-20 min |
| `/skillify [workflow]`                                | Turn a workflow into a reusable skill                 | 15-30 min |
| **Full Sprint**                                       |                                                       |           |
| `/discover [topic]`                                   | Full discovery sprint                                 | 1-2 hrs   |
| **Setup**                                             |                                                       |           |
| `/setup`                                              | Configure Gazelle for your company                    | 5-10 min  |
| `/quick-start`                                        | Role-based onboarding                                 | 2 min     |
| `/setup-cursor` / `/setup-cowork` / `/setup-code-cli` | IDE-specific setup                                    | 5 min     |

### Flags

Most commands accept:

- `--quick` / `--deep` — control search depth
- `--sources notion,slack` — limit which sources to search

`/discover` also accepts:

- `--skip [phase]` — resume from a later phase
- `--until [phase]` — stop early
- `--capture` — include browser flow capture

---

## Architecture

```
gazelle-toolkit/
├── skills/                          # 38 skills (portable across all targets)
│   ├── gazelle/                     # Orchestrator + discovery sprint protocol
│   ├── research/                    # Multi-source research
│   ├── insights/                    # Research synthesis
│   ├── competitive-analysis/        # Competitive intelligence
│   ├── opportunity-sizing/          # Opportunity scoring
│   ├── feedback-synthesizer/        # Feedback trends
│   ├── persona-builder/             # Data-grounded personas
│   ├── journey-mapping/             # User journey maps
│   ├── flow-capture/                # Screenshot live flows
│   ├── explore-designs/             # Hi-fi Figma concepts
│   ├── design-spec/                 # Design specifications
│   ├── design-critique/             # Design review
│   ├── wireframe/                   # Wireframes
│   ├── prototype/                   # HTML prototypes
│   ├── figma-use/                   # Direct Figma canvas ops (foundation)
│   ├── figma-implement-design/      # Figma → code
│   ├── figma-generate-design/       # Web → Figma
│   ├── figma-generate-library/      # DS library builder
│   ├── figma-code-connect-components/ # Component mapping
│   ├── figma-create-design-system-rules/ # DS rules generator
│   ├── figma-create-new-file/       # New Figma files
│   ├── figma-researcher/            # Extract Figma specs
│   ├── figma-image-downloader/      # Export Figma frames
│   ├── idea-check/                  # Product diagnostic (6 forcing questions)
│   ├── strategy-review/             # Strategic plan review
│   ├── pre-mortem/                  # Risk assessment
│   ├── experiment-design/           # A/B test design
│   ├── yes-and/                     # Constructive expansion
│   ├── jtbd/                        # Jobs to Be Done
│   ├── working-backwards/           # Amazon PR/FAQ
│   ├── create-deliverable/          # Stakeholder deliverables
│   ├── acceptance-criteria/         # ACs + QA checklist
│   ├── skillify/                    # Workflow → skill converter
│   ├── quick-start/                 # Role-based onboarding
│   ├── setup-code-cli/              # Claude Code setup
│   ├── setup-cursor/                # Cursor setup
│   └── setup-cowork/                # Cowork setup
├── agents/              # Subagents (delegated tasks)
│   ├── usage-analyst.md          # Product analytics analysis
│   ├── source-researcher.md     # Single-source deep search
│   ├── synthetic-user.md        # Persona-based testing
│   └── design-reviewer.md       # Design critique vs principles
├── commands/            # Claude Code command wrappers (generated by installer)
├── context-training/    # Domain knowledge loaded by skills
│   ├── domain.md
│   ├── design-principles.md
│   ├── voice-guide.md
│   ├── personas-reference.md
│   ├── reality-check-rules.md
│   ├── evidence-thresholds.md
│   ├── service-design-methods.md
│   └── data-sources.md
├── .claude-plugin/      # Cowork plugin manifest
│   └── plugin.json
└── install.sh           # Multi-target installer
# Note: .mcp.json lives at repo root (not in gazelle/) — reference for Claude Code MCP setup
```

### How Subagents Work

When you run `/research`, the orchestrator launches **parallel subagents** — one per data source (Notion, Slack, Drive, filesystem). Each subagent searches independently, then results are merged with source diversity checks.

The `usage-analyst` subagent runs analytics queries via Omni MCP (or your analytics tool) to validate qualitative findings with quantitative data.

The `synthetic-user` subagent role-plays as a data-grounded persona to test designs, flows, and copy.

---

## MCP Setup

Gazelle uses MCPs (Model Context Protocol) to access internal data. Here's how to set up each one.

### Required: Notion

Gazelle searches Notion for user feedback, product docs, roadmaps, and interview notes.

**Cursor:** Install the Notion MCP plugin from Cursor settings → MCP.

**Claude Code:** Add to `.claude/settings.yml`:

```yaml
mcpServers:
  notion:
    command: npx
    args: ["-y", "@modelcontextprotocol/server-notion"]
    env:
      NOTION_API_KEY: "${NOTION_API_KEY}"
```

You'll need a Notion integration token. Create one at [notion.so/my-integrations](https://www.notion.so/my-integrations) and share relevant databases with it.

### Required: Slack

Gazelle searches Slack for customer feedback, product discussions, and CS signals.

**Cursor:** Install the Slack MCP plugin from Cursor settings → MCP.

**Claude Code:** Add to `.claude/settings.yml`:

```yaml
mcpServers:
  slack:
    command: npx
    args: ["-y", "@anthropic/mcp-slack"]
    env:
      SLACK_BOT_TOKEN: "${SLACK_BOT_TOKEN}"
```

You'll need a Slack Bot token with `search:read`, `channels:read`, `channels:history` scopes.

### Required: Circleback

Searches meeting transcripts for customer quotes and context. Used by discovery research and source-researcher.

**Cursor:** Install the Circleback MCP plugin from Cursor settings → MCP.

**Claude Code:** Follow Circleback MCP setup instructions (add to `mcpServers` in `.claude/settings.yml`).

### Recommended: Omni (BigQuery)

Powers the `usage-analyst` subagent for quantitative validation — feature adoption, user segmentation, event analysis.

**Cursor:** Install the Omni MCP plugin from Cursor settings → MCP.

**Claude Code:** Follow Omni MCP setup instructions from your BI team.

**Using Omni REST API (resapi) with a bearer token instead of Omni MCP**

If you use Omni’s REST API (e.g. for direct query control) with a Bearer token, **never put the token in the repo or in the plugin**. Store it per channel as follows:

| Channel         | Secure storage                                                                                                                                                                                 |
| --------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **Cursor**      | Set `OMNI_API_KEY` (or `OMNI_BEARER_TOKEN`) in your shell profile or in Cursor’s MCP config env for the Omni/custom MCP. Token is not in any tracked file.                                     |
| **Claude Code** | Set `OMNI_API_KEY` in your shell or in a **gitignored** `.env` file; reference it in `.claude/settings.yml` as `env: OMNI_API_KEY: "${OMNI_API_KEY}"` for the MCP or script that calls resapi. |
| **Cowork**      | No way to inject a bearer token into org plugins today. Use the **Omni MCP** (OAuth) in Cowork; reserve resapi + bearer for Cursor / Claude Code.                                              |

Use an **Org API Key** or **Personal Access Token** from [Omni auth docs](https://docs.omni.co/api/authentication); send it as `Authorization: Bearer <token>` on each request. One token per env, no per-request login.

Powers design review in `/design-critique`. Fetches design specs, screenshots, and component structure.

**Cursor:** Install the Figma MCP plugin from Cursor settings → MCP.

**Claude Code:** Add to `.claude/settings.yml`:

```yaml
mcpServers:
  figma:
    command: npx
    args: ["-y", "@anthropic/mcp-figma"]
    env:
      FIGMA_ACCESS_TOKEN: "${FIGMA_ACCESS_TOKEN}"
```

### Recommended: Pencil

Powers wireframing and design exploration using `.pen` files.

**Cursor:** Install the Pencil MCP plugin from Cursor settings → MCP.

**Claude Code:** Follow Pencil MCP setup instructions.

### Optional: Google Drive

Enriches research with meeting notes, presentations, and customer docs.

**Cursor:** Install the Google Drive MCP plugin.

**Claude Code:** Add to `.claude/settings.yml`:

```yaml
mcpServers:
  google-drive:
    command: npx
    args: ["-y", "@anthropic/mcp-google-drive"]
    env:
      GOOGLE_CLIENT_ID: "${GOOGLE_CLIENT_ID}"
      GOOGLE_CLIENT_SECRET: "${GOOGLE_CLIENT_SECRET}"
```

### Optional: Browser (Flow Capture)

Required for `/flow-capture` which screenshots the live app.

**Cursor:** Uses `cursor-ide-browser` (built-in, no setup needed).

**Claude Code:** Uses Playwright MCP:

```yaml
mcpServers:
  playwright:
    command: npx
    args: ["-y", "@anthropic/mcp-playwright"]
```

### MCP Dependency Matrix

| MCP             | Commands That Use It                              | Priority     |
| --------------- | ------------------------------------------------- | ------------ |
| Notion          | research, insights, personas, journey             | **Required** |
| Slack           | research, insights, personas                      | **Required** |
| Circleback      | research (meeting transcripts), source-researcher | **Required** |
| Omni (BigQuery) | analyst subagent, persona validation              | Recommended  |
| Figma           | critique, design review                           | Recommended  |
| Pencil          | critique (wireframes), design review              | Recommended  |
| Browser         | flow-capture                                      | Optional     |
| Google Drive    | research (enrichment)                             | Optional     |

---

## For Engineers

### Extending Gazelle

**Add a new skill:**

1. Create `skills/your-skill/SKILL.md` with frontmatter (`name`, `description`)
2. Run `./install.sh --force` to redistribute

**Add a new subagent:**

1. Create `agents/your-agent.md` with frontmatter (`name`, `description`, `model`)
2. Set `model: inherit` to use the parent agent's model (or `fast` for speed)
3. Run `./install.sh --force`

**Add context-training:**

1. Add `.md` file to `context-training/`
2. Reference it in the skill that needs it
3. Run `./install.sh --force`

### Analytics Access

Gazelle uses your analytics tool for quantitative validation. The `usage-analyst` subagent runs queries via Omni MCP (or your analytics tool's MCP). Key tables and event schemas are documented in `context-training/data-sources.md`.

To set up: configure your analytics MCP connection and document your data schema in `context-training/data-sources.md`.

### State Files

Each Gazelle project creates state in `projects/gazelle-agent/.state/projects/{name}/`:

```
context.md        # Who, what, why
research.md       # Raw findings + source links
insights.md       # Synthesized insights + confidence
personas.md       # Data-grounded persona cards
flow-analysis.md  # Visual flow capture + per-screen analysis
screenshots/      # Numbered PNGs from flow capture
journey-map.md    # Current-state journey + metrics
spec.md           # Design specification
*.pen             # Wireframes (Pencil MCP)
session-log.md    # What happened, when
```

State files are per-user, not committed to the repo. The `.state/` directory is gitignored.

---

## Target Differences

| Feature            | Cursor                             | Claude Code                        | Cowork                              |
| ------------------ | ---------------------------------- | ---------------------------------- | ----------------------------------- |
| Install method     | `install.sh --cursor`              | `install.sh --claude`              | `install.sh --cowork` → `.zip` file |
| Interface          | Skills only (auto-discovered)      | Commands + skills                  | Skills only (auto-discovered)       |
| Subagent model     | Requires Max Mode                  | Works by default                   | Uses session model                  |
| Browser automation | cursor-ide-browser (built-in)      | Playwright MCP                     | Chrome extension (built-in)         |
| MCP configuration  | UI plugins                         | `.claude/settings.yml`             | `.mcp.json` in plugin               |
| Update method      | `git pull` (symlink) or re-install | `git pull` (symlink) or re-install | Re-package + re-upload `.zip`       |

### Known Limitations

- **Cursor Max Mode:** Subagents may default to a weaker model if Max Mode is not enabled. Enable it in Cursor settings.
- **Flow capture:** Each target uses different browser tools — the flow-capture skill auto-detects the environment.
- **Cowork:** Plugin is local-only for now. Org-wide plugin sharing is coming from Anthropic.
- **Context-training setup:** Run `/setup` to configure context-training files for your org. Without setup, skills will still work but won't have product-specific context.

---

## Feedback

Found a bug? Have an idea? Two ways to share:

1. **GitHub:** Open an issue on this repo
2. **Discussions:** Start a discussion for feature ideas and questions

---

## Version

Current: **v2.0** (April 2026) — Open source release

See [CHANGELOG.md](../CHANGELOG.md) for version history.
