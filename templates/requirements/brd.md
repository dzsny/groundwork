# Business Requirements Document — [Project name]

> **A BRD states intent, not solution.** It says what the business needs and how success is
> measured. Technology, architecture and screens belong in the spec and the design package.
> Replace every bracketed placeholder. Write **Not applicable — reason** rather than deleting a
> section, and **None** rather than leaving a table empty.

## 1. Document control

| Field | Value |
| --- | --- |
| Version | [0.1 draft, or the approved version] |
| Status | [Draft / Approved] |
| Requestor (owns the intent) | [Named person] |
| Approver | [Named person authorized to approve this BRD] |
| Approved on | [Date, or "not yet approved"] |
| Supersedes | [Previous approved version, or "Initial baseline"] |
| Source | [How this BRD came to exist: interview date, or the document it was imported from] |

## 2. Problem and opportunity

[What is wrong or missing today, for whom, and what it costs. Describe the **current
workaround** — what people do today without this. 3–6 sentences.]

## 3. Business objectives and success measures

| id | Objective | Success measure | Target | Measured how, by whom | Source |
| --- | --- | --- | --- | --- | --- |
| OBJ-01 | [Outcome the business wants] | [Metric] | [Number and date] | [Method and owner] | [decided: name, date] |

A success measure without a number is an open question (section 11), not a measure.

## 4. Stakeholders and users

| Role | Who (name or group) | Interest / what they do today | Acceptance authority? |
| --- | --- | --- | --- |
| [Primary user] | [Group] | [What they need] | No |
| [Sponsor] | [Named person] | [What they decide] | [Yes — for what] |

## 5. Scope

**In scope:** [Capabilities and the business processes touched.]

**Out of scope:** [Related things this explicitly does **not** deliver. Anything the requestor
considered and refused belongs here, so it is not rediscovered as a surprise.]

## 6. Business requirements

Each requirement has a stable id that never changes and is never reused. The functional spec
traces every user story back to one of these ids.

| id | Requirement | Objective | Priority | Rationale | Source |
| --- | --- | --- | --- | --- | --- |
| BR-001 | [One testable business need, stated as a need — "The business must be able to …"] | [OBJ-01] | [MVP / Later / Won't] | [Why it matters] | [decided: name, date] |

**Priority** is one of:

- **MVP** — the product is not worth releasing without it.
- **Later** — wanted, deliberately deferred.
- **Won't** — considered and rejected for this scope. Recorded so the decision survives.

## 7. Constraints and assumptions

| id | Type | Statement | Owner | Confirmed? |
| --- | --- | --- | --- | --- |
| C-01 | [Budget / Deadline / Legal / Compliance / Mandated technology / Organizational] | [The constraint, with its number or date] | [Name] | [Yes — date / No] |
| A-01 | Assumption | [Something taken as true that has not been verified] | [Who can verify] | [No] |

An assumption is a risk wearing a disguise: each one needs somebody who can verify it.

## 8. Dependencies and data access

| id | Dependency | Needed for | Provided by | Needed by |
| --- | --- | --- | --- | --- |
| DEP-01 | [Data, system, vendor, decision or approval] | [BR-001] | [Name] | [Date] |

Never record secrets or credentials here — only who grants access and by when.

## 9. Risks

| id | Risk | Likelihood | Impact | Mitigation | Owner |
| --- | --- | --- | --- | --- | --- |
| RSK-01 | [What could go wrong] | [L / M / H] | [L / M / H] | [What reduces it] | [Name] |

## 10. Glossary

| Term | Definition |
| --- | --- |
| [Domain noun used in this document] | [One definition, used the same way everywhere] |

## 11. Open questions

| id | Question | Owner | Due date | Blocks | Decision and reference |
| --- | --- | --- | --- | --- | --- |
| Q-01 | [What is unknown or contested?] | [Name] | [Date] | [BRD approval / spec / design / implementation] | [Open, or decision and date] |

Resolve every question that blocks BRD approval before approving. If there are none, write
**None**.

## 12. Approval record

| Version | Approver | Date | Decision | Notes |
| --- | --- | --- | --- | --- |
| [0.1] | [Name] | [Date] | [Approved / Changes requested] | [Reference] |

**Approved versions never change.** A change creates a new version through a change request
that names the requirement ids it touches, why, and the impact; the previous version is kept.
