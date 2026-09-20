# Mandatory spec sections

Each row names what the section prevents. A section is "present but inadequate" whenever it
exists yet fails to prevent its failure mode.

| # | Section | What good looks like | Failure mode it prevents | Blocking? |
| --- | --- | --- | --- | --- |
| 1 | **User stories — complete set** | Every capability the release promises has a story with an id, actor, outcome and acceptance criteria. | Work discovered mid-sprint that nobody scheduled. | Yes |
| 2 | **Non-functional requirements with numbers** | Latency at a stated percentile *and* load; availability target; throughput ceiling; data volume growth. | Drills with no threshold — i.e. theater. Performance discovered in production. | Yes |
| 3 | **Model quality targets with numbers** *(AI surfaces only)* | Metric, numeric threshold, evaluation method, and the version of the model/prompt it applies to. | An eval gate with nothing to pass. Subjective "it feels better" prompt changes. | Yes, when AI surfaces exist |
| 4 | **Gold-data availability** *(AI surfaces only)* | Named owner, dataset, version, committed date. If unavailable: the approved mitigation and its owner. | Evaluation blocked at the moment it is needed, with no fallback decided. | Yes, when AI surfaces exist |
| 5 | **UI design** *(where a UI exists)* | Versioned links to the actual frames, plus the state matrix: default, loading, empty, success, error, disabled. | "The design changed" as a mid-sprint surprise; missing empty and error states. | Yes, when a UI exists |
| 6 | **Legal confirmations** | The named confirmations obtained or explicitly pending, with owner and date. | A go-live blocked by a legal question nobody started. | Yes |
| 7 | **Compliance constraints** | Personal data inventory, retention periods, masking rules, audit events. | Auditability discovered to be impossible after the data model is fixed. | Yes |
| 8 | **Data-access grants** | What data, who grants access, by when, through which request. | A build lane blocked on credentials that take six weeks. | Yes |
| 9 | **Budget** | Infrastructure and third-party spend envelope for the target load. | An architecture that cannot be afforded at the volume the NFRs assume. | No, but flag loudly |
| 10 | **Acceptance authority per story** | A *named person*, not a role or a committee. | Nobody able to say "done"; acceptance drifting for weeks. | Yes |

## Cross-cutting checks

- **Numbers are load-bearing.** Any threshold that later becomes a drill or a gate must be
  traceable to a spec line. A number introduced in the design that is not in the spec is a gap
  in the spec.
- **One editable source.** Requirements live in the spec; the tracker links to them. A ticket
  that *copies* acceptance criteria into its own description has created a second editable copy
  and will drift.
- **Versions and baselines.** Each story identifies its approved version. A link to "the latest
  page" is insufficient — implementation must be pinned to a version that cannot change under
  it.
- **Open questions have owners and dates.** An open question with neither is not tracked, it is
  hoped about. Each should state which stage it blocks: spec completion, design, or
  implementation.
- **Existing code is not a requirement.** On a retrofit, what the system currently does is a
  *proposal* for the spec, never an approved requirement. Only the requirements owner can turn
  de-facto behavior into intent.
