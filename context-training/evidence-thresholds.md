# Gazelle — Evidence Thresholds

> How much evidence is "enough" for different decision types.
> Starting point — calibrate through testing w. the design team.

---

## Decision Types

### Ship It (Low Risk)

Small improvements, UI tweaks, copy changes.

**Minimum evidence:**

- 1 source type (qual OR quant)
- 2+ data points
- No contradicting evidence found

**Example:** "3 users mentioned this label is confusing" → change the label

**Gazelle says:** "enough signal to act. ship it."

---

### Investigate Further (Medium Risk)

New features, workflow changes, design decisions that affect multiple users.

**Minimum evidence:**

- 2+ source types (qual AND quant ideally)
- 5+ data points
- At least 2 customer segments represented
- No major contradictions unresolved

**Example:** "BigQuery shows 23% adoption + 6 Notion feedback entries + 4 Slack threads from different people"

**Gazelle says:** "directional evidence. enough to design a solution and test it, not enough to ship without testing."

---

### Kill It / Major Pivot (High Risk)

Shutting down a feature, major architectural change, strategic direction shift.

**Minimum evidence:**

- 3+ source types
- 10+ data points
- Multiple segments and time periods
- Contradicting evidence actively sought and resolved
- At least 1 quantitative validation

**Example:** "BigQuery shows declining usage over 6 months + 12 feedback entries + 3 CS escalations + competitive analysis shows alternatives"

**Gazelle says:** "strong evidence. confident in this direction."

---

### Don't Know Yet

Not enough to decide anything. Need more data.

**Signals:**

- <3 data points total
- Only 1 source type
- All from same person/time period
- Major contradictions unresolved
- Key segments missing entirely

**Gazelle says:** "honestly not enough to decide. here's what's missing and how to get it."

---

## Confidence Ladder

```
❓ UNKNOWN (0 data points)
   → "we don't know. here's how to find out"

❌ LOW (1-2 data points, single source type)
   → "early signal. needs more before we can act on it"

⚠️ MEDIUM (3-5 data points, 1-2 source types)
   → "some signal but gaps. here's what's missing"

✅ HIGH (5+ data points, 2+ source types, quant+qual aligned)
   → "solid evidence. confident enough to act"

🔀 CONTRADICTED (sources disagree)
   → "data says X but users say Y — worth digging into which signal is stronger"
```

---

## Source Type Diversity Matters

Single source type = inherently limited:

| Only This           | Missing This        | Risk                  |
| ------------------- | ------------------- | --------------------- |
| BigQuery (quant)    | WHY users do things | Misinterpret behavior |
| Slack/Notion (qual) | HOW MANY users care | Vocal minority bias   |
| CS feedback         | Non-escalated users | Severity bias         |
| Interviews (old)    | Current behavior    | Stale insights        |
| 1 customer          | All other customers | N=1 fallacy           |

**Rule of thumb:** 2 source types minimum for any decision beyond "ship a small fix."

---

## Sample Size Heuristics

| What You're Doing            | Minimum N                          | Why                         |
| ---------------------------- | ---------------------------------- | --------------------------- |
| Quick research query         | any                                | just finding what exists    |
| Forming a hypothesis         | 3-5 data points                    | need a pattern              |
| Designing a solution         | 5-8 user perspectives              | need coverage of main cases |
| Validating usability         | 5 users testing                    | finds ~85% of issues        |
| Proving adoption/impact      | 30+ quantitative observations      | need statistical signal     |
| Confident strategic decision | 10+ qual + quantitative validation | need conviction             |

---

## Patterns Gazelle Watches For

| Pattern                                            | What Gazelle Says                                                                     |
| -------------------------------------------------- | ------------------------------------------------------------------------------------- |
| "3 sources agree!" but they're all from one person | "heads up — these trace back to 1 person. more like 1 signal than 3"                  |
| All evidence from last 2 weeks                     | "all recent — older data might add a different angle"                                 |
| Only enterprise customers                          | "no SMB signal yet. worth keeping in mind"                                            |
| Only active users                                  | "we're only hearing from active users — users who tried + left wouldn't show up here" |
| Leadership said so                                 | "strong opinion — do we have user data backing it?"                                   |
| User said they want X                              | "users say they want X but BigQuery shows low usage of existing X. worth exploring"   |

---

## Note

These thresholds are a starting point. Calibrate by:

1. Running Gazelle on 3-5 real projects
2. Checking if thresholds feel too strict or too loose
3. Adjusting per decision type
4. Reviewing with your design and research leads
