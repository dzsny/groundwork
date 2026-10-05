---
name: brd
description: Create a Business Requirements Document from an idea by interviewing the user, or import and normalize a BRD that already exists somewhere else (another tool, another session, a wiki page, pasted text). Use when the user has an idea or product they plan to build and no BRD yet, wants to write or draft a BRD, asks "what should we build and why?", brings a BRD from outside the repository, or the BRD has no stable requirement ids.
allowed-tools: Read, Write, Edit, Glob, Grep, Bash
---

# BRD

**Output:** a Business Requirements Document with stable requirement ids, measurable objectives,
explicit scope boundaries, a priority on every requirement, and a named approver.
**Template:** `${CLAUDE_PLUGIN_ROOT}/templates/requirements/brd.md`.

A BRD states **intent, not solution**. What the business needs and how it will know it got it.
No technology, no architecture, no screens. If you catch yourself writing "using Postgres" or
"a modal with two buttons", it belongs in the spec or the design, and you move it there.

Two modes. Say which one you are in.

- **Author** — there is an idea and no BRD. Interview, then write.
- **Import** — a BRD exists somewhere else. Normalize it without changing what it means.

If you cannot tell which, ask once: *"Is there already a BRD, in any form — a document, a wiki
page, a chat export — or are we starting from the idea?"*

> **Who owns the BRD.** The requestor owns the intent. You draft; you never approve. When the
> user is both requestor and builder, they approve it themselves — but as a distinct, dated act,
> not an implication of having answered your questions. Engineering never maintains an approved
> BRD; changes go through a change request.

---

## Mode: Author

### Before the first question

Read what already exists. Look for an `.groundwork.yaml`, a README, any notes the user has
pointed at, and any existing `requirements/` directory. Do not ask what the repository already
says. If a BRD turns out to exist, switch to Import.

### The interview

Run the `interview` skill, with this design tree as its starting map. The branches are ordered
by dependency — the earlier ones unblock the later ones.

```
Why        problem and opportunity ─ what people do today instead ─ what it costs
 └ Who     users ─ stakeholders ─ sponsor ─ who can say "approved"
    └ Win  objectives ─ success measures with numbers ─ by when ─ measured how
       └ What   capabilities as business needs ─ priority of each (MVP / Later / Won't)
          └ Edge   explicitly out of scope ─ things considered and refused
             └ Box   constraints (budget, deadline, legal, compliance, mandated tech)
                └ Deps   data, systems, vendors, approvals ─ who provides, by when
                   └ Risk   what could sink it ─ assumptions nobody has verified ─ owners
```

Push hardest on three things, because the rest of the pipeline cannot recover from them:

1. **Success measures with numbers.** "Faster onboarding" is not a measure. "Median time from
   signup to first report under 10 minutes by 2027-03-31, measured from event logs" is. If the
   user cannot give a number, record an open question with an owner — never invent a target.
2. **What is out of scope.** Ask for it explicitly. Requirements the requestor considered and
   refused are as valuable as the ones they kept, and they are the cheapest scope-creep
   defense there is.
3. **Priority on every requirement.** MVP / Later / Won't. If everything is MVP, nothing was
   prioritized — ask "if you could ship only three of these, which three?"

Keep requirements at the level of business need: *"The business must be able to …"*. One
testable need per requirement. If a requirement contains "and" joining two outcomes, split it.

### Writing it

Copy the template to the path in `paths.brd` (default `requirements/brd.md`) and complete every
section. Rules:

- **Ids are permanent.** `BR-001`, `OBJ-01`, `C-01`, `DEP-01`, `RSK-01`, `Q-01`. Never renumber,
  never reuse. A dropped requirement stays in the table with priority **Won't** — the spec and
  the tracker may already point at it.
- **Every requirement carries provenance** — `decided: <name>, <date>`. A value the user never
  confirmed is a proposal, and goes in the open questions, not the table.
- **Inapplicable sections** read **"Not applicable — reason"**. Never delete a section, and
  never leave a bracketed placeholder in a finished document.
- **Open questions** carry an owner, a due date and what they block. None → write **None**.
- **Glossary.** Every domain noun the interview had to disambiguate becomes a glossary entry.

### Reading it back

Before declaring the draft done, play it back as a one-screen summary — the problem, the three
objectives, the MVP requirement ids, what is out — and ask for corrections. Then run the lint
below on your own draft.

---

## Mode: Import

The BRD was written somewhere else: another session, another tool, a wiki, a spreadsheet, a
Word document, or by hand. That is fine. The gap this mode closes is a BRD that arrives without
the shape the rest of the pipeline reads.

### Locate it

Take it from the user's message, an attached file, a path, or a link. A link you cannot fetch is
a link you cannot import: say so and ask for the text. Do not guess at the contents of a
document you have not read.

### Normalize — preserving meaning

The goal is to **re-shape, never re-decide**.

1. Map the source's sections onto the template. Keep the author's wording for requirements; do
   not rewrite them into your own.
2. **Assign ids** to every requirement, objective, constraint and risk that lacks one, in the
   order they appear. Where the source already has ids, keep them verbatim, whatever scheme.
3. Record the provenance in section 1: `Source: imported from <where>, <date>`.
4. Anything the source states that does not fit the template goes under the closest section,
   not away. Nothing is dropped silently.
5. **Do not fill gaps.** A missing priority, a missing number or a missing approver is not yours
   to supply. Mark it `UNKNOWN`, add an open question with an owner, and list it in the report.
   Import is the point at which fabrication is most tempting, because the document *looks*
   nearly complete.

### Lint — what a BRD must have before a spec can be built from it

Report each as **present · present but inadequate · missing**, with a reason in the reader's own
terms.

| Check | Inadequate looks like |
| --- | --- |
| Problem and current workaround stated | A solution described as if it were the problem. |
| Objectives with numbers | "Improve", "reduce", "better" with no target or date. |
| Every requirement has an id and a priority | A flat list; everything is "must". |
| Requirements are needs, not solutions | Technology, UI and architecture embedded in a requirement. |
| Each requirement is one testable need | Two outcomes joined with "and". |
| Out of scope is explicit | No section, or "anything not listed". |
| Constraints carry numbers and owners | "Limited budget", "ASAP". |
| A named approver exists | A department, "the business", or nobody. |
| Contradictions | Two requirements that cannot both hold — quote both. |

### Report

End with the lint table, the list of ids you assigned, the open questions you raised, and one
verdict:

- **Normalized, ready for a spec** — no blocking `UNKNOWN` remains that the spec cannot carry
  as an open question.
- **Normalized, needs the requestor** — name the questions only they can answer, grouped by
  owner.

If the source is thin enough that normalizing would mean inventing, say so and offer to run
**Author** mode from it instead: use the source as the seed, and interview for the rest.

---

## Approval and freezing

State where the BRD is in its lifecycle, and refuse to skip a step:

1. **Draft** — questions are being resolved. A spec may be started, but every story that rests
   on an unresolved question inherits it.
2. **Approved** — the approver records version, date and decision in section 12. Blocking
   questions are resolved first. This version is preserved unchanged.
3. **Changed** — a change request names the requirement ids affected, the reason and the
   impact. The approved version is kept; a new version supersedes it.

Do not mark a BRD approved on the user's say-so inside the interview. Ask the approver directly
— "do you approve version 0.3 as written?" — and record the answer with the date.

## Hand-off

When the BRD is drafted or imported, name the single next step: **`functional-spec`**, to derive
the spec from it. If open questions block approval, say so first — the spec can begin on a draft
BRD, but the user should know which stories will inherit which unknowns.
