# Gazelle — Data Sources Reference (Example)

> This is an example of a completed data-sources.md for the fictional **Acme Analytics**.

---

## Connected Tools

| Tool     | Type             | MCP Connected?     | What to Search                                      |
| -------- | ---------------- | ------------------ | --------------------------------------------------- |
| Notion   | Knowledge base   | Yes                | Product specs, PRDs, meeting notes, decisions       |
| Slack    | Communication    | Yes                | #product, #design, #engineering, #customer-feedback |
| BigQuery | Analytics        | Yes (via Omni MCP) | User events, feature adoption, funnel metrics       |
| Figma    | Design           | Yes                | Component library "Orbit DS", design files          |
| Linear   | Project tracking | No                 | Feature requests, bug reports, sprint boards        |
| Intercom | Support          | No                 | Customer conversations, feature requests            |

---

## Knowledge Base (Notion)

**Workspace:** Acme Product
**Key pages:**

- "Product Strategy 2026" — roadmap, OKRs, quarterly themes
- "PRDs" database — one page per feature spec
- "User Research" — interview notes, survey results, usability tests
- "Design Decisions" — ADR-style records of key design choices
- "Competitor Intel" — ongoing competitive analysis

**Search tips:** PRDs use tags like `[Connectors]`, `[AI]`, `[Embedded]` for module scoping.

---

## Team Communication (Slack)

**Workspace:** acme-analytics.slack.com
**Key channels:**

- #product — product decisions, launch announcements, roadmap discussions
- #design — design critiques, component library updates, brand discussions
- #engineering — architecture decisions, incident postmortems, tech debt
- #customer-feedback — CS team shares raw customer feedback, feature requests
- #data-science — ML model updates, experiment results, data quality
- #shipped — automated posts when features go live

---

## Analytics (BigQuery via Omni)

**GCP Project:** `acme-analytics-prod`
**Dataset:** `analytics.events`
**Access:** Omni MCP for natural language queries; BigQuery console for raw SQL

### Key Tables

| Table                  | Description                                      | Use for                               |
| ---------------------- | ------------------------------------------------ | ------------------------------------- |
| `analytics.events`     | All product events (page views, actions, errors) | Feature adoption, funnels, engagement |
| `analytics.users`      | User profiles with plan, company, role           | Segmentation, persona validation      |
| `analytics.dashboards` | Dashboard metadata (created, viewed, shared)     | Content creation metrics              |
| `analytics.queries`    | NLQ queries + AI-generated SQL                   | AI feature usage patterns             |

### Event Schema

```
event_name: string
user_id: string
timestamp: datetime
properties: {
  page: string
  action: string
  module: string  (connectors | ai_builder | anomaly | reports | embedded)
  company_id: string
  plan: string  (starter | pro | enterprise)
}
```

---

## Design (Figma)

**Design system:** "Orbit DS" — component library in Figma
**File URL:** (your Figma file URL)
**Component conventions:** PascalCase names, variants use `/` separator (e.g., `Button/Primary/Large`)
**Tokens:** Colors and spacing defined as Figma variables

---

## Meeting Notes (Circleback)

**Connected:** Yes
**Key meeting types:**

- Weekly product sync (Sarah + PMs + Design)
- Bi-weekly design critique
- Monthly customer advisory board
- Sprint retrospectives

---

## Other Sources

- **Google Drive:** Shared sales decks, customer case studies
- **GitHub:** Code context, PR discussions, architecture decisions in ADRs
- **Intercom:** Customer conversations (not MCP-connected — search manually or export)
