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

- Comments must stand on their own: they explain the code to someone reading it
  cold. Never phrase a comment as a reply to my instructions or reference our
  conversation ("as requested", "the bug you reported", "per your feedback").
- Explain the non-obvious *why* (rationale, edge cases, gotchas, regression
  guards), not the *what* the code already states.
- If a comment only restates the code, leave it out. Fewer, higher-value
  comments over narration.
- Don't justify the chosen implementation against alternatives you considered or
  rejected ("kept as a helper rather than X", "using a loop instead of Y because
  Z fails"). That's decision/process residue from writing the code, not the
  code's meaning. A cold reader needs to understand what's there, not the path
  you took to it. If a real constraint must be recorded, state it as a plain
  fact about the system ("the template compiler does not transpile `?.`"),
  attached only where that constraint actually bites — not as a defense of your
  approach.
