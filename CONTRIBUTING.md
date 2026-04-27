# Contributing to Gazelle

Thanks for your interest in contributing to Gazelle! This document explains how the project is structured and how to add your own skills, agents, or context.

## Project Structure

```
gazelle-toolkit/
├── gazelle/
│   ├── skills/          # Skill definitions (SKILL.md files)
│   ├── agents/          # Subagent definitions
│   ├── hooks/           # Safety hooks
│   └── README.md        # Plugin documentation
├── context-training/    # Domain knowledge files (customizable per org)
├── install.sh           # Multi-target installer
└── docs/                # Additional documentation
```

## Adding a New Skill

1. Create a directory: `gazelle/skills/your-skill-name/`
2. Create `SKILL.md` with this frontmatter:

```yaml
---
name: your-skill-name
description: "What it does. Include trigger phrases for auto-suggestion."
when_to_use: "When to invoke it. Examples: 'do this', 'do that'"
effort: medium
argument-hint: "[arguments]"
---
```

3. Write the skill protocol in the body. Follow existing skills as examples.
4. Reference context-training files for company-specific data:
   - `context-training/domain.md` — company, product, users
   - `context-training/data-sources.md` — tools and data sources
   - `context-training/design-principles.md` — design system
   - `context-training/personas-reference.md` — user personas

### Skill Guidelines

- **Voice section:** Include the Gazelle voice anchor at the top
- **Load Context step:** Always start by reading relevant context-training files
- **State management:** Save outputs to `projects/gazelle-agent/.state/projects/{topic}/`
- **Next steps:** End with suggestions for what skill to run next
- **Evidence quality:** Include confidence assessments in outputs
- **Domain-agnostic:** Don't hardcode company-specific content — read it from context-training

## Adding a New Agent

Agents are subprocesses that skills spawn for focused tasks. Create a markdown file in `gazelle/agents/` with:

```yaml
---
name: agent-name
description: "What it does and when to use it."
tools: Read, Glob, Grep # Available tools
maxTurns: 20
readonly: true # Most agents should be read-only
---
```

## Customizing Context

The `context-training/` directory contains your organization's domain knowledge. These files are the primary customization layer:

| File                    | What it contains                            |
| ----------------------- | ------------------------------------------- |
| `domain.md`             | Company, product, users, terminology        |
| `data-sources.md`       | Connected tools and data locations          |
| `design-principles.md`  | Design system, brand, principles            |
| `personas-reference.md` | User personas (built by `/persona-builder`) |

Run `/setup` to generate these interactively, or edit them manually.

See `docs/CUSTOMIZATION.md` for a deep guide.

## Code Style

- Skills are written in Markdown with YAML frontmatter
- Keep the voice casual, direct, and honest
- Always cite sources in research outputs
- Flag gaps and uncertainty explicitly
- Include confidence ratings (HIGH/MEDIUM/LOW) in analytical outputs

## Pull Requests

1. Fork the repo
2. Create a branch: `git checkout -b feature/your-skill`
3. Make your changes
4. Test by installing locally: `./install.sh --claude --target /path/to/test`
5. Open a PR with a description of what the skill does and when to use it

## Questions?

Open an issue on GitHub. We're happy to help!
