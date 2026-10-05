---
name: start
description: Take a project from an idea to a build-ready MVP plan, end to end — works out which stage the project is actually at (idea, BRD, spec, gap-checked, MVP cut, design, sprint plan) and runs the next one. Use when the user says they want to build something new, has an idea and no documents, has a BRD from somewhere else and no spec, asks "where do I start?", "what's the next step?", or wants the whole process from idea to MVP.
allowed-tools: Read, Write, Edit, Glob, Grep, Bash, Agent
---

# Start — idea to MVP

The router for the whole pipeline. It does not author anything itself: it finds out where the
project really is, names the **one** next step, and runs the skill that does it.

```
idea ─▶ BRD ─▶ spec ─▶ gap-check ─▶ MVP cut ─▶ design ─▶ sprint plan ─▶ build
        brd    functional-  spec-gap-   mvp-scope  design-    sprint-plan   ticket-
               spec         check                  package                  implementation
```

Each arrow is a gate with an artifact. A stage is **done when its artifact exists and passes
its check** — not when someone feels finished, and not when a document with the right name is
sitting in the folder.

> **Detect the stage; never assume it.** A user who says "I have a BRD" may have a thirty-line
> brainstorm. A user who says "just an idea" may have a complete requirements doc in a wiki.
> Look, then say what you found, with evidence.

## Step 1 — Detect

Read `.groundwork.yaml` if it exists, then check the artifacts in order. Do not ask what you can
see. Look at the configured paths first (`paths.brd`, `paths.spec`, `paths.mvp`,
`paths.design`, `paths.sprint`), then the defaults.

| Stage | Done when | If not done, run |
| --- | --- | --- |
| **1 · BRD** | A BRD exists with stable `BR-nnn` ids, a priority on each, objectives with numbers, and a named approver | `brd` — **Author** when there is only an idea, **Import** when the BRD exists elsewhere or has no ids |
| **2 · Spec** | A spec exists with a story for every MVP `BR-nnn`, and the mandatory sections are present | `functional-spec` — Author, or **Complete** when a partial spec exists |
| **3 · Gap-check** | `spec-gap-check` has returned **ready for design** on the *current* version of the spec | `spec-gap-check` |
| **4 · MVP cut** | `mvp.md` exists, is approved, and agrees with the MVP column of the story index | `mvp-scope` |
| **5 · Design** | The design pages the MVP needs exist, and no page still reads as an unfilled template | `design-package` (with `adr` for each significant choice) |
| **6 · Sprint plan** | `SPRINT.md` exists, its table parses, and every in-MVP story has tickets that meet the Definition of Ready | `sprint-plan` |
| **7 · Build** | The local MVP runs end to end — the phase boundary the workflow calls *Build ends* | `ticket-implementation`, reviewed with `code-review` |

Stages 1–6 are this plugin's front half; stage 7 hands over to the build skills. What comes
after — verification, go-live gates, release — is the rest of the workflow, and `go-live-gates`
and `release-cut` pick up from there.

**The BRD that was made somewhere else.** This is the case that motivated the pipeline, so
handle it deliberately. If the user brings a BRD from another session, tool or document, the
BRD stage is **Import**, not Author: normalize it, assign ids, lint it, and carry on. Do not
re-interview the user for what their document already says. And if there is a BRD but no spec,
do not let the process jump to design — the spec is what the design package, the NFR drill
thresholds and the acceptance criteria are built from, and leaving it out is the gap that makes
the later stages unfillable.

**Stale stages.** An artifact can be present and wrong. Flag it, and treat the stage as not
done, when:

- the spec references a BRD version that is no longer the latest;
- the gap-check verdict is older than the spec's last change;
- `mvp.md` lists a story that the spec no longer has (or the reverse);
- the design package carries an *as-built, unverified* banner on pages this flow produced.

## Step 2 — Report

Keep it under a screen:

1. **Where the project stands** — the last stage that is genuinely done, with evidence, one
   line each: *"1 · BRD — done: `requirements/brd.md` v0.4, 9 requirements, approved by J. Doe
   on 2026-09-30."*
2. **What is missing** — the stages after it, as the table above names them. No more detail
   than that.
3. **The next single step.** One. Not a backlog.

Then ask whether to proceed, and on yes run that skill. If the user wants a later stage first,
tell them plainly what that skips and what it will cost — *"Design without a gap-checked spec
means the NFR thresholds will be invented in the design instead of decided in the spec"* —
and then do what they decide. You advise on the order; you do not refuse it. The gates that
block are the user's own configured ones, not this skill's.

## Step 3 — Run the stage, then re-detect

After a stage's skill finishes, **re-run Step 1**. Report the new state and the next step
again. Stop when the user stops, or when stage 7 is reached.

Between stages, keep nothing in a hidden state file. The state lives in the artifacts: the
open questions in the BRD and the spec, the verdict on the gap report, the MVP flag in the story
index. A new session — or a different person — runs `start` and lands exactly where the last
one stopped.

## When the project already has code

If there is substantial code and no BRD, this is a retrofit, not a new project. Do not
interview the user as though nothing exists: say so, and route to `init` (assess the maturity
layer) and `design-reconstruct` (recover the design and the de-facto stories). The BRD is then
written *afterwards*, from the recovered stories, as a proposal for the requestor to confirm —
existing behavior is never an approved requirement on its own.

## When there is no configuration yet

`.groundwork.yaml` is not required to start the front half. The BRD, spec and MVP stages work
from defaults. When the project reaches design, run `init` so the layer, the tracks and the
paths are recorded; it will pick up the `requirements/` files that already exist.
