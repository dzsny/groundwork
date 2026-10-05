---
name: functional-spec
description: Create a functional specification (FS) from a BRD — the full set of user stories, non-functional requirements with numbers, traceability back to the BRD, and every other mandatory section — or complete a partial spec so that spec-gap-check passes. Use when a BRD exists (made here or anywhere else) and no spec does, when the user wants to write an FS or spec from requirements, turn a BRD into user stories, fill the gaps a gap-check found, or asks "what do I need before design can start?".
allowed-tools: Read, Write, Edit, Glob, Grep, Bash, Agent
---

# Functional spec

**Input:** a BRD with stable requirement ids.
**Output:** a spec that `spec-gap-check` can pass — the complete set of user stories, the
cross-cutting sections, and the traceability from every BRD requirement to the stories that
deliver it.
**Templates:** `${CLAUDE_PLUGIN_ROOT}/templates/requirements/functional-spec.md` (the index and
cross-cutting layer) and `${CLAUDE_PLUGIN_ROOT}/skills/user-story/template.md` (one per story).

> **You do not invent what the spec needs and the user has not said.** Latency targets, budgets,
> legal confirmations, named acceptance authorities, gold-data owners — these are the sections
> that go missing, and they are exactly the ones a plausible guess poisons. An unknown is
> recorded as an open question with an owner and carried forward. It is never filled in.

The spec is the **detail layer engineering works from**. It owns requirements; the design
package never copies them.

## Step 0 — Find the BRD, and check it is usable

Look in this order: an explicit path or link from the user, `paths.brd` in `.groundwork.yaml`,
`requirements/brd.md`, then the usual places (`docs/`, `spec/`). If it is not in the repository,
ask the user for it.

| Situation | What you do |
| --- | --- |
| No BRD exists | **Stop.** Do not derive requirements from nothing. Run the `brd` skill (Author mode), then come back. |
| A BRD exists, in the repo, with ids | Proceed. |
| A BRD exists, but outside the repo or without ids | Run `brd` in **Import** mode first. This is the common case when the BRD was made in another session or tool. |
| Only code exists, no BRD | Not this skill. Use `design-reconstruct`, which recovers de-facto stories and marks them as proposals. |

If the BRD is unapproved, you may proceed — but say so at the top of your report. Every story
that rests on an unresolved BRD question inherits it, and the user should see which.

If `paths.spec` already points at an existing spec, you are in **Complete** mode (below); never
overwrite someone's spec with a new one.

## Step 1 — Derive the story map (the first interview round)

Read every `BR-nnn`. For each, propose the stories that deliver it, split by **outcome**, not
by technical layer — see `user-story` § Splitting. Present the map as one table and put it to
the user as the first round of the interview:

| BR | Priority | Proposed stories (id — outcome) | Actor |
| --- | --- | --- | --- |

Then ask, in one round: is any story missing, is any too large to accept in one decision, and
is any BR you could not cover because the BRD is too vague to know what "done" would mean? That
last category becomes an open question against the **BRD**, owned by the requestor.

Never create a story for something the BRD does not ask for. If a story seems *necessary* but
has no BRD anchor — say, an admin screen to make a requirement operable — propose it flagged
**unanchored** and let the user decide. Scope the requestor never approved is a decision, not a
detail.

Won't-priority requirements get no stories. Later-priority requirements get **stub entries** in
the index (id, title, BR) so the set is visibly complete, but are not written out until their
turn.

## Step 2 — Interview for the cross-cutting sections

Run the `interview` skill over this tree. Skip branches the BRD already answers — read it
first — and skip anything marked inapplicable by the project's config (`project.ai_surfaces`
false removes the model-quality branches; no UI removes the UI branch).

```
Actors & permissions ─ who may do what ─ which data each sees
 ├ Non-functional: latency (percentile, load) ─ availability ─ throughput ─ data volume ─ recovery
 ├ Model quality (AI only): task ─ metric ─ threshold ─ method ─ gold data owner ─ fallback if none
 ├ UI (where one exists): design links ─ the state matrix
 ├ Legal: what must be confirmed ─ by whom ─ by when
 ├ Compliance: personal data ─ retention ─ masking ─ audit events
 ├ Data access: what data ─ who grants ─ by when
 ├ Budget: infrastructure and third-party envelope ─ at what load
 └ Acceptance authority: a named person for each story
```

Rules specific to this spec:

- **Numbers are load-bearing.** A target needs a value, a percentile or condition, and a load.
  "p95 under 400 ms at 50 concurrent users" is a number. "Fast" is a wish. Your recommended
  answer may propose a value — it stays a proposal until the user confirms it, and is then
  recorded `decided: <name>, <date>` in the Source column.
- **A named person, not a role.** "Product" is not an acceptance authority. Ask for the name.
  When the user is the only person involved, they are the authority — and they say so.
- **Gold data (AI only).** Who provides the evaluation set, and by when? If the honest answer
  is nobody, the mitigation — synthetic generation plus expert validation, staged thresholds —
  is decided *here*, with an owner, not discovered during verification.
- **Unknowns** become `UNKNOWN — Q-nn` in the table and a row in open questions, with owner,
  due date and what the unknown blocks.

## Step 3 — Write the spec

Layout, in the directory that holds `paths.spec` (default `requirements/spec.md`, so
`requirements/`):

```
requirements/
  brd.md                    # owned by the requestor — input only
  spec.md                   # the index and cross-cutting sections
  stories/
    US-001-<slug>.md        # one story each, from the user-story template
  mvp.md                    # written later, by mvp-scope
```

One file per story is deliberate. A story is approved, versioned and frozen on its own, and a
version-pinned link to a single file is something a ticket can hold.

1. Copy the spec template to `spec.md` and complete sections 1–13.
2. For each story, run the `user-story` skill — it owns the story's structure, its
   GIVEN/WHEN/THEN criteria, its error flows, and the line between approval and delivery
   acceptance. Do not paraphrase the template here; follow it.
3. Fill the **traceability table** (spec §4) and the **story index** (§3), carrying each BR's
   priority through to its stories.
4. Mark inapplicable sections **"Not applicable — reason"**. Never delete one, never leave a
   bracketed placeholder.

Write every story's `Requirement` field as the exact `BR-nnn` it traces to. This is the field
`spec-gap-check` reads in both directions.

**If the spec lives somewhere else.** When `paths.spec` is a URL — a wiki, a document system —
the spec's home is that system, and a second editable copy in the repo would drift. In that
case write the same content to a local draft file, tell the user where to paste or import it,
and treat the external page as canon once it is there. Never maintain both.

## Mode: Complete

A spec exists, and it is partial: it was written elsewhere, or a gap-check bounced it.

1. Run `spec-gap-check` first. Its gap report **is** your work list — do not re-derive it.
2. Take the blocking gaps in the order the report gives them. Group them by owner and run one
   `interview` round per owner.
3. Edit the existing spec in place. Change only what a gap requires; do not tidy, restructure
   or reword sections the check did not flag.
4. Re-run `spec-gap-check` and report the new verdict.

## Step 4 — Verify, then hand off

Run `spec-gap-check` against what you wrote and report its verdict in full. Do not soften it.
Two outcomes:

- **Ready for design.** Say so, then name the single next step: **`mvp-scope`** to cut the
  first release, or `design-package` when the whole spec is the first release.
- **Not ready.** List the blocking gaps by owner — those are the agenda for the next
  conversation with the people who can answer them. Design does not start until they close.
  Say it plainly; a spec that is "mostly done" is not a spec design can start from.

Finally, remind the user of the **freeze**: when design completes, the spec freezes, and any
later change to a story needs a change request with its own design pass.

## What failure looks like

| Failure | Why it hurts |
| --- | --- |
| An NFR the user never gave you | Becomes a drill threshold, then a go-live gate, and nobody learns it was fiction. |
| Stories split by layer — "API story", "UI story" | Neither can be accepted alone. |
| A story with no `BR-nnn` | Scope the requestor never approved. |
| A BR with no story, silently | An uncovered promise, discovered at acceptance. |
| "Product" as the acceptance authority | Nobody can say "done". |
| Restating the BRD in each story | Two editable copies of the same requirement. Link by id. |
| Solution detail in the spec | Tables, classes and algorithms belong in the design package. |
