---
description: Start a cross-repo worktree cascade for a task
argument-hint: <task-name> [repo...]
---

Create one worktree per repo for this task, so cross-repo changes can be
developed in parallel with matching branch names.

Run:

```bash
start-work-cascade <task-name> [repo...]
```

Defaults to `reading-room open-agent agent-skills` under `~/src/personal`.
Each worktree lands at `<repo>/.claude/worktrees/<task-name>` on branch
`<task-name>` off `origin/main` — the same convention reading-room already
uses. Existing worktrees are skipped.

After the work is done and merged, clean up with:

```bash
worktree-cascade-done <task-name>
```

which removes each worktree and deletes the branch (refusing unmerged
branches, mirroring `just worktree-done`).

If the task touches repos outside the default set, pass them explicitly:
`/start-work-cascade my-task the-met-db wateralert-backend datalink`
