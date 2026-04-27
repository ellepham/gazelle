---
name: setup-code-cli
description: "First-time Gazelle setup in Claude Code: install via install.sh, configure MCPs in .claude/settings.yml (Notion, Slack, Figma, etc.), and how to update. Use when someone asks how to set up Gazelle in Claude Code."
allowed-tools: Read, Bash, Glob, Write, Edit
---

# Setup Gazelle in Claude Code

Step-by-step first-time setup for Gazelle in Claude Code. MCPs are configured in `.claude/settings.yml` in your workspace.

## 1. Install Gazelle

From your workspace root (or where you want Gazelle state to live):

```bash
git clone git@github.com:your-org/gazelle-toolkit.git
cd gazelle-toolkit
./install.sh --link --claude --target /path/to/your/workspace
```

Use your actual workspace path for `--target`. **Symlink mode (`--link`)** means skill/agent updates apply after `git pull`; re-run the installer only if new commands are added.

## 2. Configure MCPs in .claude/settings.yml

Gazelle needs MCPs to access Notion, Slack, Figma, etc. Add entries under `mcpServers` in `.claude/settings.yml` in your workspace.

**Required — Notion:**

```yaml
mcpServers:
  notion:
    command: npx
    args: ["-y", "@modelcontextprotocol/server-notion"]
    env:
      NOTION_API_KEY: "${NOTION_API_KEY}"
```

Create a Notion integration at [notion.so/my-integrations](https://www.notion.so/my-integrations) and share relevant DBs with it.

**Required — Slack:**

```yaml
slack:
  command: npx
  args: ["-y", "@anthropic/mcp-slack"]
  env:
    SLACK_BOT_TOKEN: "${SLACK_BOT_TOKEN}"
```

Use a Slack Bot token with `search:read`, `channels:read`, `channels:history` scopes.

**Required — Circleback:** Follow Circleback MCP setup instructions and add to `mcpServers` (meeting transcript search).

**Recommended — Figma, Omni (BigQuery), Google Drive, Pencil, etc.:** See the repo [README MCP Setup](https://github.com/your-org/gazelle-toolkit/blob/main/gazelle/README.md#mcp-setup) for full YAML snippets and env vars. For **Omni REST API (resapi)** with a bearer token: set `OMNI_API_KEY` in your environment (or gitignored `.env`) and reference it in `mcpServers` env; never commit the token. Cowork: use Omni MCP (OAuth), not resapi.

Set the env vars (e.g. `NOTION_API_KEY`, `SLACK_BOT_TOKEN`) in your shell or a `.env` file that Claude Code can read.

## 3. Update Gazelle

If you used `--link`:

```bash
cd gazelle-toolkit
git pull
```

If new slash commands were added, re-run the installer once to generate their wrappers:

```bash
./install.sh --link --claude --target /path/to/your/workspace
```

If you used copy mode (no `--link`):

```bash
cd gazelle-toolkit
git pull
./install.sh --force --claude --target /path/to/your/workspace
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

If the user also uses Cursor or Cowork:

- MCP tokens (Notion, Slack) are the same across tools — reuse env vars
- Cursor stores MCP config in its Settings UI, not `.claude/settings.yml`
- Cowork uses OAuth connectors (no manual tokens)
- Recommend: "if you also use Cursor, run `/setup-cursor` there too — same tokens, different config location"

## Offer Next Steps

> "setup complete! try `/quick-start` to get oriented, or `/gazelle` to see all commands."

---

**Quick ref:** Repo [README](https://github.com/your-org/gazelle-toolkit/blob/main/gazelle/README.md) — Install, MCP Setup (full YAML), Commands, Target Differences.
