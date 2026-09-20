---
description: Audit design vs. code vs. deployed reality and convert every finding into a triaged ticket
argument-hint: "[optional: a path or page to scope the audit to]"
allowed-tools: Read, Glob, Grep, Bash, Agent, Write, Edit
---

Run the `drift-audit` skill. Scope: $ARGUMENTS (whole repository if empty).

Compare all three sources — the design pages, the code, and what is actually deployed — not just
the first two. Triage every finding by the standard rule (implied by the design → bug; not
implied → change request; reality changed, intent unchanged → correct the page), and mint a
ticket for each one.

The deliverable is the tickets. An audit that produces prose without tickets has failed.

Close with the trend: is drift accumulating or being paid down?
