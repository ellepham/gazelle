# /jira-ticket — Lean Jira Ticket Generator

Generate lean Jira tickets from design specs. Defaults to a "minimal but complete" house style (no dependencies, no design-spec refs, outcome-focused ACs) — adjust for your team's conventions in `context-training/`.

> **After:** `/design-spec`, `/acceptance-criteria`, or `/gazelle` discovery
> **Before:** Refinement / estimation sessions

## When to Use

- "create jira tickets", "write tickets for", "jira tickets from spec"
- "ticket this feature", "write stories for [epic]"
- After a design spec is finalized and ready for dev handoff
- When preparing tickets for a refinement session

## Input

One of:

1. **Spec file path** — reads the spec, identifies stories, generates tickets
2. **Feature description + Figma URL** — generates tickets from description
3. **Epic key** (e.g., `PROJ-1234`) — required for parenting tickets

## Ticket Format (Default House Style)

```markdown
[User story one-liner: "As a [user], I want to [action] so that [outcome]"]

## Figma

- [Frame name — description](https://www.figma.com/design/FILE_KEY/FILE_NAME?node-id=NODE_ID)
- [Frame name — edge case](https://www.figma.com/design/FILE_KEY/FILE_NAME?node-id=NODE_ID)

## Acceptance Criteria

- Bullet point AC 1 (high-level outcome, not implementation detail)
- Bullet point AC 2
- Bullet point AC 3
- (5-7 bullets total)

## Open Questions (optional — only if unresolved decisions exist)

- Question 1

## API Suggestions (optional — only for stories with API work, at bottom)

- Endpoint suggestion 1
```

## Rules

1. **User story format:** "As a [user], I want to [action] so that [outcome]"
2. **Figma:** Deep links to specific frames (not the whole section). Use `get_metadata` to extract frame IDs from the Figma file. Each link = one screen the dev will implement
3. **ACs:** 5-7 bullet points. Plain bullets (NOT checkboxes). High-level outcomes, not pixel specs
4. **Title format:** Match your team's convention. Default suggestion: `[Module] - [Feature] - [Story name]`
5. **Type:** Story | **Parent:** Epic key provided by user
6. **Labels:** Match the epic's label convention

## What NOT to Include

- Dependencies section (discussed in refinement, not written in tickets)
- Design Spec references (devs look at Figma, not spec files)
- Edge case sections (edge cases are separate Figma frames linked above)
- Data storage details (backend decides)
- Checkboxes in ACs (use plain bullets)
- Granular implementation specs (keep ACs outcome-focused)

## Workflow

1. Read input (spec file, feature description, or Figma URL)
2. If Figma URL provided: use `get_metadata` to extract frame names + node IDs
3. For each story: draft ticket in the format above
4. **Present all drafts for review** — wait for approval
5. On approval: create via Atlassian MCP (`mcp__atlassian__createJiraIssue`) with:
   - `cloudId`: your Atlassian site (e.g. `your-org.atlassian.net`) — read from `context-training/data-sources.md`
   - `project`: your project key (e.g. `PROJ`)
   - `issuetype`: Story
   - `parent`: epic key from user
   - `labels`: match epic convention
   - `contentFormat`: "markdown"
6. Report ticket numbers

## Figma Frame Extraction

When a Figma URL is provided:

1. Call `mcp__figma__get_metadata` with fileKey + nodeId from the URL
2. Parse the XML for direct child `<frame>` elements (name + id)
3. Map frames to stories based on naming convention (e.g., "1 — Returning user" → returning user story)
4. Generate deep links: `https://www.figma.com/design/{fileKey}/{fileName}?node-id={id-with-dashes}`

## Connections

- **Upstream:** `/design-spec` produces specs → `/jira-ticket` turns them into tickets
- **Upstream:** `/acceptance-criteria` produces ACs → `/jira-ticket` formats them
- **Upstream:** `/gazelle` discovery → spec → `/jira-ticket`
- **Downstream:** Created tickets go to refinement / estimation

## Example

Input: "Create tickets for [Feature Name] V2 under PROJ-1234, spec at projects/active/[feature]/design/specs/v2-sprint-spec.md, Figma at https://www.figma.com/design/FILE_KEY/..."

Output: 4 tickets (PROJ-1235 through PROJ-1238) in lean format with deep Figma links per story.
