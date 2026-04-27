# Gazelle

**AI-powered product design agent.** Run structured discovery sprints, research across your team's tools, build data-grounded personas, map user journeys, write design specs, generate Figma concepts, and critique designs — all from your terminal.

Gazelle is a toolkit of **38 skills** and **5 subagents** that plug into [Claude Code](https://docs.anthropic.com/en/docs/claude-code), [Cursor](https://cursor.sh), and [Claude Cowork](https://claude.ai). It brings design thinking methodology to AI-assisted product development with honest confidence ratings, evidence-based recommendations, and no hallucinated user research.

---

## Why Gazelle

Most AI tools generate content. Gazelle generates _evidence_.

- **Research with receipts.** Every finding cites its source — a Slack thread, a Notion page, an analytics query, a meeting transcript. No fabricated user quotes.
- **Honest about gaps.** Every output includes what we know, what we're missing, and what we're assuming. Confidence ratings (HIGH/MEDIUM/LOW) on every claim.
- **Your tools, your data.** Connects to Notion, Slack, Figma, BigQuery/analytics, Circleback, Google Drive via MCP. Searches where your team actually works.
- **Design thinking, not vibes.** Structured methodology — JTBD analysis, pre-mortems, experiment design, working-backwards PR/FAQs. Not "brainstorm 10 ideas."
- **Works for any company.** Run `/setup` once to configure Gazelle for your product, users, and tools. No hardcoded assumptions.

---

## What You Can Do

| You say...                              | Gazelle does...                                                                                                         |
| --------------------------------------- | ----------------------------------------------------------------------------------------------------------------------- |
| `/research "onboarding drop-off"`       | Searches Notion, Slack, analytics, Drive, Circleback. Returns evidence ledger with confidence ratings and source links. |
| `/persona-builder build`                | Combines analytics patterns + qualitative data to create personas with cited attributes, not fictional archetypes.      |
| `/design-spec "AI recommendations"`     | Writes a design spec grounded in your research state — user stories, requirements, edge cases, accessibility.           |
| `/explore-designs "dashboard redesign"` | Generates 2-3 distinct hi-fi design concepts in Figma, each with a different layout approach using your DS components.  |
| `/pre-mortem "Q3 launch"`               | Tigers (real risks), Paper Tigers (overblown fears), Elephants (things nobody wants to say). With mitigations.          |
| `/competitive-analysis "CompetitorX"`   | Internal signals + external research into a structured comparison matrix.                                               |
| `/experiment-design "new pricing page"` | Hypothesis, metrics, sample size, duration, guardrails, readout template.                                               |
| `/working-backwards "AI assistant"`     | Amazon-style PR/FAQ that pressure-tests whether the idea is worth building.                                             |

**38 skills total** across research, design, strategy, personas, journeys, prototyping, and Figma integration.

---

## Quick Start

### 1. Install

```bash
git clone https://github.com/ellepham/gazelle.git
cd gazelle

# Install for Claude Code (recommended)
./install.sh --claude --target /path/to/your/workspace

# Or for Cursor
./install.sh --cursor --target /path/to/your/workspace

# Or symlink mode (auto-updates via git pull)
./install.sh --link --claude --target /path/to/your/workspace
```

### 2. Configure for your company

```
/setup
```

Gazelle asks about your company, product, users, tools, and design system. Takes ~5 minutes. Generates context files that every skill reads automatically.

### 3. Try it

```
/research "your first topic"
```

---

## How It Works

Gazelle uses **context-training files** as its customization layer — plain markdown that describes your company to every skill:

```
context-training/
  domain.md              # Your company, product, users, terminology
  data-sources.md        # Your connected tools and data
  design-principles.md   # Your design system and brand
  personas-reference.md  # User personas (built by /persona-builder)
```

The `/setup` skill generates these by interviewing you. Or edit them by hand — they're just markdown.

Skills chain naturally: `/research` suggests `/insights`, which suggests `/persona-builder`, which feeds into `/design-spec`, which feeds into `/explore-designs`. Each saves state, and the next picks up where you left off.

### Subagents

When you run `/research`, Gazelle launches parallel **source-researcher** agents — one per connected tool (Notion, Slack, Drive, filesystem). Results merge with source diversity checks. The **usage-analyst** agent queries your analytics tool. The **synthetic-user** agent role-plays as your personas to test designs.

---

## MCP Connections

Gazelle searches your team's actual tools via [MCP](https://modelcontextprotocol.io/):

| MCP                 | What it enables                               | Required?         |
| ------------------- | --------------------------------------------- | ----------------- |
| **Notion**          | Search knowledge base, specs, meeting notes   | Recommended       |
| **Slack**           | Search team conversations, customer feedback  | Recommended       |
| **Figma**           | Design exploration, critique, code generation | For design skills |
| **BigQuery / Omni** | Usage analytics, persona validation           | For data skills   |
| **Circleback**      | Meeting transcript search                     | Optional          |
| **Google Drive**    | Document search                               | Optional          |

**No MCPs connected?** Gazelle still works — it uses web search and your filesystem. You just get richer results with more tools connected.

---

## All 38 Skills

<details>
<summary><strong>Research & Analysis</strong></summary>

| Skill                   | What it does                                      |
| ----------------------- | ------------------------------------------------- |
| `/research`             | Multi-source research with evidence ledger        |
| `/insights`             | Synthesize findings into insights + HMW questions |
| `/competitive-analysis` | Structured competitive intelligence               |
| `/opportunity-sizing`   | Evidence-backed opportunity scoring               |
| `/feedback-synthesizer` | Periodic feedback synthesis + trends              |
| `/measure`              | Post-launch metrics vs predictions                |

</details>

<details>
<summary><strong>Design & Prototyping</strong></summary>

| Skill              | What it does                                   |
| ------------------ | ---------------------------------------------- |
| `/design-spec`     | Design spec from research state                |
| `/explore-designs` | 2-3 hi-fi Figma concepts from spec             |
| `/design-critique` | Review against your design principles          |
| `/wireframe`       | Wireframes in Figma or Pencil                  |
| `/prototype`       | Standalone HTML prototype                      |
| `/diverge`         | Force 5+ different solutions before converging |

</details>

<details>
<summary><strong>Figma Integration</strong></summary>

| Skill                               | What it does                       |
| ----------------------------------- | ---------------------------------- |
| `/figma-use`                        | Direct Figma canvas operations     |
| `/figma-implement-design`           | Figma design to production code    |
| `/figma-generate-design`            | Web page to Figma recreation       |
| `/figma-generate-library`           | Build/update DS libraries in Figma |
| `/figma-code-connect-components`    | Map Figma components to codebase   |
| `/figma-create-design-system-rules` | Generate project-specific DS rules |
| `/figma-researcher`                 | Extract design specs + tokens      |
| `/figma-image-downloader`           | Export Figma frames as PNG/PDF     |
| `/figma-create-new-file`            | Create new Figma files             |

</details>

<details>
<summary><strong>Strategy & Decision-Making</strong></summary>

| Skill                | What it does                                        |
| -------------------- | --------------------------------------------------- |
| `/idea-check`        | Product diagnostic — 6 forcing questions            |
| `/jtbd`              | Jobs to Be Done (functional + social + emotional)   |
| `/working-backwards` | Amazon-style PR/FAQ                                 |
| `/pre-mortem`        | Risk assessment (Tigers / Paper Tigers / Elephants) |
| `/experiment-design` | A/B test design with sample size calculations       |
| `/yes-and`           | Constructive idea expansion                         |
| `/strategy-review`   | Strategic plan review (4 modes)                     |

</details>

<details>
<summary><strong>People & Journeys</strong></summary>

| Skill              | What it does                                 |
| ------------------ | -------------------------------------------- |
| `/persona-builder` | Data-grounded personas from your tools       |
| `/journey-mapping` | User journey maps with metrics + pain points |
| `/flow-capture`    | Screenshot + document live user flows        |

</details>

<details>
<summary><strong>Deliverables</strong></summary>

| Skill                  | What it does                                      |
| ---------------------- | ------------------------------------------------- |
| `/create-deliverable`  | Voice cards, debates, decision matrices, 1-pagers |
| `/acceptance-criteria` | Hills-format ACs + Given/When/Then + QA checklist |
| `/skillify`            | Turn a workflow into a reusable skill             |

</details>

<details>
<summary><strong>Setup</strong></summary>

| Skill          | What it does                       |
| -------------- | ---------------------------------- |
| `/setup`       | Configure Gazelle for your company |
| `/quick-start` | Role-based onboarding tour         |

</details>

---

## How Gazelle Compares

Gazelle is not a general-purpose agent framework. It's a **domain-specific toolkit for product design work**.

|                     | Gazelle                                                                 | CrewAI / AutoGen / LangChain                              |
| ------------------- | ----------------------------------------------------------------------- | --------------------------------------------------------- |
| **Focus**           | Product design methodology (research, personas, specs, design critique) | General-purpose agent orchestration                       |
| **Output**          | Evidence-grounded design artifacts with confidence ratings              | Varies — depends on what you build                        |
| **Setup**           | `./install.sh` + `/setup` — working in 5 minutes                        | Write agent definitions, chains, and prompts from scratch |
| **Data sources**    | Searches your existing tools (Notion, Slack, Figma, analytics) via MCP  | You build the integrations                                |
| **Methodology**     | Built-in design thinking (JTBD, pre-mortems, journey mapping, etc.)     | No built-in domain methodology                            |
| **Honest gaps**     | Every output flags what's missing and what confidence level             | You add this yourself                                     |
| **Requires coding** | No — it's markdown skills, not Python                                   | Yes — Python/TypeScript                                   |

**Use Gazelle when** you're a product or design team that wants structured discovery, not a developer building a custom agent from scratch.

---

## Platforms

|               | Claude Code             | Cursor                   | Cowork                   |
| ------------- | ----------------------- | ------------------------ | ------------------------ |
| **Install**   | `./install.sh --claude` | `./install.sh --cursor`  | `./install.sh --cowork`  |
| **Interface** | `/commands`             | Skills (auto-discovered) | Skills (auto-discovered) |
| **Subagents** | Built-in                | Requires Max Mode        | Uses session model       |
| **Browser**   | Playwright MCP          | Built-in                 | Chrome extension         |

---

## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md) for how to add skills, agents, and context.

**Add a new skill:** Create `gazelle/skills/your-skill/SKILL.md` with YAML frontmatter + protocol. That's it.

---

## Documentation

- **[Getting Started](GETTING-STARTED.md)** — 5-minute quickstart guide
- **[Examples](examples/)** — detailed walkthroughs with example output
- **[Architecture](docs/ARCHITECTURE.md)** — how the skill system works
- **[Customization](docs/CUSTOMIZATION.md)** — how to configure for your org
- **[Full plugin docs](gazelle/README.md)** — all skills, agents, MCP setup
- **[Deployment](docs/ROLLOUT.md)** — rolling out to a team
- **[Contributing](CONTRIBUTING.md)** — how to add skills and agents
- **[Changelog](CHANGELOG.md)** — version history

---

## License

MIT — see [LICENSE](LICENSE).

---

Built by [@ellepham](https://github.com/ellepham). Designed for product teams who want AI that's honest about what it knows and what it doesn't.
