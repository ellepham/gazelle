# Gazelle — Domain Context (Example)

> This is an example of a completed domain.md file for a fictional company called **Acme Analytics**.
> Use this as a reference when filling in your own `domain.md`.

**Last updated:** 2026-04-12

---

## Company

**Company:** Acme Analytics
**Description:** AI-powered business intelligence platform that turns raw data into executive dashboards in minutes.
**Domain:** B2B SaaS / Data Analytics
**Stage:** Growth (Series B, 200 customers)
**Size:** ~80 employees (30 engineering, 8 design, 15 sales, 10 CS, rest ops/leadership)

---

## Product

Acme Analytics is a cloud-based BI platform. Users connect their data sources (Snowflake, BigQuery, PostgreSQL, CSV), and Acme's AI layer auto-generates dashboards, detects anomalies, and sends alerts. The product targets ops/analytics teams at mid-market companies (200-2000 employees) who don't want to hire a dedicated data team.

### Modules / Feature Areas

| Module               | Description                                             |
| -------------------- | ------------------------------------------------------- |
| Connectors           | Data source integrations (20+ connectors)               |
| AI Dashboard Builder | Auto-generates dashboards from natural language queries |
| Anomaly Detection    | Alerts when metrics deviate from expected patterns      |
| Scheduled Reports    | Automated email/Slack reports on cadence                |
| Embedded Analytics   | White-label dashboards for customers' customers         |

---

## Users

| Role         | Description                                  | Key Goals                                              |
| ------------ | -------------------------------------------- | ------------------------------------------------------ |
| Ops Manager  | Non-technical; needs quick answers from data | Get a dashboard without writing SQL                    |
| Data Analyst | Semi-technical; builds custom views          | Faster iteration than raw SQL; share with stakeholders |
| VP/Director  | Decision maker; reviews dashboards           | Trust the data, act on insights                        |
| Developer    | Integrates embedded analytics                | Clean API, good docs, fast renders                     |

---

## Terminology

| Term          | Meaning                                                                  |
| ------------- | ------------------------------------------------------------------------ |
| Connector     | A data source integration (Snowflake, BigQuery, etc.)                    |
| Insight       | An AI-generated observation about the data (anomaly, trend, correlation) |
| Dashboard     | A collection of charts/tables showing key metrics                        |
| NLQ           | Natural Language Query — asking questions in plain English               |
| Embed         | A dashboard embedded in a customer's own product via iframe/SDK          |
| Anomaly Score | 0-100 confidence that a metric change is meaningful, not noise           |

---

## Competitors

| Competitor     | Overlap                | Differentiation                                                           |
| -------------- | ---------------------- | ------------------------------------------------------------------------- |
| Looker         | Full BI platform       | Acme is 10x faster to set up; no LookML learning curve                    |
| Metabase       | Open-source dashboards | Acme's AI layer auto-generates dashboards; Metabase requires manual setup |
| Mode Analytics | SQL + notebooks        | Acme targets non-technical users; Mode requires SQL knowledge             |
| ThoughtSpot    | AI-driven analytics    | Acme is cheaper, better for mid-market; ThoughtSpot targets enterprise    |

---

## Team

- **Product:** Sarah (VP Product), James (PM - Connectors), Priya (PM - AI/Dashboards)
- **Design:** Marcus (Design Lead), 2 product designers
- **Engineering:** 30 engineers across 4 squads (Connectors, AI, Platform, Embedded)
- **Sales:** Lisa (VP Sales), 10 AEs, 5 SDRs
- **CS:** 8 CSMs, 2 Solutions Engineers
