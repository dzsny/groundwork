<!-- Groundwork PR template. The Review order section is mandatory — it is the difference
between a reviewer reading in a sensible order and a reviewer guessing. -->

## What and why

<!-- One paragraph. What behavior changes, and which ticket or finding asked for it. -->

**Ticket:**
**Story:**
**Design pages touched:**

## Review order

<!-- Files or groups, DEPENDENCY-LEAF-FIRST: what everything else builds on, first. One line of
summary each, plus an estimated review time. -->

1. `path/to/file` — <one line> *(~n min)*
2. `path/to/file` — <one line> *(~n min)*

**Estimated total:** ~n min

## Acceptance criteria

<!-- Each AC from the SPRINT.md row, with where it is satisfied and which test covers it.
An AC with no test is not met. -->

- [ ] **AC-1** — <how it is met> · covered by `test_…`
- [ ] **AC-2** — <how it is met> · covered by `test_…`

## Downstream requirements provided

<!-- Every provides note this ticket promised, and confirmation it exists with that exact
shape. A renamed function that "does the same thing" breaks the dependent's plan — silently,
a week later. -->

- **→ <TICKET>:** `<symbol / route / artifact>` ✅

## Definition of Done

- [ ] Unit tests cover the happy path and at least one failure mode
- [ ] Acceptance criteria met
- [ ] No new `TODO` without a ticket id
- [ ] **Affected design pages updated in this PR** (not as a follow-up)
- [ ] Lint, type-check and tests clean locally

## Notes for the reviewer

<!-- Anything that would otherwise cost the reviewer time: a deliberate deviation, a known
limitation with its ticket, a section that looks odd for a reason. -->

<!-- Size: soft cap 500 changed lines, excluding lockfiles, generated files, docs and
docstrings. Over it? Justify here, or split the PR. -->

<!-- Commits: atomic, one behavioral change each, Conventional Commits scoped by module, no
planning ids in the messages. Atomic history is the cheapest path through review — a large or
squashed commit re-enters Round 1 as if it were a new PR. -->
