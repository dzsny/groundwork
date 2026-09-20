# Go-live readiness

<!-- The go-live decision record. Not a checklist someone ticks — a register of dated
observations.

THE RULE: a gate closes only on a dated observation.
    ✅ 2026-03-14 — load test at 1200 rps sustained p99 340 ms against the 500 ms target
                    (NFR-2); [run link]; 40 min soak.
Never by inference from CI green. A close without an observation is rejected in review.

Work that advances a gate but does not close it appends a dated progress note; the verdict
stays open. Touching the surface of a closed gate reopens it. Entries are APPEND-ONLY — this is
the record someone will need during an incident review. -->

**Project:** <name> · **Target date:** <date> · **Owner:** <name>

## Summary

| Gate | Status | Owner | Ticket |
| --- | --- | --- | --- |
| Tests green | open | | |
| Drills | open | | |
| Load | open | | |
| Eval gates | open / n/a | | |
| Monitoring | open | | |
| Runbooks | open | | |
| Rollback | open | | |
| Security review | open | | |
| Auditability | open | | |
| Integrations (LIVE) | open | | |
| Sign-off | open | | |

<!-- Delete an inapplicable gate with a one-line reason. A permanently-open gate that never
applied trains people to ignore the register. -->

---

## Tests green

**Status:** open · **Owner:** · **Ticket:**

- `YYYY-MM-DD` —

## Drills

**Status:** open · **Owner:** · **Ticket:**

<!-- Thresholds come from the spec's NFR numbers. A drill without a threshold does not close
anything — it is theater. -->

| Drill | Threshold | Source NFR | Result |
| --- | --- | --- | --- |
| Dependency unavailable | | | |
| Process/pod kill | | | |
| Failover | | | |

- `YYYY-MM-DD` —

## Load

**Status:** open · **Owner:** · **Ticket:**

- `YYYY-MM-DD` —

## Eval gates

**Status:** open · **Owner:** · **Ticket:**

<!-- Targets and gold data come from the spec. A gate with no target does not close. Record the
model and prompt version each result applies to — a passing result on a different version is
not a result. -->

| Suite | Target | Source | Model/prompt version | Result |
| --- | --- | --- | --- | --- |
| | | | | |

- `YYYY-MM-DD` —

## Monitoring

**Status:** open · **Owner:** · **Ticket:**

<!-- Closes on an OBSERVED alert firing for a failure mode the drills exercised. A dashboard
existing is not an observation. -->

- `YYYY-MM-DD` —

## Runbooks

**Status:** open · **Owner:** · **Ticket:**

<!-- Closes when someone who did not write the runbook followed it successfully. -->

- `YYYY-MM-DD` —

## Rollback

**Status:** open · **Owner:** · **Ticket:**

<!-- A drill PERFORMED: previous tag redeployed, migrations reversed, service verified. Not
"we could roll back". -->

- `YYYY-MM-DD` —

## Security review

**Status:** open · **Owner:** · **Ticket:**

<!-- One full review, dated verdict. Round-1 security passes feed it; they do not close it.
Legal and regulatory compliance is a separate gate owned outside engineering. -->

- `YYYY-MM-DD` —

## Auditability

**Status:** open · **Owner:** · **Ticket:**

<!-- Engineering's share of the compliance gate: the evidence trail exists — logs masked and
retained per the compliance constraints, dated verdicts, tagged releases, decision history. -->

- `YYYY-MM-DD` —

## Integrations (LIVE)

**Status:** open · **Owner:** · **Ticket:**

| Integration | Auth | Rate limits | Error shapes | Timeouts | Verified |
| --- | --- | --- | --- | --- | --- |
| | ☐ | ☐ | ☐ | ☐ | |

- `YYYY-MM-DD` —

## Sign-off

**Status:** open · **Owner:** <the acceptance authority named in the spec>

- `YYYY-MM-DD` —
