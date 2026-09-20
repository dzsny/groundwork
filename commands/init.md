---
description: Assess this repository's documentation maturity and set up the Groundwork workflow
argument-hint: "[optional: target layer 1-4, or a note about the project]"
allowed-tools: Read, Write, Edit, Glob, Grep, Bash
---

Run the Groundwork `init` skill on the current repository.

Detect the documentation maturity layer from what actually exists — branch model, commit
convention, tests and CI, `design/`, the spec reference, `SPRINT.md`, the gate register — then
present the entry assessment card, write `.groundwork.yaml`, and install only what the detected
layer supports.

Do not scaffold empty placeholder documents. Do not declare a layer the artifacts do not prove.

Additional context from the user: $ARGUMENTS
