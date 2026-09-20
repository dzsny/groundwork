# Changelog

All notable changes to this plugin are documented here. The format follows
[Keep a Changelog](https://keepachangelog.com/en/1.1.0/), and the project adheres to
[Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [0.1.0] — 2026-09-20

First public release.

### Added

- **13 skills** covering the full path from requirements to steady state: `init`,
  `spec-gap-check`, `user-story`, `design-package`, `design-reconstruct`, `adr`, `sprint-plan`,
  `sprint-ticket`, `ticket-implementation`, `code-review`, `go-live-gates`, `release-cut`,
  `drift-audit`.
- **7 commands**: `/groundwork:init`, `status`, `gap-check`, `adr`, `gate`, `review`,
  `drift-audit`.
- **3 hooks**: session context injection, a once-per-session docs-in-same-PR reminder, and a
  Conventional Commits linter with `off` / `warn` / `enforce` policies.
- **`doc-auditor` agent** — a read-only parallel worker for drift audits and reconstruction
  surveys.
- **Templates** for the design package (architecture, tech rationale, infrastructure,
  communications, security, go-live readiness, ADR), `SPRINT.md`, the user story, the PR body,
  `CODEOWNERS` and `.groundwork.yaml`.
- **Reference documentation**: the workflow, the retrofit ladder, and the configuration schema.
