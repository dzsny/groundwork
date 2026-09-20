# Patch-up — retrofitting an existing project

Companion to [workflow.md](workflow.md). It does not restate it.

The Groundwork Workflow assumes a project born under it: a BRD and spec, a design package, a
`SPRINT.md`. Most real projects have none of these — undocumented, design-less, some of them
live in production. This document defines how such a project is brought under the workflow
**without stopping its development and without a rewrite**.

The core idea: the workflow retrofits **in layers, cheapest and most self-healing first**. A
project adopts each layer as a unit; layers build on each other and are never skipped.

> **The layers are detected, not declared.** `init` reads the repository — branch
> split, `design/`, `SPRINT.md`, the gate register — records the level in `.groundwork.yaml`, and
> enables only the checks that can actually run there. Workflow-bound checks **degrade loudly**
> ("skipped: no `design/`") instead of passing green. A PR that lands `design/` promotes the
> repo on the next init. The ladder below is a promotion ladder the tooling recognizes on its
> own.

---

## Entry assessment

Before Layer 1 — ten minutes, one card per project:

| Dimension | Question |
| --- | --- |
| Traffic | Live in production? Internal only? Frozen? |
| Activity | Actively developed, occasional fixes, or untouched? |
| Tests | Any? Does CI run them? |
| Docs | Anything trustworthy? |
| AI surfaces | Does EVAL apply? |

The card fixes three things: which layers apply, the starting layer (always 1 — the question is
how far the project goes), and the named owner.

**Not every project must graduate.** A frozen internal tool may stay at Layer 1 permanently —
that is a *recorded decision on the card*, not neglect. The rule: **a project's layer must match
its risk.** Live and actively developed demands all four; frozen and internal justifies one.

**Prioritization across a portfolio:** order by **risk × activity**. Live systems under active
change first (highest risk of undesigned drift), live-but-quiet second, internal tools third,
frozen projects last or never.

---

## Layer 1 — Review discipline

*Day 1. Zero code understanding required.*

Everything in this layer applies to **new changes only** — no reading of the legacy corpus is
needed, which is why it can start immediately on every project at once:

- Branch protection on the integration and release branches (create the split if the repo has a
  single branch); feature branches + PR-first, no direct pushes.
- The full **Review process** chapter of the workflow: the three rounds, the clean-code pass,
  the ground rules, the Review-order section, the 500-line soft cap.
- **Conventional Commits** and atomic-commit discipline — this is what enables the cheap Round-2
  path and, later, generated changelogs.
- **Coverage ratchet initialized at the current number** — even if that number is 0 %. The
  ratchet only forbids *decreasing*; diff coverage ≥ 80 % applies to new changes. No wholesale
  test-writing campaign is demanded.
- Environment template (`.env.example`) created, and kept current from now on.

Two properties make this layer first:

1. **It is validation-first applied to retrofit.** The review layer starts fixing the codebase
   *before* anyone documents it: every touched file gets pulled toward the standard.
2. **The gate judges diffs, never the legacy corpus.** Pre-existing oversized or non-compliant
   files that are only touched lightly are explicitly out of scope. Retrofit never means
   "rewrite until the linter is happy".

**Working in Layer 1: `ticket-implementation` runs in lite mode.** There is no design to
resolve, so acceptance criteria come from the tracker ticket alone and the PR body is flagged
`lite mode`. This is sanctioned, not a loophole — per-step commit approval, the atomic commit
plan, the input gate and self-review all still apply, and the alternative is no discipline at
all. Layer-2 promotion removes the flag by restoring the design-resolution step.

---

## Layer 2 — Design reconstruction

Reverse-engineer the design package from the code — agent-assisted, **human-verified** — into
the standard pages in `design/`, including `security.md` (for a live project, the page that
matters most) and the org-required artifacts.

- `tech-rationale.md` is written as the **inferred** current rationale.
- `adr/` starts **empty**. Decision history is not fabricated; it begins with the first
  post-retrofit decision.
- Every reconstructed page carries an explicit banner:

  > **as-built, unverified** — this page describes what the code appears to do, not what was
  > verified or intended.

Then the crucial step: the reconstruction also yields a set of **de-facto user stories** — what
the system *does* — handed to product as the **draft spec**. Product reviews them and rules on
what it *should* do. That pass produces:

- the project's first frozen **spec baseline** (intent, finally written down), and
- the first entries of the **gap register**: every difference between de-facto and intended
  behavior, triaged immediately by the Phase 0 rule — implied by (now-written) intent → bug; new
  desire → CR.

**NFRs get numbers in this pass too.** An existing project has *implicit* NFRs — whatever it
currently sustains. Product either blesses those numbers or names better ones. The same goes for
model quality targets and gold data where the project has AI surfaces. Without them, Layer 3's
drills and eval gates cannot run.

From the moment `design/` exists: the **Changing canon** rules apply, `CODEOWNERS` covers the
directory, and the docs-in-same-PR rule is active.

*Skill:* `design-reconstruct`, then `spec-gap-check` against the reconstructed baseline exactly
as it would run against a new one.

---

## Layer 3 — Verify

*Enter the workflow at Phase 3.*

The reconstructed design is a set of hypotheses. Verify it like any other: mint TEST / LIVE /
DRILL / EVAL tickets into a retrofit `SPRINT.md` and run the Verify phase unchanged.

- **TEST** — build the missing test pyramid guided by what Layer 2 found load-bearing, not by
  coverage vanity: the riskiest paths first.
- **LIVE** — every outbound integration exercised against its real provider; the as-built pages
  are amended to **as-verified** page by page, dropping the banner.
- **DRILL** — drills against the Layer-2 NFR numbers. For a live project these are the first
  honest answers to "what happens when its database goes away".
- **EVAL** — where the project has model surfaces: gates and golden sets established *before*
  any further prompt changes.

Every discrepancy feeds the gap register through the standard triage intake. Layer 3 is, in
effect, **the project's first drift audit** — oversized, run once. After graduation the normal
1–2-week cadence takes over.

---

## Layer 4 — Retroactive go-live gates

*Live projects only.*

A project already in production never had a go-live phase; it gets one retroactively:

- Write `go-live-readiness.md` against **running production**. Every gate starts `open`; gates
  close only by the dated-observation rule.
- **Red verdicts are the priority queue** for the next sprints. An open gate on a live system is
  a known, named risk with an owner — strictly better than the unnamed risk it was yesterday.
- The **Release and hotfix** chapter is adopted at the first release cut after Layer 1: the
  first annotated tag on the current production state is the rollback anchor; release PRs and
  SemVer from then on. The expand–contract migration rule applies from the first post-retrofit
  migration.

---

## Exit criterion — graduation

A project graduates when:

- the design package has **no remaining as-built banners** — everything verified or corrected,
- the gate register has **no open red verdicts**, and
- it runs in **track OP** with the standard intake and the 1–2-week drift audit.

From graduation on, only [workflow.md](workflow.md) applies: a retrofitted project is
indistinguishable from a born-compliant one.
