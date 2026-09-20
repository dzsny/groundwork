---
name: ticket-implementation
description: Implement a ticket end to end under review discipline — resolve the design and acceptance criteria first, plan the atomic commit sequence upfront, develop test-first with per-commit approval, self-review, then open a PR with a review-order section. Use when the user asks to implement, build or work on a specific ticket, story or task from a sprint plan or tracker, or wants disciplined test-first implementation with atomic commits.
allowed-tools: Read, Write, Edit, Glob, Grep, Bash, Agent
---

# Ticket implementation

**Input:** a ticket that meets the Definition of Ready.
**Output:** a merge-ready PR with atomic, individually approved commits, and a tracker status
that tracks reality.

## 1. Resolve before writing any code

Read, in this order:

1. The `SPRINT.md` row — acceptance criteria, dependencies, the provides notes on its edges.
2. The tracker ticket — status, links, the spec story at its pinned version.
3. **The design pages the acceptance criteria name.** Not a skim. This is the step that gets
   skipped, and skipping it is how code diverges from canon silently.

> **If the ticket and the design disagree — stop and raise it.** Never silently diverge. The
> design owner rules on the resolution, and if the design is wrong, **the design page is
> corrected in the same PR as the code that adapts to it** — never as a follow-up ticket.

**Lite mode.** When the repository is at Layer 1 (no `design/` yet), there is nothing to
resolve: acceptance criteria come from the ticket alone and the PR body is flagged `lite mode`.
This is sanctioned, not a loophole — everything below still applies. Layer-2 promotion removes
the flag.

## 2. Plan first, commits included

Produce the plan before touching code. It lists:

- Each acceptance criterion and how it will be satisfied
- The downstream requirements this ticket must provide (from its *blocks* edges' provides notes)
- **The atomic commit sequence, upfront** — one behavioral change per commit, each with its
  intended message

Plan the sequence; do not bundle and retro-split. Retro-splitting produces commits whose
messages describe a slice of a change rather than a change, which is exactly what Round 2 of
review cannot check.

## 3. The input gate

Classify **every** input the ticket needs:

- **(A) Created in scope** — its creation steps join the plan.
- **(B) Produced by an upstream ticket** — blocked until it exists. Check, do not assume.
- **(C) An external resource** — credentials, a provisioned service, a dataset, an API key.
  **Blocked until confirmed to exist.**

**No coding on assumed inputs.** A ticket built against an imagined schema is rework, and it is
discovered late, in review or in verification.

## 4. Per-step development

For each step in the plan:

1. **Tests first** — happy path plus at least one failure mode. That is the Definition-of-Done
   floor, not the standard; the coverage gate lives in CI and review.
2. **Minimum code to green.** Solve the problem the acceptance criteria state, not the one you
   imagine coming after it.
3. **Lint, type-check, tests clean.**
4. **Stop. Get explicit approval of the commit message** before committing, and before starting
   the next step.
5. Commit.

**Never commit red.** A red commit breaks bisect and makes Round 2 impossible.

Conventions, throughout:

- **No planning ids in code or commit messages.** The branch and PR carry them. Commit messages
  describe behavior.
- **Conventional Commits, scoped by module** — `feat(auth): reject expired refresh tokens`. The
  release changelog is generated from these.
- **No AI attribution** in commits or code comments.
- **No force-push** without explicit approval.
- Branch name from the configured pattern, default `feature/<TICKET-ID>-<slug>`, off the
  ticket's integration branch.

## 5. Self-review before the PR

Run the `code-review` skill's Round 1 against your own branch. Check:

- **Design compliance** against `design/`
- **Acceptance criteria** met, each one, named
- **Downstream dependencies satisfied** — every provides note you promised, actually provided
  with that exact shape
- **Clean-code pass**
- **Security pass**, if the change touches auth, personal data, external input or outbound calls
- **Design pages updated in this PR** if behavior they describe changed

Failures get fixed and re-run **before** the PR opens. A PR that fails its author's own review
wastes a reviewer's day.

## 6. Open the PR

Body from `${CLAUDE_PLUGIN_ROOT}/templates/PULL_REQUEST_TEMPLATE.md`. The mandatory
**Review order** section lists files or groups in **dependency-leaf-first** order, one line of
summary each, with an estimated review time. This is not a formality — it is the difference
between a reviewer reading in a sensible order and a reviewer guessing.

Also in the body: the ticket link, the acceptance criteria with how each is met, the design
pages touched and why, and a justification if the diff exceeds the soft line cap (default 500,
excluding lockfiles, generated files, docs and docstrings) — or split the PR.

## 7. Tracker status

Move the ticket to in-progress at start and to review when the PR opens, when the tracker is
configured and the team has agreed to it. Until the team has seen this skill work, propose the
transition rather than performing it.

## When you get stuck

Raise it. A blocked ticket that stays silently blocked is the failure mode this whole process
exists to prevent. Say what is blocking, what you tried, and what decision you need — then stop.
Do not invent a workaround that diverges from the design.
