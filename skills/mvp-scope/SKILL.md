---
name: mvp-scope
description: Cut the smallest end-to-end first release from an approved BRD and spec — decide which user stories are in the MVP and which are deferred, define the walking skeleton and the numeric exit criteria, and produce the scope that the first sprint plan is built from. Use when the user asks what the MVP should be, wants to cut or prioritize scope, says the spec is too big to build at once, or wants to go from a ready spec to a plan.
allowed-tools: Read, Write, Edit, Glob, Grep, Bash
---

# MVP scope

**Input:** a spec that `spec-gap-check` has passed, and the BRD it derives from.
**Output:** `mvp.md` — the bet, the exit criteria, the stories in and out, and the walking
skeleton. It is the scope input to `design-package` and `sprint-plan`.
**Template:** `${CLAUDE_PLUGIN_ROOT}/templates/requirements/mvp.md`.

An MVP is the **smallest end-to-end slice that is worth releasing and that tests the riskiest
assumption**. It is not the first half of the backlog, and it is not "everything, but rough".

> **Cut by outcome, never by quality.** Scope is removed at the level of a whole story. What
> survives is built to its full acceptance criteria — including the error flows, the permission
> checks and the NFRs it carries. An MVP with the error flows cut is not a smaller product, it
> is an unfinished one.

## Step 0 — Preconditions

1. Read the spec index. If `spec-gap-check` has not returned **ready for design** on it, say so
   and offer to run it. You can still scope a draft spec, but every choice rests on unknowns,
   and the user should see which ones.
2. Read the BRD priorities. **MVP** requirements are your starting set; **Later** ones are
   candidates only if the MVP set cannot form a working flow without them; **Won't** ones are
   out and stay out.
3. If the spec has no stories carrying MVP requirements, stop: that is a spec gap, not a
   scoping question.

## Step 1 — State the bet

Interview — one round, using the `interview` skill — on what this release is *for*:

- What must be true for the MVP to be worth building, and what is the riskiest assumption it
  tests? (A technical one, a demand one, a workflow one.)
- Who gets it first, and what do they do with it on day one?
- What would make the user declare it a success, in numbers? Draw these from the BRD's
  objectives and the spec's NFRs; if neither has the number, that is an open question for its
  owner, not something to settle here.
- Is there a hard date or budget the cut has to fit?

Write the answer as the bet — one paragraph. If the user cannot name a riskiest assumption, say
that an MVP with no assumption to test is just a small release, and ask whether that is what
they want.

## Step 2 — Find the walking skeleton

The **walking skeleton** is the thinnest flow from trigger to outcome that touches every layer
the product has — input, logic, storage, output, deploy. Find it by walking the MVP stories and
asking, for each: *can the skeleton run without this?* If yes, it is a candidate to defer.

Build order follows from it: skeleton first, then widen. Name the skeleton in `mvp.md` as a
flow, with the story ids it exercises.

## Step 3 — Draw the cut line

Present **one table** — every story, in or out, with your recommendation and the reason — and
let the user move rows. Ask about the borderline ones, not about all of them.

Tests for a story being in:

1. Does a BRD **MVP** requirement depend on it?
2. Does the walking skeleton need it to run end to end?
3. Does an exit criterion fail without it?

A story that fails all three is deferred, however attractive. A story the user wants in that
fails all three needs a reason written down — the reason is what survives the next scope fight.

**Respect the dependencies.** If an included story needs a capability another story owns —
login, a data feed, an admin step to make it operable — that story is included, or the
dependency is met some other named way. List the pulled-in stories and why.

**What does not get cut**, regardless of pressure — record it in `mvp.md` §5:

- Security and compliance requirements of the stories that remain.
- The NFRs those stories carry. A drill threshold the MVP skips is a gate it must still pass
  before go-live.
- Error and permission flows in the acceptance criteria.
- A named acceptance authority.

If the user wants to cut one of those, that is a change to the spec, with a change request — not
a scoping decision.

## Step 4 — Record and carry through

1. Write `mvp.md` at `paths.mvp` (default `requirements/mvp.md`). Deferred stories get a reason
   and a trigger to revisit.
2. In the spec's story index, set the **MVP** column to `yes` / `no` for every story. This is
   the one place the spec records MVP membership; `mvp.md` links to it, and the two must agree.
3. Add open questions with owner, due date and what they block. None → **None**.
4. Ask the sponsor or requestor to approve the cut, and record the approver and date. The
   person who owns the intent decides what the first release contains; you propose.

## Hand-off

The next single step is **`design-package`**, scoped to the MVP stories — it designs the
system the MVP needs, not the whole backlog. After design, **`sprint-plan`** reads `mvp.md` and
turns the included stories into tickets: stories not listed under *In the MVP* do not get
tickets.

Say this to the user in one line, because it is the point of the file: **anything not in the MVP
is not in the sprint.**

When Later stories are eventually pulled in, that is a **change request** against the frozen
spec scope, with its own design pass — the same triage rule as any other change.

## What failure looks like

| Failure | Why it hurts |
| --- | --- |
| Cutting the error flows to "ship faster" | The MVP ships and breaks in the first week; the cut was borrowed against it. |
| An MVP that is just the first N stories | No skeleton, so nothing runs end to end until the last story lands. |
| No exit criteria, or criteria with no numbers | Nobody can say whether the MVP worked, so it is never "done" or "failed". |
| Stories deferred but still in the sprint | The plan quietly rebuilds the whole backlog. |
| Silent scope growth after approval | Each addition is a small decision nobody reviewed. Route it as a change request. |
