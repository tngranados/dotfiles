---
name: cleanup-comments
description: Use when the user asks for a comment review or cleanup, e.g. "clean up the comments", "remove unnecessary comments", "comment pass" on a diff, branch, or set of files. Deletes comments that narrate the code or the change, and rewrites the ones worth keeping.
---

# Cleanup Comments

A dedicated second pass over comments, run in a clean conversation. You did not
write this code and you did not see the conversation that produced it. That is
the point: judge every comment only on what it gives a reader who arrives in a
year with no context.

## Scope

Default scope is the uncommitted and unpushed work:

```bash
git status --short
git diff
git diff --cached
git diff <default-branch>...HEAD   # when the branch has commits
```

Read the full files around each hunk, not the diff alone. A comment can be
correct in isolation and false next to code the diff changed.

If the user names files, a branch, a PR, or the whole repository, use that scope
instead. Do not widen the scope on your own.

## Verdict for each comment

For every comment in scope, pick one:

**Delete** when any of these is true:

- It restates the next line, the function or variable name, the types, the
  control flow, the test setup, an assertion, or the shape of a data structure.
- It labels a section inside a function, or reads as running commentary.
- It describes the change instead of the code: "so the caller no longer has
  to...", "this used to...", "instead of...", "new in...", "renamed from...", a
  restatement of the bug that was fixed, a rejected alternative, or a reference
  to a request, review comment, or conversation.
- It titles a group of constants, enum values, or config keys whose names
  already carry the meaning.
- It is false, or the code it described is gone.
- It is a commented-out block of code, unless the user asks to keep it.
- It is a TODO with no owner, no ticket, and no clear condition. Report these
  instead of silently deleting if they look deliberate.

**Rewrite** when the fact is durable but the wording is not:

- Cut it to one or two lines. If it needs a paragraph, an em dash, or a list of
  the cases it covers, the detail belongs in the PR description, not the code.
- State the constraint, not the history. "Rate limit resets on the hour, so a
  retry inside the same hour always fails" survives; "we added a retry here
  because the API was flaky" does not.
- Move it next to the exact line whose constraint it explains.
- Translate it to english if it is in another language.
- Trim API documentation (YARD, docstrings, generated annotations) down to the
  contract: parameters, return value, raised errors, side effects, non-obvious
  invariants. Drop prose that repeats the signature.

**Keep** when it records non-obvious rationale, a constraint from an external
system, an invariant, an edge case, or a regression hazard that the code cannot
carry on its own.

**Add** a comment only where you find code whose failure mode is invisible: an
ordering that must hold, a value that must match something outside this file, a
workaround for a known defect. This is rare. Prefer a clearer name, smaller
control flow, a stronger type, or a better test description over a new comment.

## Two tests before you finish

Apply both to every comment you kept or wrote:

1. Delete it. If the code still tells a reader what they must not break, leave
   it deleted.
2. Read it as someone who joins in a year and never saw the change. If it only
   makes sense next to the diff that introduced it, delete it.

Then cut every survivor to the shortest wording that keeps the fact.

## Rules for this pass

- Change comments only. No renames, no refactors, no logic edits, no formatting
  churn. If a comment exists because the code is confusing, delete the comment
  and report the code smell instead of fixing it here.
- Do not touch files outside the scope, and do not sweep the repository for
  comments unrelated to the work under review.
- Keep license headers, pragma and directive comments (`# frozen_string_literal`,
  `// @ts-expect-error`, `# noqa`, `eslint-disable`, shebangs), and generated-file
  banners. They are code, not prose.
- Preserve documentation the project requires or the tooling reads.
- Do not commit. Leave the edits in the working tree.

## Report

Close with a short summary: count deleted, count rewritten, count added, plus
any judgement call worth a second opinion (a deliberate-looking TODO, a comment
that hides confusing code, a comment you could not verify).
