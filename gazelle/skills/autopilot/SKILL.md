---
name: autopilot
description: "Time-bound autonomous work — plan, run for a set duration, wrap with a mechanical timer. Single entry point for 'run autonomously for X hours.'"
when_to_use: "Use when user says 'run autopilot for [time]', 'autonomous mode', '/autopilot start', 'work for X hours on Y', or asks the agent to work for a specified duration."
effort: low
argument-hint: "[mode|start [duration]]"
context: "fork"
---

# Autopilot — Autonomous Time-Bound Work

The single entry point for running Gazelle (or anything else) autonomously for a set duration. Plans the work, picks the right architecture for the duration, and uses a mechanical timer wrap so the session ends cleanly.

## When to use which timer skill

| Need                                      | Skill                                          |
| ----------------------------------------- | ---------------------------------------------- |
| Time-bound autonomous work (one session)  | **`/autopilot start [duration]`** ← this skill |
| Recurring on a clock ("every 5 min")      | `/loop [interval] [prompt]`                    |
| Iterate until a completion promise is met | `ralph-loop` (in a separate CC session)        |
| Cron schedule, cloud-only                 | `/schedule`                                    |
| Many tasks, fresh session each            | Watchdog script + `tasks.json` (BYO)           |

## Usage

```
/autopilot                    # Show this guide
/autopilot mode               # Load context silently, don't start a session
/autopilot start [duration]   # Start an autonomous session for a duration
```

`duration` accepts: `30m`, `1hr`, `2hr`, `overnight`, or `until HH:MM`.

Also triggers on: "autonomous mode", "run autopilot for X", "work for X on Y".

---

## /autopilot start [duration] — Begin Autonomous Session

### Step 0: Route by Duration (Architecture Decision)

**Empirical finding:** Single long sessions degrade. Pass rate drops sharply after ~35 min on a single context. Doubling task duration roughly quadruples failure rate. Architecture must match duration.

| Duration  | Architecture                              | Why                                              |
| --------- | ----------------------------------------- | ------------------------------------------------ |
| ≤30m      | Single session, no wakeup                 | Cache stays warm, work fits before degradation   |
| 30m–2hr   | Single session + `ScheduleWakeup` wrap    | Mechanical timer prevents drift                  |
| 2hr–6hr   | Watchdog + `tasks.json` (fresh per task)  | Avoid degradation past ~35min                    |
| Overnight | Watchdog mandatory + auto-task generation | Self-replenishes queue, recovers from rate limit |

**Rule:** if duration > 2hr and the user hasn't named the architecture, default to watchdog/fresh-session and tell them why. Don't fight the architecture.

### Step 1: Confirm Parameters

```
Starting autopilot session.

Duration: [X] (end: HH:MM)
Architecture: [single | watchdog]   ← auto-selected from Step 0
Mode: [supervised | autonomous]
Projects: [which repos/dirs]
Priority: [what's most important]

Confirm or adjust?
```

### Step 2: Plan Work — 80% Estimation Gate (HARD)

**Source priority for tasks (in order):**

1. **The user's prompt is the primary task source.** Tier 1 (do it), Tier 2 (depth — citations, edge cases, failure modes on the **same** topic), and Tier 3 (derivative — "what would make this 2x better" on the **same** topic) all stay on the prompt's subject.
2. **Adjacent project state** — only when the prompt is genuinely exhausted. Stay in the same domain.
3. **The auto-gen sources in Step 3** — last resort. Use only when prompt + adjacent are both exhausted, or when the prompt itself was "general maintenance" / "do good work."

**Failure mode this prevents:** filling time with random project-state work while the user wanted depth on the original prompt. Time was filled, rules followed — but user got the wrong work. Don't.

**Then:**

1. Estimate how long the planned tasks will actually take
2. **If estimate < 80% of duration → REFUSE TO START.** Generate more Tier 2/3 tasks on the prompt's topic first; only fall back to auto-gen sources if depth is genuinely exhausted.
3. Show the user: "I estimate ~[X]min. You asked for [Y]min. To fill the gap: [stretch goals — staying on topic]"
4. Break into 30-minute blocks with escalation tiers:

```
Session plan ([duration]):

Tier 1 (core):       [primary tasks]                       ~[Xm]
Tier 2 (depth):      [add citations, cross-ref, validate]  ~[Xm]
Tier 3 (derivative): [alternatives, stakeholder views]     ~[Xm]
Tier 4 (critique):   [self-review, "2x-better" pass]       ~[Xm]
Reserved:            last 15min for handoff
```

### Step 3: Auto-Generate Tasks (When Queue Empties)

Generate concrete tasks (each: deliverable + file path + estimated duration). **Source priority matches Step 2 — A before B before C.**

**A. Prompt + session context (primary — try this first)**

1. Re-read the user's original prompt — what specific verbs/nouns/constraints?
2. Scan the prior session transcript for TODOs, "I'll do X next" statements, links the user shared but didn't act on, partial work
3. Tier 2 depth on the prompt's topic: citations, edge cases, failure modes
4. Tier 3 derivative on the prompt's topic: alternatives, stakeholder views, "what would make this 2x better"

**B. Adjacent project state (only when A is exhausted)**

5. Active project folders related to the prompt's topic — open specs, partial drafts, related issues/tickets
6. Recent commits in repos the prompt touches (`git log --oneline -20`) — work without summaries

**C. Generic auto-gen (last resort — A + B both exhausted, OR prompt was "general maintenance" / "do good work")**

7. Project README files — stale docs, missing sections
8. Open issues / TODOs in code
9. Wiki / docs gaps (orphaned pages, missing summaries)
10. Test coverage gaps
11. Stale dependencies / TODO markers
12. Any persistent "task queue" file in the project

**If A is exhausted before timer fires:** that's a real signal. Wrap up honestly with a status report; don't fall to C just to fill time. Filling time with off-topic work is the silent-failure mode this skill exists to prevent.

### Step 4: Execute

For single-session runs:

1. Set `ScheduleWakeup` for the timer end (mandatory — promises don't fire)
2. Work tier 1 first
3. Health check every 30 minutes (timer + work-done log + queue depth)
4. Escalate tiers when ahead of schedule
5. **Never stop early. Never ask "what next?" if time remains.**

For watchdog runs:

1. Write `tasks.json` (each task has id, prompt, completion_marker, timeout)
2. Dry-run your watchdog script (e.g. `bash your-watchdog.sh --dry-run tasks.json`)
3. Live run: `bash your-watchdog.sh tasks.json`
4. Monitor: `tail -f /tmp/your-watchdog.log`
5. Replenish `tasks.json` when queue < 20% of original

> **Note:** Gazelle does not ship a watchdog script. Bring your own (any orchestration tool that spawns fresh CC sessions per task and parses a tasks.json queue). The pattern is what matters — fresh session per task to avoid context degradation past ~35min.

### Step 5: Wrap Up (Last 15 Minutes)

```
1. Read final state of all sessions
2. Write handoff file: handoff-autopilot-YYYY-MM-DD.md
3. Update any project status board
4. Clean up temp files
5. Notify user: "Session complete. [duration], [N commits/tasks]. Here's what shipped."
```

---

## Hard Rules (from logged failures)

- **NEVER ask "what should I do next?" or "want me to keep going?"** if time remains. Generate your own tasks from Step 3.
- **NEVER promise "I'll check in 10 min" without `ScheduleWakeup`** — promises don't fire, mechanical timers do.
- **NEVER run Ralph Loop in the main session** — user messages interrupt iterations.
- **NEVER write logs into the agent's config dir** (`.claude/`, `.cursor/`, etc.) — write to repo root.
- **`claude -p` headless mode is fragile** — no MCP access, exits silently on complex tasks. Wrap with `gtimeout`. Good for file ops, bad for tool-heavy work.
- **Sessions > 2hr default to watchdog/fresh-session.** Single long sessions degrade.

## Background Agent Rules

- **Constrain exploration scope.** Never "explore everything" — specify files/dirs. Agents on large codebases hit "Prompt is too long" and return 0 useful output.
- **Retry on <100-token output.** Failure modes are silent.
- **Chain over span.** 4 agents of 2hr > 1 agent of 8hr.

## Completion Criteria

### With a timer

Work until the timer fires. Tier escalation fills any gap. **The ONLY valid exits are:** timer fires, user says stop, or 3 consecutive API failures.

### Without a timer (task-based)

| Depth    | Stops when                                                       |
| -------- | ---------------------------------------------------------------- |
| Shallow  | Direct answer found, or confirmed not quickly findable           |
| Standard | 3-5 sources synthesized + clear pattern, or needs user input     |
| Deep     | All source types searched + recommendation ready, or blocker hit |

## Why This Skill Exists

Autopilot was built to consolidate three separate-but-overlapping patterns:

- "Run for X hours" — needed a timer
- "Be autonomous on this task" — needed scope discipline
- "Load my agent persona" — needed identity context

Combining them gives one entry point that scales from a 30-minute focused task to an overnight watchdog run, with the right architecture auto-selected for the duration.

## Customization

Bring your own persona file. Reference it in your project's `CLAUDE.md` or `.cursor/rules/`:

```markdown
When `/autopilot start` is invoked, read `~/your-agent-persona.md` for
decision-making rules before planning the session.
```

The persona file should cover:

- Who the user is (role, focus, constraints)
- Decision authority (what the agent can do unilaterally vs. ask)
- Hard guardrails (what's never allowed)
- Communication style
