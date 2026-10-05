# Functional Specification — [Project name]

> This is the **index and cross-cutting layer** of the spec. Each user story lives in its own
> file under `stories/`, so it can be approved, versioned and frozen independently
> (`stories/US-001-<slug>.md`, from the `user-story` template).
>
> **Never invent a number, a name or a date.** An unknown is written as `UNKNOWN — Q-nn` and
> tracked as an open question with an owner. `spec-gap-check` flags it; a made-up figure it
> cannot flag.

## 1. Document control

| Field | Value |
| --- | --- |
| Version | [0.1 draft, or the approved version] |
| Status | [Draft / Approved / Frozen] |
| Business requirements | [Link and **version** of the BRD this spec derives from] |
| Product owner | [Named person] |
| Spec approver | [Named person authorized to approve] |
| Frozen on | [Date, or "not frozen"] |

Frozen means: adding or modifying a user story now requires a change request with its own
design pass.

## 2. Actors and permissions

| Actor | Description | Permissions / data scope |
| --- | --- | --- |
| [Role] | [Who they are] | [What they may and may not do; which data they see] |

## 3. User story index

| Story | Title | Covers | Priority | MVP | Version | Acceptance authority | Status |
| --- | --- | --- | --- | --- | --- | --- | --- |
| [US-001](stories/US-001-slug.md) | [Outcome] | [BR-001] | [MVP / Later] | [yes / no] | [0.1] | [Named person] | [Draft / Approved] |

The set must be **complete**: every capability the release promises has a story here.

## 4. Traceability — BRD ↔ stories

| BRD requirement | Priority | Delivered by | Verdict |
| --- | --- | --- | --- |
| BR-001 | MVP | US-001, US-002 | Covered |
| BR-002 | Later | — | Deferred (BRD priority: Later) |

Both directions must hold: every **MVP** `BR-nnn` has at least one story, and every story names
at least one `BR-nnn`. A story with no anchor is scope the requestor never approved.

## 5. Non-functional requirements — with numbers

| id | Category | Requirement | Target | Percentile / load / conditions | Verification | Source |
| --- | --- | --- | --- | --- | --- | --- |
| NFR-01 | Latency | [What] | [e.g. 400 ms] | [p95, at 50 concurrent users] | [Load test] | [decided: name, date] |
| NFR-02 | Availability | [What] | UNKNOWN — Q-03 | | | |

Cover, as applicable: latency, availability, throughput, data volume and growth, recovery
objectives. Drill thresholds are derived from this table — no number, no drill, no go-live.

## 6. Model quality targets and gold data *(AI surfaces only)*

| id | Task | Metric | Threshold | Evaluation method | Applies to model / prompt version |
| --- | --- | --- | --- | --- | --- |
| MQ-01 | [What the model does] | [Metric] | [Number] | [How measured] | [Version] |

**Gold data:** [Dataset, owner (named), version, committed date.] If nobody can provide it,
record the approved mitigation here **and its owner** — decided now, not discovered during
verification.

## 7. UI design *(where a UI exists)*

[Versioned links to the actual frames or prototypes, plus the state matrix: default, loading,
empty, success, error, disabled. Designs stay here, linked — never copied into the design
package.]

## 8. Legal confirmations

| id | Confirmation | Owner | Status | Date |
| --- | --- | --- | --- | --- |
| LGL-01 | [What legal must confirm] | [Name] | [Obtained / Pending] | [Date] |

## 9. Compliance constraints

| Concern | Requirement |
| --- | --- |
| Personal data inventory | [What personal data, whose, why] |
| Retention | [Period per data class] |
| Masking | [What is masked, where] |
| Audit events | [Which events must be recorded, and for how long] |

## 10. Data-access grants

| Data | Granted by | Request / reference | Needed by | Status |
| --- | --- | --- | --- | --- |
| [Dataset or system] | [Named person] | [Link or ticket] | [Date] | [Granted / Requested / Not started] |

Never record secrets. Only who grants access and by when.

## 11. Budget

| Item | Envelope | Basis |
| --- | --- | --- |
| Infrastructure at target load | [Amount per period] | [Which NFR load it assumes] |
| Third-party services | [Amount per period] | [Which services] |

## 12. Glossary

[Inherit the BRD glossary by reference; add only terms introduced by this spec.]

## 13. Open questions

| id | Question | Owner | Due date | Blocks | Decision and reference |
| --- | --- | --- | --- | --- | --- |
| Q-01 | [What is unknown?] | [Name] | [Date] | [Spec completion / design / implementation] | [Open, or decision and date] |

If there are none, write **None**.
