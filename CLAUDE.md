# Gazelle Toolkit — Context for Claude Code

Product design & service design agent toolkit. Discovery sprints, multi-source research, data-grounded personas, journey mapping, specs, design critique. Honest confidence ratings throughout.

**Targets:** Cursor, Claude Code, Claude Cowork. Single repo; `install.sh` builds for all three.

---

## Read First

| Doc                                            | Use for                                      |
| ---------------------------------------------- | -------------------------------------------- |
| [README.md](README.md)                         | Quick start, installation, what Gazelle does |
| [gazelle/README.md](gazelle/README.md)         | Full docs: skills, agents, architecture      |
| [docs/CUSTOMIZATION.md](docs/CUSTOMIZATION.md) | How to configure Gazelle for your company    |
| [CONTRIBUTING.md](CONTRIBUTING.md)             | How to add skills, agents, context           |

---

## Layout

```
gazelle-toolkit/
├── gazelle/                 # Plugin root (skills, agents, manifest)
│   ├── skills/              # 38 skills (research, persona-builder, setup, etc.)
│   ├── agents/              # 5 subagents (source-researcher, usage-analyst, etc.)
│   └── README.md            # Full plugin doc
├── context-training/        # Domain knowledge (customizable per org)
│   ├── domain.md            # Your company, product, users, terms
│   ├── data-sources.md      # Your connected tools and data
│   ├── design-principles.md # Your design system and brand
│   ├── personas-reference.md # User personas (built by /persona-builder)
│   ├── *.example.md         # Example files for reference
│   └── (methodology files)  # evidence-thresholds, reality-check, etc.
├── install.sh               # Installer: --cursor, --claude, --cowork
├── docs/                    # Additional documentation
└── LICENSE                  # MIT
```

**State (per user):** `projects/gazelle-agent/.state/projects/{topic}/` — research, insights, personas, journey-map, spec, etc.

---

## First-Time Setup

1. Install: `./install.sh --claude --target /path/to/workspace`
2. Run `/setup` to configure Gazelle for your company
3. Try `/research [topic]` or `/quick-start`

---

## Key Commands

- `/setup` — configure Gazelle for your company (generates context-training files)
- `/gazelle` — hub: show commands + projects
- `/research [topic]` — multi-source research with evidence ledger
- `/insights [topic]` — synthesize research into insights + HMW questions
- `/persona-builder`, `/journey-mapping`, `/design-spec`, `/design-critique`
- `/quick-start` — guided tour of all skills for your role

---

## Conventions

- **Voice:** Casual, direct, honest. Cite sources; flag gaps; coach, don't audit.
- **MCPs:** Notion + Slack recommended; Figma, analytics, Drive optional. See `context-training/data-sources.md`.
- **Context:** All company-specific knowledge lives in `context-training/` files.
