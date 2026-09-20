# Contributing to Groundwork

Thanks for looking. This plugin is opinionated on purpose, so the most useful thing to know
before contributing is *which* opinions are load-bearing and which are just defaults.

## The most valuable contribution

**A skill that failed on a real repository, with the repository shape that broke it.**

These skills were written against a particular idea of what a software project looks like. Every
report of the form "`design-reconstruct` produced nonsense on a monorepo with 40 packages" or
"`commit-lint` blocked a legitimate commit because …" is worth more than a feature request.
Include the repository shape, what the skill did, and what it should have done.

## Load-bearing principles

Changes that violate these will be asked to change direction, not merged and fixed later:

1. **A check whose input is missing fails loudly.** It never passes green, and it never invents
   the input. A fabricated NFR number becomes a drill threshold, then a go-live gate, and nobody
   ever learns it was fiction.
2. **The gate judges the diff, never the legacy corpus.** Adopting Groundwork must never require
   rewriting existing code until the linter is happy.
3. **Nothing blocks by default.** Every enforcing behavior is opt-in through `policy.*` in
   `.groundwork.yaml` and ships as `warn`. A plugin that blocks a stranger's commit on install
   gets uninstalled, and rightly.
4. **Tool-agnostic.** No skill names a vendor. An issue tracker, not a specific one; a spec, not
   a specific wiki. Anything vendor-specific goes behind `tracker.kind` in the config.
5. **Single source of truth.** If a change would create a second editable copy of a fact, it is
   the wrong change.
6. **Hooks fail open.** A hook must never break a session because the hook itself broke. Exit 0
   on any internal error, and never block on anything but an explicit `enforce`.

Everything else — the exact page set, the default track menu, the wording of the templates — is
a default, and defaults are negotiable with a reason.

## Repository layout

```
.claude-plugin/     plugin.json and marketplace.json
skills/<name>/      SKILL.md, plus any reference files that skill loads
commands/           thin user-invoked entry points that route to skills
agents/             subagent definitions
hooks/              hooks.json and hooks/scripts/
templates/          the documents the skills scaffold from
docs/               the workflow, the retrofit ladder, the config reference
```

## Working on a skill

A `SKILL.md` is a prompt, not documentation. Some things that reliably matter:

- **The `description` frontmatter decides when the skill fires.** Write it as the situations a
  user would be in, in their words, not as a summary of what the skill contains. Most
  "the skill didn't trigger" bugs are description bugs.
- **State the rule and the reason.** "Never invent an NFR number" is followed more reliably when
  it is followed by *why* — because it becomes a gate nobody knows is fiction.
- **Give the failure mode, not just the instruction.** A table of "what a failure looks like"
  does more work than a paragraph of guidance.
- **Keep reference material in a sibling file** the skill points at, so the body stays short.

Test a change by running it against a real repository — ideally an ugly one:

```bash
claude --plugin-dir ./groundwork
```

## Working on a hook

Hook scripts live in `hooks/scripts/` and share `lib.sh`. They must:

- Exit 0 on every internal error, including a missing config, a missing `jq`, or an unexpected
  payload.
- Block (exit 2) **only** under an explicit `enforce` policy, with the reason on stderr.
- Read nothing beyond what the check needs, and emit no repository content into context beyond
  what the message requires.
- Stay quiet in repositories that have not adopted Groundwork.

Test with a sample payload:

```bash
echo '{"cwd":"'"$PWD"'","tool_input":{"command":"git commit -m \"bad message\""}}' \
  | ./hooks/scripts/commit-lint.sh
```

## Commits and PRs

The plugin follows its own workflow, which is the only honest way to ship it:

- **Conventional Commits**, scoped by area: `feat(skills): …`, `fix(hooks): …`,
  `docs(readme): …`.
- **Atomic commits** — one behavioral change each, message stating exactly that change.
- **No AI attribution** in commits or code.
- PRs use the template in `templates/PULL_REQUEST_TEMPLATE.md`, including the **Review order**
  section.
- If you change a skill's behavior, update the README table and `CHANGELOG.md` in the same PR.
  Docs update with the behavior they describe — that rule applies here too.

## Validating before you push

```bash
claude plugin validate .
```

Plus: every JSON file parses, every `SKILL.md` has `name` and `description` frontmatter, and
every hook script is executable and exits 0 on a malformed payload.

## Licensing

By contributing you agree your contribution is licensed under the [MIT License](LICENSE).
