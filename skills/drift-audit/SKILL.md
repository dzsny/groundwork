---
name: drift-audit
description: Run a deep audit comparing what the design documents promise, what the code does, and what is actually deployed — and convert every finding into a triaged ticket. Use when the user wants to check whether documentation is still accurate, asks if the docs match the code, wants a periodic documentation or architecture health check, suspects the design has drifted, or wants stale docs found and fixed.
allowed-tools: Read, Glob, Grep, Bash, Agent, Write, Edit
---

# Drift audit

**Cadence:** every 1–2 weeks.
**Scope:** code ↔ `design/` ↔ deployed reality, plus `SPRINT.md` ↔ tracker consistency.
**Output:** **tickets, not reports.**

> An audit run that produces prose without tickets has failed. The finding-to-ticket conversion
> is the deliverable. Prose gets read once and forgotten; a ticket gets scheduled.

## 1. Compare three things, not two

The usual mistake is checking docs against code and stopping. There are three sources, and each
pair disagrees differently:

| Pair | Typical finding |
| --- | --- |
| **Design ↔ code** | The page describes a component, mechanism or flow the code no longer has — or the code grew one the page never mentions |
| **Code ↔ deployment** | A configuration default that the deployed environment overrides; a feature flag permanently on; a resource limit nothing in the repo knows about |
| **Design ↔ deployment** | The infrastructure page describes an estate that has moved, scaled or been replaced. This pair drifts fastest and is checked least |

Read the deployment sources properly: CI/CD definitions, infra-as-code, environment
configuration, container definitions, and whatever runtime state you can observe.

## 2. What to check, by page

- `architecture.md` — does every component still exist, with the stated responsibility? Does the
  data flow still follow those hops? Are there new components the diagram lacks?
- `tech-rationale.md` — is each choice still the choice? Does any entry's **revisit condition**
  now hold? Do the ADRs and this page still agree — a superseded decision with no matching
  rationale update is a finding.
- `infrastructure.md` — network, environments, and especially the **data-residency table**:
  does every store named in the architecture have a row, and is the region right?
- `communications.md` — does every external system the code calls have an entry? Do the stated
  error shapes, timeouts and rate limits match the client code?
- `security.md` — every enforcement point still enforced? Any new route, handler or job without
  an authorization check? Any new place personal data is stored or logged that the inventory
  lacks?
- `go-live-readiness.md` — has the surface of any **closed** gate changed since it closed? That
  gate re-opens.
- `SPRINT.md` ↔ tracker — statuses, dependencies, ids. **The file wins on intent; the tracker
  wins on status.** Report divergence; correct the tracker, not the file.
- Stale banners — any `as-built, unverified` page whose claims have since been verified, and any
  page that dropped the banner without verification.

For a large repository, fan the pages out as parallel subagents, each reporting findings in the
format below, then reconcile and triage centrally. Subagents report; you triage.

## 3. Triage every finding — before it becomes a ticket

Use the standard rule, and write the ruling on the ticket:

> **Implied by the design → it is a bug.** Fix it in sprint, no ceremony.
> **Not implied → it is a change request.** Design pass required.

Applied to drift, the question is *which artifact is wrong*:

- The **code** diverged from a design that still expresses the intent → bug: fix the code.
- The **design** is stale because reality legitimately changed, intent unchanged → a reality
  correction: amend the page (this needs no CR, only the design owner's ruling).
- The **intent** itself has changed — someone wanted different behavior and it arrived as code →
  change request. This is the important one. Code that quietly changed what a story promises is
  the exact failure the whole process exists to prevent, and it gets named as such.

A finding you cannot triage is a question for the design owner. Route it, do not guess.

## 4. Mint the tickets

Through the `sprint-ticket` skill, into the normal intake — not a separate "audit backlog",
which is where findings go to die. Each ticket carries:

- The finding, with its locations in **all three** sources
- The triage ruling and its reason
- Which artifact changes: the code, the page, or both

Severity ordering for the report: anything **security-relevant**, then anything that makes an
**incident harder to diagnose** (a wrong runbook, a stale alert), then correctness drift, then
cosmetic staleness.

## 5. Report

Short. The register of tickets minted is the output; the prose exists only to make it
reviewable:

```
# Drift audit — <date>

**12 findings → 12 tickets.** 3 bugs, 2 change requests, 7 reality corrections.

## Security-relevant
- **DRIFT-3** — `security.md` claims tenant checks at the repository layer; `reports.py:88`
  queries across tenants directly. → bug, CORE.

## Incident-relevant
## Correctness
## Staleness

## Could not triage — for the design owner
- …
```

Then one line on the **trend**: is drift accumulating or being paid down? That is the number
that tells the team whether the docs-in-same-PR rule is actually being followed, and it is the
only justification this ceremony needs.
