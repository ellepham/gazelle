---
name: setup-cursor
description: "First-time Gazelle setup in Cursor: install via install.sh, configure MCPs (Notion, Slack, Figma, etc.), and how to update. Use when someone asks how to set up Gazelle in Cursor."
allowed-tools: Read, Bash, Glob, Write, Edit
---

# Setup Gazelle in Cursor

Step-by-step first-time setup for Gazelle in Cursor. Connectors/MCPs are configured per user in Cursor settings.

## 1. Install Gazelle

From your workspace root (or where you want Gazelle state to live):

```bash
git clone git@github.com:your-org/gazelle-toolkit.git
cd gazelle-toolkit
./install.sh --link --cursor --target /path/to/your/workspace
```

Use your actual workspace path for `--target`. **Symlink mode (`--link`)** means updates apply after `git pull`; no need to re-run the installer for skill changes.

## 2. Configure MCPs (one-time per machine)

Gazelle needs MCPs to access Notion, Slack, Figma, etc. In **Cursor**:

1. Open **Settings → MCP** (or Cursor Settings → Features → MCP).
2. Install and configure each connector you need:
   - **Notion** (required) — install Notion MCP; add Notion integration token from [notion.so/my-integrations](https://www.notion.so/my-integrations); share relevant DBs with the integration.
   - **Slack** (required) — install Slack MCP; use a Slack Bot token with `search:read`, `channels:read`, `channels:history`.
   - **Circleback** (required) — install Circleback MCP for meeting transcript search.
   - **Figma** (recommended for design critique) — install Figma MCP; add Figma access token.
   - **Omni / BigQuery** (recommended for usage analyst) — install Omni MCP; follow BI team instructions. To use **Omni REST API (resapi)** with a bearer token instead: set `OMNI_API_KEY` in your environment (Cursor MCP env or shell); never put the token in the repo. See README “Omni (BigQuery)” for per-channel details.
   - **Google Drive**, **Pencil** — optional; install if you use those sources.

Full MCP details (tokens, scopes, env vars): see the repo [README MCP Setup](https://github.com/your-org/gazelle-toolkit/blob/main/gazelle/README.md#mcp-setup).

## 3. Enable Max Mode (recommended)

For subagent model inheritance (e.g. usage-analyst, source-researcher), enable **Max Mode** in Cursor settings so Gazelle’s subagents use a capable model.

## 4. Update Gazelle

If you used `--link`:

```bash
cd gazelle-toolkit
git pull
```

Skills and agents update automatically. If new Claude Code commands were added and you also use Claude Code, re-run the installer once to regenerate command wrappers.

If you used copy mode (no `--link`):

```bash
cd gazelle-toolkit
git pull
./install.sh --force --cursor --target /path/to/your/workspace
```

## Role-Specific MCP Priority

Not everyone needs every MCP. Suggest based on role:

| Role         | Must-have MCPs            | Recommended            | Optional         |
| ------------ | ------------------------- | ---------------------- | ---------------- |
| **Designer** | Notion, Slack, Figma      | Circleback, Pencil     | Omni             |
| **PM**       | Notion, Slack, Circleback | Omni (BigQuery), Figma | Google Drive     |
| **Engineer** | Slack                     | Notion, Figma          | Circleback, Omni |
| **CS**       | Slack, Notion, Circleback | —                      | Figma            |

Ask: "what's your role?" and tailor MCP setup order accordingly.

## Cross-Tool Setup

If the user also uses Claude Code or Cowork:

- MCP tokens (Notion, Slack) are the same across tools — reuse env vars
- Claude Code stores MCP config in `.claude/settings.yml`; Cursor uses Settings UI
- Cowork uses OAuth connectors (no manual tokens)
- Recommend: "if you also use Claude Code, run `/setup-code-cli` there too — same tokens, different config file"

## Offer Next Steps

> "setup complete! try `/quick-start` to get oriented, or `/gazelle` to see all commands."

---

**Quick ref:** Repo [README](https://github.com/your-org/gazelle-toolkit/blob/main/gazelle/README.md) — Install, MCP Setup, Target Differences.
