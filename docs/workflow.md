# The Groundwork Workflow

The process this plugin mechanizes. Read it once; the skills enforce it from then on.

> **Thesis:** defined process → necessary skills → automated workflows → freed-up human
> attention. The process comes first. Skills mechanize its repetitive parts. Humans keep only
> the judgment calls.

This document is deliberately tool-agnostic. It names an *issue tracker*, not a vendor; a
*spec*, not a wiki product. Everything it requires lives either in the repository or in
whatever system your team already uses, configured once in `.groundwork.yaml`.

---

## Principles

1. **Validation-first / PR-first.** Code fails and designs have gaps — plan for it. Every
   change enters through a pull request and a defined review gauntlet. This is also
   *self-healing*: when a *development* rule changes nobody retro-fixes the codebase, but when
   a *review* rule changes every future PR applies it and assimilated errors get fixed as code
   is touched. Invest in review rules over dev rules.
2. **Complexity is the enemy of progress.** When two approaches solve the same problem, take
   the simpler one — and simple is measured *from the reader's seat*: easier to review, reason
   about, and change later. Not always the shorter or the cleverer one.
3. **Accountability.** The author owns everything in their PR regardless of what generated it.
   "The AI wrote it" is never an answer in review.
4. **Single source of truth.** Every fact lives in exactly one place; everything else links to
   it. Two copies always drift, and drift is silent.
5. **Raise, don't bury.** Problems surface at the source, loudly and early — in code (fail
   fast, no bug-hiding fallbacks) and in process (a design disagreement is raised, never
   silently diverged from). Silence is the only failure mode.
6. **Build for now.** Solve the problem the spec states, not the one you imagine coming after
   it. Speculative generality is complexity paid today for a future that usually never
   arrives — and when it does, it arrives as a change request with its own design pass.
7. **Boring technology.** Prefer proven, well-understood tech; spend the novelty budget where
   the product actually differentiates. Every exotic choice needs an ADR justifying what the
   boring option could not do.

---

## The two requirement layers

| Layer | Owner | Nature |
| --- | --- | --- |
| **BRD** — business requirements | The requestor | Approved intent. Input only; engineering never maintains it. |
| **Spec (FS)** — functional specification | Product/PM/BA | The detail layer engineering works from. Versioned and frozen per user story. |

**Mandatory spec sections** (the checklist `spec-gap-check` runs):

- User stories — the complete set
- Non-functional requirements **with numbers** — latency, availability, throughput. Drill
  thresholds are derived from these; no numbers → no drills → no go-live.
- Model quality targets (AI surfaces) **with numbers**, *plus* gold-data availability: who
  provides the evaluation sets, by when. If nobody can, the mitigation is decided here, not
  discovered during verification.
- UI design, where applicable
- Legal confirmations
- Compliance constraints — PII, retention, audit
- Data-access grants — what data, who provides credentials, by when
- Budget (cloud / third-party spend)
- **Acceptance authority** — the named person who says "done", per user story

The spec typically arrives incomplete. Completing it is Phase 0's job. Design starts only on a
gap-free spec.

---

## Phase 0 — Intake and freeze

1. Run a **gap check** on the spec: missing mandatory sections, ambiguities, contradictions —
   plus a **BRD↔spec coverage check** so everything the BRD promises appears in the spec.
2. Gaps found → **stop.** Iterate with product until the spec is complete.
3. When design completes, the spec **freezes**. Adding or modifying a user story from then on
   requires a change request with its own design pass.

**Triage rule** — the boundary that keeps the freeze honest:

> If the behavior is already implied by the spec or the design, it is a **bug** — fix in
> sprint, no ceremony. Otherwise it is a **CR** — design pass required.

The design owner arbitrates; the ruling is written on the ticket.

*Skill:* `spec-gap-check`.

---

## Phase 1 — Design

### The design package

The repository's `design/` directory is **canon** — read before substantial changes, updated
in the same PR as the behavior it describes. Standard pages:

| Page | Holds |
| --- | --- |
| `architecture.md` | High-level architecture diagram + data flow |
| `tech-rationale.md` | *Current* rationale: choices and rejected alternatives |
| `adr/` | Decision history — traceability only, immutable |
| `infrastructure.md` | Network topology, data residency, environments |
| `communications.md` | External contracts — every inbound/outbound integration |
| `security.md` | Authentication, authorization, data handling |
| `go-live-readiness.md` | The gate register |

There is deliberately **no in-repo functional spec**: the spec owns requirements. Design pages
and tickets reference user-story ids; UI designs and legal confirmations stay in the spec,
linked, never copied.

Common org-required artifacts map to exactly one home each — no standalone duplicates:

| Required artifact | Home |
| --- | --- |
| High-level architecture | `architecture.md` — opening diagram |
| Data-flow diagram | `architecture.md` § Data flow |
| Network-flow diagram | `infrastructure.md` § Network |
| Data residency and classification | `infrastructure.md` § Data residency |
| Authentication & authorization | `security.md` |

### ADRs

`tech-rationale.md` carries the **current** rationale — why things are the way they are *now*,
updated when a decision is superseded. It is the page reviewers and agents work from.

Every significant technical decision *additionally* lands as an ADR in
`design/adr/NNN-<slug>.md` with **Context / Decision / Consequences / Status**, kept for
traceability only: immutable, never edited, only superseded (`Status: superseded by NNN`).
Nobody works from ADRs — they relate to `tech-rationale.md` the way git history relates to
code.

A change of technical intent therefore means a new ADR **and** the matching `tech-rationale.md`
update, in the same PR.

*Skills:* `design-package`, `adr`, `design-reconstruct`.

### Changing canon

Canon status begins at design completion — the same moment the spec freezes. From then on
exactly four paths may change it:

**Intent change** (stakeholders want different behavior):

1. **CR with a design pass** — the only path that may add or modify user-story-level behavior.
   Big CRs re-enter Phase 1 entirely.

**Reality corrections** (the world turned out different; intent unchanged):

2. **Implementation-discovered gaps** — a developer finds the design wrong, ambiguous or
   impossible mid-ticket. Rule: **raise it, never silently diverge.** The design page is
   corrected *in the same PR as the code that adapts to it* — never as a follow-up.
3. **Verification findings** — the promised API does not behave as documented, an infra
   assumption does not hold, a drill exposes a wrong number. The design is amended from
   *as-designed* to *as-verified* in the finding's PR.
4. **Drift-audit findings** — code-vs-design divergence detected after the fact → ticket
   through the Phase 0 triage intake → correction PR.

Paths 2–4 change the *description of reality*, not the *intent*, so they need no CR ceremony.
The moment a "correction" would alter what a user story promises, it is path 1.

Enforcement: `design/` lives behind branch protection like everything else, and a `CODEOWNERS`
entry makes the design owner a required reviewer on every PR touching it.

### Track taxonomy

Tracks partition ownership and dependency chains. Ticket ids carry the lane (`CORE-3`,
`DRILL-2`), so the id alone tells you who owns it and roughly where the project stands.

| Track | What it handles | Phase |
| --- | --- | --- |
| **CORE** | The product's brain — the domain logic that *is* the product | Build |
| **DATA** | Everything that feeds or leaves the brain — ingestion, stores, external clients. If the acceptance criteria name someone else's API or a schema, it is DATA. | Build |
| **PLAT** | The shell the product runs in, built *from inside the repo* — API skeleton, container image, CI, observability wiring | Build |
| **INF** | The estate, built *from outside the repo* — IaC, clusters, managed services, networking, secrets. Separate owner and permission model, which is why it is not PLAT. | Build, parallel lane |
| **TEST** | "Does the code do what we think" — integration tests, golden sets, coverage depth | Verify |
| **LIVE** | "Do other people's systems do what they promised" — every outbound integration exercised against the real provider. The deliverable is a dated verdict, not code. | Verify |
| **DRILL** | "What happens when things break" — chaos, failover, load, measured against the spec's NFR numbers | Verify |
| **EVAL** | "Is the model output actually good" — eval gates, judge rubrics, golden answers, prompt promotion | Verify + Operate |
| **GL** | The checklist lane — tickets close gates in the readiness register: verdicts, not features | Go-live |
| **OP** | Steady state — bugfixes, small CRs, drift findings, prompt maintenance | Post-go-live |
| **SEC** | *Optional.* Regulated or high-exposure projects only | any |

Small projects collapse tracks (one developer may own CORE+DATA). What never collapses are the
**phase boundaries**:

- **Build ends** when the local MVP runs end to end. Everything external may still be
  hypothetical.
- **Verify ends** when nothing is hypothetical — every promised API and infra assumption has
  been exercised for real.
- **Go-live ends** at sign-off.

At design time, walk the taxonomy like a **menu** — "does this project need DATA? EVAL? SEC?" —
and instantiate only what applies. To classify a ticket, ask *what would falsify its success?*
A failing unit of product logic → CORE. A surprising external API → DATA (build) or LIVE
(verify). A broken deploy → PLAT or INF. A bad answer despite working code → EVAL.

**Two-lane agreement:** CORE/DATA/PLAT build against a local runtime from day 0 — nobody waits
on infrastructure. INF provisions in parallel. The sprint plan names the **join points** where
the lanes meet (e.g. "real-cluster deploy + smoke") — the places where INF's promises become
verified facts.

### Design output: `SPRINT.md` + tickets

The design's executable form is a `SPRINT.md` in the repo plus the corresponding tracker
issues. Every ticket carries:

> **track · ETA · story link (or —) · dependencies (blocks / blocked-by) · description with
> context · acceptance criteria · tracker link**

Each *blocks* edge carries a one-line **provides** note naming the symbol, route or artifact the
dependent will consume. Written once, consumed three times: the review's downstream-dependency
check, the implementation plan, and the dependent's input gate.

The table is **machine-readable by contract**: fixed column order, fenced with a
`<!-- groundwork:sprint-table -->` marker.

**Definition of Ready** — a ticket cannot be scheduled without: acceptance criteria · resolved
(or scheduled) dependencies · design reference · ETA.

**Definition of Done** — every ticket, every phase:

- [ ] Code merged to its integration branch
- [ ] Unit tests cover the happy path and at least one failure mode — the per-ticket floor, not
      the standard; the full coverage gate lives in review/CI
- [ ] Acceptance criteria met
- [ ] No new `TODO` without a ticket id
- [ ] Affected design pages updated **in the same PR**

**Source-of-truth rule:** `SPRINT.md` is canon for *design intent* — dependencies, acceptance
criteria, track structure. The tracker is canon for *live status*. On conflict `SPRINT.md` wins
and the tracker gets corrected: the file sits behind branch protection and review; a tracker
field edit does not.

*Skills:* `sprint-plan`, `sprint-ticket`.

---

## Phase 2 — Build

### Scheduling

Two modes, chosen per sprint:

- **Capacity mode:** given a budget (e.g. 200 h over 3 weeks), select unblocked tickets by ETA
  and dependency order and assign across the developers.
- **Demand mode:** engineering states the hours needed to hit a milestone.

**Calibration loop** — every retro recalibrates per track, on two layers:

- **Velocity (always on, zero ceremony):** per track, the sum of estimates of tickets
  *completed* divided by the capacity given. Needs no timestamps and no logging. This factor
  alone keeps "200 h worth of tickets" honest.
- **Logged hours (refinement, where present):** ETA vs. logged time gives the true per-ticket
  effort error. When logging discipline lapses, calibration degrades to velocity.

### Branch and commit discipline

- Every ticket branches as `feature/<TICKET-ID>-<slug>` off its work-stream's **integration
  branch** and PRs back to it. The release branch is separate.
- **The branch name carries the ticket id; commits and code do not.** Commit messages describe
  behavior; planning ids live in the branch and the PR.
- **Conventional Commits scoped by module** — `feat(agents): …`, `chore(infra): …`. This is
  load-bearing: the release changelog is generated from it.
- **Atomic commits** — one behavioral change per commit, message states exactly that change.
  Atomic history buys the cheap review path; squashed history sends you back to a full
  re-review. Plan the commit sequence before writing code.

**Two integration strategies** — they differ *only* in where ticket PRs land; review, release
and hotfix are identical in both:

- **Ticket-based (default):** the integration branch is the shared development branch itself.
  Fastest integration.
- **Story-based (opt-in per story/CR):** the story gets its own integration branch carrying the
  same branch protection while it lives; its tickets branch off it; the whole story lands
  atomically once it works end to end. Two obligations: **sync-merge the development branch in
  at least weekly**, and the final merge is a merge commit with a *lightweight* check —
  sync-merges happened, CI green, no unreviewed commits — never a content re-review.

### Ceremonies

| Ceremony | Cadence | Output |
| --- | --- | --- |
| Mid-sprint check-in | Weekly | Re-scheduling decisions, blocked-ticket escalations |
| Sprint retro | Per sprint | Calibration table, process findings |
| Drift audit | Every 1–2 weeks | Findings → tickets via the Phase 0 triage rule |

*Skills:* `sprint-plan`, `ticket-implementation`.

---

## Review process

Review is where validation-first lives or dies.

### Ground rules

- Comments target **lines or files**; actionable or it does not get posted.
- **No merge with unresolved comments.** The reviewer resolves; the author responds.
- Every PR body carries a **Review order** section: files/groups in dependency-leaf-first
  order, a one-line summary each, estimated review time.
- **Cross-track reviewer** — at least one reviewer from outside the ticket's track, so context
  spreads.
- **First review response within 1 business day.**
- **Soft cap: 500 changed lines per PR**, excluding lockfiles, generated files, docs and
  docstrings. Above it: justify in the PR body or split.

### The rounds

**Round 1 — automated pass, human-filtered.** On the checked-out branch, verify: **design
compliance** against `design/` · **acceptance criteria** met, from the `SPRINT.md` row ·
**downstream dependency requirements** satisfied, checked against the *provides* notes · the
**clean-code pass** · the **security pass** when the PR touches auth, PII, external input or
outbound calls. In parallel a human reads the ticket, PR description and design pages.

> **Filtering rule:** *agent-produced* findings are human-validated — right branch, no
> hallucinations, no stale code — before they are posted. *Tool-produced* findings (grounded in
> file, line, symbol) post directly.

**Round 2 — commit by commit.** If Round 1 left little, skip to Round 3. Otherwise check that
Round-1 comments were answered, and walk the new commits **one by one**, verifying each does
exactly what its message says. This only works on atomic history — **a big or squashed commit
is effectively a new PR and re-enters Round 1.** That asymmetry is deliberate: it makes atomic
commits the cheapest path through review, which does more for commit hygiene than any rule.

**Round 3 — manual.** Guided by the Review-order section. The rules never cover everything; the
human eye is the last line, and its findings become new rules.

### Test coverage gate

- CI: diff coverage **≥ 80 %** on every PR, plus a project-wide floor that may **never
  decrease** (ratchet).
- Round 1 checks that tests assert *behavior* — no tautologies, no assertion-free tests gaming
  the ratchet.
- Coverage *depth* (integration, golden sets) is built in Verify / track TEST; the CI gate only
  guards the baseline.

### Clean-code invariants

- Every applicable rule is **pass**, a **justified exception**, or a **fail** — never silently
  skipped; failures block until fixed.
- Rules marked *soft* allow a justified exception; everything else is a hard fail.
- The gate judges **the diff**, never the legacy corpus.
- Universal rules apply to every language; language-specific rules only to files of that
  language.
- It is a *quality* gate — correctness bugs are the rest of Round 1's job.

*Skill:* `code-review`.

---

## Phase 3 — Verify

Everything Build treated as hypothetical becomes real. Bugs found here **close as bugs now** —
not as surprises at go-live.

- **TEST** — the test pyramid: integration tests against real local services, domain golden-set
  gates, coverage depth.
- **LIVE** — every outbound integration exercised against the **real provider**: auth flows,
  rate limits, error shapes, timeouts. Each verification gets a dated verdict in
  `go-live-readiness.md`.
- **DRILL** — chaos (dependency down, process kill), failover, load. **Thresholds come from the
  spec's NFR numbers** — a drill without a threshold is theater.
- **EVAL** — eval gates and prompt quality, plus **prompt promotion discipline**: no prompt
  reaches a production label without passing its gate. **Targets and gold data come from the
  spec** — a gate without a target is theater, same as drills. EVAL outlives this phase and
  continues into Operate, because prompts keep changing after code freezes.

**Infrastructure joins here:** the INF lane's join points are LIVE tickets — deploy to the real
environment, smoke, verify every managed-service assumption.

### Security placement

Security is **not a standing track** by default; it enters at three fixed points:

1. **Design, per story:** every story touching auth, PII, external input or outbound calls gets
   a lite threat pass; the outcome is *security acceptance criteria on the normal tickets*.
2. **Review:** PRs touching those surfaces get the security pass in Round 1.
3. **Go-live gate:** one full security review verdict before sign-off.

Escape hatch: regulated or high-exposure projects *may* instantiate a dedicated SEC track at
design time.

---

## Go-live — track GL

Gates, each with a written, dated verdict in `go-live-readiness.md`:

- All drills, unit and integration tests green on the development environment
- Load test passed against the NFR numbers
- Eval/prompt gates green
- Monitoring **sufficient and automated** — alerts fire on the failure modes the drills
  exercised
- Runbooks exist for the drilled scenarios
- Rollback drill performed (tag redeploy + migration reversibility)
- Security review verdict — internal engineering review. Legal/regulatory compliance is a
  separate gate owned outside engineering; engineering's share is **auditability**: the
  evidence trail exists (masked/retained logs per the compliance constraints, dated verdicts,
  tagged releases, decision history)
- **Sign-off by the acceptance authority** named in the spec

**Promotion pipeline:** `dev → (SIT → UAT) → prod`. Parenthesized stages are adopted per org
maturity; until they exist, the substitute is stakeholder UAT on the development environment
plus a soak period before the release cut.

*Skill:* `go-live-gates`.

---

## Release and hotfix

**Release cut.** Merging a story-closing PR to the development branch makes it *eligible*. The
cut itself is a deliberate release PR `develop → main` — product decides content, engineering
decides readiness. It merges with a **merge commit, never a squash**: the branches keep shared
history and the atomic, behavior-per-commit history survives on the branch that gets tagged.
On merge an **annotated SemVer tag** lands: minor per story/CR bundle, patch for fix-only cuts
and hotfixes, major for breaking external contracts.

- **Changelog** — generated from Conventional Commits, grouped by story; it *is* the release PR
  body.
- **Images** tagged `<version>+<git-sha>`; deployments **pin tags, never `latest`**.
- **Rollback** = redeploy the previous tag. What makes that real: **expand–contract
  migrations** — every schema change is backward compatible for one version (add and dual-write
  in one release, remove in a later one). A migration that cannot roll back one version fails
  review.
- **Release checklist on the release PR** (lightweight re-verify, not a Verify re-run): smoke
  green · drills current · eval gates green · migrations rollback-safe · no open red gate
  verdicts.

**Hotfix.** Qualifies only when production is broken or materially degraded and cannot wait —
everything else is a regular bugfix. `hotfix/<ticket>` off the release branch → expedited PR
(still PR-first: one reviewer + Round 1) → patch tag → deploy → **back-merge into the
development branch**. Automate the back-merge: it is the step everyone forgets, until the next
release cut regresses the fix.

*Skill:* `release-cut`.

---

## Phase 4 — Operate: track OP

One track for steady state. Inside it, ticket **types** as labels, not sub-tracks: `bugfix` ·
`CR` · `drift-finding` · `eval maintenance`.

**The boundary rule:** every CR gets a design pass — size decides where it happens. A **small
CR** stays in OP: the design owner updates the affected page/ADR and mints the tickets. A CR
big enough to need **its own mini sprint plan** re-enters Phase 1 and gets regular tracks. OP is
steady state; the moment something needs a plan, it is not steady state. This rule exists to
prevent OP from silently becoming a second, undesigned development lane.

**Drift audit** — every 1–2 weeks, a deep automated + manual check of code vs. design vs.
reality. Findings become tickets **through the same Phase 0 triage intake**: implied by design →
bug; not implied → CR. *An audit that produces reports instead of tickets has failed.*

*Skill:* `drift-audit`.

---

## Enforcement matrix

*A rule with no enforcer is a wish.* Unenforced rows are your automation backlog.

| Rule | Enforced by |
| --- | --- |
| Spec completeness + BRD↔spec coverage | `spec-gap-check` |
| Spec freeze / CR triage | Design owner's ruling, written on the ticket |
| Canon changes (`design/`) | PR review + `CODEOWNERS` |
| Definition of Ready | `sprint-plan` refuses non-ready tickets |
| Definition of Done | `code-review` Round 1 + CI |
| `SPRINT.md` ↔ tracker consistency | `drift-audit`; `SPRINT.md` wins |
| Branch naming, protected integration branches | Branch protection + CI |
| Conventional Commits | `commit-lint` hook + CI |
| Atomic commits | Round 2's cheap-path incentive |
| PR ≤ 500 changed lines (soft) | Round 1: justify or split |
| Design compliance, AC, downstream deps | Round 1, human-filtered |
| Clean-code rules | Round 1 static + judgment passes |
| Security on sensitive surfaces | Round 1 security pass + GL gate |
| Diff coverage ≥ 80 % + ratchet | CI |
| Behavioral (non-tautological) tests | Round 1 + mutation testing |
| Docs updated in the same PR | `docs-in-same-pr` hook + Round 1 + drift audit backstop |
| No merge with unresolved comments | Repository merge settings |
| NFR-derived drill thresholds | GL gate refuses threshold-less drills |
| Spec-derived eval targets + gold data | GL gate refuses target-less eval gates |
| Expand–contract migrations | Review + release checklist |
| Tag-pinned deployments | Deploy pipeline |
| Hotfix back-merge | CI-opened PR + hotfix ticket DoD |
| Big CR re-enters Phase 1 | Design owner's triage |
| Drift-audit cadence | Scheduled `drift-audit` run |

---

## Out of scope (explicitly)

- Incident management beyond the hotfix flow — on-call rotation, comms, postmortems.
- Multi-repo / shared-library versioning and cross-project dependency management.
- Retrofitting an existing design-less project — see [patch-up.md](patch-up.md).
