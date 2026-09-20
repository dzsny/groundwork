# External contracts

<!-- Canon. One entry per external contract, inbound and outbound. The error, timeout and retry
columns are the point: they are what the LIVE verification track checks against the real
provider, and what turns "the integration works" into a dated verdict. -->

## Inventory

| Counterpart | Direction | Protocol | Auth | Contract | Verified |
| --- | --- | --- | --- | --- | --- |
| | out | | | | ☐ |

<!-- "Verified" = exercised against the REAL provider and recorded in go-live-readiness.md.
Until then, every claim on this page is a hypothesis about someone else's system. -->

---

## <Counterpart name>

**Direction:** outbound | inbound
**Purpose:** <what we need from them, or what they need from us, in one sentence>
**Contract:** <link to their spec / OpenAPI / our published contract>
**Authentication:** <mechanism; where the credential lives — never the credential>

### Operations used

| Operation | When we call it | Idempotent? |
| --- | --- | --- |
| | | |

### Failure policy

| Condition | Their behavior | Our response |
| --- | --- | --- |
| 4xx — client error | | |
| 429 — rate limited | | |
| 5xx — server error | | |
| Timeout | | |
| Malformed response | | |

**Timeout:** <value> **Retry:** <policy, cap, backoff — retriable conditions only>
**Rate limits:** <theirs, and how we stay under them>

### What we send

<!-- Explicit, because this is a data-egress decision. Cross-check against the personal data
inventory in security.md. -->

### Verification

| Date | What was exercised | Verdict |
| --- | --- | --- |
| | | |

<!-- A promise in a provider's documentation is not a verified fact. Auth flows, rate limits,
error shapes and timeouts all routinely differ from the docs — that is why LIVE exists. -->
