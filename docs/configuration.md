# Configuration — `.groundwork.yaml`

One file at the repository root. `init` writes it; every skill and hook reads it. It is
the only place the plugin learns anything project-specific, which is what keeps the rest of the
plugin project-agnostic.

The file is optional. Without it the plugin falls back to detection and safe defaults, and the
hooks stay in `warn` mode.

## Full example

```yaml
version: 1

# Maturity layer, 1-4 (see docs/patch-up.md). Written by init from what it detects.
# Skills refuse, or degrade loudly, when a step needs a higher layer than this.
layer: 2

project:
  name: acme-billing
  # Free text. Used only to pick sensible defaults and to word generated docs.
  kind: service            # service | web-app | mobile-app | library | cli | data-pipeline
  ai_surfaces: false       # true enables the EVAL track and model-quality gates
  in_production: true      # true enables Layer 4 (retroactive go-live gates)
  owner: "Jane Doe"        # the named design owner; required reviewer on design/

paths:
  design: design/
  sprint: SPRINT.md
  # Where the functional spec lives. A path, or a URL when it lives in an external system.
  spec: https://wiki.example.com/spaces/ACME/spec
  # Directories treated as product code by the docs-in-same-PR hook.
  code:
    - src/
    - lib/
  # Directories excluded from that check.
  exclude:
    - tests/
    - docs/

# Only the tracks this project actually instantiated. The menu is
# CORE DATA PLAT INF TEST LIVE DRILL EVAL GL OP SEC.
tracks: [CORE, DATA, PLAT, TEST, LIVE, GL, OP]

tracker:
  kind: github             # none | github | jira | linear | gitlab | azure-devops | other
  project_key: ACME        # ticket id prefix used by the tracker, when it has one
  # {id} is replaced with the ticket id. Used to render links in SPRINT.md and PR bodies.
  url_template: "https://github.com/acme/billing/issues/{id}"

git:
  integration_branch: develop
  release_branch: main
  branch_pattern: "feature/{ticket}-{slug}"

policy:
  # off | warn | enforce. `enforce` lets the hook block the action.
  conventional_commits: warn
  docs_in_same_pr: warn
  diff_coverage_min: 80
  pr_soft_line_cap: 500
  # Commit scopes accepted by the commit-lint hook. Empty list = any scope.
  commit_scopes: []
  commit_types: [feat, fix, docs, style, refactor, perf, test, build, ci, chore, revert]
```

## Field reference

| Key | Default | Meaning |
| --- | --- | --- |
| `version` | `1` | Config schema version. |
| `layer` | detected | 1–4. Gates which skills will run; see [patch-up.md](patch-up.md). |
| `project.kind` | `service` | Shapes which design pages and tracks are proposed. |
| `project.ai_surfaces` | `false` | Enables the EVAL track, model-quality spec sections and eval gates. |
| `project.in_production` | `false` | Enables Layer 4 retroactive gates and hotfix flow. |
| `project.owner` | — | The design owner named in `CODEOWNERS` and in triage rulings. |
| `paths.design` | `design/` | The canon directory. |
| `paths.sprint` | `SPRINT.md` | The sprint plan. |
| `paths.spec` | — | Path or URL to the functional spec. |
| `paths.code` | detected | Directories the docs-in-same-PR hook watches. |
| `paths.exclude` | `[]` | Directories that hook ignores. |
| `tracks` | detected | Instantiated tracks. `sprint-ticket` refuses an unlisted track. |
| `tracker.kind` | `none` | Which issue tracker, if any. `none` keeps everything in `SPRINT.md`. |
| `tracker.url_template` | — | `{id}` placeholder; renders ticket links. |
| `git.integration_branch` | `develop` | Where ticket PRs land. |
| `git.release_branch` | `main` | What gets tagged and deployed. |
| `policy.conventional_commits` | `warn` | `off` / `warn` / `enforce` for the commit-lint hook. |
| `policy.docs_in_same_pr` | `warn` | `off` / `warn` / `enforce` for the design-drift hook. |
| `policy.diff_coverage_min` | `80` | Reported by `code-review`; enforced by your CI. |
| `policy.pr_soft_line_cap` | `500` | Soft cap flagged in Round 1. |

## Precedence

1. An explicit instruction in the current conversation.
2. `.groundwork.yaml`.
3. Detection (branches, directories, existing files).
4. The defaults in this document.

A skill that cannot satisfy a step at the configured layer says so **loudly** — it never
silently passes. That is the same "raise, don't bury" principle the workflow applies to code.
