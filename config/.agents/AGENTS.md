# Personal working preferences (tngranados)

Output tokens are precious, be succinct in your responses. Use ASD-STE100 simplified technical english

## Committing

- Do NOT commit on your own. Only commit when I explicitly ask you to. Do not
  commit after each change or "as you go" unless I say so in that request.
- When I do ask for a commit, use a simple, single-line, imperative subject
  (e.g. "Add scheduled tasks page", "Fix sidebar toggle"). No body, no bullet
  lists, no co-author/footer trailers, no emoji.
- Prefer a feature branch over committing directly to the default branch.
- Always use english for the commits, regardless of the project language.

### If you are ask to commit, only commit your own work

If the task may end in a commit, run `git status` before you start. Note every
pre-existing modified or untracked path and keep it out of your commits. A
worktree can hold leftovers that the branch history no longer tracks.

- Never `git add -A`, `git add .`, or `git commit -a` when the workspace starts
  out dirty. Stage the exact paths you changed.
- Before committing, read `git diff --cached --stat` and confirm every path is
  yours. After committing, read `git show --stat HEAD`. If you are asked to push,
  read `git diff --stat <base>...HEAD` before doing it — if it lists files you
  never touched, the commit is wrong.
- Leave unrelated changes alone. Report them instead. Never revert, delete, or
  `git checkout` someone else's work, and never delete untracked files without
  asking.
- Check what `HEAD` is before `git reset` or `git commit --amend`. Amending a
  merge commit, or resetting past one, rewrites history you did not author.

## Code comments

Default to no new comment. Add one only when it records a durable fact that a
cold reader cannot reasonably infer from names, types, control flow, or tests.

- Explain non-obvious rationale, constraints, invariants, edge cases, or
  regression hazards. Never narrate what the next line, method name, test setup,
  assertion, partial locals, or data structure already says.
- Prefer clearer naming, smaller control flow, stronger types, or a better test
  description over a comment that explains confusing code.
- Do not reference the request, conversation, diff, review feedback, rejected
  alternatives, or the writing process. Put change rationale in the PR or commit
  description, not in the code.
- Comment the constraint that outlives the change, never the change itself. "So
  the caller no longer has to…", "this used to…", "instead of…", and any
  restatement of the problem you just fixed all belong in the PR.
- Keep it to one or two lines. If it needs a paragraph, an em dash, or a list of
  the cases it covers, it belongs in the PR description.
- Do not comment a group of constants, enum values, or config keys whose names
  already carry the meaning.
- Do not add comments as section labels or running commentary inside a method.
  A nearby comment must attach to the exact constraint it explains.
- In specs, let example and helper names explain intent. Comment only when a
  surprising fixture or system constraint cannot be made clear in code.
- Required API documentation (YARD, docstrings, generated annotations, etc.) is
  an exception to the no-comment default. Keep it to the contract: parameters,
  return value, raised errors, side effects, and non-obvious invariants. Do not
  pad it with prose that restates the signature or implementation.
- Preserve useful existing comments, but update or remove one when your change
  makes it false. Do not sweep unrelated files for comment cleanup unless asked.
- Always use english for the comments, regardless of the project language.

Before finishing, inspect every comment added or changed in the diff and apply
both tests:

1. Delete it. If the code still tells a reader what they must not break, leave
   it deleted.
2. Read it as someone who joins in a year and never saw the change. If it only
   makes sense next to the diff that introduced it, delete it.

Then cut every surviving comment to the shortest wording that keeps the fact.

## Code cleanliness

- Keep the smallest implementation that owns the behavior. Avoid speculative
  abstractions, thin wrappers, and one-use helpers that merely rename an
  operation.
- Do not add production methods, scopes, or public APIs solely for a test. Test
  the persisted or observable contract instead.
- Search for callers before adding or removing an abstraction. Remove code made
  dead by your change, along with tests and comments that only describe it.
- Before finishing, review the diff for narration, dead code, duplicated logic,
  unnecessary indirection, and unrelated formatting churn.
