---
name: quick-start
description: "Guided onboarding for first-time Gazelle users. Asks your role, shows what to try first based on common team workflows. Use when someone new wants to try Gazelle."
when_to_use: "Use when someone new wants to try Gazelle or needs onboarding. Examples: 'how do I use Gazelle', 'first time with Gazelle', 'onboard me', 'what can Gazelle do'"
argument-hint: "[--role designer/pm/engineer/sales/leadership]"
allowed-tools: Read, Glob
---

# Quick Start

**Voice:** Casual, direct, honest, welcoming. Assume the person is smart but unfamiliar with design thinking vocabulary.

## Usage

```
/quick-start
/quick-start --role engineer
/quick-start --role pm
/quick-start --role designer
/quick-start --role sales
/quick-start --role leadership
```

## Protocol

### 1. Determine Role

If `--role` not specified, ask:

> "hey! what's your role on the team? this helps me show you the most relevant skills."
>
> 1. **Designer** — i design features in Figma, run user research, do critiques
> 2. **PM** — i prioritize features, do discovery, present to stakeholders
> 3. **Engineer** — i build features and want context on what i'm building
> 4. **Sales** — i talk to customers, prep for meetings, do competitive research
> 5. **Leadership** — i set direction, need data for strategy decisions

### 2. Role-Specific Guide

#### For Designers

> **what gazelle does for you:** explores multiple design directions in Figma using real DS components, critiques designs against your design principles, and runs synthetic user testing — all from a short prompt.
>
> **try this now:**
>
> ```
> /explore-designs [feature you're working on] --concepts 2
> ```
>
> this generates 2 hi-fi design concepts in Figma from your design spec. each uses a different page layout (table+sidebar vs full-width dashboard vs wizard). real DS components, not drawings.
>
> **prerequisites:** you need a spec first. if you don't have one:
>
> ```
> /research [your feature] --quick
> /design-spec [your feature]
> ```
>
> **after exploration:**
>
> - `/design-critique` — review against your design principles (using "I like / I don't get / I wonder if" format)
> - `/persona-builder --test` — test your design with a synthetic user persona
> - `/wireframe [feature]` — create wireframes in Figma or Pencil
>
> **what you DON'T need to:** run competitive analysis or opportunity sizing. those are PM skills.
>
> **tip:** the `use_figma` MCP tool directly creates and edits elements natively in Figma with the full context of the design system. if Figma MCP isn't connected, `/setup-cursor` or `/setup-code-cli` to configure it.

#### For PMs

> **what gazelle does for you:** runs multi-source research across all internal data (Slack, Notion, Circleback meetings, analytics usage data) in parallel, then synthesizes into decision-ready artifacts. the kind of research that takes you a full day — done in 30 minutes.
>
> **try this now:**
>
> ```
> /research [topic you're investigating] --quick
> ```
>
> searches 3-5 internal sources for signal. you'll get evidence from multiple sources with links, unique voice counts (not just message counts), and confidence ratings.
>
> **common PM workflows:**
>
> 1. **"i need to prioritize opportunities"**
>    ```
>    /opportunity-sizing [opportunity]
>    ```
>    analytics user counts + demand signals + evidence-backed scoring
> 2. **"i need to present findings to leadership"**
>    ```
>    /create-deliverable [topic] --type one-pager --for [stakeholder-name]
>    ```
>    generates a 1-pager tailored to the stakeholder
> 3. **"i need to compare us vs a competitor"**
>    ```
>    /competitive-analysis [competitor]
>    ```
>    internal signals + external research → comparison matrix
> 4. **"i need a design spec from research"**
>    ```
>    /research [topic] --deep
>    ```
>    then: `/insights` → `/design-spec` → `/acceptance-criteria`
>
> **tip:** competitive research that used to take an hour of finding and structuring key links — `/competitive-analysis` automates exactly that workflow.

#### For Engineers

> **what gazelle does for you:** pulls user context from Slack, Notion, Circleback, and analytics so you understand WHO uses what you're building and WHY, without reading 50 Slack threads yourself.
>
> **try this now:**
>
> ```
> /research [the feature you're working on] --quick
> ```
>
> searches Notion feedback board + Slack product channels + local project files for what users have said about your feature.
>
> **what you'll get:**
>
> - evidence table: who said what, when, where (with links)
> - key findings: patterns across sources
> - confidence ratings: how strong the evidence is
>
> **after research:**
>
> - `/acceptance-criteria [feature]` — generate testable ACs from findings
> - `/create-deliverable [topic] --type one-pager --for [pm-name]` — create a 1-pager to align with your PM
>
> **for power users:** gazelle is extensible. each skill is a SKILL.md file — you can read, fork, or contribute new skills. check `gazelle/skills/` in the repo. if you want to extend gazelle with new data sources, the `source-researcher` subagent pattern is a good starting point.
>
> **tip:** you DON'T need to run personas, journey maps, or design critique. those are optional phases for deeper discovery work.

#### For Sales

> **what gazelle does for you:** competitive intelligence, meeting prep, and customer profiling. the stuff you're already doing manually with Claude — but with access to all of your team's internal data (Slack, Notion, Circleback meeting transcripts, analytics).
>
> **try this now:**
>
> ```
> /competitive-analysis [competitor name]
> ```
>
> this pulls internal signals (Slack mentions, lost deals, CS feedback) + external research → structured comparison matrix. exactly the kind of work that "kills the first hour of finding and structuring key links."
>
> **other things you can do:**
>
> 1. **meeting prep / summary:**
>    tell gazelle to summarize a meeting — it reads the Circleback transcript and extracts action items, decisions, and follow-ups in a structured format.
> 2. **customer persona for marketing:**
>    ```
>    /persona-builder build --module [your-module]
>    ```
>    builds a data-grounded persona from real usage data + meeting transcripts — great for ensuring marketing copy matches how customers actually talk.
> 3. **feedback patterns:**
>    ```
>    /feedback-synthesizer [topic]
>    ```
>    clusters recent customer feedback by theme — shows trends over time.
>
> **works in Cowork too!** you don't need Cursor or Claude Code. these skills work in Claude Cowork with the Notion + Slack connectors. ask `/setup-cowork` if you need help setting up.
>
> **tip:** "you have to think of AI agents like a person. you have to train them and spend time — it's almost like you're a leader of real people." start with one skill, get good at it, then expand.

#### For Leadership

> **what gazelle does for you:** data-rich research and persona building for strategic decisions. turn a question into structured evidence from across your team's internal data — Slack, Notion, Circleback (meeting transcripts), analytics usage data.
>
> **try this now:**
>
> ```
> /research [strategic question] --deep
> ```
>
> example: `/research "how could AI disrupt our core module"` — searches all internal sources, finds what customers and the team have said, identifies gaps in our knowledge.
>
> **your top use cases:**
>
> 1. **data-rich personas for product discovery:**
>    ```
>    /persona-builder build --module [your-module]
>    ```
>    builds personas from real analytics usage patterns + Circleback interview data + Notion feedback.
> 2. **weekly competitive monitoring:**
>    ```
>    /competitive-analysis [competitor]
>    ```
>    internal signals + external research. can be run periodically to track competitive landscape.
> 3. **meeting summaries + decision logs:**
>    share a Circleback link and ask for a structured summary — gazelle extracts decisions, action items, and open questions.
> 4. **prototype a feature idea:**
>    ```
>    /prototype [feature]
>    ```
>    builds a clickable HTML prototype from your live app — looks like the real thing, not a wireframe.
>
> **getting started:** if you haven't used Claude Code before, ask your team's design or eng lead — they can do a 30-min walkthrough. or run `/setup-code-cli` for self-guided setup.

### 3. Troubleshooting

If the user hits issues:

**"MCP not connected":**

> "looks like [Notion/Slack/etc] isn't connected. run `/setup-code-cli` (Claude Code), `/setup-cursor` (Cursor), or `/setup-cowork` (Cowork) to configure."

**"No research found":**

> "gazelle skills build on each other. start w/ `/research [topic] --quick` to get evidence, then the other skills can use it."

**"Too many options":**

> "start here: `/research [your topic] --quick`. that's it. see what comes back, then decide what to do next."

### 4. Available Skills Reference

Show this if asked "what can gazelle do?":

```markdown
## Gazelle Skills (23 total)

**Start here — 4 entry points:**
| Command | What it does |
|---------|-------------|
| `/gazelle research [topic]` | Research any topic across internal data |
| `/gazelle design [feature]` | Design spec + hi-fi Figma concepts |
| `/gazelle prototype [feature]` | Clickable HTML prototype from live app |
| `/gazelle meeting [link]` | Structured meeting summary |

**All skills by phase:**
| Phase | Skill | What it does | Time |
|-------|-------|-------------|------|
| Research | `/research` | Multi-source evidence gathering | 10-60 min |
| Research | `/competitive-analysis` | Competitor intelligence | 20-60 min |
| Research | `/feedback-synthesizer` | Feedback synthesis + trends | 15-30 min |
| Synthesis | `/insights` | Research → insights + HMW questions | 15 min |
| Synthesis | `/create-deliverable` | Voice cards, debates, 1-pagers | 10-30 min |
| Sizing | `/opportunity-sizing` | Evidence-backed opportunity scoring | 15-30 min |
| People | `/persona-builder` | Data-grounded personas | 20-40 min |
| People | `/journey-mapping` | User journey from data | 20-40 min |
| Design | `/design-spec` | Design spec from research | 20-40 min |
| Design | `/explore-designs` | 2-3 hi-fi Figma concepts | 30-60 min |
| Design | `/wireframe` | Wireframes in Figma/Pencil | 20-40 min |
| Design | `/design-critique` | Review against principles | 10-20 min |
| Prototype | `/prototype` | HTML prototype from live app | 15-30 min |
| Validate | `/flow-capture` | Screenshot + document live flows | 10-20 min |
| Validate | `/acceptance-criteria` | Testable ACs from spec | 10-20 min |
| Sprint | `/discover` | Full discovery sprint | 2-4 hrs |

**Start with:** `/research [topic] --quick`
**Skip what you don't need.** No phase is mandatory.
```

---

## Appendix: Domain Context

> To customize Gazelle for your company, populate `context-training/domain.md` with your product's modules, users, key terms, competitors, and team structure. See the template in that file for the expected format.
>
> This appendix is intentionally empty in the open-source distribution. Your company-specific context lives in the context-training files, not here.
