---
name: interview
description: Interview the user relentlessly about a plan, idea, requirement or decision until every branch is resolved and nothing is silently assumed. Use when the user says "grill me", wants to stress-test an idea, is describing what they want to build, has a vague or half-formed requirement, or when another Groundwork skill (brd, functional-spec, mvp-scope) needs answers only the user can give.
allowed-tools: Read, Glob, Grep, Bash, Agent
---

# Interview

The questioning engine behind `brd`, `functional-spec` and `mvp-scope`. Use it directly whenever
someone has an idea that is not yet a decision.

> The *design-tree / frontier* method is adapted from the `grilling` skill in
> [mattpocock/skills](https://github.com/mattpocock/skills) (MIT). Rewritten here for
> requirements work, with the unknowns policy below added.

## The method

Map the topic as a **design tree**: every decision branches into the decisions that hang off
it. "Who is this for?" sits above "what do they do first?", which sits above "what happens when
that fails?".

Work the tree in **rounds**. The **frontier** is every decision whose prerequisites are already
settled — the questions you can ask *now* without guessing at answers you have not heard. Ask
the whole frontier in one round, then wait.

Format each question:

```
**Q1 — <short title>**
<the question; offer concrete options where that helps the user answer>

Recommended: <your proposed answer, with one line of why>
```

- **Number the questions** and keep numbers stable across rounds, so the user can answer
  "1 yes, 2 B, 3 skip".
- **Always give a recommended answer.** It turns "what do you want?" into "do you agree?", which
  is faster and surfaces disagreement sooner. A recommendation is a *proposal*, never a
  decision — see the provenance rule below.
- **Five questions per round at most.** If the frontier is wider, ask the five that unblock the
  most other branches and carry the rest.
- A question whose answer depends on another question still open in this round belongs to a
  **later round**.
- After each round, recompute the frontier: settled decisions push it outward and unblock the
  branches that hung off them.

## Facts are your job; decisions are theirs

Never ask the user for something you could look up. If a question needs a fact from the
repository, an attached document, a config file or an existing BRD, read it — or, when the
search is broad, dispatch a subagent — and ask only what remains. Do not block the whole round
on it: only the questions *downstream* of the fact wait; ask the rest of the frontier now.

Anything the user must *decide* — scope, priority, a number, a name, who approves — you put to
them and wait for.

## The unknowns policy

This is the rule the rest of the plugin leans on.

> **"I don't know" is a valid answer, and it is never filled in for them.**

When the user does not know, do not invent a plausible value and move on. A guessed latency
target becomes a drill threshold, then a go-live gate, and nobody ever learns it was fiction.
Instead record an **open question** with: an id, the question, the **owner** (who can answer),
a **due date**, and **what it blocks** (spec completion, design or implementation). Then continue
down the branches that do not depend on it.

An open question with no owner and no date is not tracked, it is hoped about. Ask for both
before you accept it.

## Provenance: proposed versus decided

Your recommended answers are proposals. When the user accepts one, record it as **decided**, and
record who decided and when: `decided: <name>, <date>`. When they overrule it, record theirs.
Never write down a value as if the user said it when they only did not object — silence on a
round is *not* acceptance; ask again, or mark it open.

Where a number matters (a target, a budget, a deadline), a bare "sounds fine" is not enough:
read the number back and get a yes.

## Pressure, not pedantry

Interview hard where the cost of being wrong is high, lightly where it is not.

| Press hard | Move quickly |
| --- | --- |
| Who the user is, and what they do *today* without this | Naming, wording, labels |
| What "done" means, in numbers | Anything reversible in a day |
| What is explicitly **out** of scope | Defaults the user is visibly indifferent to |
| Money, law, personal data, external dependencies | Cosmetic preferences |
| Contradictions with an earlier answer — quote both, ask which stands | |

Challenge terms, too. When the user uses a noun two ways ("account", "customer", "order"), stop
and pin it down: that is a glossary entry and a latent ambiguity.

Be direct, and be kind about it. The point is a shared understanding, not an interrogation.

## What a round looks like when it goes wrong

| Failure | What it looks like |
| --- | --- |
| Interrogating the user for facts | "What framework is the repo using?" — read the repo. |
| Leading, unrecommended questions | An open "what do you want?" with no proposal to react to. |
| Accepting silence as agreement | Recording a recommended value the user never confirmed. |
| Filling unknowns | A number, a name or a date nobody gave you. |
| One endless round | Twenty questions at once; the user answers three, the rest rot. |
| Not stopping | Continuing after the frontier is empty because it feels productive. |

## Finishing

The session is **done when the frontier is empty**: every branch visited, every unknown either
answered or recorded as an open question with an owner and a date, nothing left silently
assumed.

Then, before anyone acts on it:

1. Play back a **short summary** — decisions, open questions, and what is explicitly out.
2. Ask the user to confirm that it is a shared understanding.
3. Only on confirmation, hand the **decision ledger** to whatever comes next.

The ledger is a plain list, not a hidden state file:

```
Decided:   D-01 <decision> — decided: <name>, <date>
Open:      Q-01 <question> — owner: <name> — due: <date> — blocks: <spec | design | implementation>
Out of scope: <item>
Terms:     <term> — <definition>
```

When another skill called you, return the ledger to it. When the user called you directly and
there is no next skill, offer to write the ledger to a file — never write it unasked.
