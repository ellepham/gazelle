# Gazelle Skill Reference

> Complete guide to creating and configuring Gazelle skills.
> Based on Claude Code's official skill system (verified from source).

---

## SKILL.md Frontmatter Fields

All fields are optional. Skills work without any frontmatter.

### Required for Gazelle skills

| Field         | Type   | Description                                                        |
| ------------- | ------ | ------------------------------------------------------------------ |
| `name`        | String | Skill identifier. Used in `/skill-name` commands.                  |
| `description` | String | What the skill does. Keep under 250 chars (truncated in listings). |

### Recommended

| Field           | Type         | Description                                                                             |
| --------------- | ------------ | --------------------------------------------------------------------------------------- |
| `when_to_use`   | String       | **CRITICAL for auto-invocation.** Start with "Use when..." and include trigger phrases. |
| `argument-hint` | String       | Shows expected arguments. Format: `"[topic] [--flag]"`                                  |
| `model`         | String       | `opus` (complex), `sonnet` (default), `haiku` (lightweight). Omit for sonnet.           |
| `allowed-tools` | String/Array | Restrict tools. Example: `Read, Grep, Glob, Write, Edit` or `Bash(git:*)`               |

### Optional

| Field                      | Type         | Default | Description                                                                                   |
| -------------------------- | ------------ | ------- | --------------------------------------------------------------------------------------------- |
| `context`                  | String       | —       | Set to `"fork"` for isolated execution with own token budget. Good for heavy research skills. |
| `arguments`                | String/Array | —       | Named argument definitions. Enables `$name` substitution in body.                             |
| `effort`                   | String       | —       | `low`, `medium`, `high`, `max`. Only works on Opus 4.6 + Sonnet 4.6.                          |
| `disable-model-invocation` | Boolean      | `false` | If true, only user can invoke (not auto-triggered).                                           |
| `user-invocable`           | Boolean      | `true`  | If false, skill doesn't appear in /help.                                                      |
| `paths`                    | String/Array | —       | Gitignore-style patterns. Skill only loads when matching files touched.                       |
| `hooks`                    | Object       | —       | Attach event hooks to the skill.                                                              |
| `shell`                    | String       | `bash`  | Shell for inline execution. `bash` or `powershell`.                                           |
| `version`                  | String       | —       | Skill version number.                                                                         |

---

## Argument Substitution

| Pattern                          | Resolves to                                   |
| -------------------------------- | --------------------------------------------- |
| `$ARGUMENTS`                     | Full raw arguments string                     |
| `$ARGUMENTS[0]`, `$ARGUMENTS[1]` | Indexed arguments                             |
| `$0`, `$1`                       | Shorthand for indexed                         |
| `$name`                          | Named argument (from `arguments` frontmatter) |
| `${CLAUDE_SKILL_DIR}`            | Absolute path to skill's directory            |
| `${CLAUDE_PLUGIN_ROOT}`          | Absolute path to plugin root                  |

If no placeholders found and args provided, `ARGUMENTS: {args}` is appended automatically.

---

## Inline Shell Execution

Execute shell commands at skill invocation time:

**Inline:** `` !`git branch --show-current` ``

**Block:**

````
```!
date -u +%Y-%m-%dT%H:%M:%SZ
```
````

Shell commands run through the same permission system as BashTool. Useful for injecting dynamic context (current date, branch name, file listings).

---

## Skill Loading

### Priority Order (highest to lowest)

1. **Managed** (`/etc/claude-code/.claude/skills/`)
2. **User** (`~/.claude/skills/`)
3. **Project** (`.claude/skills/`)
4. **Additional dirs** (from `--add-dir`)
5. **Legacy commands** (`.claude/commands/` — deprecated)
6. **Bundled** (built into Claude Code)
7. **MCP** (from connected MCP servers)
8. **Dynamic** (activated by `paths` matching)
9. **Plugin** (from installed plugins)

### Conditional Activation

Skills with `paths` field start unloaded. When a file matching any pattern is touched, the skill activates for the rest of the session.

```yaml
paths: ["src/styles/**", "*.css.ts"] # Only loads when styling files touched
```

Uses gitignore-style matching (via `ignore` library).

---

## Context Budget

- **Skill descriptions use 1% of context window** (~40K chars for Opus 4.6)
- Only `name` + `description` + `when_to_use` count toward this budget
- Full skill content is lazy-loaded (only when invoked)
- Per-entry hard cap: 250 characters for description in listings
- Bundled skills are never truncated

---

## Fork Execution

Set `context: "fork"` for skills that:

- Generate lots of tool output (research across 5+ sources)
- Don't need mid-run user interaction
- Could clutter the parent conversation's context

Fork benefits:

- Inherits parent's full conversation context
- Shares parent's prompt cache (~90% token discount)
- Isolated token budget (can use full context window)
- Results returned as a summary notification

Fork rules:

- Don't set `model` on a fork (breaks cache sharing)
- Don't read the fork's output file mid-flight
- Don't fabricate or predict fork results

---

## Best Practices (from Anthropic's patterns)

1. **`when_to_use` is the most important field** — it determines when Claude auto-suggests your skill
2. **Start with minimal frontmatter** — add fields only when needed
3. **Use `allowed-tools` to restrict** — "be as restrictive as possible"
4. **Bash patterns** — use `Bash(git:*)` not just `Bash` for safety
5. **Success criteria on every step** — helps the model know when to move on
6. **Per-step annotations** — Execution mode, Artifacts, Human checkpoints, Rules
7. **Keep descriptions under 250 chars** — longer gets truncated in skill listings
8. **Fork heavy research skills** — keeps parent context clean
9. **Use `haiku` for lightweight skills** — faster, cheaper
10. **Use `opus` for complex reasoning** — design exploration, verification

---

## Template

````yaml
---
name: my-skill
description: "One-line description under 250 chars"
when_to_use: "Use when [trigger]. Examples: 'phrase 1', 'phrase 2'"
argument-hint: "[topic] [--flag]"
allowed-tools: Read, Grep, Glob, Write, Edit
---

# My Skill

Description of what this skill does.

## Usage

\```
/my-skill [topic] [--flag]
\```

## Protocol

### 1. Load Context

Read relevant files before starting.

**Success criteria:** Context loaded, constraints identified.

### 2. Core Action

Steps to execute.

**Success criteria:** Output meets quality standards.

### 3. Save Output

Where to save results.

**Success criteria:** File saved, user informed.
````
