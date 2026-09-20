# Sprint plan — <project / milestone>

<!-- Canon for DESIGN INTENT: dependencies, acceptance criteria, track structure.
The tracker is canon for LIVE STATUS. On conflict this file wins and the tracker is corrected —
this file sits behind branch protection and review; a tracker field edit does not. -->

**Sprint:** <n> · **Window:** <start> → <end> · **Capacity:** <hours> · **Owner:** <name>

## Tickets

<!-- groundwork:sprint-table -->
| id | track | title | ETA | story | blocks | blocked-by | status | ticket |
| --- | --- | --- | --- | --- | --- | --- | --- | --- |
| CORE-1 | CORE | | | US- | | — | todo | |
<!-- /groundwork:sprint-table -->

<!-- Fixed column order — the markers make this table machine-readable. Do not hand-insert
rows: use the sprint-ticket skill, which propagates dependency edges, provides notes,
critical-path arithmetic and downstream cells. A hand-inserted row is how a plan starts lying. -->

## Critical path

`CORE-1 → CORE-2 → LIVE-1` = <n> d

**Per-track wall time:** CORE <n> d · DATA <n> d · PLAT <n> d

<!-- The longest dependency chain is the project's floor; everything else is slack. Per-track
totals tell you whether the lane assignment is balanced or whether one person IS the schedule. -->

## Join points

<!-- Where the parallel lanes meet. CORE/DATA/PLAT build against a local runtime from day 0;
INF provisions in parallel. These tickets are where INF's promises become verified facts. -->

| Join | Lanes | Ticket | Meaning |
| --- | --- | --- | --- |
| | | | |

---

## Ticket detail

### CORE-1 — <title>

**Track:** CORE · **ETA:** <n>h · **Story:** <US-id> · **Status:** todo

**Context:** <why this exists, what it is part of, which design page governs it>

**Design reference:** [architecture.md § <section>](design/architecture.md)

**Acceptance criteria:**

- [ ] AC-1 —
- [ ] AC-2 —

<!-- These are the ticket's contract. Round 1 of review checks the diff against exactly this
list. An AC with no test is not met. -->

**Provides (to its dependents):**

- **→ CORE-2:** `SessionStore.get(session_id) -> Session | None`, raising `SessionExpired`.

<!-- One provides note per blocks edge, naming the symbol, route, schema or artifact the
dependent will consume. Written once, consumed three times: the review's downstream check, the
implementation plan, and the dependent's input gate. A blocks edge without one is an unfinished
plan. -->

**Definition of Ready:** ☐ acceptance criteria ☐ dependencies resolved or scheduled
☐ design reference ☐ ETA

---

## Definition of Done — every ticket, every phase

- [ ] Code merged to its integration branch
- [ ] Unit tests cover the happy path and at least one failure mode
- [ ] Acceptance criteria met
- [ ] No new `TODO` without a ticket id
- [ ] Affected design pages updated **in the same PR**
