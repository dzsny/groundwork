# Security

<!-- Canon. For a live system this is the page with the highest cost of being wrong — and on a
retrofit, the one to write first. Document the enforcement POINTS, not just the model: a rule
stated in a document and enforced nowhere is the most common real vulnerability. -->

## Authentication

**How identity is established:**

| Actor type | Mechanism | Proven by | Session lifetime |
| --- | --- | --- | --- |
| | | | |

**Token/session handling:** <issuance, validation (signature, issuer, audience, expiry,
algorithm), renewal, invalidation on logout and on credential change>

## Authorization

**Model:** <roles / scopes / attributes / tenancy — whichever it actually is>

**Enforcement points** — where the check happens, in code:

| Surface | Check | Enforced at | Default |
| --- | --- | --- | --- |
| | | | deny |

<!-- Deny by default. A permission that defaults to "allowed" is a finding, every time. -->

**Object-level authorization:** <how we ensure the caller has rights to THIS record, not just
to the endpoint>

**Tenancy boundary:** <what stops a query crossing it when an id is guessed or substituted>

## Personal data

| Data | Where stored | Where logged | Masking | Retention | Legal basis |
| --- | --- | --- | --- | --- | --- |
| | | | | | |

<!-- Cross-check against infrastructure.md § Data residency and communications.md § What we
send. Three pages, one inventory — if they disagree, one of them is wrong. -->

## Audit events

| Event | Actor | Subject | Recorded where | Retention |
| --- | --- | --- | --- | --- |
| | | | | |

<!-- This section is engineering's share of the compliance gate: the evidence trail exists. -->

## External input

| Entry point | Validated where | Against what |
| --- | --- | --- |
| | | |

## Per-story security outcomes

<!-- Every story that touched auth, personal data, external input or outbound calls got a lite
threat pass during design. Its outcome — the security acceptance criteria that went onto the
implementation tickets — is recorded here. This is the running record of what was actually
considered, and it is what the full go-live security review reads first. -->

### <US-id> — <title>

**Surfaces touched:**
**Threats considered:**
**Security acceptance criteria placed on tickets:**
**Residual risk accepted, by whom:**

---

## Known gaps

| Gap | Risk | Owner | Tracked as |
| --- | --- | --- | --- |
| | | | |

<!-- A named gap with an owner beats an unnamed one. Do not delete a gap to make the page look
better; close it or record who accepted it. -->
