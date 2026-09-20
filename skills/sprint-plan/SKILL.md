---
name: sprint-plan
description: Turn a design into an executable sprint plan — a machine-readable SPRINT.md with tracks, dependencies, estimates and a critical path — or schedule an existing one against a capacity budget or a milestone. Use when the user wants to plan a sprint, break a design or feature into tickets, needs a work breakdown with dependencies, asks how long something will take or what fits in a given capacity, or wants a sprint retro with velocity calibration.
allowed-tools: Read, Write, Edit, Glob, Grep, Bash
---

# Sprint plan

Three modes. Say which one you are in.

- **Author** — turn a completed design into `SPRINT.md`.
- **Schedule** — assign ready tickets to people, in capacity or demand mode.
- **Retro** — compute the calibration factors that keep the estimates honest.

`SPRINT.md` is canon for **design intent**: dependencies, acceptance criteria, track structure.
The tracker is canon for **live status**. On conflict the file wins and the tracker is
corrected — the file sits behind branch protection and review; a tracker field edit does not.

---

## Mode: Author

Read the design package first. A sprint plan authored without reading `design/` produces
plausible tickets that do not add up to the system.

### Choosing tracks

Walk the taxonomy as a **menu** and instantiate only what applies. The full menu with
definitions is in `${CLAUDE_PLUGIN_ROOT}/docs/workflow.md` § Track taxonomy: CORE · DATA ·
PLAT · INF · TEST · LIVE · DRILL · EVAL · GL · OP · (SEC).

In practice a track is **one person's lane for a sprint**: tickets with a shared subject that
mostly depend on each other and rarely on other lanes, so people run in parallel and meet only
at named join points.

Small projects collapse tracks — one person may own CORE+DATA. What never collapses are the
phase boundaries: Build ends when the local system runs end to end; Verify ends when nothing is
hypothetical; go-live ends at sign-off.

To classify a ticket, ask **what would falsify its success?** A failing unit of product logic →
CORE. A surprising external API → DATA in build, LIVE in verify. A broken deploy → PLAT or INF.
A bad answer despite working code → EVAL.

### The table

Fenced with the marker so tooling can parse it. Fixed column order:

```markdown
<!-- groundwork:sprint-table -->
| id | track | title | ETA | story | blocks | blocked-by | status | ticket |
| --- | --- | --- | --- | --- | --- | --- | --- | --- |
| CORE-1 | CORE | Session state store | 6h | US-003 | CORE-2, DATA-1 | — | todo | #41 |
<!-- /groundwork:sprint-table -->
```

Below the table, one section per ticket with its **description with context** and its
**acceptance criteria**. Acceptance criteria are the ticket's contract — they are what Round 1
of review checks against.

Every **blocks** edge carries a one-line **provides** note naming the symbol, route, schema or
artifact the dependent will consume:

```markdown
### CORE-1 → CORE-2
**provides:** `SessionStore.get(session_id) -> Session | None`, raising `SessionExpired`.
```

Written once, consumed three times: the review's downstream-dependency check, the
implementation plan, and the dependent ticket's input gate. A *blocks* edge without a provides
note is an unfinished plan.

### Definition of Ready

A ticket cannot be scheduled without **all four**: acceptance criteria · resolved or scheduled
dependencies · a design reference · an ETA. Mark tickets that miss one; do not quietly schedule
them.

### Two lanes

CORE/DATA/PLAT build against a local runtime from day 0 — nobody waits on infrastructure. INF
provisions in parallel, on its own owner's schedule. **Name the join points** in the plan: the
specific tickets where the lanes meet, e.g. "deploy to the real cluster + smoke". Those are
where INF's promises become verified facts, and they belong to LIVE.

### The critical path

Compute it and show it. The longest dependency chain by cumulative ETA is the project's floor;
everything else is slack. Show per-track wall-time totals too — that is what tells you whether
the lane assignment is balanced or whether one person is the schedule.

---

## Mode: Schedule

Two modes, chosen with whoever owns capacity:

**Capacity mode** — given a budget (e.g. 200 h over 3 weeks) and *n* people:

1. Filter to **unblocked, Definition-of-Ready** tickets. Refuse the rest, by rule — this is what
   actually enforces DoR.
2. Apply the per-track calibration factor to each raw ETA.
3. Respect dependency order and per-person lane ownership.
4. Fill each person's budget; stop when it is full. Report what did not fit and what the first
   thing off the list is.

**Demand mode** — given a target milestone, state the hours needed: the critical path plus the
parallelizable remainder, calibrated, with the assumption set written out.

**Out of scope, both modes:** changing estimates or priorities. You schedule what the tickets
say and report when the numbers do not fit. Adjusting an estimate to make a plan work is how a
schedule becomes fiction.

---

## Mode: Retro

Produce the calibration table, per track, on two layers:

**Velocity — always on, zero ceremony.** Per track: the sum of estimates of tickets *completed*
in the sprint ÷ the capacity given. Needs no timestamps and no time logging. A track that
completed 60 h of estimates on 100 h of capacity has a factor of 0.6: next sprint, 100 h of
capacity buys 60 h of estimates. This factor alone keeps "200 h worth of tickets" a credible
number instead of a drifting fiction.

**Logged hours — refinement, where it exists.** Estimate vs. logged time gives the true
per-ticket effort error, which separates "we estimate badly" from "we get interrupted". When
logging discipline lapses, calibration degrades to velocity — say so, do not fabricate.

Then the process findings: which tickets blew their estimate and why, which dependencies were
discovered rather than planned, which join points slipped. Findings become tickets or process
changes, not prose.

---

## Updating an existing plan

Never hand-edit the table when adding a ticket — use the `sprint-ticket` skill, which propagates
the dependency edges, the provides notes, the critical-path arithmetic and the downstream cells.
A hand-inserted row is how a plan starts lying.
