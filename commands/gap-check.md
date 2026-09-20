---
description: Gap-check a spec or requirements document and give a ready / not-ready-for-design verdict
argument-hint: "[path or link to the spec; optionally the BRD too]"
allowed-tools: Read, Glob, Grep, Write, Bash
---

Run the `spec-gap-check` skill against: $ARGUMENTS

If no path was given, look for the spec at `paths.spec` in `.groundwork.yaml`, then in the usual
places (`docs/`, `spec/`, `requirements/`). If you cannot find it, ask for it — do not review
the wrong document.

Produce: structural completeness, BRD↔spec coverage, per-story findings, and a binary
**ready / not ready for design** verdict with the blocking gaps listed by owner.

Never invent a missing section — especially not a number. A fabricated NFR becomes a drill
threshold, then a go-live gate, and nobody ever learns it was fiction.
