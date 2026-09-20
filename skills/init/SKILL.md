---
name: init
description: Assess a repository's documentation maturity and set up the Groundwork workflow in it. Use when the user wants to adopt, initialize, bootstrap or configure the Groundwork documentation workflow, asks "what documentation is this project missing?", wants a documentation health check or maturity assessment of a repo, or wants to retrofit an undocumented/legacy project onto a documented process. Also use before any other Groundwork skill when .groundwork.yaml is absent.
allowed-tools: Read, Write, Edit, Glob, Grep, Bash
---

# Baseline init — assess, then set up

You are setting up the Groundwork workflow in a repository. Two jobs, in order:
**assess what is actually there**, then **install only what that level supports**.

Read `${CLAUDE_PLUGIN_ROOT}/docs/patch-up.md` before you start. The layer model is the whole
point of this skill.

> **Never declare a layer. Detect it.** A repo is at the layer its *artifacts* prove, not the
> one its README claims. And never install a check that cannot run — a check that silently
> passes because its input is missing is worse than no check.

## Step 1 — Detect

Gather evidence. Do not ask the user anything you can determine yourself.

| Signal | How to detect | Feeds |
| --- | --- | --- |
| Branch model | `git branch -r`, default branch, protection if visible | Layer 1 |
| PR discipline | `git log --merges`, presence of PR templates, `.github/` | Layer 1 |
| Commit convention | Sample the last 50 subjects: do they match `type(scope): …`? | Layer 1 |
| Tests + CI | test directories, CI workflow files, coverage config | Layer 1 |
| Design package | `design/` and which of the standard pages exist | Layer 2 |
| Spec | `.groundwork.yaml` `paths.spec`, or any spec/requirements directory | Layer 2 |
| Sprint plan | `SPRINT.md` and whether it carries the `groundwork:sprint-table` marker | Layer 2/3 |
| Gate register | `design/go-live-readiness.md` and whether any gate carries a dated verdict | Layer 4 |
| Production | deploy workflows, release tags, environment configs | Layer 4 |
| AI surfaces | prompt files, model SDK imports, eval directories | EVAL track |
| Tracker | issue templates, ticket ids in branch names or commit trailers | `tracker.kind` |
| Languages, entry points, module layout | file census | `paths.code` |

Then assign the layer — the **highest** layer whose *entry* conditions are all met:

- **Layer 1** — always the floor. Review discipline applies to new changes only.
- **Layer 2** — `design/` exists with the standard pages, and a spec baseline exists.
- **Layer 3** — Layer 2 plus a `SPRINT.md` carrying verify-phase tickets (TEST/LIVE/DRILL/EVAL).
- **Layer 4** — Layer 3 plus a gate register with dated verdicts.

State the layer with its *evidence*, one line each. "Layer 1 — `design/` absent, no spec
reference, 4 of the last 50 commits follow Conventional Commits."

## Step 2 — The entry assessment card

Present a short card and confirm it with the user. This is the only thing you ask, and you ask
it once, with your detected answers pre-filled:

| Dimension | Detected | Confirm |
| --- | --- | --- |
| Traffic | live in production / internal only / frozen | |
| Activity | actively developed / occasional fixes / untouched | |
| Tests | present and running in CI / present / none | |
| Docs | trustworthy / stale / none | |
| AI surfaces | yes / no | |
| Target layer | the layer this project's **risk** justifies | |
| Owner | the named design owner | |

The **target layer** is a decision, not a detection: a frozen internal tool may stay at Layer 1
permanently, and that is a recorded decision, not neglect. The rule is *a project's layer must
match its risk*. Write the card's outcome into the config as comments so the next run has it.

## Step 3 — Write `.groundwork.yaml`

Copy `${CLAUDE_PLUGIN_ROOT}/templates/groundwork.yaml` and fill it from what you detected. See
`${CLAUDE_PLUGIN_ROOT}/docs/configuration.md` for every field.

Rules:

- Fill `tracks` from the **menu**, not the whole menu. Instantiate only what the project needs;
  a track nobody owns is noise. Ask "what would falsify this ticket's success?" for the work
  the project actually does.
- Set `policy.*` to `warn` on first init, always. Escalating to `enforce` is the team's
  decision, made after they have seen the warnings — never yours on day one.
- Set `layer` to the **detected** layer, not the target. The target belongs in the card.

## Step 4 — Install what the layer supports

Install in this order, and stop at the boundary of the detected layer. Never scaffold a Layer-2
artifact into a Layer-1 repo as an empty stub: an empty `design/architecture.md` is a lie that
passes checks.

**Layer 1 — always:**

- `.groundwork.yaml`
- A PR template with the mandatory **Review order** section —
  `${CLAUDE_PLUGIN_ROOT}/templates/PULL_REQUEST_TEMPLATE.md`
- `.env.example` if the project reads environment variables and lacks one
- Report — do not silently apply — what branch protection and CI checks the repo is missing:
  protected integration and release branches, PR-only merges, commit lint, diff-coverage gate
  with the ratchet seeded **at the current number**. These require repository-admin rights;
  produce the exact settings and, where the tracker supports it, the workflow file, and let the
  user apply them.

**Layer 2 — when `design/` is in scope:**

- Scaffold `design/` from `${CLAUDE_PLUGIN_ROOT}/templates/design/` — but hand the actual
  authoring to the `design-package` skill (greenfield) or `design-reconstruct` (existing code).
  Scaffolding is creating the files *and filling them*, in the same pass. Never leave a
  placeholder page behind.
- `CODEOWNERS` entry making `project.owner` a required reviewer on `paths.design`
  (`${CLAUDE_PLUGIN_ROOT}/templates/CODEOWNERS`).

**Layer 3:**

- `SPRINT.md` from `${CLAUDE_PLUGIN_ROOT}/templates/SPRINT.md`, via the `sprint-plan` skill.

**Layer 4:**

- `design/go-live-readiness.md`, via the `go-live-gates` skill. Every gate starts `open`.

## Step 5 — Report and hand off

Close with three things:

1. **Where the project stands** — detected layer, target layer, and the named gap between them.
2. **What was installed**, by path.
3. **The next single step.** One. Not a backlog. The next step is almost always the cheapest
   rung of the ladder that is not yet occupied — usually `design-reconstruct` for an existing
   project or `spec-gap-check` for a new one.

If the repository is not a git repository, or you cannot read it, say so and stop. Do not
initialize one.
