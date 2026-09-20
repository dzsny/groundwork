---
name: user-story
description: Write, review or rewrite a user story to a rigorous, testable standard with GIVEN/WHEN/THEN acceptance criteria, scope boundaries, error flows and a named acceptance authority. Use when the user wants to author a user story, turn a feature request or idea into a story, improve vague requirements or acceptance criteria, split a story that is too large, or produce the matching short issue-tracker description.
allowed-tools: Read, Write, Edit, Glob, Grep
---

# User story

A story describes **a meaningful outcome for an actor that can be accepted independently**. It
must make clear who needs the capability, why it matters, under what conditions it works, and
how the result will be verified.

The full template is `${CLAUDE_PLUGIN_ROOT}/skills/user-story/template.md`. Copy it into the
spec, do not paraphrase it.

## Where each thing lives

This is the rule that prevents the most common and most expensive failure — two editable copies
of the same requirement.

| Record | Authoritative home |
| --- | --- |
| Story intent, scope, requirements, acceptance criteria, requirement approval | **The spec**, with a stable story id and an explicitly approved version |
| Technical design and implementation plan | The repository's `design/` and `SPRINT.md` |
| Assignee, live status, work dependencies, execution estimates | **The tracker** (planning *intent* stays in `SPRINT.md`) |
| Test results, demonstrations, delivery acceptance | The tracker's delivery record, linking to the evidence |

Consequences you enforce when writing:

- The tracker issue **links** to the spec story at a specific version. It never copies the value
  statement, requirements or acceptance criteria into an independently editable description.
- A link to "the current page" is not enough. Pin the version.
- **Approved versions never change.** A requirement change creates a *new* approved version
  through a change request; the old version is preserved and the new one records which baseline
  it supersedes. Implementation that fails to meet an approved behavior is a **bug against that
  baseline**, not a reason to rewrite the requirement.
- **Requirement approval and delivery acceptance are different decisions.** Approval authorizes
  what may be built. Acceptance records whether the implementation meets it. Keep acceptance
  evidence out of the frozen baseline.

## Writing the story

Work through the template's sections. A simple story may need only a few sentences and its
acceptance criteria; use tables where they clarify complex behavior. Mark inapplicable
subsections **"Not applicable — reason"**; never delete them silently and never leave a
bracketed placeholder in a finished story.

The parts people get wrong, and how to get them right:

**Scope.** *In scope* is the behavior this story delivers, including where the flow starts and
ends. *Out of scope* is related behavior handled elsewhere — link those stories. "Process" means
the user or business flow, not the work of building it.

**Preconditions** are shared work. Product defines the business conditions (eligibility,
required business state); engineering contributes the technical ones (session, data, access,
service availability). Capture what is needed to understand and validate the story; detailed
implementation prerequisites belong in the design.

**Successful end state** is one brief, observable, testable sentence. It summarizes the outcome
without repeating the flow steps.

**Main flow** is the step sequence from trigger to successful outcome, described as *business
behavior*. Internal classes, tables and algorithms belong in the technical design, not here.

**Alternative and error flows.** Walk the list deliberately and name the ones that apply:
cancellation or back navigation · invalid or missing data · insufficient permissions · empty
results · expiry or timeout · external-service failure · repeated submission. For each: the
triggering condition, the expected behavior and feedback, and the end state — is data
preserved, how does the actor recover?

**Acceptance criteria** are the deliverable. GIVEN a specific actor, permissions, preconditions
and *starting data*; WHEN an unambiguous action or event occurs; THEN a verifiable result
follows; AND the feedback or preserved state, where relevant.

> Reject your own draft if an AC contains "successfully", "correctly", "fast", "secure" or
> "user-friendly". Those are not criteria. Cover every substantive requirement — the main flow
> **and** the relevant error, permission and boundary cases. There is no required number of
> criteria; there is a required coverage.

**Scope-specific sections.** Complete only what applies:

- *UI/UX* — versioned design links; the state matrix; interaction, focus and keyboard behavior;
  approved copy and accessibility requirements.
- *Backend / integrations* — a dependency table: required capability with inputs, outputs **and
  error outcomes**; the contract link; the owner and *verified* availability or a committed
  date. Data access: what data, who grants it, by when. Never secrets.
- *Non-functional, security, compliance* — reference shared requirements by id; for anything new
  to this story, give the measurable target **and** how it will be verified. Security
  requirements found here are refined into security acceptance criteria on the implementation
  tickets.
- *AI / model behavior* — what the model may do with what information; what happens when
  information is insufficient (response or human handoff); the quality target with its metric,
  numeric threshold and evaluation method; the golden set's owner, version and date; the
  mitigation if that data is missing; and what evaluation evidence must be delivered.

**Open questions** get an id, an owner, a due date, and the stage they block. If there are none,
write **None** — an empty table reads as "not checked".

## Splitting

If the story cannot be accepted in one decision, split it. Good seams, in order of preference:

1. By **outcome** — separate acceptable results, not separate technical layers.
2. By **flow** — happy path first, then a named alternative or error flow.
3. By **actor or permission scope**.
4. By **surface** — web, then mobile, then API — only when each is separately acceptable.

Never split into "backend story" and "frontend story": neither can be accepted alone, which
defeats the definition.

## Approval lifecycle

State which step the story is at, and refuse to skip one:

1. **Draft** — requirements questions are being resolved. Discovery, clarification and design
   tasks may exist; the delivery story and implementation tasks may **not** be created yet.
2. **Approved baseline** — the approver records the story id, exact version and date. Blocking
   questions must be resolved first. That version is preserved unchanged.
3. **Implementation** — tracker issues are created against that baseline. Approval permits
   ticket creation; *scheduling* additionally requires the design reference, acceptance scope,
   dependencies and an estimate (the Definition of Ready).
4. **Change requested** → **change approved** → **controlled adoption** — a CR names the
   affected story and baseline, the proposed change, reason and impact. Completed work keeps its
   original baseline; follow-up work is created for the approved change.

## The short tracker description

After approval, produce the tracker issue body from the template's final section: authoritative
requirements (id, version, version-specific link), links to the value statement, acceptance
criteria and acceptance authority, the Definition of Done reference, change control, and an
empty delivery record. Use the tracker's native fields for parent, assignee, priority, status
and blocks/blocked-by relationships.
