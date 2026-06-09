# Personal working preferences (tngranados)

Cross-tool guidance for how any coding agent should work for me. Symlinked to
the locations each tool expects (e.g. `~/.claude/CLAUDE.md`) by `install.sh`.

## Committing

- Do NOT commit on your own. Only commit when I explicitly ask you to. Do not
  commit after each change or "as you go" unless I say so in that request.
- When I do ask for a commit, use a simple, single-line, imperative subject
  (e.g. "Add scheduled tasks page", "Fix sidebar toggle"). No body, no bullet
  lists, no co-author/footer trailers, no emoji.
- Prefer a feature branch over committing directly to the default branch.

## Code comments

A comment exists to explain the code to someone reading it cold. That single
purpose drives every rule below, which apply to comments in every file — code,
config, data manifests, docs.

- **Explain the non-obvious _why_, not the _what_.** Rationale, edge cases,
  gotchas, and regression guards earn their place; a comment that just restates
  the code does not. Fewer, higher-value comments over narration.
- **Don't reference our conversation or your instructions.** A comment is not a
  reply to me ("as requested", "the bug you reported", "per your feedback"); the
  cold reader was never in the room.
- **Don't leave the writing process in the code.** Two common forms:
  - Justifying the implementation against alternatives you rejected ("kept as a
    helper rather than X", "using a loop instead of Y because Z fails"). The
    reader needs what's there, not the path you took to it.
  - Selling the change or its payoff ("lives outside whatever/ so editing needs
    no admin approval", "that's it — no job-config change needed"). Describe what
    the thing _is_, not what choosing it saves.

  Rationale for the change belongs in the PR/commit description; user-facing
  benefits belong in a README. If a real constraint must be recorded, state it as
  a plain fact about the system ("the template compiler does not transpile
  `?.`"), attached only where that constraint actually bites.

- **Litmus test:** if a comment only makes sense to someone reading the diff that
  introduced it, delete it.
