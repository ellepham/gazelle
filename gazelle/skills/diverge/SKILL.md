---
name: diverge
description: "Force divergent thinking: generate 5+ deliberately different solutions before converging. Breaks the 'first reasonable answer' pattern. Use before /design-spec or when a design feels too obvious."
when_to_use: "Use when exploring solution space, feeling stuck on one direction, or the current approach feels too safe. Examples: 'diverge on this', 'what are all the ways we could solve this', 'give me wild options', 'explore alternatives', 'I want more options'"
effort: low
argument-hint: "[problem or feature]"
allowed-tools: Read, Grep, Glob, Write, Edit, WebSearch, Agent
---

# Diverge

**Voice:** Casual, direct, honest. Abbrevs ok (w/, bc, tbh, imo, kinda).
Creative energy — you're expanding the solution space, not converging yet.

**Purpose:** Break the "first reasonable answer" pattern that AI agents default to. Generate 5+ genuinely different solutions — not variations on a theme, but different approaches to the same problem.

**When to use:**

- Before `/design-spec` — explore the solution space first
- When a proposed design feels "obvious" or "safe"
- When stakeholders disagree and you need to map the possibility space
- After research, before committing to a direction
- When the PM says "what else could we do?" or "this feels too narrow"

**Distinct from:**

- `/yes-and` — expands ONE idea bigger. `/diverge` generates MANY different ideas.
- `/explore-designs` — generates 2-3 visual concepts in Figma. `/diverge` is pre-visual, concept-level.
- `/competitive-analysis` — looks at what others do. `/diverge` invents what nobody does yet.

## Usage

```
/diverge [problem or feature]
/diverge "how should users switch between product modules?"
/diverge --from spec.md                    # diverge from an existing spec
/diverge --constraint "no URL changes"     # add constraints to work within
/diverge --wild                            # include 2 deliberately impractical ideas
```

**Flags:**

- `--from [path]` — diverge from an existing spec or brief
- `--constraint [text]` — add constraints the solutions must respect
- `--wild` — include 2 "what if we had no constraints" ideas alongside practical ones
- `--project [name]` — save to project state folder

## Protocol

### 1. Understand the Problem (not the solution)

Read available context:

- User's input / linked spec
- `projects/gazelle-agent/.state/projects/{name}/` — existing research, insights
- `CLAUDE.md` — project context

**Restate the problem in one sentence.** Not the feature, the problem. "Users can't find their module" not "we need module tabs."

Ask if the restatement is right. If the user already gave a clear problem, skip the confirmation and go.

### 2. Generate the Divergence Map (5+ solutions)

**Rules:**

1. **Minimum 5 solutions.** Not 3 (too easy to pick the middle), not 10 (noise). 5 forces real variety.
2. **Each must be structurally different.** "Tabs vs pills vs dropdown" is NOT divergent — that's one solution (switcher) with visual variations. Divergent means different mechanisms, different information architecture, different mental models.
3. **Include at least one from each category:**
   - **Conventional:** The obvious solution that every SaaS does
   - **Radical simplification:** What if we removed something instead of adding?
   - **Inversion:** What if we did the opposite of what we assume?
   - **Analogy:** Steal a pattern from a completely different domain
   - **User-driven:** What if the user configured this themselves?
4. **If `--wild` flag:** Add 2 more that are deliberately impractical but thought-provoking. Label them as wild cards.
5. **No judgment yet.** Don't evaluate while generating. Save that for Step 3.

**Format per solution:**

```markdown
### [#] [Name] — [one-line pitch]

**Mechanism:** [How it actually works — 2-3 sentences]
**Mental model:** [What's the user's mental model? What analogy does this follow?]
**Assumes:** [What must be true for this to work?]
**Breaks if:** [When does this fall apart?]
**Effort:** S/M/L
**Precedent:** [Who does something similar? Or "novel"]
```

### 3. Compare (structured, not vibes)

After generating all solutions, produce a comparison table:

```markdown
## Comparison

| #   | Solution | Solves the core problem? | Effort | Risk         | Scales beyond? | User learning curve |
| --- | -------- | ------------------------ | ------ | ------------ | -------------- | ------------------- |
| 1   | [name]   | Yes/Partially/No         | S/M/L  | Low/Med/High | Yes/No         | Low/Med/High        |
```

**Evaluation dimensions** (pick 4-5 most relevant to the problem):

- Does it solve the core problem?
- Effort (S/M/L)
- Risk (what could go wrong?)
- Scalability (does it work for 2 modules? 5? 10?)
- User learning curve
- Impact on existing users (migration pain)
- Technical feasibility
- Business impact

### 4. Recommend (with honest trade-offs)

```markdown
## My lean

**I'd go with [#X] because [reason].** It [strength], which matters most here because [context].

**The real trade-off is between [#X] and [#Y]:**

- [#X] is better if [condition]
- [#Y] is better if [condition]

**What I'd steal from other solutions:**

- From [#Z]: [specific element that could be combined]
```

### 5. Save Output

Save to: `projects/gazelle-agent/.state/projects/{name}/diverge.md`

If no project name, save to: `projects/gazelle-agent/.state/diverge-{topic}.md`

## Anti-Patterns (what NOT to do)

1. **Don't generate variations, generate alternatives.** "Blue button vs green button" is not divergence. "Button vs gesture vs voice command vs no UI at all" is divergence.
2. **Don't evaluate while generating.** The internal "that won't work" filter kills creative ideas. Generate first, evaluate in Step 3.
3. **Don't anchor on the user's suggested solution.** If the user says "should we use tabs?", don't generate "tabs vs pills vs segmented control." Reframe: "how should users navigate between modules?" and generate from that.
4. **Don't default to 3 options.** 3 creates a natural "middle option" bias. 5 forces genuinely different thinking.
5. **Don't skip the "breaks if" field.** Every solution has a failure mode. Name it upfront — it builds trust and saves time.

## Divergence Prompts (use when stuck generating)

If you're stuck after 3 solutions, use these prompts to force different thinking:

- **"What if we removed X instead of adding Y?"** (radical simplification)
- **"How does [Spotify/Notion/Figma/Slack/Jira] solve a similar problem?"** (analogy)
- **"What would a user with zero training expect?"** (beginner's mind)
- **"What if this was a mobile app with 320px width?"** (constraint-driven)
- **"What if we had to ship this in 1 day?"** (effort constraint)
- **"What if we had unlimited engineering time?"** (remove constraint)
- **"What would the user do if we built nothing?"** (null hypothesis)
- **"What if the user could configure this themselves?"** (user-driven)
- **"What's the opposite of what we're assuming?"** (inversion)

## Integration

- **Before `/design-spec`:** Run `/diverge` to explore the solution space. The winning direction feeds into the spec.
- **After `/research`:** Research reveals the problem. `/diverge` expands the solution space before converging.
- **With `/yes-and`:** `/diverge` generates options, `/yes-and` expands the winning one.
- **With `/explore-designs`:** `/diverge` is concept-level (pre-visual). `/explore-designs` takes the top 2-3 concepts and makes them visual in Figma.

## Skill Chaining

```
/research → /insights → /diverge → /design-spec → /explore-designs → /design-critique
```

`/diverge` sits between understanding the problem and committing to a solution.
