# Changelog

All notable changes to this plugin are documented here. The format follows
[Keep a Changelog](https://keepachangelog.com/en/1.1.0/), and the project adheres to
[Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [0.2.0] — Unreleased

### Added

- **The front half of the process, so the workflow runs from idea to MVP.** Five new skills:
  `start` (detects the project's real stage and runs the next one), `interview` (the questioning
  engine), `brd`, `functional-spec` and `mvp-scope`.
- `brd` **Import** mode for a BRD written elsewhere — another session, tool or document — which
  is normalized to stable ids and linted without changing its meaning.
- `functional-spec` **Complete** mode, which uses a `spec-gap-check` report as its work list.
- Templates: `templates/requirements/brd.md`, `functional-spec.md` and `mvp.md`.
- `/groundwork:fs` command; `paths.brd` and `paths.mvp` config keys.
- Session-context hook reports the BRD and MVP scope when configured.

### Changed

- `spec-gap-check` honors BRD priorities (an uncovered MVP requirement blocks, a Later one does
  not) and reads a spec laid out as `spec.md` plus `stories/`.
- `sprint-plan` plans only the stories listed in `mvp.md` when it exists.
- The workflow doc gains *Phase −1 — Idea to spec*. The spec may now live in the repository
  (`requirements/`) when no external system owns it; one home either way, never both.

## [0.1.0] — 2026-09-20

First public release.

### Added

- **13 skills** covering the full path from requirements to steady state: `init`,
  `spec-gap-check`, `user-story`, `design-package`, `design-reconstruct`, `adr`, `sprint-plan`,
  `sprint-ticket`, `ticket-implementation`, `code-review`, `go-live-gates`, `release-cut`,
  `drift-audit`.
- **4 commands** — `status`, `gap-check`, `gate`, `review` — as short aliases for the skills
  whose names are longer. Skills are invokable as slash commands in their own right, so
  `/groundwork:init`, `/groundwork:adr` and `/groundwork:drift-audit` work without a command
  file; adding one would only collide with the skill's name.
- **3 hooks**: session context injection, a once-per-session docs-in-same-PR reminder, and a
  Conventional Commits linter with `off` / `warn` / `enforce` policies.
- **`doc-auditor` agent** — a read-only parallel worker for drift audits and reconstruction
  surveys.
- **Templates** for the design package (architecture, tech rationale, infrastructure,
  communications, security, go-live readiness, ADR), `SPRINT.md`, the user story, the PR body,
  `CODEOWNERS` and `.groundwork.yaml`.
- **Reference documentation**: the workflow, the retrofit ladder, and the configuration schema.
