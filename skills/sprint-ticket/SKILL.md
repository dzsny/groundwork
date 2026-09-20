---
name: sprint-ticket
description: Mint a single new ticket into an existing sprint plan — insert the row, propagate dependency edges and critical-path arithmetic, and file the matching issue in the tracker. Use when the user wants to add a ticket, task or work item to a sprint or backlog, turn a review finding, bug or drift finding into a ticket, or file an issue from a design change.
allowed-tools: Read, Write, Edit, Glob, Grep, Bash
---

# Mint a ticket

**Trigger:** a ticket must exist — from a design pass, a review finding, a drift-audit finding,
or a bug.
**Output:** a **consistent** `SPRINT.md` *and* a tracker that agrees with it. Never just a table
row.

> A ticket inserted without propagation is worse than no ticket: the plan now shows a critical
> path that is wrong, and nobody knows it.

## 1. Propose every field with provenance

Each field you propose cites where it came from — the design page, the code line, the ticket,
the review comment. A wrong dependency then shows up as a **wrong reason**, which a human can
spot in seconds; a wrong dependency with no reason is invisible.

On a cold start — a bare title, no context — say so plainly and ask. Confident filler in a
planning document propagates into a schedule someone commits to.

## 2. Two fields always go to a human

- **Track** — it encodes lane ownership, which is a staffing decision, not an inference.
- **Estimate** — it feeds critical-path arithmetic. A confidently wrong number silently changes
  the schedule and nobody audits it.

Offer both with context ("this looks like DATA because the acceptance criteria name an external
API"; "comparable ticket CORE-4 took 6 h"). Never auto-fill them.

## 3. Allocate the id from file ∪ tracker

`max(ids in SPRINT.md ∪ ids on the board) + 1`, per track prefix.

Struck-through, cancelled and superseded ids **stay taken**. A reused gap silently aliases two
tickets, and every link to the old one now points at the new one. Check both sources — the file
alone is not enough, because tickets get filed directly on the board.

## 4. Insert, then propagate

All of it, in one pass:

- [ ] The table row, in the fixed column order, inside the `groundwork:sprint-table` markers
- [ ] The ticket's detail section: description with context, acceptance criteria
- [ ] The dependency DAG: the new node and **every** edge, in both directions
- [ ] A **provides** note on each new *blocks* edge — the symbol, route, schema or artifact the
      dependent will consume
- [ ] Every **downstream ticket's `blocked-by` cell** updated
- [ ] Stage gates — ask, do not infer
- [ ] Critical-path arithmetic, shown as **old → new**
- [ ] Per-track wall-time totals

Showing the critical path as `old → new` is what makes the insertion's cost visible. "14 d →
14 d" means it absorbed into slack; "14 d → 17 d" is a conversation someone needs to have today.

## 5. File it in the tracker

When `tracker.kind` is not `none`: file the issue by default, parented to its user story, and
write the created key back into the table row. Use the tracker's native fields for parent,
assignee, priority, status and blocks/blocked-by.

Do **not** copy requirements or acceptance criteria into the tracker description as editable
text — link the spec story at its approved version. The ticket carries the *work*; the spec
carries the *requirement*.

When `tracker.kind` is `none`, the row is the ticket. Say so, rather than silently skipping the
step.

## 6. File the review companion

Every ticket gets an `[RE]` review companion on the board:

- Estimate ≈ **20 %** of the original, floored at 30 minutes
- **Blocked by** its ticket
- Lives **only on the board** — no `SPRINT.md` row

Review is schedulable work, not an invisible tax on the author's estimate. The plan tracks the
build; the board tracks the total.

## 7. Verify the propagation

At the end, check — do not assume:

- The new id appears everywhere it must: its row, its section, every neighbor's dependency cell.
- **No total still shows the old number.** This is the most common failure: the row lands, the
  totals do not.
- The DAG has no cycle.
- Every *blocks* edge has a provides note.

A clean insert is not evidence of a correct one. Show the verification.

## Out of scope

Whether the ticket is warranted, what its priority is, which sprint it belongs to. This skill
**records a decision; it does not make one.** If the ticket should not exist, say so once — then
do what you are asked.
