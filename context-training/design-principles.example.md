# Gazelle — Design Principles (Example)

> This is an example of a completed design-principles.md for the fictional **Acme Analytics**.

**Last updated:** 2026-04-12

---

## 1. Company Values (Foundation Layer)

| Value                          | What It Means in Practice                                                 |
| ------------------------------ | ------------------------------------------------------------------------- |
| **Clarity over cleverness**    | Reduce complexity. If it needs a tutorial, simplify it.                   |
| **Trust through transparency** | Show users how we got the answer. No black-box AI.                        |
| **Speed of insight**           | Time-to-value matters more than feature count.                            |
| **Data democracy**             | Everyone should be able to answer questions with data, not just analysts. |

---

## 2. Product & Design Principles (Working Layer)

| Principle              | What Gazelle Should Enforce                                               |
| ---------------------- | ------------------------------------------------------------------------- |
| Progressive disclosure | Show the minimum needed; reveal complexity only when requested            |
| Defaults that work     | Every dashboard, query, and visualization should be useful out of the box |
| Show, don't tell       | Use visualizations and examples, not documentation walls                  |
| Undo over confirmation | Let users undo instead of blocking with "Are you sure?"                   |
| Guided, not gated      | Help users learn by doing, not by completing onboarding flows             |

---

## 3. AI-Specific Design Principles

| Principle          | Guideline                                                                     |
| ------------------ | ----------------------------------------------------------------------------- |
| Transparency       | Show the SQL behind every AI-generated dashboard. Users can edit it.          |
| Confidence scoring | Every AI insight shows an anomaly score (0-100). Low scores get a warning.    |
| User override      | Users can pin, dismiss, or edit any AI suggestion. AI never auto-publishes.   |
| Explainability     | "This metric spiked because..." — always include the reasoning chain.         |
| Graceful fallback  | When AI can't answer, suggest manual query paths instead of failing silently. |

---

## 4. Design System

**Name:** Orbit DS
**Frontend stack:** React + Tailwind CSS
**Component library:** Custom built on Radix primitives
**Styling approach:** Tailwind with design tokens as CSS variables

### Brand

**Primary color:** #2563EB (blue)
**Secondary color:** #64748B (slate)
**Accent color:** #10B981 (emerald — for positive metrics)
**Error color:** #EF4444 (red — for anomalies and alerts)
**Typography:** Inter (UI), JetBrains Mono (SQL/data), weight 400/500/600

### Key Patterns

- **Tables:** Virtualized rows for >100 items, sortable columns, sticky header
- **Charts:** Recharts library, consistent color palette, always include legend
- **Empty states:** Illustration + clear CTA + link to docs
- **Loading:** Skeleton screens, never spinners
- **Forms:** Inline validation, errors below field, debounced validation
- **Modals:** Max 1 modal deep, no modal-in-modal. Use slideovers for complex forms.
- **Toasts:** Bottom-right, auto-dismiss after 5s, include undo action where applicable

---

## 5. Design Decision Makers

| Role        | Name   | Cares About                                                |
| ----------- | ------ | ---------------------------------------------------------- |
| Design Lead | Marcus | Craft quality, consistency, brand alignment, accessibility |
| VP Product  | Sarah  | User impact, business metrics, competitive positioning     |
| Tech Lead   | Arun   | Performance, bundle size, API design, maintainability      |

---

## 6. Critique & Review Culture

- **Weekly design critique:** Thursdays 2pm — present WIP, get feedback from whole design team
- **Async reviews:** Figma comments for small changes; Loom videos for complex flows
- **PM review:** Required before engineering handoff. PM approves scope + edge cases.
- **Design QA:** Designer reviews implementation against Figma before release
