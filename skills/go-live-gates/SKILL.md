---
name: go-live-gates
description: Create and maintain the go-live readiness register — the record of what has actually been verified before a system ships, with dated observations instead of assumptions. Use when the user asks whether something is ready to go live or ship, wants a launch or production-readiness checklist, needs to track verification verdicts, or wants to close, open or audit a readiness gate.
allowed-tools: Read, Write, Edit, Glob, Grep, Bash
---

# Go-live gates

**Object:** `design/go-live-readiness.md` — the go-live decision record. Not a checklist someone
ticks; a register of **dated observations**.

Template: `${CLAUDE_PLUGIN_ROOT}/templates/design/go-live-readiness.md`.

## The one rule

> **A gate closes only on a dated observation.**
>
> `✅ 2026-03-14 — load test at 1200 rps sustained p99 340 ms against the 500 ms target; run
> link, 40 min soak.`
>
> Never by inference from CI green. Never by "should be fine". A close without an observation is
> rejected in review.

Three consequences, all of which people try to route around:

- **Work that advances a gate but does not close it appends a dated progress note.** The verdict
  stays `open`. "Mostly done" is `open`.
- **Re-open on drift.** Touching the surface of a closed gate — a provider swap, an estate
  change, a config change, a dependency major version — flips it back to
  `open — <date> — <reason>`. The gate records that *something was observed to work*; change the
  thing and the observation no longer applies.
- **The register is the single source of truth.** Never duplicate it into a slide, a tracker
  epic or a status document. Link to it. A second copy is how a red gate becomes green in
  someone's deck.

## The gates

Instantiate the ones that apply; delete the ones that do not, with a one-line reason. An
inapplicable gate left in the register as permanently-open noise trains people to ignore the
register.

| Gate | Closes on |
| --- | --- |
| **Tests green** | All unit and integration tests green on the target environment, with a dated run |
| **Drills** | Each drill executed, against a threshold **derived from the spec's NFR numbers**. A drill without a threshold does not close anything |
| **Load** | Load test passed against the NFR numbers, at the stated percentile and duration |
| **Eval gates** *(AI surfaces)* | Every eval suite passing its spec-derived target, on a named model/prompt version. A gate with no target does not close |
| **Monitoring** | Alerts exist and **fire on the failure modes the drills exercised** — verified by an observed alert, not by the existence of a dashboard |
| **Runbooks** | A runbook exists for each drilled scenario, and someone who did not write it followed it |
| **Rollback** | A rollback drill *performed*: previous tag redeployed, migrations reversed. Not "we could roll back" |
| **Security** | One full security review, verdict dated and recorded |
| **Auditability** | The evidence trail exists: logs masked and retained per the compliance constraints, dated verdicts, tagged releases, decision history |
| **Integrations (LIVE)** | One row per outbound integration, each exercised against the **real provider**: auth, rate limits, error shapes, timeouts |
| **Sign-off** | The acceptance authority named in the spec has accepted, by name and date |

Compliance and legal approvals are a separate gate owned **outside** engineering; their
confirmations arrive through the spec. Engineering's share is the auditability row.

## Register format

```markdown
## <Gate name>
**Status:** open | ✅ closed
**Owner:** <name>
**Ticket:** <GL-3>

- `2026-03-02` — drill harness written, not yet run against the staging estate. *(progress)*
- `2026-03-14` — ✅ pod-kill drill: 3 of 3 runs recovered within 22 s against the 60 s
  threshold (NFR-4). [run link]
- `2026-04-01` — reopened: managed database moved to the new region; the recovery observation
  no longer applies.
```

Entries are append-only. Never rewrite history in the register — that is the record someone will
need during an incident review.

## Working the register

- **Gates owned by no ticket are reviewed at the mid-sprint check-in.** Nothing closes them
  automatically, and an unowned gate is how a launch slips in the last week.
- **Red verdicts are the priority queue.** On a retrofit of a live system especially: an open
  gate is a known, named risk with an owner — strictly better than the unnamed risk it was
  yesterday.
- When asked "are we ready?", answer from the register and nothing else: the open gates, their
  owners, and what each needs to close. Never estimate readiness from a feeling about the
  codebase.

## Release checklist vs. gates

The gates are the go-live decision, made once. The **release checklist** on each release PR is a
lightweight re-verify, not a re-run: smoke green · drills current · eval gates green ·
migrations rollback-safe · **no open red gate verdicts**. That last item is where the register
does its ongoing work.
