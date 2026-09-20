---
description: Write a new architecture decision record, or supersede an existing one
argument-hint: "[the decision, e.g. \"use Postgres advisory locks for job claiming\"; or \"supersede 004\"]"
allowed-tools: Read, Write, Edit, Glob, Grep
---

Run the `adr` skill for: $ARGUMENTS

Allocate the next number as `max(existing) + 1` — never reuse one, including from superseded or
rejected records. Write Context as it was at the time, with no hindsight. Give Consequences in
both directions, and include the condition that would make the team revisit the decision.

Remember the pairing: a new ADR **and** the matching `design/tech-rationale.md` update, in the
same change. One without the other is drift.

To supersede: write the new ADR, then change **only** the old one's status line.
