---
name: adr
description: Write an architecture decision record, or supersede an existing one. Use when the user makes or describes a significant technical decision — a stack, storage model, integration pattern, framework or protocol choice — wants it documented, asks for an ADR, asks "why did we choose X?", or wants to record that a previous decision is being replaced.
allowed-tools: Read, Write, Edit, Glob, Grep
---

# Architecture decision records

An ADR records **one decision**, at the moment it is made, and is then never edited.

## The division of labor

This is the part teams get wrong, so get it right first:

| | `design/tech-rationale.md` | `design/adr/` |
| --- | --- | --- |
| Holds | The **current** rationale | The **history** |
| Mutable? | Yes — rewritten when a decision changes | No — immutable, only superseded |
| Who reads it | Everyone: reviewers, new engineers, agents | Someone asking "why is it like this?" about a past choice |

The analogy: `tech-rationale.md` is the code; `adr/` is the git history. Nobody works from the
history.

So a change of technical intent means **two edits in one PR**: a new ADR, and the matching
`tech-rationale.md` update. One without the other is drift.

## When something deserves an ADR

Write one when the decision is **significant and hard to reverse**:

- A stack, language, framework or runtime choice
- A storage model, or a change to one
- An integration pattern — sync vs. async, push vs. pull, the shape of a contract
- A boundary — what becomes a separate service, what stays in-process
- A cross-cutting mechanism — auth model, tenancy model, error handling, observability
- Adopting an exotic technology over the boring option. *Especially* this one: the boring
  option is the default, so departing from it is the decision that needs justifying.

Do **not** write one for: a library version bump, a refactor that changes no external behavior,
a naming convention, or anything a reviewer would settle in one comment.

If unsure, ask: *would a competent engineer arriving in a year be puzzled by this, and would the
puzzle cost them a day?* If yes, write the ADR.

## Format

`design/adr/NNN-<kebab-slug>.md`, from
`${CLAUDE_PLUGIN_ROOT}/templates/design/adr/000-template.md`. `NNN` is zero-padded and
allocated as `max(existing) + 1` — never reuse a number, including one belonging to a
superseded or rejected ADR.

```markdown
# NNN — <Decision in a noun phrase>

- **Status:** proposed | accepted | superseded by NNN | rejected
- **Date:** YYYY-MM-DD
- **Deciders:** <names>
- **Related:** <story ids, other ADRs, design pages>

## Context
## Decision
## Consequences
## Alternatives considered
```

### Context

The forces, stated neutrally: the constraint, the requirement (link its story or NFR id), the
thing that stopped working. A reader must be able to tell whether these forces still hold — that
is how they know if the decision has expired.

Write it as it was *at the time*. No hindsight, no "obviously".

### Decision

One sentence, active voice, present tense: "We use X for Y." Then the specifics that bind —
version constraints, the boundary of the decision, what it explicitly does not cover.

### Consequences

Both directions, honestly. What gets easier, what gets harder, what this now commits us to, what
it costs, and what it forecloses. An ADR with only positive consequences has not been thought
through and will not be trusted.

Include **what would make us revisit this** — the condition under which the decision expires.
This single line is what makes an ADR useful years later.

### Alternatives considered

Each with what it would have given you and **why not**. "Not considered" is a legitimate entry
when true — it tells a future reader where the blind spot was. This section is where the boring
option gets its explicit rejection.

## Superseding

Never edit an accepted ADR's content. To change a decision:

1. Write a **new** ADR with the next number. Its Context explains what changed since the
   original — new constraint, new evidence, the original's revisit condition having triggered.
2. In the old ADR, change **only** the status line to `superseded by NNN` and add the date. One
   line, nothing else.
3. Update `design/tech-rationale.md` so the current rationale reflects the new decision.
4. All three in the same PR.

A rejected proposal keeps its number and gets `Status: rejected`. Rejected ADRs are worth
keeping: the next person to propose the same thing gets the argument for free.

## Reading ADRs back

When asked "why is it like this?", read `tech-rationale.md` first — it is the current answer.
Go to `adr/` only when the question is historical ("why did we move off X?") or when the
rationale page is silent. If the rationale page and the ADR chain disagree, that is a drift
finding: report it.
