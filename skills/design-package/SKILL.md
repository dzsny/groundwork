---
name: design-package
description: Create or update the in-repo technical design package — architecture, data flow, tech rationale, infrastructure, external contracts, security and the go-live readiness register. Use when the user wants architecture documentation, a design doc, a technical design for a new system or feature, wants to document how a system works, asks what design docs a project should have, or needs org-required artifacts like a high-level architecture, data-flow or network diagram.
allowed-tools: Read, Write, Edit, Glob, Grep, Bash
---

# Design package

The repository's `design/` directory is **canon**: read before substantial changes, updated in
the same PR as the behavior it describes. This skill authors it.

For an existing codebase with no design at all, use `design-reconstruct` instead — it produces
the same pages but marks them honestly as as-built and unverified.

## The pages

Exactly these, each with exactly one job. Templates live in
`${CLAUDE_PLUGIN_ROOT}/templates/design/`.

| Page | Owns |
| --- | --- |
| `architecture.md` | The high-level architecture diagram, the component inventory, and the data flow |
| `tech-rationale.md` | The **current** rationale: every significant choice, and what was rejected |
| `adr/` | Decision history — immutable, traceability only (see the `adr` skill) |
| `infrastructure.md` | Network topology, environments, data residency and classification |
| `communications.md` | Every external contract: inbound and outbound, with error shapes |
| `security.md` | Authentication, authorization, data handling, per-story security outcomes |
| `go-live-readiness.md` | The gate register (see the `go-live-gates` skill) |

Org-required artifacts map to **one home each**. If an organization asks for a "data-flow
diagram" and a "network-flow diagram" as separate deliverables, they are still sections of
`architecture.md` and `infrastructure.md` — produce an export, never a second editable copy.

**There is deliberately no in-repo functional spec.** Requirements live in the spec. Design
pages reference story ids; UI designs and legal confirmations are linked, never copied.

## Rules that make the package worth maintaining

1. **A page states what *is*, not what might be.** Speculation belongs in an ADR's rejected
   alternatives, not in the architecture page.
2. **Diagrams are text.** Use Mermaid, so the diagram is reviewable in a diff. A PNG is a
   binary blob that goes stale invisibly.
3. **Every claim is locatable.** When a page says "requests are rate-limited at the gateway",
   a reader must be able to find that code. Name the module, the file, or the config key.
4. **No page describes a thing twice.** If auth appears in `architecture.md` and `security.md`,
   one of them links to the other. Drift is silent.
5. **Updated in the same PR as the behavior.** Not as a follow-up ticket. Follow-up doc tickets
   are how design packages die.

## Writing a page from scratch

Work from evidence, in this order, and say which you used:

1. The spec — what the system is *supposed* to do.
2. The code — what it *does*. Read entry points, module boundaries, configuration and
   dependency manifests before you write a word.
3. The deployment — what is *actually running*: CI/CD definitions, infra-as-code, environment
   config.

Where these three disagree, that disagreement is the most valuable thing in the document. Write
it down explicitly rather than smoothing it over; then route it through the triage rule —
implied by the spec → bug; not implied → change request.

### `architecture.md`

Opens with the diagram. Then: the component inventory (what each component is responsible for,
in one line each, plus what it is *not* responsible for), the data flow (follow one
representative request end to end, naming every hop), and the state model (what is persisted,
what is in-memory, what is cached and for how long).

### `tech-rationale.md`

One entry per significant choice: **the choice · why · what was rejected and why not · what
would make us revisit it**. That last clause is what turns a rationale into a maintainable
document — it names the condition under which the decision expires. Keep it current: when a
decision is superseded, rewrite the entry and file the superseding ADR.

### `infrastructure.md`

Network topology and trust boundaries. The environment matrix (what exists, what it is for,
what data it holds). Data residency as a table: **store × data type × classification ×
region** — this is the section auditors actually read. Secrets handling: where they live, who
can read them, how they rotate. Never the secrets.

### `communications.md`

One entry per external contract, inbound and outbound: the counterpart, the protocol, the
authentication method, the payload contract link, **the error shapes and what we do with each
one**, the timeout and retry policy, and the rate limits. The error and retry columns are the
point — that is what the LIVE verification track will check against reality.

### `security.md`

Authentication: who can be who, and how that is proven. Authorization: the permission model and
where it is enforced (the enforcement *point* matters more than the model). Data handling:
personal data inventory, masking, retention, audit events. Then a running section of per-story
security outcomes: each story that touched auth, personal data, external input or outbound
calls, and the security acceptance criteria that came out of it.

## Finishing

Before you call the package done:

- Every page exists and none contains an unreplaced placeholder.
- The data-residency table covers every store named in `architecture.md`.
- Every external system in `architecture.md` has a row in `communications.md`.
- `CODEOWNERS` makes the design owner a required reviewer on the directory.
- The diagrams render. Check the Mermaid syntax.

Then say which claims you could **not** verify against code or deployment, and what would be
needed to verify them. An unverified claim stated confidently is the failure mode this whole
package exists to prevent.
