# Groundwork

**A Claude Code plugin that gives any software project a complete documentation baseline — and
keeps it honest.**

From a one-line idea to an MVP plan, in one process: interview → BRD → functional spec →
gap-check → MVP cut → design → sprint plan.

Most projects have documentation that was true once. Groundwork treats the design package as
*canon*: written from evidence, updated in the same change as the behavior it describes, and
audited against reality on a cadence. It works on a greenfield project from the first
requirement, and it retrofits onto a legacy codebase that has nothing at all.

It is deliberately **project-agnostic and tool-agnostic**. It names an *issue tracker*, not a
vendor; a *spec*, not a wiki product. One config file at your repository root is the only place
it learns anything about your project.

```
/plugin marketplace add dzsny/groundwork
/plugin install groundwork@groundwork
```

Then, in the repository you want to document:

```
/groundwork:init      # an existing project: assess it, install what its maturity supports
/groundwork:start     # a new project, or one whose requirements are missing or half-written
```

---

## What it actually does

`/groundwork:init` reads your repository and tells you where it stands — not where you wish it
stood. Branch model, commit convention, tests, `design/`, spec reference, sprint plan, gate
register. From that it assigns a **maturity layer** and installs only the checks that can
actually run there.

> A check whose input is missing must **fail loudly**, not pass green. That single rule is why
> the layers are detected rather than declared.

| Layer | You have | Groundwork adds |
| --- | --- | --- |
| **1** | Code, and possibly nothing else | Review discipline — the gauntlet, commit convention, PR template, coverage ratchet seeded at today's number |
| **2** | Layer 1 | The design package, reverse-engineered from the code if need be, plus a draft spec of what the system *actually does* |
| **3** | Layer 2 | Verification: the design's claims tested against real providers, real load, real failure |
| **4** | Layer 3 | The go-live gate register — including retroactively, for something already in production |

Nothing is skipped and nothing is faked. A retrofitted design page carries an **as-built,
unverified** banner until a human verifies it, because a reconstructed page that reads like
authoritative design is worse than no page at all.

## From idea to MVP

Groundwork's later stages — design, sprint plan, review — are only as good as the requirements
they read. A project with a BRD written in another tool and no functional spec leaves nothing
for the design to derive its numbers from, so the front half ships in the plugin too.

```
idea ─▶ BRD ─▶ spec ─▶ gap-check ─▶ MVP cut ─▶ design ─▶ sprint plan ─▶ build
        brd    functional-  spec-gap-   mvp-scope  design-    sprint-plan   ticket-
               spec         check                  package                  implementation
```

`/groundwork:start` works out which stage your project is *actually* at and runs the next one.
Bring a BRD from another session or tool and it is imported and normalized rather than redone;
bring only an idea and it is interviewed out of you. The interview is relentless about the
things downstream stages cannot recover from, and it never fills in an unknown — a figure
nobody gave becomes an open question with an owner, not a drill threshold.

## Skills

Claude invokes these on its own when the work calls for them; you can also call any of them
directly as `/groundwork:<name>`.

| Skill | What it does |
| --- | --- |
| `start` | Detect which stage a project is at, from idea to sprint plan, and run the next one |
| `interview` | Relentless one-round-at-a-time questioning with recommended answers — and "I don't know" recorded as an owned open question, never filled in |
| `brd` | Write a BRD from an idea, or import and normalize one made elsewhere: stable ids, numeric objectives, priorities, named approver |
| `functional-spec` | Derive the full spec from a BRD — stories, NFRs with numbers, traceability — or complete a partial one |
| `mvp-scope` | Cut the smallest end-to-end release: the bet, exit criteria, walking skeleton, stories in and out |
| `init` | Detect the maturity layer, write the config, install what that layer supports |
| `spec-gap-check` | Check requirements for completeness, ambiguity and BRD coverage → a binary ready-for-design verdict |
| `user-story` | Write or repair a story: scope, flows, error paths, GIVEN/WHEN/THEN criteria, named acceptance authority |
| `design-package` | Author the canon: architecture, rationale, infrastructure, external contracts, security |
| `design-reconstruct` | Recover all of that from an undocumented codebase, plus the de-facto user stories |
| `adr` | Write or supersede an architecture decision record |
| `sprint-plan` | Turn a design into a machine-readable plan with tracks, dependencies and a critical path — or schedule and calibrate one |
| `sprint-ticket` | Mint one ticket *with* full dependency and critical-path propagation |
| `ticket-implementation` | Implement under discipline: resolve design first, plan commits upfront, test-first, per-commit approval |
| `code-review` | The three-round gauntlet — design compliance, acceptance criteria, downstream deps, clean-code, security |
| `go-live-gates` | The readiness register, where a gate closes only on a dated observation |
| `release-cut` | Changelog from commits, verified checklist, SemVer tag, hotfix and back-merge |
| `drift-audit` | Design ↔ code ↔ deployed reality → triaged tickets, not a report |

## Commands

`/groundwork:init` · `/groundwork:start` · `/groundwork:status` · `/groundwork:fs` ·
`/groundwork:gap-check` · `/groundwork:adr` · `/groundwork:gate` · `/groundwork:review` ·
`/groundwork:drift-audit` — every skill is also invokable as `/groundwork:<name>`.

## Hooks

Three, all quiet by default and all opt-in to strictness through `policy.*` in your config:

- **Session context** — tells Claude which design pages exist, which are missing, and which
  still carry the as-built banner. Prevents the most common failure mode: confidently
  referencing a document that isn't there.
- **Docs-in-same-PR reminder** — fires **once per session**, after product code is edited with
  no design page touched. Once, because a reminder that fires on every edit gets tuned out.
- **Commit lint** — checks Conventional Commits before the commit exists. `warn` by default;
  `enforce` blocks. Also catches ticket ids and AI attribution in commit subjects.

Set any policy to `enforce` only after your team has seen the warnings for a while. That is
their decision, not the plugin's.

## Configuration

One file, `.groundwork.yaml`, written by `init`:

```yaml
layer: 2
project:
  name: acme-billing
  ai_surfaces: false
  in_production: true
  owner: "Jane Doe"
paths:
  design: design/
  brd: requirements/brd.md
  spec: requirements/spec.md
  mvp: requirements/mvp.md
tracks: [CORE, DATA, PLAT, TEST, LIVE, GL, OP]
tracker:
  kind: github
  url_template: "https://github.com/acme/billing/issues/{id}"
policy:
  conventional_commits: warn
  docs_in_same_pr: warn
  diff_coverage_min: 80
```

Full reference: [`docs/configuration.md`](docs/configuration.md).

## The ideas underneath

Read [`docs/workflow.md`](docs/workflow.md) once — the skills enforce it from then on. The parts
worth knowing before you start:

**Validation-first.** Invest in *review* rules over *development* rules. Change a development
rule and nobody retro-fixes the codebase; change a review rule and every future PR applies it,
so the code heals as it is touched.

**Single source of truth.** Every fact lives in exactly one place. Requirements in the spec,
design intent in `SPRINT.md`, live status in the tracker, current rationale in
`tech-rationale.md`, decision history in `adr/`. Two copies always drift, and drift is silent.

**Raise, don't bury.** A developer who finds the design wrong raises it and the page is
corrected *in the same PR as the code*. Never a follow-up ticket — follow-up doc tickets are how
design packages die.

**A gate closes only on a dated observation.** Not on CI being green, not on "should be fine".
`✅ 2026-03-14 — pod-kill drill: 3 of 3 runs recovered within 22 s against the 60 s threshold.`

**The gate judges the diff, never the legacy corpus.** This is what makes retrofit survivable.
Adopting Groundwork never means rewriting until the linter is happy.

**An audit that produces prose instead of tickets has failed.** Findings that aren't scheduled
aren't findings.

For retrofitting an existing project, [`docs/patch-up.md`](docs/patch-up.md) is the on-ramp.

## Trying it before you install

```bash
git clone https://github.com/dzsny/groundwork
claude --plugin-dir ./groundwork
```

## Contributing

Issues and pull requests welcome — see [CONTRIBUTING.md](CONTRIBUTING.md). The most useful
contribution is a skill that failed on a real repository, with the repository shape that broke
it.

## License

[MIT](LICENSE).

The `interview` skill adapts the design-tree / frontier method of `grilling` from
[mattpocock/skills](https://github.com/mattpocock/skills) (MIT).

This plugin generalizes a software development workflow originally written for one
organization's internal use, rewritten here to be vendor-neutral and reusable.
