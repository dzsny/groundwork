# Security pass

Runs in Round 1 **only when the diff touches** authentication, authorization, personal data,
external input, or outbound calls. Restraint is the point: a security pass that runs on every
diff gets skimmed on every diff.

This is an *engineering* review. Legal and regulatory compliance is a separate gate, owned
outside engineering; engineering's share of it is **auditability** — that the evidence trail
exists.

## Trigger check

Run the pass if the diff touches any of:

- Identity: login, session, token issuance or validation, password or key handling, SSO
- Authorization: permission checks, role or scope logic, tenancy boundaries, admin paths
- Personal data: anything identifying a person — read, written, logged, exported or retained
- External input: HTTP handlers, file or upload parsing, deserialization, queue consumers, CLI
  arguments, webhook receivers
- Outbound calls: any request to a system you do not control
- Configuration of any of the above, including infrastructure definitions

## 1. Authentication

- Is identity **proven**, or merely asserted? A user id read from a request body is an
  assertion.
- Token validation: signature, issuer, audience, **expiry**, and the algorithm — a verifier
  that accepts `none`, or accepts an algorithm chosen by the token, is broken.
- Session lifecycle: creation, renewal, invalidation on logout **and on password change**.
- Timing-safe comparison for secrets and tokens.
- Nothing security-relevant decided by a value the client controls.

## 2. Authorization

- **Where is the check enforced?** The enforcement point matters more than the model. A check in
  the UI is not a check.
- Every new route, handler, job and query: is there an authorization check, and is it the right
  one? A missing check on one route is the most common real vulnerability in this category.
- Object-level authorization: does the caller have rights **to this specific record**, not just
  to the endpoint?
- Tenancy: can a query cross a tenant boundary if an id is guessed or substituted?
- Deny by default. A new permission that defaults to "allowed" is a finding.

## 3. External input

- Validated **at the boundary**, with a schema, before it reaches domain logic.
- Injection surfaces: SQL and other query languages (parameterized, always), shell commands,
  path construction, template rendering, deserialization of untrusted data.
- Size and rate limits: request bodies, uploads, collection lengths, pagination parameters.
  Unbounded input is a denial-of-service surface.
- Output encoding appropriate to its destination.
- Redirects and URLs built from input: validated against an allowlist.

## 4. Outbound calls

- Timeouts on **every** call. No exceptions.
- Retry policy: capped, with backoff, and **only on retriable errors**. An unbounded retry on a
  permanent failure is an outage amplifier.
- TLS verification never disabled. If the diff disables it, that is a blocking finding
  regardless of the comment next to it.
- Credentials from configuration or a secret store, never from the source.
- The **error shape** handled: what happens on 4xx, on 5xx, on a timeout, on malformed JSON?
  Each needs a decision, and that decision belongs in `design/communications.md`.
- Is data being sent that should not leave? Check the payload, not the intent.

## 5. Data handling

- **Personal data inventory:** does this diff introduce a new place personal data is stored,
  logged or transmitted? If so, `design/security.md` and the data-residency table update in
  this PR.
- Logs and error messages: no personal data, no secrets, no tokens — including in stack traces
  and in the arguments of exceptions.
- Retention: does new stored data have a defined lifetime, and something that enforces it?
- Encryption in transit and at rest, per the project's stated classification.
- Audit events: is an action that should be auditable actually recorded, with actor, subject,
  action and timestamp?

## 6. Secrets

- No secret, key, token, password or connection string in the diff — **including in tests,
  fixtures and example files**.
- `.env.example` carries names, never values.
- A secret that was ever committed is compromised: the finding is "rotate it", not "remove it".

## Reporting

Order by exploitability, not by category. For each finding:

- The **concrete** failure: who can do what, with which input, and what they get.
- The location.
- Severity: **blocking** / should-fix / nit.
- What would fix it.

A finding you cannot make concrete is a question, not a finding — ask it as one. Speculative
security findings are the fastest way to get the whole pass ignored.

## Feeding the go-live gate

Findings from this pass do not close the go-live security gate — that gate needs one **full**
review with a dated verdict before sign-off. But note here anything the full review will need to
revisit, so it is not rediscovered from scratch.
