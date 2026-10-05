---
description: Create a functional spec from a BRD, or complete a partial one until it passes the gap-check
argument-hint: "[path or link to the BRD; optionally the existing partial spec]"
allowed-tools: Read, Write, Edit, Glob, Grep, Bash, Agent
---

Run the `functional-spec` skill against: $ARGUMENTS

If no path was given, look for the BRD at `paths.brd` in `.groundwork.yaml`, then
`requirements/brd.md`. A BRD from outside the repository goes through the `brd` skill's Import
mode first. If there is no BRD at all, stop and say so — do not derive requirements from
nothing.

Never fill in a number, a name or a date the user did not give. An unknown is an open question
with an owner.
