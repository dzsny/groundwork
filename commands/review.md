---
description: Run the three-round review gauntlet on the current branch or a pull request
argument-hint: "[optional: PR number, branch name, or base ref to diff against]"
allowed-tools: Read, Glob, Grep, Bash, Agent
---

Run the `code-review` skill against: $ARGUMENTS (the current branch vs. its integration branch
if empty).

Round 1 in full: design compliance, acceptance criteria from the `SPRINT.md` row, downstream
dependency requirements from the *provides* notes, the clean-code pass, the security pass when
the diff touches auth / personal data / external input / outbound calls, and the coverage gate.

Label every finding **tool-produced** (grounded in file, line, symbol) or **agent-produced**
(concluded by reading) — the human validates the second kind before it gets posted.

Order findings most severe first, and end with a verdict: blocked, approve with comments, or
approve. Do not pad the list to look thorough.
