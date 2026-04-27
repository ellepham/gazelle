# Demo Recording Script

A 30-second terminal recording showing Gazelle in action. Record with [asciinema](https://asciinema.org/) or [VHS](https://github.com/charmbracelet/vhs).

---

## Setup Before Recording

1. Install Gazelle into a clean workspace
2. Run `/setup` with a fictional company ("Acme Analytics", BI platform, 200 customers)
3. Pre-populate some state so the demo shows rich output fast
4. Connect at least Notion MCP (or have web search available)

## The Recording (30 seconds)

### Scene 1: The Hook (5 sec)

```
$ # Gazelle — AI product design agent
$ # 38 skills. Evidence-based. Honest about gaps.
```

### Scene 2: Research (10 sec)

```
$ /research "dashboard adoption drop-off" --quick
```

Show the output streaming:

- "Searching Notion..." / "Searching Slack..." / "Searching filesystem..."
- The evidence ledger appearing with findings, confidence ratings
- **Highlight:** The "Gaps" section where it flags what's missing
- **Highlight:** Source links on every finding

### Scene 3: Chain to Insights (8 sec)

```
$ /insights "dashboard adoption"
```

Show:

- "Reading research state..."
- Insights appearing with HMW questions
- **Highlight:** Confidence rating (MEDIUM — because no analytics data)

### Scene 4: Chain to Design Spec (7 sec)

```
$ /design-spec "dashboard redesign"
```

Show:

- "Reading research + insights state..."
- User stories with evidence citations
- Requirements table with priority + evidence column
- **Highlight:** "Open Questions" section — things it doesn't know

### End Card

```
$ # github.com/ellepham/gazelle
$ # pip install... just kidding. It's markdown.
$ # ./install.sh --claude && /setup && go.
```

---

## Key Moments to Capture

These are the frames that make the GIF compelling:

1. **Parallel search** — when multiple "Searching..." lines appear simultaneously
2. **Evidence table** — the structured output with source links
3. **Confidence rating** — the honest "MEDIUM — no analytics data" moment
4. **Gaps section** — where Gazelle flags what's missing
5. **State chaining** — "Reading research state..." showing automatic handoff

## Alternative: Longer Demo (60 seconds)

Add after Scene 4:

### Scene 5: Pre-Mortem

```
$ /pre-mortem "dashboard redesign"
```

Show Tigers / Paper Tigers / Elephants appearing. The Elephant that says something uncomfortable and true.

### Scene 6: Competitive Analysis

```
$ /competitive-analysis "Looker"
```

Show the comparison matrix with "What They Do Better" section (the honest part).

---

## Recording Tips

- Use a dark terminal theme with good contrast
- Set font size to 16pt+ so it's readable in a small GIF
- Speed up the "thinking" pauses, keep the output visible longer
- End on the GitHub URL
- Target 800x400px for README embedding
- Loop the GIF with a 2-second pause at the end
