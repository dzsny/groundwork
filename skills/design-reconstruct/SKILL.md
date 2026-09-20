---
name: design-reconstruct
description: Reverse-engineer a complete design package and a set of de-facto user stories from an existing, undocumented codebase. Use when a project has no documentation and the user wants to document what it already does, asks to reverse-engineer or recover the architecture of a legacy system, wants onboarding docs for an inherited codebase, or is retrofitting an existing project onto a documented process.
allowed-tools: Read, Write, Edit, Glob, Grep, Bash, Agent
---

# Design reconstruction

Layer 2 of the retrofit ladder (`${CLAUDE_PLUGIN_ROOT}/docs/patch-up.md`). You are recovering a
design package from code that never had one, and handing product a draft spec of what the system
*actually does*.

> **The one rule that makes this safe:** you are documenting *observed behavior*, not intent.
> Every page you produce carries the as-built banner until a human verifies it. A reconstructed
> page that reads like an authoritative design is worse than no page at all, because the next
> engineer will trust it.

## The banner

Every reconstructed page opens with, verbatim:

```markdown
> **as-built, unverified** — this page describes what the code appears to do, not what was
> verified or intended. Reconstructed <date>. Remove this banner only when the claims below
> have been verified against a running system.
```

The banner is dropped per page, by the LIVE/DRILL verification work, never in bulk and never by
you.

## 1. Survey before you write

Do not start writing pages. Build a map first:

- **Entry points** — HTTP routes, CLI commands, queue consumers, scheduled jobs, event
  handlers. This is the system's actual API surface, and it is what the de-facto user stories
  are derived from.
- **Module boundaries** — what the directory structure claims, and whether imports agree.
  Disagreement here is your first finding.
- **Data stores** — every database, cache, bucket, queue and file path. For each: what writes
  it, what reads it, what the schema is, whether it holds personal data.
- **External dependencies** — every outbound call. Read the client code, not the README.
- **Configuration** — every environment variable and config key, what reads it, and what
  happens when it is absent. This reveals undocumented operating modes.
- **Deployment** — CI/CD definitions, container definitions, infra-as-code, environment
  configuration. What is *actually* running is a source, not a guess.
- **Authentication and authorization** — where identity enters, where permission is checked.
  For a live system this is the most important survey output.

For a large repository, fan this out: run the survey dimensions as parallel subagents, each
reporting its inventory, then reconcile. Do not let a subagent write a design page — they
report findings; you write the document.

## 2. Write the pages

Same pages and same rules as the `design-package` skill, with three differences:

- **`tech-rationale.md` is written as *inferred* rationale.** Say so in each entry: "inferred
  from …". You are reconstructing what the choice appears to have been and what it appears to
  cost. Never invent a motive. "Chosen because …" is a claim about a person's reasoning that you
  have no evidence for; "the codebase depends on X's transaction semantics in <file>" is a fact.
- **`adr/` starts empty.** Decision history is not fabricated. It begins with the first
  post-retrofit decision. Create the directory and a README saying exactly that.
- **`security.md` gets written first and carefully.** For a live system this is the page with
  the most immediate value and the highest cost of being wrong. Document the enforcement
  *points*, and flag every route or handler where you could not find an authorization check —
  as a question, not an accusation.

## 3. Derive the de-facto user stories

This is the step that makes reconstruction worth doing. From the entry-point survey, write out
what the system *does* as user stories — actor, capability, outcome, and the observable
behavior including its error paths.

Rules:

- One story per independently meaningful outcome, not per route.
- Include the ugly ones. Undocumented admin endpoints, legacy compatibility paths and
  special-case behavior for one customer are exactly what this exercise exists to surface.
- Mark each **de-facto** — this is what the system does, not what it should do.
- Where behavior is conditional on configuration, say so; a flag that changes user-visible
  behavior is part of the story.

Hand this set to product as the **draft spec**. They rule on what the system *should* do. That
pass produces two things:

1. The project's first frozen **spec baseline** — intent, finally written down.
2. The first entries of the **gap register**: every difference between de-facto and intended
   behavior, triaged immediately — implied by the now-written intent → bug; new desire → change
   request.

Write the gap register to `design/gap-register.md` with columns: **id · de-facto behavior ·
intended behavior · triage (bug/CR) · owner · status**.

## 4. Numbers

An existing project has *implicit* non-functional requirements: whatever it currently sustains.
Measure or extract them — from monitoring, logs, load tests, or the infrastructure's own limits —
and present them to product, who either blesses those numbers or names better ones. Same for
model quality targets and gold data where the project has AI surfaces.

Without these numbers the verification layer cannot run: a drill with no threshold and an eval
gate with no target are both theater. State that explicitly when you hand over.

## 5. Hand-off

Close with:

- The pages written, and which ones you are least confident in.
- **Every unverified assumption**, listed. Not buried in the pages — listed, so the
  verification work can be scheduled from it.
- The de-facto story count and the gap-register entries.
- The named next step: product's review of the draft spec. Nothing else can proceed before it.

From the moment `design/` exists, the canon-change rules apply: `CODEOWNERS` on the directory,
and design pages update in the same PR as the behavior they describe.
