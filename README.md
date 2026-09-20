# Groundwork

**A Claude Code plugin that gives any software project a complete documentation baseline — and
keeps it honest.**

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
/groundwork:init
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

## Skills

Claude invokes these on its own when the work calls for them; you can also call any of them
directly as `/groundwork:<name>`.

| Skill | What it does |
| --- | --- |
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

`/groundwork:init` · `/groundwork:status` · `/groundwork:gap-check` · `/groundwork:adr` ·
`/groundwork:gate` · `/groundwork:review` · `/groundwork:drift-audit`

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
  spec: https://wiki.example.com/acme/spec
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

This plugin generalizes a software development workflow originally written for one
organization's internal use, rewritten here to be vendor-neutral and reusable.
