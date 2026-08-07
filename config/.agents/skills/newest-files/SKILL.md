---
name: newest-files
description: Use this only when adding a substantial, convention-sensitive code file to a large, mature Git repository and nearby code cannot establish the current pattern. Never load for edits, small or standalone files, configuration, documentation, scripts, tests, project setup, or ordinary implementation work.
---

## Finding Reference Files with `newest-files`

### Why This Matters

In large, long-lived codebases, patterns evolve. Older files may contain legacy approaches we no longer want to replicate. **Always prefer learning from the newest files** in a category—they reflect current best practices, recent refactors, and the team's latest conventions.

### The Tool

`newest-files` lists the N most-recently-created files in a Git repository, ordered by the commit date when each file was first added. This is NOT modification date—it's true creation date from Git history.

**Syntax:**

```bash
newest-files [options] [GLOB]
```

**Options:**

- `-n, --count NUMBER` — Number of files to show (default: 10)
- `GLOB` — Filter by glob pattern (e.g., `"*.rb"`, `"app/services/**/*.rb"`)

### When to Use It

Use `newest-files` only when all of these are true:

1. You are creating a new, substantive implementation file in an existing Git repository.
2. The repository has multiple plausible conventions for that file category, or the current convention is not clear from nearby files.
3. Reviewing recent examples would materially affect the file's structure, dependencies, or style.

Do not use it for:

- Editing an existing file or adding a small function, test, configuration, documentation, or one-off script.
- Creating a file when a directly adjacent implementation, template, or explicit user specification already establishes the pattern.
- Broad exploration, routine validation, or when no new file will be created.

When it is warranted, use `newest-files` to find exemplary files to study:

| Task                 | Command                                             |
| -------------------- | --------------------------------------------------- |
| New service object   | `newest-files -n 5 "app/services/**/*.rb"`          |
| New GraphQL mutation | `newest-files -n 5 "app/graphql/mutations/**/*.rb"` |
| New GraphQL query    | `newest-files -n 5 "app/graphql/queries/**/*.rb"`   |
| New GraphQL type     | `newest-files -n 5 "app/graphql/types/**/*.rb"`     |
| New model            | `newest-files -n 5 "app/models/**/*.rb"`            |
| New Vue component    | `newest-files -n 5 "app/javascript/**/*.vue"`       |
| New composable       | `newest-files -n 5 "app/javascript/**/use*.ts"`     |
| New RSpec test       | `newest-files -n 5 "spec/**/*_spec.rb"`             |
| New worker           | `newest-files -n 5 "app/workers/**/*.rb"`           |

### Workflow

1. Confirm the task meets the conditions above.
2. Identify the category of file you need to create (service, mutation, component, etc.).
3. Run `newest-files` with the appropriate glob to get 3-5 recent examples.
4. Read only the examples needed to resolve the convention.
5. Also check `.templates/` when that directory exists and is relevant.
6. Write the new file following the pattern you observed.

### Example

Creating a new service for processing refunds:

```bash
$ newest-files -n 3 "app/services/**/*.rb"
Created          │ Author        │ File                                              │ Commit
─────────────────────────────────────────────────────────────────────────────────────────────
2025-11-24 17:22 │ Toni Granados │ app/services/ask_alkimii/tools/graphql/concierge_overview_tool.rb │ 1ced2b31
2025-11-24 15:56 │ Toni Granados │ app/services/ask_alkimii/tools/graphql/maintenance_overview_tool.rb │ e28a25f1
2025-11-24 14:50 │ Toni Granados │ app/services/ask_alkimii/tools/graphql/housekeeping_overview_tool.rb │ 386904e1
```

Then read those 3 files to see how services are currently structured before writing your own.

### Key Benefits

- **Avoids mimicking legacy code** — Old files may have outdated patterns, deprecated methods, or pre-refactor structures
- **Learns from recent decisions** — Recent files incorporate lessons learned and current team conventions
- **Consistent codebase** — New code matches recent code, not code from years ago
