# MVP definition — [Project name]

> The MVP is the **smallest end-to-end slice** that makes the product worth releasing and
> tests the riskiest assumption. This file is the scope input for the first sprint plan:
> stories not listed under "In the MVP" do not get tickets.

## 1. The bet

[One paragraph: what must be true for this MVP to be worth building, and what we learn or prove
by shipping it. Name the riskiest assumption it tests.]

## 2. Exit criteria

| id | Criterion | Number | Measured how | Traces to |
| --- | --- | --- | --- | --- |
| MX-01 | [Observable outcome that means the MVP succeeded] | [Target] | [Method] | [OBJ-01 / NFR-01] |

Exit criteria come from the BRD's success measures and the spec's NFRs — never from this file
alone.

## 3. In the MVP

| Story | Title | Covers | Why it is in |
| --- | --- | --- | --- |
| US-001 | [Outcome] | BR-001 | [Why the MVP is not worth releasing without it] |

**Walking skeleton:** [The thinnest flow, trigger to outcome, that touches every layer. Build
this first; everything else hangs off it.]

## 4. Deferred

| Story | Why deferred | Revisit when |
| --- | --- | --- |
| US-007 | [Reason] | [Trigger or date] |

## 5. Not negotiable, even in an MVP

Cutting scope never cuts these for the stories that remain: security and compliance
requirements, NFRs the included stories carry, error and permission flows in the acceptance
criteria, and the named acceptance authority.

## 6. Open questions

| id | Question | Owner | Due date | Blocks |
| --- | --- | --- | --- | --- |
| Q-01 | [What is unknown?] | [Name] | [Date] | [Design / implementation] |

## 7. Approval

| Approver | Date | Decision |
| --- | --- | --- |
| [Requestor or sponsor] | [Date] | [Approved / Changes requested] |
