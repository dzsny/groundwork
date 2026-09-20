---
name: release-cut
description: Cut a release — generate the changelog from conventional commits, instantiate and verify the release checklist, open the release PR and produce the annotated SemVer tag. Also handles hotfixes and their back-merge. Use when the user wants to cut, prepare or ship a release, generate a changelog or release notes, decide a version number, or produce a hotfix.
allowed-tools: Read, Write, Edit, Glob, Grep, Bash
---

# Release cut

**Trigger:** someone decides a story or bundle ships.
**Output:** a release PR from the integration branch to the release branch, with a generated
changelog as its body, a verified checklist, and — on merge — an annotated SemVer tag.

The division of authority, stated up front because it is where releases go wrong: **product
decides content; engineering decides readiness.** A failing checklist item blocks the cut. It
does not get waived because the date was promised.

## 1. Determine the content

Everything merged to the integration branch since the last tag. Group it by story or change
request — that is how the changelog reads and how the release is discussed.

Confirm the intended content with whoever owns it: a cut may deliberately hold a story back.
Holding back a *merged* story means either excluding its commits (messy) or agreeing that it
ships dark — say which, do not assume.

## 2. Generate the changelog

From **Conventional Commits** since the last tag. This is why the commit convention is
load-bearing.

- Group by story/CR, then by type: features, fixes, performance, then the rest.
- `BREAKING CHANGE:` footers and `!` markers get their own prominent section — these drive the
  major version and the consumer's upgrade work.
- Drop pure-chore noise. Keep anything a consumer or an operator would care about.
- The changelog **is** the release PR body. Not a separate file that duplicates it.

If commits do not follow the convention, say so and show what could not be classified. Do not
silently guess — a changelog that quietly omits a change is worse than one that admits a gap.

## 3. Choose the version

SemVer, by these rules:

- **major** — a breaking change to an external contract. Someone else's code or configuration
  must change.
- **minor** — a story or change-request bundle ships.
- **patch** — a fix-only cut, or a hotfix.

State the version **and the reason** in one line. When the content is ambiguous between minor
and major, it is major: the cost of an unexpected break is higher than the cost of a version
number.

## 4. Verify the release checklist

A lightweight re-verify, not a re-run of the verification phase:

- [ ] **Smoke green** on the development environment, dated
- [ ] **Drills current** — no drill invalidated by a change in this release
- [ ] **Eval gates green** on the model/prompt versions this release ships *(AI surfaces)*
- [ ] **Migrations rollback-safe** — see below
- [ ] **No open red gate verdicts** in `design/go-live-readiness.md`

Each item gets a dated observation, same discipline as the gates. **A failing item blocks the
cut** — engineering readiness overrules content desire. Say it plainly when it happens.

### Migration rollback safety

Every schema change must be backward compatible for **one version**: add and dual-write in one
release, remove in a later one (expand–contract). Check the migrations in this release against
the previous tag's code: would that code still run against this schema?

A migration that cannot roll back one version fails the checklist. This is what makes "rollback
= redeploy the previous tag" a true statement rather than a hope.

## 5. The PR and the merge

- Release PR: integration branch → release branch.
- **Merge commit, never squash.** The branches keep shared history — no divergence, no branch
  re-cutting rituals — and the atomic, behavior-per-commit history survives on the branch that
  gets tagged and shipped.
- On merge: an **annotated** tag (`git tag -a`), message = the changelog summary. Annotated, not
  lightweight — the tag carries the release's metadata and is what the rollback anchors to.
- Images tagged `<version>+<git-sha>`. **Deployments pin tags, never `latest`.**

## 6. Hotfix mode

Qualifies **only** when production is broken or materially degraded and cannot wait for a normal
cut. Everything else is a regular fix through the integration branch. Say so when the criterion
is not met — "urgent" is not the criterion.

1. `hotfix/<ticket>` off the **release** branch.
2. Expedited PR back to the release branch — still PR-first: one reviewer plus Round 1, the
   cheapest fast check. The gauntlet gets shortened, not skipped.
3. Patch tag, deploy.
4. **Back-merge the release branch into the integration branch.** Verify it happened — this is
   the step everyone forgets, and forgetting it means the next release cut silently regresses
   the fix. Automate it if you can (CI opens the back-merge PR when the patch tag lands); verify
   it in the hotfix ticket's Definition of Done either way.

## 7. After the cut

Report: the version and why, what shipped (by story), what was held, the checklist verdicts, the
tag, and anything the next cut inherits — a deferred migration contraction, a re-opened gate, a
back-merge still pending.
