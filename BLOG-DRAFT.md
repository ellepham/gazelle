# What If Your Design Process Had an Agent That Actually Understood Your Product?

_Introducing Gazelle — an open-source product design agent toolkit for AI-assisted discovery._

---

We've been using AI to write code for a while now. But what about everything that happens _before_ code — the research, the user interviews, the personas, the journey maps, the design specs, the stakeholder debates?

That's where most product work actually lives. And that's where AI has been... underwhelming. Generic chatbots generate generic insights. They hallucinate user quotes. They produce specs that sound plausible but aren't grounded in anything real.

We built Gazelle because we wanted something different: an AI design agent that searches our actual tools, cites its sources, and tells us when it doesn't know something.

Today we're open-sourcing it.

## What Gazelle Does

Gazelle is a toolkit of 38 skills that plug into [Claude Code](https://docs.anthropic.com/en/docs/claude-code), Cursor, and Claude Cowork. You type commands like:

```
/research "onboarding drop-off"
/persona-builder build
/design-spec "dashboard redesign"
/competitive-analysis "CompetitorX"
/pre-mortem "Q3 launch"
```

Each skill searches your team's actual tools — Notion, Slack, Figma, your analytics platform, meeting transcripts — and produces structured output with confidence ratings and source links.

The key difference from a chatbot: **every finding cites its source**. No fabricated user quotes. No hallucinated metrics. If evidence is thin, Gazelle says so.

## Why Not CrewAI / AutoGen / LangChain?

Those are excellent general-purpose agent frameworks. If you want to build a custom agent for your specific use case in Python, they're great tools.

Gazelle is different. It's a **domain-specific toolkit for product design work**. You don't write code — you run commands. The methodology is built in: JTBD analysis, pre-mortems, experiment design, Amazon-style working-backwards PR/FAQs, journey mapping.

|                 | Gazelle                                   | General agent frameworks                      |
| --------------- | ----------------------------------------- | --------------------------------------------- |
| Setup time      | 5 minutes (install + `/setup`)            | Hours to days (write agents, chains, prompts) |
| Output          | Evidence-grounded design artifacts        | Whatever you build                            |
| Methodology     | Built-in design thinking                  | None — you design the methodology             |
| Data sources    | Auto-searches your existing tools via MCP | You build integrations                        |
| Requires coding | No                                        | Yes                                           |

Gazelle is for product teams, not developers building agents from scratch.

## How We Actually Use It

We've been using Gazelle internally for six months. Here's what actually changed our workflow:

### Research that's honest about gaps

Before Gazelle, research meant: open Notion, open Slack, search both, lose track of what came from where, present findings without confidence levels.

Now: `/research "feature X"` launches parallel agents across Notion, Slack, meeting transcripts, and analytics. Five minutes later, we get a structured evidence ledger. The best part isn't what it finds — it's how it flags gaps:

> "heads up — 3 of these 4 threads are from the same CS rep. it's really 1 signal, not 4."

> "all evidence is from enterprise customers. zero SMB signal. that's a blind spot."

That kind of honest assessment was the hardest thing to get right, and the most valuable.

### Pre-mortems that surface the unspoken

Our favorite skill is `/pre-mortem`. It classifies risks into three buckets:

- **Tigers** — real threats with real probability
- **Paper Tigers** — fears that sound scary but aren't real
- **Elephants** — risks everyone knows about but nobody wants to raise

The Elephants category is worth the entire toolkit. It consistently surfaces the organizational risks that are the actual blockers — "the PM left and nobody owns this," "we're shipping to hit a deadline, not because it's ready."

### Design specs grounded in evidence

`/design-spec` builds on whatever research you've done. Every requirement traces back to a finding. Every user story cites its evidence. The "Open Questions" section is brutally honest about what we're still guessing about.

We stopped writing specs from scratch. We run `/research` → `/insights` → `/design-spec` and get a spec where every claim has a receipt.

## Under the Hood

Gazelle is markdown all the way down. Skills are SKILL.md files with YAML frontmatter. Context about your company lives in plain text files that you can read and edit. State is saved between skills so they chain naturally.

```
/research → /insights → /persona-builder → /design-spec → /explore-designs → /design-critique
```

Each skill reads the previous one's output. No copy-pasting. No "here's what we found in the last step."

The subagent system is the most interesting architectural choice. When you run `/research`, Gazelle doesn't search sequentially — it launches one agent per data source in parallel. A Notion agent, a Slack agent, a meeting transcript agent, a filesystem agent. They all search simultaneously, then results merge with source diversity checks.

The context-training system is how Gazelle knows about your company. Run `/setup` once — it asks about your product, users, tools, design system — and generates context files that every skill reads. No hardcoded assumptions.

## Try It

```bash
git clone https://github.com/ellepham/gazelle.git
cd gazelle
./install.sh --claude --target /path/to/workspace
```

Then:

```
/setup                              # Configure for your company (3 min)
/research "any topic"               # Your first research (15 min)
/quick-start                        # Guided tour of all skills
```

It works without any MCP connections — web search + filesystem is the baseline. Connect Notion and Slack for deeper internal research.

**Full docs:** [github.com/ellepham/gazelle](https://github.com/ellepham/gazelle)

---

Gazelle is MIT licensed. It's built on Claude Code's skill system, which means it works anywhere Claude Code, Cursor, or Cowork runs. We've been using it daily for six months, and the honest confidence ratings alone changed how we make product decisions.

The best tools don't just generate — they generate with integrity. That's what we built Gazelle to do.

— Elle ([@ellepham](https://github.com/ellepham))
