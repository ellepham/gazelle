---
name: working-backwards
description: "Amazon-style PR/FAQ: write the press release first, then FAQ. Pressure-tests ideas by forcing clarity before building. Includes 5 assessment tests (Clarity, Differentiation, Customer Obsession, Internal FAQ Quality, Kill Test)."
when_to_use: "Use when pressure-testing ideas before building. Examples: 'working backwards', 'write the press release', 'PR/FAQ', 'amazon style', 'would anyone care about this'"
effort: medium
argument-hint: "[product/feature idea]"
allowed-tools: Read, Grep, Glob, Write, Edit
---

# Working Backwards

**Voice:** Casual, direct, honest. Abbrevs ok (w/, bc, tbh, imo, kinda).
Lead w/ answer, context after. Flag gaps helpfully (coach, not auditor). Cite sources always.

**Source:** Adapted from Amplitude Builder Skills' amazon-working-backwards framework. The 5 assessment tests at the end are the real value.

## Usage

```
/working-backwards [product or feature idea]
/working-backwards "AI-powered report section drafting"
/working-backwards "cross-feature search for power users" --project cross-feature-search
```

**Flags:**

- `--project [name]` — save to specific project state folder
- `--from [path]` — write PR/FAQ from an existing spec or research document

## The Rule

**Write at 6th-grade reading level.** If you need jargon, the idea isn't clear enough. The press release is for the customer, not for the team. If a Clinical Affairs Specialist can't understand it in one read, rewrite it.

## Protocol

### 1. Load Context

Read these if available:

- `projects/gazelle-agent/.state/projects/{name}/spec.md` — existing spec
- `projects/gazelle-agent/.state/projects/{name}/research.md` — research findings
- `projects/gazelle-agent/.state/projects/{name}/jtbd.md` — jobs analysis
- `projects/gazelle-agent/.state/projects/{name}/opportunity-sizing.md` — demand data
- `projects/gazelle-agent/context-training/domain.md` — products, modules, users

### 2. Write the Press Release

The press release is written as if the feature/product has already launched. It forces you to articulate the value before building anything.

```markdown
# [HEADLINE: What the customer gets, in their language]

**[City, Date]** — [Company] today announced [feature/product], which [what it does for the customer in one sentence].

## The Problem

[1-2 paragraphs: What pain does the customer face today? Be specific — name the workflow, the time wasted, the risk. Write from the customer's perspective, not the company's.]

## The Solution

[1-2 paragraphs: What does this do? How does it work from the customer's perspective? Focus on outcome, not technology. "AI" is not a benefit — "saves 4 hours per report update" is a benefit.]

## Customer Quote

> "[Quote from a specific user persona describing how this changes their work. Must sound like something a real Clinical Affairs Specialist or Vigilance Officer would actually say — not marketing speak.]"
>
> — [Name], [Title] at [Company type]

## How It Works

[3-5 bullet points: the key capabilities, each one sentence, each focused on a customer outcome]

- [Capability 1: outcome-focused]
- [Capability 2: outcome-focused]
- [Capability 3: outcome-focused]

## Getting Started

[How does a customer start using this? What's the activation path? If it requires migration, say so.]

## Company Quote

> "[Quote from internal leader — CEO, VP Product, or relevant PM — explaining why this matters strategically. Must connect to the company's mission, not just the feature.]"
>
> — [Name], [Title] at [Company]
```

**Rules for the press release:**

- Write for the customer, not the team
- No internal jargon (say "find relevant research papers" not "execute structured queries against indexed databases")
- The headline must make a customer care — if it reads like a changelog entry, rewrite it
- The customer quote must sound like a real person, not a testimonial
- If you can't write a compelling press release, the idea might not be compelling

### 3. Write the FAQ

Two sections: customer FAQ (external) and internal FAQ (the hard questions).

#### Customer FAQ

```markdown
## Customer FAQ

**Q: How is this different from [closest existing alternative]?**
A: [Specific, honest answer. Name the competitor or workaround.]

**Q: Will this work with my existing [workflow/data/tools]?**
A: [Specific answer about integration, migration, compatibility]

**Q: How does the AI work? Can I trust it?**
A: [Specific answer about transparency, control, override capability. For AI products: emphasize human-in-the-loop.]

**Q: What does this cost?**
A: [Honest answer — even if "included in existing subscription" or "pricing TBD"]

**Q: When can I use this?**
A: [Timeline — even if approximate]
```

#### Internal FAQ (The Hard Questions)

```markdown
## Internal FAQ

**Q: Why should we build this instead of [alternative priority]?**
A: [Evidence-backed answer. Reference demand signals, revenue impact, strategic alignment.]

**Q: What's the biggest risk?**
A: [Honest answer. Don't minimize — name the real risk and the mitigation plan.]

**Q: How do we know customers actually want this?**
A: [Specific evidence: customer quotes, usage data, deal blockers. "We think they want it" is not evidence.]

**Q: What happens if this fails?**
A: [Honest answer about reversibility, sunk cost, impact on team morale and roadmap]

**Q: How long will this take to build?**
A: [Realistic estimate — include the AI-adjusted effort anchors from /opportunity-sizing]

**Q: What are we NOT building?**
A: [Explicit scope exclusions — what's tempting but out of scope]

**Q: What must be true for this to succeed?**
A: [List of assumptions that must hold — if any breaks, the idea breaks]
```

### 4. Run the 5 Assessment Tests

After writing the PR/FAQ, evaluate it against these 5 tests. Each test produces a PASS/FAIL with reasoning:

```markdown
## Assessment

### Test 1: Clarity Test

**Question:** Can a new hire understand what this does and why it matters in 60 seconds?
**Result:** [PASS/FAIL]
**Evidence:** [Read the headline + first paragraph. If you need context to understand it, FAIL.]

### Test 2: Differentiation Test

**Question:** If you removed the company name, could this press release be about a competitor's product?
**Result:** [PASS/FAIL]
**Evidence:** [If yes, the differentiation is weak. What's unique about THIS solution?]

### Test 3: Customer Obsession Test

**Question:** Is the press release written from the customer's perspective, or from the company's?
**Result:** [PASS/FAIL]
**Evidence:** [Count sentences about the customer vs. sentences about the technology/company. Customer should win 3:1.]

### Test 4: Internal FAQ Quality Test

**Question:** Do the internal FAQ answers contain specific evidence, or are they hand-wavy?
**Result:** [PASS/FAIL]
**Evidence:** [Each "how do we know" answer must cite a specific source. "We believe" = FAIL.]

### Test 5: Kill Test

**Question:** If this press release generates zero excitement from the target customer, would you still build it?
**Result:** [PASS/FAIL]
**Evidence:** [If yes, why? If no, the idea depends entirely on customer pull — and you need to verify that pull exists.]

## Overall Assessment

| Test                 | Result      | Key Issue        |
| -------------------- | ----------- | ---------------- |
| Clarity              | [PASS/FAIL] | [1-line summary] |
| Differentiation      | [PASS/FAIL] | [1-line summary] |
| Customer Obsession   | [PASS/FAIL] | [1-line summary] |
| Internal FAQ Quality | [PASS/FAIL] | [1-line summary] |
| Kill Test            | [PASS/FAIL] | [1-line summary] |

**Verdict:** [SHIP THE IDEA / REVISE AND RETEST / KILL IT]
[1-2 sentences explaining the verdict]
```

### 5. Iterate if Needed

If any test FAILs:

1. Identify what caused the failure
2. Revise the specific section of the PR/FAQ
3. Re-run the failed test(s)
4. Maximum 2 revision rounds — if it still fails, the idea may need more research

### 6. Anti-Plays

- Don't write the press release in engineering language — if it reads like a technical spec, start over
- Don't fake the customer quote — if you can't imagine a real user saying it, the value prop is off
- Don't dodge the Kill Test — it's the most important test. An idea that can't survive "would you still build this?" deserves to die early
- Don't treat the internal FAQ as a formality — those questions WILL be asked by leadership. Answer them honestly now.
- Don't skip the "What are we NOT building?" question — scope creep starts when boundaries aren't explicit

### 7. Save Output

Save to: `projects/gazelle-agent/.state/projects/{topic}/working-backwards.md`

### 8. Offer Next Steps

> "PR/FAQ complete. assessment: [N]/5 tests passed. verdict: [verdict].
>
> next options:
>
> - failed tests? revise and retest (`/working-backwards [idea]` — will reload existing draft)
> - ready to spec? (`/design-spec [feature]`)
> - need more evidence? (`/research [topic] --deep`)
> - validate the underlying job? (`/jtbd [segment]`)
> - want to expand the idea first? (`/yes-and [idea]`)
> - run a pre-mortem before launch? (`/pre-mortem [feature]`)
> - design an experiment to test it? (`/experiment-design [hypothesis]`)
> - need to size the opportunity? (`/opportunity-sizing [feature]`)"

## Integration

- Pairs with: `/yes-and` (expand before pressure-testing), `/office-hours` (adversarial feedback), `/jtbd` (validate the underlying job), `/pre-mortem` (risk assessment after validation), `/experiment-design` (test before full commitment)
- Reads from: research, JTBD, opportunity sizing, spec state
- Feeds into: design spec, pre-mortem, experiment design

---

## Appendix: Domain Context

> For company-specific modules, users, and PR/FAQ context, read `context-training/domain.md`.
> The press release should use language your customers understand — check the Terminology section.
> Run `/setup` if that file hasn't been configured yet.
