---
name: persona-builder
description: "Build, update, and test with data-grounded personas. Combines analytics usage patterns, Notion/Slack feedback, and Circleback interviews to create or refresh personas. Also runs synthetic user tests."
when_to_use: "Use when building, refreshing, or testing with data-grounded personas. Examples: 'build a persona', 'refresh personas', 'test with persona', 'synthetic user test'"
argument-hint: "build/test/audit [--module your-module-name]"
---

# Persona Builder

**Voice:** Casual, direct, honest. Abbrevs ok (w., bc, tbh, imo, kinda).
Lead w. answer, context after. Flag gaps helpfully (coach, not auditor). Cite sources always.

## Usage

```
/persona-builder build [archetype]          # Build/refresh a persona from data
/persona-builder test [archetype] [context] # Run synthetic user test as persona
/persona-builder audit                      # Check freshness of all personas
```

**Flags:**

- `--sources [list]` — restrict data sources (analytics,notion,slack,circleback,drive)
- `--project [name]` — save to project state folder

## Protocol

### Mode: Build / Refresh

#### 1. Load Context

Read these before starting:

- `projects/gazelle-agent/context-training/personas-reference.md` — existing persona data + freshness
- `.cursor/rules/synthetic-user-testing.mdc` — full persona profiles + testing framework
- `projects/gazelle-agent/context-training/data-sources.md` — analytics schema, event names
- `projects/gazelle-agent/context-training/domain.md` — product/domain context

Check for existing state:

- `projects/gazelle-agent/.state/projects/{project}/personas.md` — project-specific personas

#### 2. Assess Current Data

For the requested persona, check:

- **Last interview data:** when was this persona type last interviewed?
- **Analytics validation:** are usage numbers verified or assumed?
- **Feedback freshness:** how old is the qualitative data?
- **Assumed attributes:** which attributes are marked 🔮?

Output a quick freshness summary before doing new research.

**If no persona data exists at all (cold start):** Say "no existing data for [archetype]. building from scratch — this will be heavily 🔮 ASSUMED until we get real interview + analytics data. I'll mark everything that's assumed." Then proceed to Step 3 with all attributes starting as 🔮.

#### 3. Gather New Data (Using Subagents)

**Define your persona archetypes in `context-training/personas-reference.md`.** Use a table like this:

| Archetype                  | Role                        | Product Area  | Company type              | Key search terms                              |
| -------------------------- | --------------------------- | ------------- | ------------------------- | --------------------------------------------- |
| **Power User**             | [primary role]              | [module/area] | [target segment]          | [domain-specific terms]                       |
| **Cautious Learner**       | [role]                      | [module/area] | [segment, new to product] | onboarding, help, export, questions, confused |
| **Manager/Overseer**       | [manager role]              | [module/area] | Enterprise                | review, approve, team, audit, oversight       |
| **Pragmatic Multi-tasker** | [role doing multiple tasks] | [module/area] | Any size                  | [workflow-specific terms]                     |

Launch subagents in parallel for data gathering. Replace `[persona archetype]` with the exact archetype name and details from your personas table:

```
gazelle-analyst → "Query analytics for usage patterns for [exact archetype name].
  E.g. for Power User: look for users with high activity in [primary product area].
  Segment by org size and user role. Get: session frequency, features used,
  drop-off points, error rates. Filter internal users."

gazelle-source-researcher → "Search Circleback for customer meetings with
  [archetype role] users (e.g. '[role title]').
  Look for [company type from table] companies.
  Extract quotes about their workflows, pain points, expectations."

gazelle-source-researcher → "Search Notion for user feedback from [archetype role].
  Check your feedback board.
  Filter by [company type]. CS escalations, feature requests, interview notes."

gazelle-source-researcher → "Search Slack for feedback about [archetype name] users.
  Channels: your product discovery and feedback channels.
  Count unique customers mentioned."
```

**Cross-Area Persona (users spanning multiple product areas):**

When building archetypes that span multiple product areas, use additional subagent queries:

```
gazelle-analyst → "Query analytics for users active in BOTH [area A] AND [area B].
  How many users use both areas? What's their session pattern?
  Do they use both areas in the same session or on different days?
  Get: areas used, session overlap frequency, feature overlap."

gazelle-source-researcher → "Search Circleback for meetings where the same person discusses tasks spanning [area A] and [area B].
  Extract: what tasks span both areas, what's the handoff friction?"
```

Key behaviors unique to cross-area personas:

- Switches between product areas frequently (sometimes same session)
- Needs data from multiple areas for combined workflows
- Frustrated when areas don't share formats or conventions
- Most likely to notice inconsistencies in behavior across areas

Collect results, then update persona attributes.

#### 4. Update Persona

For each attribute, note:

- **Validated:** data confirms existing assumption → mark ✅
- **Updated:** new data changes the picture → update + cite source
- **Still assumed:** no new data found → keep 🔮, note "still unvalidated"
- **Contradicted:** new data disagrees → flag 🔀, present both

#### 5. Write Output

Present in chat:

```markdown
## persona refresh: [Archetype]

### what changed

- [attribute]: [old value] → [new value] (source: [link])
- [attribute]: confirmed ✅ (source: [link])

### still assumed (no new data)

- 🔮 [attribute] — [what would validate it]

### freshness after update

| Attribute Category | Sources   | Last Updated | Confidence |
| ------------------ | --------- | ------------ | ---------- |
| Demographics       | [sources] | [date]       | ✅/⚠️/❌   |
| Usage patterns     | [sources] | [date]       | ✅/⚠️/❌   |
| Pain points        | [sources] | [date]       | ✅/⚠️/❌   |
| Quotes             | [sources] | [date]       | ✅/⚠️/❌   |

### my take

[honest assessment of persona health — is this persona still useful or getting stale?]
```

#### 6. Save State

Update `projects/gazelle-agent/context-training/personas-reference.md` with new data.
If project-specific, also save to `projects/gazelle-agent/.state/projects/{project}/personas.md`.

---

### Mode: Synthetic User Test

**Uses subagent:** `gazelle-synthetic-user` (`.cursor/agents/gazelle-synthetic-user.md`)

The persona testing is delegated to the `gazelle-synthetic-user` subagent, which has full persona profiles and testing rules embedded. This keeps the persona roleplay context-isolated from the main conversation.

#### 1. Set Context

Ask user (max 2 questions):

1. **What are we testing?** — screenshot, flow, copy, feature concept?
2. **What's the user's situation?** — e.g. "mid-workflow, tight deadline, 200 of 400 items processed"

If context is clear from the request, skip questions and start.

#### 2. Launch Subagent

Launch `gazelle-synthetic-user` with:

```
"You are the [archetype] persona. [workflow context from user].
I'm going to show you [what's being tested].
React as this user would — think out loud, express confusion naturally,
say what you'd do next. After the test, break character and return structured findings."
```

To test with 2 personas simultaneously, launch 2 `gazelle-synthetic-user` subagents in parallel with different archetypes.

#### 3. Collect Results

The subagent returns:

- First-person persona reactions (in character)
- Structured testing notes (out of character): key reactions, misinterpretations, which attributes drove responses, confidence in the test, complementary test suggestion

Present results to user. Suggest follow-up if needed (different persona, different screen).

---

### Mode: Audit

Check all personas in `personas-reference.md` and output:

```markdown
## persona health check

| Persona       | Last Updated | Analytics Validated | Freshest Source | Overall  |
| ------------- | ------------ | ------------------- | --------------- | -------- |
| [Archetype 1] | [date]       | ✅/❌               | [source + date] | ✅/⚠️/❌ |
| [Archetype 2] | [date]       | ✅/❌               | [source + date] | ✅/⚠️/❌ |
| [Archetype 3] | [date]       | ✅/❌               | [source + date] | ✅/⚠️/❌ |
| [Archetype 4] | [date]       | ✅/❌               | [source + date] | ✅/⚠️/❌ |

### recommendations

1. [who needs refresh most urgently and why]
2. [what data would strengthen the weakest persona]
```

---

## Persona Quality Rules

A persona is **healthy** when:

- At least 3 attribute categories have real data (not assumed)
- Analytics usage patterns are validated (not guessed)
- Last data source is <3 months old
- At least 2 direct quotes from real users of this archetype
- Pain points cite specific feedback entries

A persona is **stale** when:

- All data is >6 months old
- Analytics attributes are all 🔮 ASSUMED
- No real quotes (only synthetic/guessed)
- No feedback entries from matching archetype in last 6 months

**What to do with stale personas:** Don't delete — flag staleness in every output that uses them. Recommend specific actions to refresh (which queries, which customers to check).

## Offer Next Steps

After personas are built or refreshed:

> "persona saved. next options:
>
> - want to map their journey? → `/journey-mapping [flow] --persona [name]`
> - want to test a design with this persona? → launch `synthetic-user` subagent
> - ready for a spec? → `/design-spec [feature]` (if insights + personas exist)"

## Integration

- **Subagents used:**
  - `gazelle-source-researcher` (parallel) — for persona data gathering in build mode
  - `gazelle-analyst` — for analytics usage pattern validation
  - `gazelle-synthetic-user` — for persona testing mode
- Reads from: `personas-reference.md`, `synthetic-user-testing.mdc`
- Outputs feed into: `/gazelle-journey`, `/gazelle-insights`, `/gazelle-spec`
- State saved to: `projects/gazelle-agent/.state/projects/{project}/personas.md`
- Persona updates written back to: `context-training/personas-reference.md`

---

## Appendix: Domain Context

> Inline reference so this skill works in any environment (Cowork, Cursor, Claude Code) without external context files.
> **Replace this section with your own company/product context.** See `context-training/domain.md` for the full template.

## Your Product

Describe your company and product here. Include: what you do, who your customers are, your key modules/features, and your market position.

## Modules / Product Areas

| Area       | Name   | What it does  | Owner      |
| ---------- | ------ | ------------- | ---------- |
| **Area 1** | [Name] | [Description] | [PM/Owner] |
| **Area 2** | [Name] | [Description] | [PM/Owner] |
| **Area 3** | [Name] | [Description] | [PM/Owner] |

## Users

| Persona  | Does            | Product Area |
| -------- | --------------- | ------------ |
| [Role 1] | [Primary tasks] | [Area]       |
| [Role 2] | [Primary tasks] | [Area]       |
| [Role 3] | [Primary tasks] | [Area]       |

**User context:** Describe your users' general context — their industry, expectations, trust level with AI, tool familiarity, etc.

## Key Terms

Define your domain-specific terminology here. Include acronyms, product-specific concepts, and industry jargon that personas would use.

## Competitors

| Competitor         | vs. Your Product   |
| ------------------ | ------------------ |
| **[Competitor 1]** | [How they compare] |
| **[Competitor 2]** | [How they compare] |

## Design Principles

Reference your design principles from `context-training/design-principles.md`. These guide persona-driven design decisions.

## Team

List your team structure here: Design, PM, Engineering, CS, Leadership roles.
