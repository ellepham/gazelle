---
name: skillify
description: "Create a new Gazelle skill from the current session. Analyzes your workflow, interviews you, and generates a complete SKILL.md with proper frontmatter, protocol, and state management."
when_to_use: "Use when capturing a repeatable workflow as a reusable skill. Examples: 'turn this into a skill', 'create a skill from this session', 'skillify this workflow'"
argument-hint: "[workflow-description]"
disable-model-invocation: true
---

# Skillify

Turn a workflow you just did into a reusable Gazelle skill. Analyzes the session, interviews you, and writes a complete SKILL.md.

**Voice:** Casual, direct, helpful. You're pair-programming a skill definition, not interrogating.

## Usage

```
/skillify
/skillify my-new-skill
```

If a name is provided, use it. Otherwise, suggest one based on the workflow analysis.

## Protocol

### 1. Analyze the Session

Scan the current conversation for:

- **Tools used** — which MCPs, subagents, file operations
- **Subagents spawned** — source-researcher, usage-analyst, design-reviewer, etc.
- **Files read/written** — context-training docs, state files, output files
- **Decision points** — where the user made choices or corrections
- **Repeatable pattern** — the trigger → context load → actions → output shape

Produce a 5-line summary:

```
WORKFLOW DETECTED:
- Trigger: [what kicked this off]
- Inputs: [what data/context was needed]
- Actions: [what tools/subagents were used]
- Outputs: [what was produced and where]
- Decisions: [key choices the user made]
```

### 2. Interview (Max 4 Rounds)

Keep it tight. Skip rounds if the answer is obvious from the session.

**Round 1 — Confirm the workflow:**

> "Here's what I see as the core workflow: [summary]. Accurate? What would you change?"

**Round 2 — Execution model:**

> "Should this skill be forked or inline? (Fork = isolated context, no mid-run questions. Inline = stays in conversation, can interact.)"
>
> Also ask: "Does it need a specific model? (opus for complex reasoning, sonnet for speed, inherit for whatever's running)"

**Round 3 — Triggers and arguments:**

> "What should trigger this skill? Give me: the `/command` name, a one-line description, and what arguments it takes (if any)."
>
> Also: "Any flags? (e.g. `--quick`, `--deep`, `--project [name]`)"

**Round 4 — Guard rails:**

> "Any edge cases or anti-patterns to document? Things like 'never do X' or 'always check Y first'?"

### 3. Generate SKILL.md

Write a complete skill file following Gazelle conventions. Use this template:

````markdown
---
name: {skill-name}
description: "{one-line description}"
when_to_use: "Use when {trigger condition}. Examples: '{trigger phrase 1}', '{trigger phrase 2}'"
{# Only include fields that apply:}
{context: "fork"  # if forked execution — use for self-contained tasks without mid-run user input}
{model: opus  # if model override needed (opus for complex reasoning, haiku for lightweight)}
{argument-hint: "[arg1] [--flag]"  # if takes arguments}
{arguments: "topic flag"  # named args — enables $topic, $flag substitution in body}
{allowed-tools: Read, Grep, Glob, Write, Edit  # restrict to minimum needed tools}
{disable-model-invocation: true  # if user-only (not auto-invocable)}
{paths: ["pattern/**"]  # if path-conditional — only loads when matching files touched}
---

# {Skill Name}

**Voice:** Casual, direct, honest. Abbrevs ok (w/, bc, tbh, imo, kinda).
Lead w/ answer, context after. Flag gaps helpfully (coach, not auditor). Cite sources always.

## Usage

\```
/{skill-name} [arguments]
\```

**Flags:**

- `--flag` — description

## Protocol

### 1. Load Context

Read these before starting:

- `projects/gazelle-agent/context-training/{relevant-files}`
- Check for existing state: `projects/gazelle-agent/.state/projects/{topic}/`

### 2. {Core Action}

{Steps — be specific about which tools/subagents to use}

**Success criteria:** {What proves this step is done and we can move on}

**Domain Template Hints:**

When generating a skill, check if these patterns apply and include them:

| If skill involves...      | Include in protocol                                                                            |
| ------------------------- | ---------------------------------------------------------------------------------------------- |
| Research / data gathering | Source-researcher subagents (per connected MCP) in parallel + usage-analyst for analytics      |
| User-facing output        | Product module disambiguation in Load Context step (read `context-training/domain.md`)         |
| AI feature design         | AI behavior section: confidence thresholds, human override, graceful degradation, transparency |
| Cross-module work         | Cross-module handling: consistent AI behavior, shared export formats                           |
| Design output             | Design context from `context-training/design-principles.md` (tokens, typography, spacing)      |
| Evidence-based output     | Evidence thresholds from `context-training/evidence-thresholds.md`, anti-hallucination rules   |

Also include a "Domain Context" appendix pointing to `context-training/domain.md` at the end of every generated SKILL.md.

### 3. {Synthesis/Output}

{What to produce, where to save it, what format}

**Success criteria:** {Artifact exists, passes quality check, user confirmed}

### Per-Step Annotations (use when helpful)

- **Success criteria** — ALWAYS include. What proves the step is done?
- **Execution** — Direct (default), Task agent, Teammate, or [human]
- **Artifacts** — data this step produces that later steps need
- **Human checkpoint** — pause for user review (especially irreversible actions)
- **Rules** — hard constraints or preferences from the user

## Output Format

Save to: `projects/gazelle-agent/.state/projects/{topic}/{output-file}.md`

{Template for the output document}
````

**Frontmatter rules:**

- Always include `name` and `description`
- Only add optional fields when they're actually needed (don't add `model: inherit` — that's the default)
- `description` should include trigger phrases that help the model know when to suggest the skill
- If the skill spawns 4+ subagents, recommend `context: "fork"`

### 4. Save and Register

1. Save to `gazelle/skills/{name}/SKILL.md`
2. Show the user the full file for review
3. Ask: "Want me to add this to `~/.claude/skills-index.md`?"

### 5. Post-Generation Checklist

Before declaring done, verify:

- [ ] Frontmatter is valid YAML
- [ ] Description includes trigger phrases
- [ ] Protocol steps reference specific tools/subagents (not vague "search for info")
- [ ] State management follows `projects/gazelle-agent/.state/projects/{topic}/` convention
- [ ] Context-training references point to files that actually exist
- [ ] Output format is specified with save location
- [ ] Voice section matches Gazelle convention

## Reference: Available Frontmatter Fields

From Claude Code's skill system (safe to use — unknown fields ignored by Cursor/Cowork):

| Field                      | Type                                            | When to use                                                |
| -------------------------- | ----------------------------------------------- | ---------------------------------------------------------- |
| `name`                     | string                                          | Always (defaults to dir name if omitted)                   |
| `description`              | string                                          | Always — include trigger phrases                           |
| `context`                  | `"fork"`                                        | Skill spawns 4+ subagents or generates massive tool output |
| `model`                    | `"opus"` / `"sonnet"` / `"haiku"` / `"inherit"` | Only if skill needs specific model capability              |
| `effort`                   | `"low"` / `"medium"` / `"high"` / `"max"`       | Only if skill needs specific reasoning depth               |
| `argument-hint`            | string                                          | Skill takes arguments                                      |
| `arguments`                | string[]                                        | Named arguments for `$name` substitution                   |
| `disable-model-invocation` | boolean                                         | User-only skill (model shouldn't auto-invoke)              |
| `paths`                    | string[]                                        | Skill only relevant when touching specific files           |
| `allowed-tools`            | string[]                                        | Auto-grant tool permissions during execution               |
| `hooks`                    | object                                          | Register session hooks when invoked                        |

## Reference: Existing Gazelle Subagents

| Agent               | Use for                                                   |
| ------------------- | --------------------------------------------------------- |
| `source-researcher` | Searching ONE data source (launch in parallel per source) |
| `usage-analyst`     | BigQuery/Omni queries                                     |
| `design-reviewer`   | Design critique against your design principles            |
| `synthetic-user`    | Persona simulation for UI/flow testing                    |
| `verifier`          | Read-only verification with anti-rationalization rules    |

---

## Appendix: Domain Context

> For company-specific modules, users, terminology, and team info, read `context-training/domain.md`.
> For design system and brand info, read `context-training/design-principles.md`.
> Run `/setup` if these files haven't been configured yet.
