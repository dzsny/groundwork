# User story template

Copy this into the functional spec and complete it. Sections 1–4 and 6–8 are the core; complete
section 5 according to the story's scope and mark inapplicable subsections
**"Not applicable — reason."** Replace every bracketed placeholder. Record unknowns as open
questions with an owner and a due date.

---

## 1. Story details

**Title:** [A short title describing the outcome; name the surface where it matters.]

| Field | Value |
| --- | --- |
| Story id | [Stable identifier, e.g. US-012] |
| Parent epic | [Link] |
| BRD requirement / approved change request | [Exact section or requirement id, and link] |
| Product owner | [Name] |
| Acceptance authority | [The named person who accepts this story] |
| Affected surface / channel | [Web, mobile, API, internal process, …] |
| Requirements approver | [Named person authorized to approve the requirements] |
| Baseline version and approval | [Draft, or exact approved version + version-specific link + approver + date] |
| Change control | [Initial baseline, or CR link and superseded version] |

## 2. Background and scope

[2–4 sentences: the user or business need, the context it arises in, the intended outcome. Say
whether this introduces a new capability or changes an existing one.]

**In scope:** [The outcome this story delivers, including where the flow starts and ends.]

**Out of scope:** [Related capabilities handled by other stories — link them.]

## 3. Value statement

**AS A** [specific role or user type],
**I WANT** [an action or capability],
**SO THAT** [a business or user outcome].

## 4. Requirements

### Actors, permissions and preconditions

- **Initiator and other actors:** [Who starts it, who is affected, who approves.]
- **Permissions:** [Who is allowed or denied? Which organization, account or data scope? Link
  the permissions matrix.]
- **Entry point / trigger:** [Where the capability is accessed, or which event starts it.]
- **Preconditions:** [Required session, business state and available data.]
- **Successful end state:** [What changes, and what feedback the actor receives.]

### Main flow

1. [User action or triggering event.]
2. [System response and the applicable business rule.]
3. [Next step and observable outcome.]

[Describe business behavior. Internal classes, database tables and algorithms belong in the
technical design.]

### Business rules and data

| Rule / data | Requirement or shared-rule reference |
| --- | --- |
| [R-01 — business rule] | [Exact condition and consequence; reference the existing shared rule where one exists] |
| [Field / input] | [Required or optional, allowed values or limits, validation and error feedback] |

### Alternative and error flows

Consider: cancellation or back navigation · invalid or missing data · insufficient
permissions · empty results · expiry or timeout · external-service failure · repeated
submission.

| Flow | Triggering condition | Expected behavior and feedback | End state / recovery |
| --- | --- | --- | --- |
| [A-01] | [Exact event] | [What happens and what the actor sees] | [Is data preserved? How does the actor continue or retry?] |

## 5. Scope-specific requirements

### UI / UX — where a user interface is involved

**Design:** [Exact frame or prototype link, with version.]
**States:** [Default, loading, empty, success, error, disabled — as applicable.]
**Interactions:** [Navigation, dismissal, back navigation, focus and keyboard behavior, platform
differences.]
**Copy and accessibility:** [Approved wording or its reference; applicable requirements.]

### Backend / integrations — where data or external systems are involved

| Dependency | Required capability / inputs and outputs | Contract link | Owner and availability |
| --- | --- | --- | --- |
| [Service / another story] | [Behavior required by this story, **including error outcomes**] | [Spec / design / API contract] | [Name; verified availability or committed date] |

**Data access:** [Which data, who provides access, by when. Link the access request or grant. No
secrets.]

### Non-functional, security and compliance requirements

**Affected areas:** [Authentication/authorization, personal data, external input, outbound
calls — or "Not applicable" with a reason.]

Reference shared requirements by id and link. For a requirement new to this story, give the
measurable target and how it will be verified.

| Requirement | Applicable target and measurement conditions | Verification |
| --- | --- | --- |
| [NFR id and link] | [e.g. response-time percentile, threshold and load] | [Measurement / test reference] |
| [Security / data-handling requirement] | [Access, masking, retention, auditable event] | [Security acceptance criterion / check] |

Security requirements identified here are refined into security acceptance criteria on the
implementation tickets.

### AI / model behavior — for stories involving a model

- **Expected output and boundaries:** [Which task may the model perform, using which
  information? What response or human handoff is expected when information is insufficient?]
- **Quality target:** [Metric, numeric threshold, evaluation method; link the spec's evaluation
  requirement.]
- **Golden set:** [Data owner, dataset and version, availability and committed date.]
- **Missing evaluation data:** [Approved mitigation and its owner, if required.]
- **Evidence required:** [What evaluation evidence must be delivered; the run and
  model/prompt version are recorded during verification.]

## 6. Acceptance criteria

Acceptance criteria define **how correct behavior will be demonstrated**. Cover every
substantive requirement, including the main flow and the relevant error, permission and boundary
cases. Tests and implementation tickets reference these ids.

### AC-01 — [Successful main flow]

**GIVEN** [actor, permissions, preconditions and specific starting data],
**WHEN** [an unambiguous action or event occurs],
**THEN** [a verifiable result follows],
**AND** [feedback or a preserved business state, where relevant].

### AC-02 — [Error or rejected action]

**GIVEN** [the specific condition that causes the error],
**WHEN** [the action occurs],
**THEN** [the expected rejection or error feedback is provided],
**AND** [the resulting data state and permitted recovery are defined].

### AC-03 — [Alternative flow / boundary / permission]

**GIVEN** [a precise situation],
**WHEN** [an event occurs],
**THEN** [a verifiable outcome follows].

[Add criteria as needed. These headings do not prescribe a number. "Fast", "secure" and "works
correctly" are not acceptance criteria.]

## 7. Readiness and Definition of Done

Record the state at approval here. After approval, maintain readiness progress and delivery
records in the tracker; do not update the frozen baseline to reflect progress.

**Business clarification:** [No unresolved questions blocking the requirements / the ids of the
blocking questions.]

**Ticket creation gate:** the delivery story and implementation tasks may be created only from
an explicitly approved version. Discovery, clarification and design tasks are preparation work
and may precede approval.

**Implementation readiness:** record the approved baseline, applicable AC ids, design reference,
resolved or scheduled dependencies, and estimate on the implementation tickets. Track ownership
and estimates are human decisions made during planning. Approval alone does not make a ticket
ready to start.

**Common Definition of Done — implementation tickets:**

- [ ] Code merged into its integration branch
- [ ] Unit tests cover the happy path and at least one failure mode (the minimum; review and CI
      coverage gates also apply)
- [ ] Acceptance criteria met
- [ ] No new `TODO` without a ticket id
- [ ] Affected design pages updated in the same PR
- [ ] Required review and CI checks pass; review comments resolved before merge

**Story-specific additions:** [Deliverables beyond the common Definition of Done, or "None."]

**Delivery record — maintained in the tracker after approval:** dated evidence against the
approved version and AC ids, including test, demonstration or evaluation links and pass/fail
results; business acceptance with the acceptance authority's name, date and decision. Acceptance
remains pending until recorded. Do not append these results to the frozen baseline.

Story completion and acceptance do not replace the release and go-live gates required for
production deployment.

## 8. Notes — open questions and decisions

| id | Question / conflicting requirements | Owner | Due date | Blocking? Which stage? | Decision and reference |
| --- | --- | --- | --- | --- | --- |
| [Q-01] | [What is missing or contradictory?] | [Name] | [Date] | [Spec completion / design / implementation / none] | [Open, or approved decision link and date] |

If there are no open questions, write **None**. Resolve blocking requirement questions before
approving a baseline. Existing code alone does not establish an approved requirement.

---

## Short tracker description — copy and complete after approval

Create the tracker delivery story only after requirement approval. The approved baseline
reference is mandatory and cannot be "pending".

**Authoritative requirements:** [Story id, approved version, version-specific link, approval
record.]
**Value statement:** [Link to section 3 of that baseline.]
**Acceptance criteria:** [Link to section 6 of that baseline.]
**Acceptance authority:** [Link to section 1 of that baseline.]
**Design and implementation plan:** [Versioned design reference and the relevant `SPRINT.md`
section — required before implementation starts.]
**Definition of Done:** [This template, section 7, plus story-specific additions.]
**Change control:** [Initial baseline, or approved CR with the old and new baselines.]
**Delivery record:** [Dated evidence links, AC results, business acceptance. "Pending delivery"
until available.]

Use the tracker's native fields for parent, assignee, priority, live status, implementation and
test tickets, and blocks / blocked-by relationships. Do not copy the value statement,
requirements or AC text into an independently editable description.
