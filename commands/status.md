---
description: Report what baseline documentation this project has, what it is missing, and the single next step
allowed-tools: Read, Glob, Grep, Bash
---

Report this repository's documentation status. Read-only — change nothing.

1. Read `.groundwork.yaml` if it exists; otherwise detect the layer as the `init` skill does.
2. For each design page, report: **present and current · present but stale · missing · not
   applicable**. "Stale" needs evidence — a claim that no longer matches the code, or an
   `as-built, unverified` banner still in place.
3. Report the spec reference, `SPRINT.md` health (does the table parse? do all tickets meet the
   Definition of Ready?), and the gate register (how many gates, how many open, how many
   closed on a dated observation vs. closed without one).
4. Name any obvious drift you noticed in passing — but do not run a full drift audit; say that
   `drift-audit` is the skill for that.

End with **one** next step. Not a backlog. The cheapest rung of the ladder that is not yet
occupied.

Keep the whole report under a screen. This is a status check, not an audit.
