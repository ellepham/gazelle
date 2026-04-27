---
name: setup-cowork
description: "First-time Gazelle setup in Claude Cowork: what Gazelle does, example tasks, connect connectors (one-time OAuth per user), and how to update. Use when someone asks how to set up Gazelle in Cowork or what they can do with it."
allowed-tools: Read, Bash, Glob, Write, Edit
---

# Welcome to Gazelle

Gazelle is your product and service design agent. It researches across your internal tools — Notion, Slack, Figma, meeting transcripts — and turns that into design decisions: personas, journey maps, specs, and design critiques. All grounded in real data, with honest confidence ratings when evidence is thin.

## What you can do

**Research a topic**

> "Research how our customers use the bulk screening feature"
> "What do we know about Module 2 adoption from Slack and Notion?"

**Synthesize insights**

> "What are the biggest pain points in the complaint handling workflow?"
> "Summarize what we know about user onboarding and give me HMW questions"

**Build or refresh personas**

> "Build a persona for the Regulatory Affairs Manager role"
> "Update our CRA persona with anything new from the last 3 months"

**Map a user journey**

> "Map the current-state journey for submitting a report in the main module"

**Write a design spec**

> "Write a design spec for the AI-assisted literature search feature"

**Critique a design**

> "Critique this Figma design against our design principles" _(paste Figma link)_

**Run a full discovery sprint**

> "Do a full discovery sprint on bulk screening adoption" _(chains research → insights → personas → journey map → spec)_

---

## First-time setup: connect your data sources

Gazelle reads from the tools you connect. This is a one-time step per user.

1. Open **Customize** (gear icon on the Gazelle plugin card)
2. Go to **Connectors**
3. Click **Install** or **Connect** on each source you need:
   - **Notion** — product docs, roadmaps, interview notes
   - **Slack** — customer signals, team discussions
   - **Circleback** — meeting transcripts, customer conversations
   - **Figma** — design files and specs
   - **Google Drive** — meeting notes, presentations
   - **Atlassian** — Jira tickets, Confluence pages
   - **Gmail**, **Google Calendar** — optional but useful

Omni/BigQuery (if available in your org): use the Omni connector — OAuth only. Bearer-token REST API (resapi) is not supported in Cowork; use Cursor or Claude Code for that.

Each connector requires a one-time OAuth login in the browser. The org can't pre-authorize these since tokens are per-user.

**Tip:** Click **Customize** on the plugin card and Cowork will walk you through connector setup interactively.

### Role-Specific Connector Priority

| Role         | Must-connect              | Recommended       | Optional                |
| ------------ | ------------------------- | ----------------- | ----------------------- |
| **Designer** | Notion, Slack, Figma      | Circleback        | Google Drive            |
| **PM**       | Notion, Slack, Circleback | Figma             | Google Drive, Atlassian |
| **Engineer** | Slack                     | Notion, Atlassian | Figma, Circleback       |
| **CS**       | Slack, Notion, Circleback | —                 | Figma                   |

### Cross-Tool Notes

If you also use Cursor or Claude Code:

- Cowork uses OAuth connectors (automatic) — no manual tokens to manage
- Cursor and Claude Code need manual MCP setup with tokens — run `/setup-cursor` or `/setup-code-cli` there
- Gazelle state (`.state/projects/`) is local to each environment — they don't share state automatically

---

## Updates

Gazelle updates automatically when org admins sync the plugin (Organization settings → Plugins → Update). You don't need to do anything.

## Offer Next Steps

> "setup complete! try `/quick-start` to get oriented, or `/gazelle` to see all commands."
