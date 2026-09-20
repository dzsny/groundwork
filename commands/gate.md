---
description: Open, close or audit a go-live readiness gate
argument-hint: "[e.g. \"close rollback: redeployed v1.3.2, migrations reversed, 12 min\" | \"status\"]"
allowed-tools: Read, Write, Edit, Glob, Grep, Bash
---

Run the `go-live-gates` skill for: $ARGUMENTS

With no argument, or `status`: report the register — every gate, its verdict, its owner, and for
each open one, what it needs to close. Flag any gate closed **without** a dated observation;
those are not closed.

To close a gate you need a dated observation: what was observed, against which threshold, with a
link. `✅ <date> — <observation> + link`. CI being green is not an observation about a gate.

If the surface of a closed gate has changed — a provider swap, an estate change, a config
change — reopen it with the date and the reason.

Entries are append-only. Never rewrite the register's history.
