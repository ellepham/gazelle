# Deploying Gazelle to Your Organization

## Installation Methods

### Individual Install (Claude Code / Cursor)

```bash
./install.sh --claude --target /path/to/workspace   # Claude Code
./install.sh --cursor --target /path/to/workspace    # Cursor
./install.sh --both --target /path/to/workspace      # Both
./install.sh --link --target /path/to/workspace      # Symlink mode (updates via git pull)
```

After install, each team member runs `/setup` to configure their context.

### Org-wide (Cowork Plugin Marketplace)

**Where to configure:** [Organization settings > Plugins](https://support.claude.com/en/articles/13837433-manage-cowork-plugins-for-your-organization) in Claude Desktop (the app).

**Ways to add Gazelle:**

- **Manual upload** — Organization settings > Plugins > Add plugins > Upload a file. Upload `gazelle.zip` (build with `./install.sh --cowork`).
- **GitHub sync** — Organization settings > Plugins > Add plugin > GitHub. Enter `owner/repo`. Repo must be **private or internal**; install the Cowork GitHub App.

**Requirements:** Cowork and Skills must be enabled for the org. Plugin zip must be < 50 MB.

### GitHub Sync Requirements

- Repo must be **private or internal** (public repos not allowed for org marketplaces)
- **Cowork GitHub App** must be installed on the repo
- **Marketplace catalog** at `.claude-plugin/marketplace.json` with `source: "./gazelle"`
- **`plugin.json`** — only `name`, `version`, `description`, `author` fields (no `repository` or `keywords`)
- **Skill names** cannot contain reserved words: `claude`, `cowork`, `anthropic`

If sync fails, fall back to manual upload of `gazelle.zip`.

---

## Pre-Rollout Checklist

- [ ] **Context setup** — Each team member runs `/setup` to configure for their project context
- [ ] **MCP connectors** — Each user must install connectors individually (Notion, Slack, Figma, etc.). No auto-connect.
- [ ] **Cowork upload** — Only `.zip` accepted for drag-and-drop
- [ ] **Cowork re-install** — To update, delete old plugin first (Customize > Gazelle > ... > Delete) then upload new zip
- [ ] **IDE differences** — Claude Code gets `/commands`; Cursor and Cowork use skills directly
- [ ] **State path** — Project state lives under `projects/gazelle-agent/.state/projects/`
- [ ] **Analytics** — Usage analytics queries require Omni MCP or CLI access. Many users may only have Notion + Slack — that's enough for research/insights.
- [ ] **Shared context** — Consider committing customized context-training files to your workspace repo so the whole team gets consistent context.

---

## Shared Context Strategy

For teams, you have two options for context-training files:

### Option A: Individual Setup (default)

Each team member runs `/setup`. Their context files are local to their workspace. Good for diverse teams where each person works on different products.

### Option B: Shared Context (recommended for product teams)

1. One person runs `/setup` and configures context files
2. Commit the `context-training/` files to your workspace repo
3. Other team members get the same context via `git pull`
4. Use `--full /path/to/shared/context` during install to use shared files

---

## Naming Note

Gazelle uses generic skill names: `/research`, `/insights`, `/design-critique`, etc. If your org has other skills with the same names, consider adding a prefix like `pd-` (product design) to avoid collisions.
