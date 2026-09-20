---
name: code-review
description: Run the three-round review gauntlet on a pull request or branch — design compliance, acceptance criteria, downstream dependencies, clean-code and security passes, commit-by-commit verification and manual review. Use when the user asks to review a PR, branch, diff or changes, wants a code review before merging, asks whether a change is ready to merge, or wants a security or clean-code pass on a diff.
allowed-tools: Read, Glob, Grep, Bash, Agent
---

# The review gauntlet

Review is where validation-first lives or dies. Three rounds, in order, with an explicit
escape from Round 2.

> **The filtering rule, above everything else.** *Agent-produced* findings — anything you
> concluded by reading — are **validated by a human before they are posted**: right branch, no
> hallucination, not stale code. *Tool-produced* findings — grounded in a file, line and
> symbol by a linter, type-checker or test run — post directly. When you present findings,
> label which kind each one is. A reviewer who cannot tell the difference will either trust
> everything or nothing, and both are wrong.

## Ground rules

- Comments target **lines or files**. Actionable, or it does not get posted.
- **No merge with unresolved comments.**
- The PR body carries a **Review order** section: dependency-leaf-first, one-line summaries,
  estimated review time. Its presence and coverage of the diff are checked mechanically.
- At least one **cross-track reviewer** — someone from outside the ticket's lane, so context
  spreads.
- First response within **1 business day**.
- **Soft cap 500 changed lines** (excluding lockfiles, generated files, docs, docstrings).
  Above it: justified in the body, or split.

---

## Round 1 — automated pass, human-filtered

On the checked-out branch. Five checks; report each separately.

### 1.1 Design compliance

Against `design/`. The diff must not contradict canon. Three outcomes:

- **Compliant** — name which pages you checked against.
- **Divergent** — the code does something the design says otherwise about. Quote both.
- **Undescribed** — the change introduces behavior no design page covers. This is a finding:
  either the page updates in this PR, or the change is out of scope for this ticket.

And the standing rule: **if behavior a design page describes changed, that page updates in this
PR.** Not a follow-up. Check it.

### 1.2 Acceptance criteria

From the branch's `SPRINT.md` row. Go through them **one at a time**, and for each say where in
the diff it is satisfied and which test covers it. An AC with no test is not met.

### 1.3 Downstream dependency requirements

From the *provides* notes on the ticket's `blocks` edges. Each promised symbol, route, schema or
artifact must exist **with the promised shape**. A renamed function that "does the same thing"
breaks the dependent ticket's plan, and it breaks it in a week, silently.

### 1.4 Clean-code pass

Run the project's static checks first — linters, type-checkers, formatters — and report their
output as tool-produced findings. Then the judgment remainder, using
`${CLAUDE_PLUGIN_ROOT}/skills/code-review/clean-code.md`.

Invariants:

- Every applicable rule is **pass**, a **justified exception**, or a **fail**. Never silently
  skipped.
- *Soft* rules allow a justified exception; everything else is a hard fail.
- **The gate judges the diff, never the legacy corpus.** A pre-existing 900-line file that this
  PR touches in two lines is out of scope. Say so explicitly when it comes up — otherwise every
  retrofit review turns into a rewrite demand.
- Universal rules apply to every language; language-specific rules only to files of that
  language.
- It is a *quality* gate. Correctness bugs are the rest of Round 1's job, not this check's.

### 1.5 Security pass

**When the diff touches authentication, authorization, personal data, external input or
outbound calls** — and only then, to keep the signal high. Use
`${CLAUDE_PLUGIN_ROOT}/skills/code-review/security.md`.

### 1.6 Test coverage gate

- Diff coverage against the configured minimum (default 80 %), and the project floor must not
  decrease.
- **Check that tests assert behavior.** No tautologies (`assert x == x`), no assertion-free
  tests that execute code to inflate coverage, no mocks asserted against themselves. A few
  well-designed tests beat a hundred tautologies, and the ratchet cannot tell them apart — you
  can.

---

## Round 2 — commit by commit

**Skip to Round 3 if Round 1 left little** — a small or clean PR does not earn a commit walk.

Otherwise:

1. Check whether Round-1 comments were answered or fixed.
2. Walk the new commits **one by one**, verifying each does *exactly* what its message says —
   no more (a stray refactor bundled in) and no less (a message promising more than the diff).

This only works on atomic history. **A large or squashed commit is effectively a new PR and
re-enters Round 1.** State that plainly when it happens. The asymmetry is deliberate: it makes
atomic commits the cheapest path through review, which does more for commit hygiene than any
rule could.

---

## Round 3 — manual

Guided by the Review-order section. The rules never cover everything — the odd data structure,
the import that resolves by filename, whatever someone invented this week. The human eye is the
last line.

Round-3 findings are the most valuable output of the whole process: each one is a candidate
**new rule**. When you find something the rules missed, say so explicitly and propose the rule,
with the checker that would catch it. A bullet nobody checks is a wish; a checker is a rule.

---

## Reporting

Order findings **most severe first**. For each:

- **What** is wrong, in one sentence
- **Where** — file and line
- **Why it matters** — the concrete failure it causes, with inputs if you can name them
- **Kind** — tool-produced or agent-produced
- **Severity** — blocking / should-fix / nit

Then the verdict: **blocked** (with the blocking list), **approve with comments**, or
**approve**.

Do not pad. A review that lists eleven nits to look thorough buries the one finding that
mattered. If the PR is good, say it is good.
