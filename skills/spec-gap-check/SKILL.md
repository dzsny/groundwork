---
name: spec-gap-check
description: Check a functional specification or requirements document for completeness, ambiguity and coverage against the business requirements before design starts. Use when the user has a spec, PRD, FS, BRD or requirements doc and wants it reviewed, gap-checked, validated, or asks "is this ready to build?", "what's missing from these requirements?", or wants a readiness verdict before a design or sprint plan.
allowed-tools: Read, Glob, Grep, Write, Bash
---

# Spec gap check

**Trigger:** requirements arrive and someone wants to start designing.
**Input:** the business requirements (BRD) and the functional spec (FS), in whatever form they
exist — a document, a wiki export, a folder of markdown, a ticket description.
**Output:** a gap report that doubles as the agenda for the requirements meeting, plus a binary
**ready / not-ready-for-design** verdict.

> **You never patch a gap yourself.** A missing section is returned to its owner, not invented.
> Inventing an NFR number is the single most expensive thing this skill could do: it becomes a
> drill threshold, then a go-live gate, and nobody ever learns it was fiction.

## 1. Structural completeness

Check the spec against the mandatory sections. Use
`${CLAUDE_PLUGIN_ROOT}/skills/spec-gap-check/checklist.md` — it carries the full list with the
failure mode each section prevents.

For each section: **present · present but inadequate · missing**. "Present but inadequate" is
the most useful verdict you produce, and it needs a reason in the reader's own terms — "the NFR
section exists but says 'fast response times'; a drill cannot be written against that."

The numeric sections are not optional and not negotiable:

- **NFRs with numbers** — latency, availability, throughput, at stated percentiles and load.
  No numbers → no drill thresholds → no go-live. Flag as blocking.
- **Model quality targets with numbers** (only when `project.ai_surfaces` is true) — gold-set
  pass rates, rubric scores, *plus* gold-data availability: who provides the sets, by when. If
  nobody can, the mitigation (synthetic generation + expert validation, staged thresholds) is
  decided **here**, not discovered during verification. Flag as blocking.
- **Named acceptance authority per user story** — a role is not a name. Flag as blocking.

## 2. BRD ↔ spec coverage

Two directions, both matter:

- **Uncovered promise:** something the BRD commits to that no user story delivers. This is the
  expensive one — it surfaces at acceptance, in front of the requestor.
- **Unanchored content:** a user story with no BRD anchor. Not necessarily wrong — it may be
  necessary detail — but it is scope the requestor never approved. Flag it for a decision, do
  not delete it.

Produce a coverage table: BRD requirement id → the story ids that cover it → verdict.

## 3. Per-story quality

For each user story, flag:

- **Ambiguity** — wording that two competent people would implement differently. Quote the
  phrase.
- **Contradiction** — with another story, a shared business rule, or itself.
- **Untestable acceptance wording** — "works correctly", "fast", "secure", "user-friendly".
  For each, state what a verifiable version would need: an actor, a precondition, a trigger, an
  observable result.
- **Undefined terms** — domain nouns used as if defined, that the spec never defines.
- **Missing failure paths** — a main flow with no alternative or error flow. Cancellation,
  invalid input, insufficient permissions, empty results, timeout, external-service failure,
  duplicate submission: name the ones this story plausibly has and lacks.

Reference `${CLAUDE_PLUGIN_ROOT}/skills/user-story/template.md` for the story structure this is
measured against, and hand individual stories to the `user-story` skill when the user wants them
rewritten rather than just flagged.

## 4. The verdict

End with exactly one of:

- **Ready for design** — no blocking gaps. Non-blocking findings are listed as a follow-up.
- **Not ready** — list the blocking gaps, in priority order, each with its owner. Say plainly
  that design does not start until they close.

Then the **iteration agenda**: the blocking gaps grouped by who must answer them, so the
requirements meeting runs off this document. One line per item: the question, the owner, and
what it blocks.

## Output format

Write the report to a file when the user wants to circulate it (`spec-gap-report.md` next to
the spec, or wherever they say); otherwise answer in the conversation. Structure:

```
# Spec gap check — <spec name>, <date>

**Verdict: NOT READY FOR DESIGN** — 4 blocking gaps.

## Blocking gaps
| # | Gap | Section | Owner | Blocks |

## Structural completeness
| Section | Verdict | Note |

## BRD ↔ spec coverage
| BRD requirement | Covered by | Verdict |

## Per-story findings
### US-012 — <title>
- **Ambiguous** — "…" — two readings: … / …
- **Untestable AC** — AC-02 …

## Iteration agenda
```

Keep every finding quotable and located. A finding the owner cannot find in their own document
is a finding they will ignore.
