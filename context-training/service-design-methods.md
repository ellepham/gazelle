# Gazelle — Service Design Methods (Prescriptive)

> Not a reference. A decision tree. Tell Gazelle what situation you're in, it picks the method.
> Non-designers (PMs, engineers) should be able to use this without prior service design knowledge.

**Source:** `shared/service-design-knowledge/` (54 methods) + your own research playbook — distilled for agent use.  
**Last updated:** 2026-02-23

---

## Quick Lookup: "I Want To..."

| If You Want To...                     | Use These                                     | Time       |
| ------------------------------------- | --------------------------------------------- | ---------- |
| Understand user needs                 | Interviews, Shadowing                         | 1-2 weeks  |
| Map current experience                | Journey Mapping + Interviews                  | 1 week     |
| Understand the ecosystem              | Stakeholder Mapping                           | 1-2 days   |
| Generate solution ideas               | HMW Questions → Brainstorming → Sketching     | 1-3 days   |
| Visualize a concept                   | Storyboarding, Concept Posters                | 2-4 hours  |
| Test UI/interactions                  | Paper Prototype → Clickable Prototype         | days-weeks |
| Test an AI/automation concept         | Wizard of Oz                                  | 1-2 weeks  |
| Validate before building              | Clickable Prototype + 5 users                 | 1-2 weeks  |
| Launch safely                         | Pilot (3-5 customers) → Phased Rollout        | 2-3 months |
| Improve existing feature              | Analytics Review → 5 Interviews → Journey Map | 1-2 weeks  |
| Check what users actually do (vs say) | BigQuery analytics + Interviews               | 3-5 days   |

---

## Method Definitions

Every method Gazelle might recommend, in one line. If user doesn't know the term, point them here.

### Research

| Method                   | What It Is                                                                                                                 |
| ------------------------ | -------------------------------------------------------------------------------------------------------------------------- |
| **Desk Research**        | Review existing info (analytics, support tickets, competitor tools, past research) before talking to anyone                |
| **User Interviews**      | 1-on-1 conversations (45-60 min) to understand experiences, needs, pain points. Ask open questions, listen.                |
| **Shadowing**            | Watch a user do real work in their real environment. Observe, don't interrupt. See what they actually do vs what they say. |
| **Journey Mapping**      | Visual timeline of user's experience across stages. Shows actions, emotions, pain points, touchpoints.                     |
| **Personas**             | Fictional characters representing user types, built from real research. Name + role + goals + pains + quote.               |
| **Stakeholder Mapping**  | Diagram of all people involved in/affected by a service. Shows power, interest, relationships.                             |
| **Analytics Review**     | Study usage data (BigQuery) — drop-offs, time-on-task, feature adoption, error rates.                                      |
| **Competitive Analysis** | Use competitor products as if you're a real user. Note what works, what doesn't, what's missing.                           |
| **Diary Study**          | Users document their own experiences over 1-4 weeks. Captures behavior you can't observe in a single session.              |
| **Affinity Mapping**     | Synthesis method: write observations on sticky notes, group similar ones, name the groups → themes emerge.                 |

### Ideation

| Method                   | What It Is                                                                                                           |
| ------------------------ | -------------------------------------------------------------------------------------------------------------------- |
| **HMW Questions**        | Reframe problems as "How Might We...?" questions. Opens solution space without jumping to answers.                   |
| **Brainstorming**        | Group idea generation. Rules: no critique, go for quantity, build on others' ideas, be visual. Target 30-100+ ideas. |
| **Sketching**            | Quick hand-drawn UI concepts. Speed over polish. Use thick markers (forces simplicity).                              |
| **Storyboarding**        | Comic-strip sequence (6-12 frames) showing user journey through a concept. Setup → Action → Outcome.                 |
| **Concept Posters**      | One-page visual summary of a service concept: name, big idea, how it works, key benefits, user journey.              |
| **10 Plus 10**           | Generate 10 realistic ideas, then 10 wild/impossible ideas. Combine the best of both.                                |
| **Worst Possible Idea**  | "How could we make this WORSE?" → flip the worst ideas into good ones. Unlocks creativity when stuck.                |
| **Crazy 8s**             | 8 ideas sketched in 8 minutes. Forces speed over perfection.                                                         |
| **Dot Voting**           | Everyone gets 3-5 dots, vote on favorite ideas. Quick visual consensus.                                              |
| **Impact/Effort Matrix** | Plot ideas on 2x2: high impact + low effort = do first. High impact + high effort = strategic bet.                   |
| **Co-Creation Workshop** | Structured session where stakeholders (users, PMs, engineers) design solutions together. Builds buy-in.              |

### Prototyping & Testing

| Method                  | What It Is                                                                                                                                |
| ----------------------- | ----------------------------------------------------------------------------------------------------------------------------------------- |
| **Paper Prototype**     | Hand-drawn screens on paper. "Human computer" swaps pages as user taps. Test in hours, iterate in minutes.                                |
| **Desktop Walkthrough** | Print/sketch all touchpoints, lay on table, walk through the journey. Good for multi-touchpoint flows.                                    |
| **Wizard of Oz**        | Build a believable UI but have a human do the "AI/automation" behind the scenes. User thinks it's real. Tests value before building tech. |
| **Clickable Prototype** | Interactive Figma prototype — click through screens, test flows. Medium-high fidelity.                                                    |
| **Pilot Testing**       | Launch to 3-5 real customers for 4-8 weeks. Real data, real feedback, real validation.                                                    |
| **A/B Testing**         | Two versions, split traffic, measure which performs better. For optimizing existing features.                                             |
| **Service Blueprint**   | Detailed diagram showing frontstage (what user sees) + backstage (what happens behind) + support systems.                                 |

---

## Pick Your Situation

### "I need to understand a problem" (Research)

| Time        | What to Do                                                                   | Output                         |
| ----------- | ---------------------------------------------------------------------------- | ------------------------------ |
| **1 day**   | Desk research: Notion feedback board + Slack threads + BigQuery analytics    | Quick findings summary         |
| **3 days**  | Desk research + 3 rapid interviews (30 min) + synthesis                      | Research brief w. key patterns |
| **1 week**  | Desk research → 5 interviews (45 min) → current-state journey map            | Insight brief + journey map    |
| **2 weeks** | 8-10 interviews + 2-3 shadowing sessions → personas + journey maps           | Full research package          |
| **4 weeks** | Full cycle: desk + interviews + shadowing + analytics + competitive analysis | Comprehensive discovery        |

**Default: 1 week / 5 interviews.** Why? Nielsen/Norman research shows 5 users find ~80% of usability issues. Diminishing returns after that unless you're testing across segments.

**Shortcut: Ask CS first.** CS team talks to users daily. Before scheduling interviews, ask CS: "what are you hearing about [topic]?" This gives you signal in hours, helps you write better interview questions, and sometimes eliminates the need for desk research.

### "I need to validate a hypothesis" (Testing)

| Confidence Needed   | What to Do                                    | Output                               |
| ------------------- | --------------------------------------------- | ------------------------------------ |
| **Quick gut check** | Synthetic user test (Gazelle persona skill)   | Persona reaction + issues flagged    |
| **Directional**     | 3 user interviews focused on hypothesis       | Confirmed/denied + nuance            |
| **Solid**           | BigQuery data + 5 interviews + synthetic test | Evidence brief w. quant + qual       |
| **High conviction** | A/B prototype test w. 7+ users + analytics    | Statistical + qualitative validation |

**Default: directional (3 interviews).** Synthetic user tests are fast but not real — always note this in confidence ratings. If BigQuery has relevant data, check it first (free, fast, no scheduling).

### "I need to generate solutions" (Ideation)

| Context                   | What to Do                                           | Output                       |
| ------------------------- | ---------------------------------------------------- | ---------------------------- |
| **Solo designer**         | HMW questions → sketching → 10 Plus 10               | 30+ ideas + top 3 sketched   |
| **Small team (2-3)**      | HMW → brainstorming → concept posters                | Ranked concepts w. rationale |
| **Cross-functional (4+)** | Co-creation workshop → crazy 8s → dot voting         | Aligned direction + buy-in   |
| **Stuck / conventional**  | Worst Possible Idea → flip it → competitive analysis | Fresh angles                 |

**Default: HMW → sketching.** Fast, works solo or team. Best practice: explore min 3 solutions before selecting one.

### "I need to test a concept" (Prototyping)

| Fidelity               | What to Do                               | When                                    | Remote Adaptation               |
| ---------------------- | ---------------------------------------- | --------------------------------------- | ------------------------------- |
| **Napkin (hours)**     | Paper prototype or desktop walkthrough   | Very early, testing core concept        | Share screen, draw on iPad      |
| **Lo-fi (days)**       | Clickable Figma prototype w. 3 users     | Testing flow + information architecture | Figma prototype link + Zoom     |
| **Mid-fi (1-2 weeks)** | Interactive prototype w. 5-7 users       | Testing interactions + usability        | Figma prototype + Maze/Useberry |
| **Hi-fi (weeks)**      | Working MVP or Wizard of Oz w. real data | Testing full experience                 | Deploy to staging, share URL    |
| **Live (months)**      | Pilot w. 3-5 real customers              | Validating in production                | Feature flag rollout            |

**Default: lo-fi Figma w. 5 users.** Finds 85% of usability issues. Costs days not weeks.

### "I need to ship something" (Implementation)

| Risk Level                           | What to Do                                                   | Timeline   |
| ------------------------------------ | ------------------------------------------------------------ | ---------- |
| **Low** (UI improvement)             | Just ship it, monitor BigQuery for regressions               | Days       |
| **Medium** (new feature)             | Phased rollout: early adopters → all. Version-gate in code.  | 2-4 weeks  |
| **High** (major change)              | Pilot w. 3-5 customers → iterate → phased rollout            | 2-3 months |
| **Critical** (compliance/regulatory) | Pilot + extra validation + documentation + change management | 3-6 months |

**Default: medium / phased rollout.** A versioning system makes this easy — gate behind feature flag, monitor, expand.

---

## How to Do the Top 5 Methods (Adapted for Practice)

### 1. User Interviews in Practice

**Recruiting (the hard part):**

- **Ask CS first** — they know who's engaged, who has upcoming renewals, who's vocal
- **Email via CS** — cold emails from Product get ~10% response. CS intros get ~60%.
- **Incentive:** €100 Amazon voucher or early feature access
- **Lead time:** 2 weeks minimum. Domain experts are busy.
- **Segment:** Mix company sizes + experience levels. Don't just interview power users.

**Structure (60 min, remote via Zoom):**

| Time   | Section                 | What to Ask                                                                                        |
| ------ | ----------------------- | -------------------------------------------------------------------------------------------------- |
| 5 min  | **Intro**               | Thanks, purpose, confidential, recording OK?                                                       |
| 10 min | **Background**          | Role, how long in their domain, tools used, how often they do the key task                         |
| 20 min | **Current process**     | "Walk me through your last literature search." Follow the thread. Ask to screen-share if possible. |
| 15 min | **Pain points**         | "What's most frustrating?" "Where do you spend most time?" "What keeps you up at night?"           |
| 5 min  | **Tools & workarounds** | What else do they use? What hacks have they built?                                                 |
| 5 min  | **Wrap-up**             | Magic wand question. Anything else? Can we follow up?                                              |

**Good questions:**

- "Walk me through last time you..."
- "What happens when...?"
- "Why is that important?"
- "Can you show me?" (screen share)
- "Tell me more about that..."

**Bad questions:**

- ❌ "Don't you think X would be better?" (leading)
- ❌ "Would you use this feature?" (hypothetical — they'll say yes)
- ❌ "Do you like A or B?" (too narrow, too early)

**Quality bar: Interview is "done" when:**

- You can retell the user's workflow from memory
- You have 3+ direct quotes captured
- You found at least 1 thing that surprised you
- You can describe their biggest pain point in their words, not yours

### 2. Journey Mapping in Practice

**When:** After 3+ interviews. Never from assumptions alone.

**Remote setup:** Miro or FigJam board. Share screen. Can be async (team adds stickies, then sync to discuss).

**Steps:**

1. **Define scope:** One persona + one journey (e.g., "Sarah completes an end-to-end workflow")
2. **Stages (5-8):** Project scoping → Strategy creation → Search execution → Title screening → Abstract screening → Full-text review → Data extraction → Synthesis
3. **For each stage, map:**
   - Actions (what user does)
   - Touchpoints (your product, other tools, email, etc.)
   - Emotions (draw curve: high = confident, low = frustrated)
   - Pain points (red stickies, use actual quotes)
   - Opportunities (green stickies)
4. **Overlay BigQuery data** where available: time-on-task, drop-off rates, feature usage per stage
5. **Dot vote** on biggest opportunities

**Quality bar: Journey map is "done" when:**

- Based on real research (not guesses)
- Has at least 3 user quotes as evidence
- Shows emotions, not just actions
- Pain points are specific ("screening 500 titles takes 3 hours") not vague ("screening is hard")
- Team agrees on top 3 opportunities

**Output template:**

```
## Journey Map: [Persona] — [Journey Name]

**Based on:** [N] interviews, [N] shadowing sessions, BigQuery data
**Date:** [date]

### Stage 1: [Name]
- **Actions:** [what user does]
- **Touchpoints:** [where]
- **Emotion:** [😊/😐/😩 + why]
- **Pain points:** "[quote]" — [explanation]
- **Opportunity:** [what could improve]

[repeat for each stage]

### Top Opportunities (prioritized)
1. [opportunity] — [evidence]
2. [opportunity] — [evidence]
3. [opportunity] — [evidence]
```

### 3. Wizard of Oz in Practice

**Best for:** Testing AI features before building them. This method validates value before engineering investment.

**How it works:**

1. Build a believable UI (Figma prototype or simple frontend)
2. A human (domain expert, CS person) manually does what the AI would do
3. User interacts thinking it's a real system
4. You learn: Does the concept provide value? What do users expect? How should the system respond?

**Example — AI relevance scoring:**

- **Frontend:** Search results UI with relevance scores next to each item
- **Backend:** A domain expert manually scores 50-100 items
- **Test:** 3-5 users work with "AI scores" for 3-5 days
- **Learn:** Do they trust scores? What threshold feels right? Do they need explanations? How do they handle disagreements?

**Add realistic delays.** If real AI would take 2 seconds, don't respond instantly. Build response-time delays.

**Debrief:** After testing, reveal the wizard. Ask: "Would you have used this differently if you knew it was manual?" This reveals trust dynamics.

**Quality bar: Wizard of Oz is "done" when:**

- 3+ users tested over 3+ days (not just 1 session)
- You can answer: "Is this valuable enough to build?"
- You have specific requirements for the real system (not just "build AI")

### 4. Research Synthesis (Findings → Insights → Recommendations)

This is where most non-designers get stuck. Raw data ≠ insights.

**The difference:**

- **Observation:** "3 users mentioned they use Excel alongside the product"
- **Pattern:** "Users maintain parallel systems because the product doesn't export in their format"
- **Insight:** "Users need their data in familiar formats to trust the workflow — it's about control, not features"
- **Recommendation:** "Support export templates that match customers' existing report templates"

**Process (half-day, ideally w. team):**

1. **Dump everything** — write every observation on a sticky note (1 per note). Remote: Miro board.
2. **Silent grouping** — everyone silently moves notes into clusters. No talking. ~15 min.
3. **Name the groups** — what's the theme? "Trust issues," "Time sinks," "Workarounds," etc.
4. **Extract insights** — for each theme, write: "We learned that [users] [do/feel/need] [X] because [Y]"
5. **Generate HMW questions** — "How might we [address the insight]?"
6. **Prioritize** — dot vote on HMWs. Top 3-5 become the design brief.

**Quality bar: Synthesis is "done" when:**

- Themes are based on 2+ sources (not just one interview)
- Insights explain WHY, not just WHAT
- HMW questions are actionable (not too broad, not too narrow)
- Team agrees on top 3-5 opportunities
- You can explain findings to someone who wasn't in the research in <5 min

**Output template:**

```
## Research Synthesis: [Topic]

**Based on:** [sources]
**Date:** [date]
**Team:** [who participated in synthesis]

### Themes

**Theme 1: [Name]** (N sources)
- Observation: [what we saw/heard]
- Insight: [what it means]
- Evidence: "[quote]" — [user], "[quote]" — [user]
- Confidence: [HIGH/MEDIUM/LOW]

[repeat]

### How Might We...
1. HMW [question]? (from Theme [N])
2. HMW [question]? (from Theme [N])
3. HMW [question]? (from Theme [N])

### Recommended Next Steps
- [action] — [why] — [timeline]

### What We Still Don't Know
- [gap] — [how to fill it]
```

### 5. Competitive Analysis in Practice

**Map competitors by product area:**

| Product Area   | Direct Competitors             | Adjacent              |
| -------------- | ------------------------------ | --------------------- |
| Core workflow  | [list your direct competitors] | [list adjacent tools] |
| Secondary flow | [list your direct competitors] | [list adjacent tools] |
| Tertiary flow  | [list your direct competitors] | [list adjacent tools] |

**How to do it:**

1. Sign up (free trials) or watch demo videos
2. Try the core workflow as if you're a real user in your target segment
3. Note: onboarding experience, core flow, what's intuitive, what's confusing, what's missing
4. Screenshot key screens
5. Compare: where is your product better? Where are they better? What can you adopt?

**Remote-friendly:** Most competitors have free trials or public demos. This is pure desk research.

---

## Common Shortcuts

These combos come up all the time:

### "Users say X but we're not sure"

1. BigQuery: check if behavior matches claim (say-do gap check)
2. 3 interviews: validate qualitative
3. Synthetic user test: stress-test the finding
   → takes ~3 days

### "New AI feature idea"

1. Desk research (what exists, competitor analysis)
2. Wizard of Oz test (fake the AI, test the UX)
3. 5 user interviews with prototype
4. Pilot w. 3 customers
   → takes ~4-6 weeks

### "Something feels wrong but we can't pinpoint it"

1. Analytics review (BigQuery: drop-offs, time-on-task, error rates)
2. Ask CS: "what are users complaining about in [area]?"
3. Journey map (current state from data + 3 interviews)
4. Pain point prioritization
   → takes ~1 week

### "Need to decide between 2 design options"

1. A/B synthetic user test (Gazelle persona skill) — instant
2. 3-5 real user tests w. both options — 3-5 days
3. Compare w. BigQuery metrics if feature already exists
   → takes ~3-5 days

### "Customer escalated a problem"

1. Check Slack + Notion for prior reports of same issue
2. BigQuery: scope of impact (how many users, how often, which segments)
3. 1-2 quick interviews to understand context
4. Prioritization brief
   → takes ~1 day

### "Leadership wants 3 solutions before we pick"

1. 30-min HMW session → generate 5+ questions
2. Quick sketching → 3 distinct directions
3. 1-paragraph writeup per direction: what it is, pros, cons, effort
   → takes ~half day

---

## Method Combinations (What Chains Well)

| Chain                                        | When                    | Why                                   |
| -------------------------------------------- | ----------------------- | ------------------------------------- |
| **Desk Research → Interviews → Journey Map** | Starting any discovery  | Background → depth → visualization    |
| **Interviews + Shadowing**                   | Understanding workflows | Ask + observe = full picture          |
| **HMW → Brainstorming → Sketching**          | Any ideation            | Frame → generate → visualize          |
| **Paper Prototype → Clickable Prototype**    | Testing UI              | Fast → polished (increasing fidelity) |
| **Wizard of Oz → MVP → Pilot**               | AI features             | Fake → real → validated               |
| **BigQuery + Interviews**                    | Validating any claim    | Quant + qual = triangulation          |
| **Synthetic User Test + Real User Test**     | Quick then deep         | Fast signal → real validation         |
| **Analytics → CS Check → Interviews**        | Investigating a problem | Data → team knowledge → user voice    |

---

## Recruiting Users for Research

### Channels (fastest to slowest)

| Channel                   | Speed        | Quality                                      | How                                                   |
| ------------------------- | ------------ | -------------------------------------------- | ----------------------------------------------------- |
| **CS team**               | ⚡ Same day  | Good (they know who's engaged)               | Slack CS: "who's a good person to ask about [topic]?" |
| **Notion feedback board** | ⚡ Same day  | Medium (pre-existing feedback, no follow-up) | Search for relevant topics                            |
| **CS-introduced email**   | 🕐 3-5 days  | High (warm intro, higher response)           | CS sends intro, you follow up                         |
| **Direct email**          | 🕐 1-2 weeks | Medium (cold, ~10% response)                 | Recruitment email template below                      |
| **In-app prompt**         | 🕐 1-2 weeks | Variable (self-selected)                     | Banner or feedback widget                             |

### Recruitment email template

```
Subject: Help shape [feature area] — 60 min, €100 voucher

Hi [Name],

We're improving [specific area] in [product name] and want to learn from how you work.

• 60-minute video call
• Your experience and honest feedback
• €100 Amazon voucher
• Flexible scheduling over the next 2 weeks

Interested? Reply with your availability.

Thanks,
[Name], [Company] Product Design
```

### Who to recruit (mix these)

- 2-3 power users (use the product weekly+)
- 1-2 occasional users (use monthly)
- 1-2 from different company sizes (enterprise + SMB)
- 1 from a different role (RA or QM, not just Clinical Affairs)

---

## Remote Adaptations

Most user research is remote. Users may be spread across multiple regions and time zones.

| Method                   | In-Person               | Remote Adaptation                              | Tool              |
| ------------------------ | ----------------------- | ---------------------------------------------- | ----------------- |
| **Interviews**           | Face-to-face            | Video call, ask for screen share               | Zoom, Teams       |
| **Shadowing**            | Sit next to user        | "Share your screen and work normally"          | Zoom screen share |
| **Journey Mapping**      | Sticky notes on wall    | Digital board, async + sync                    | Miro, FigJam      |
| **Brainstorming**        | Room + sticky notes     | Digital board, timer, breakout rooms           | Miro, FigJam      |
| **Co-Creation Workshop** | Half-day in room        | 2-hour Zoom, tighter agenda, more async prep   | Miro + Zoom       |
| **Paper Prototype**      | Paper on table          | Draw on iPad, share screen                     | iPad + Zoom       |
| **Clickable Prototype**  | Laptop in front of user | Share prototype link, observe via screen share | Figma + Maze      |
| **Affinity Mapping**     | Wall of sticky notes    | Digital board, silent grouping                 | Miro              |

**Remote tips:**

- Sessions max 60-90 min (attention drops faster online)
- Send agenda + context 24h before
- Use "share your screen" aggressively — seeing > hearing
- Record everything (w. permission) — you'll miss things live
- Follow up with async questions if needed

---

## Methods NOT Worth Using (at Early/Growth Stage)

| Method                     | Why Not                                                                               |
| -------------------------- | ------------------------------------------------------------------------------------- |
| **Ethnographic research**  | Too slow, users are remote, can't visit offices                                       |
| **Focus groups**           | Hard to recruit domain specialists in groups. Enterprise B2B = 1-on-1 is more honest. |
| **Physical prototyping**   | SaaS, not physical product                                                            |
| **3D modeling**            | Not relevant                                                                          |
| **Theatrical prototyping** | Too complex for team size                                                             |
| **Business Model Canvas**  | Already have product-market fit, pricing model exists                                 |
| **Bodystorming**           | Remote team, physical acting doesn't translate to Zoom                                |

---

## When to Skip Service Design Entirely

- **Single UI fix** → just design + test, no process needed
- **Pure backend / technical** → no user impact, just build it
- **Urgent hotfix** → fix now, research later
- **Tiny incremental improvement** → A/B test or just ship w. version flag
- **No access to users** → desk research only (BigQuery + Notion + CS), flag the gap honestly

---

## Output Templates

### Research Brief (1-day research)

```
## Research Brief: [Topic]

**Date:** [date]
**Method:** Desk research (BigQuery + Notion + Slack)
**Time spent:** [hours]

### What We Found
- [finding 1] — source: [where]
- [finding 2] — source: [where]
- [finding 3] — source: [where]

### What We Still Don't Know
- [gap 1] — would need [method] to fill
- [gap 2]

### Recommendation
[1-2 sentences: what to do next]

### Confidence: [HIGH/MEDIUM/LOW]
[Why this rating]
```

### Insight Brief (1-week research)

```
## Insight Brief: [Topic]

**Date:** [date]
**Methods:** [list]
**Participants:** [N] interviews, [N] shadowing, BigQuery data
**Team:** [who did synthesis]

### Key Insights (prioritized)

**1. [Insight name]** — Confidence: [HIGH/MEDIUM/LOW]
Users [do/feel/need] [X] because [Y].
Evidence: "[quote]" — [user]. BigQuery: [data point].
→ Opportunity: [what we could do]

**2. [Insight name]** — Confidence: [HIGH/MEDIUM/LOW]
[same format]

**3. [Insight name]** — Confidence: [HIGH/MEDIUM/LOW]
[same format]

### How Might We...
1. HMW [question]?
2. HMW [question]?
3. HMW [question]?

### Recommended Next Steps
- [action] — [timeline]

### What We Still Don't Know
- [gap] — [how to fill]
```

### Concept Brief (after ideation)

```
## Concept: [Name]

**Problem:** [1 sentence]
**Solution:** [1 sentence]

### How It Works
[3-5 bullet points]

### Why This Direction
- Evidence: [what supports it]
- Fits: [how it fits the platform]

### Key Risks
- [risk 1] — mitigation: [how]

### Next Step
[prototype type] with [N] users — [timeline]
```

---

## Cross-Reference

| Source                                                      | What's There                                                   |
| ----------------------------------------------------------- | -------------------------------------------------------------- |
| `shared/service-design-knowledge/03-research-methods.md`    | Detailed how-tos for all research methods                      |
| `shared/service-design-knowledge/04-ideation-methods.md`    | Detailed ideation method guides                                |
| `shared/service-design-knowledge/05-prototyping-methods.md` | Detailed prototyping guides                                    |
| `shared/service-design-knowledge/07-tools-reference.md`     | Full 54-method reference + decision trees                      |
| Your team's research playbook (if available)                | Interview guide, shadowing guide, persona template, recruiting |
| `context-training/personas-reference.md`                    | Persona profiles + synthetic testing scenarios                 |
| `context-training/evidence-thresholds.md`                   | What counts as "enough" evidence per decision type             |
| `context-training/personas-reference.md`                    | Data-grounded personas (built by `/persona-builder`)           |
