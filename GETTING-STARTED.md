# Getting Started with Gazelle

Go from zero to your first research output in 5 minutes.

---

## Step 1: Install (1 minute)

```bash
git clone https://github.com/ellepham/gazelle.git
cd gazelle

# For Claude Code:
./install.sh --claude --target /path/to/your/workspace

# For Cursor:
./install.sh --cursor --target /path/to/your/workspace

# For both:
./install.sh --both --target /path/to/your/workspace
```

**Tip:** Use `--link` for symlink mode — skills auto-update when you `git pull`.

You should see output like:

```
  [skill] acceptance-criteria
  [skill] competitive-analysis
  ...
  [cmd]   research
  [cmd]   setup
  ...
  Done! Run /setup to configure Gazelle for your company, then try: /research "your topic"
```

---

## Step 2: Configure for Your Company (3 minutes)

Open Claude Code (or Cursor) in your workspace and run:

```
/setup
```

Gazelle asks ~5 questions:

1. **What's your company name?** — e.g., "Acme Analytics"
2. **What does your product do?** — one sentence is fine
3. **What industry?** — e.g., fintech, healthcare, developer tools
4. **Who are your users?** — their roles and what they care about
5. **What tools does your team use?** — Notion, Slack, Figma, BigQuery, etc.

Gazelle generates 4 context files from your answers. Every skill reads these automatically.

**No MCP connections yet?** That's fine. Skip the tools question — Gazelle works with just web search and your filesystem. You can add MCPs later.

---

## Step 3: Connect Your Tools (optional, 2 minutes per tool)

Gazelle gets richer results when it can search your team's actual tools. Each tool connects via [MCP](https://modelcontextprotocol.io/).

### Notion (recommended first)

Claude Code — add to `.claude/settings.yml`:

```yaml
mcpServers:
  notion:
    command: npx
    args: ["-y", "@modelcontextprotocol/server-notion"]
    env:
      NOTION_API_KEY: "${NOTION_API_KEY}"
```

Get your token at [notion.so/my-integrations](https://www.notion.so/my-integrations). Share your databases with the integration.

### Slack

```yaml
mcpServers:
  slack:
    command: npx
    args: ["-y", "@anthropic/mcp-slack"]
    env:
      SLACK_BOT_TOKEN: "${SLACK_BOT_TOKEN}"
```

Needs a Slack app with `search:read`, `channels:read`, `channels:history` scopes.

### Figma

```yaml
mcpServers:
  figma:
    command: npx
    args: ["-y", "@anthropic/mcp-figma"]
    env:
      FIGMA_ACCESS_TOKEN: "${FIGMA_ACCESS_TOKEN}"
```

Get your token at [figma.com/developers/api](https://www.figma.com/developers/api).

**Don't have these tools?** Gazelle still works — it just uses web search and your local files. The MCP connections make research deeper, not required.

---

## Step 4: Run Your First Research (2 minutes)

```
/research "onboarding drop-off"
```

Replace with any topic relevant to your product. Gazelle will:

1. Load your company context from the setup you just did
2. Search connected tools (Notion, Slack, etc.) — or web search if no MCPs
3. Return an evidence ledger with findings, confidence ratings, and source links

See [examples/01-research-a-topic.md](examples/01-research-a-topic.md) for a full walkthrough.

---

## Step 5: Build on Your Research

Research chains into other skills. After `/research`, try:

```
/insights "onboarding drop-off"     # Synthesize findings into actionable insights
/design-spec "onboarding redesign"  # Write a design spec grounded in evidence
/persona-builder build              # Create personas from your data
```

Each skill reads the state from the previous one. No copy-pasting needed.

---

## What to Try Next

| Goal                  | Command                               | Time      |
| --------------------- | ------------------------------------- | --------- |
| Get a guided tour     | `/quick-start`                        | 2 min     |
| Research any topic    | `/research "your topic"`              | 15-30 min |
| Write a design spec   | `/design-spec "feature"`              | 20-40 min |
| Analyze a competitor  | `/competitive-analysis "CompetitorX"` | 20-60 min |
| Test an idea          | `/idea-check "your idea"`             | 15-30 min |
| Full discovery sprint | `/discover "topic"`                   | 1-2 hrs   |

---

## Troubleshooting

**"context-training files not found"** — Run `/setup` first, or check that you installed to the right target directory.

**MCP connection errors** — Check that your API tokens are set as environment variables. Run `echo $NOTION_API_KEY` to verify.

**Empty research results** — If no MCPs are connected, Gazelle uses web search which may not find your internal data. Connect at least Notion or Slack for internal research.

**Skills not showing up** — Re-run `./install.sh --force --target /path/to/workspace` to regenerate command wrappers.

---

## Learn More

- [README.md](README.md) — full overview of all 38 skills
- [examples/](examples/) — detailed walkthroughs with example output
- [docs/CUSTOMIZATION.md](docs/CUSTOMIZATION.md) — deep guide on context configuration
- [docs/ARCHITECTURE.md](docs/ARCHITECTURE.md) — how the skill system works
- [CONTRIBUTING.md](CONTRIBUTING.md) — how to add your own skills
