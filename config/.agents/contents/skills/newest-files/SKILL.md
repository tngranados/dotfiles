---
name: newest-files
description: Use before writing new code files to list the N most recently created files in a git repository (by git history, not mtime), optionally filtered by glob, so you can find modern reference implementations and avoid legacy patterns.
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

Use `newest-files` **before writing new code** to find exemplary files to study:

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

1. **Identify the category** of file you need to create (service, mutation, component, etc.)
2. **Run `newest-files`** with the appropriate glob to get 3-5 recent examples
3. **Read those files** to understand current patterns, naming conventions, and structure
4. **Also check `.templates/`** for the canonical template (templates + recent examples = best guidance)
5. **Write your new code** following the patterns you observed

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
