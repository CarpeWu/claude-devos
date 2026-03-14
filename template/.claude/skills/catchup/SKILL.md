---
description: Resume context after session compaction or fresh session start
---

Rebuild context after a context compaction or at the start of a new session.

## Step 1: Check Recent History
- Run `git log --oneline -20` to see recent commits
- Run `git diff --stat` to see uncommitted changes
- Run `git status` to see working tree state

## Step 2: Check for In-Progress Work
- Look for recent spec files in `docs/specs/`
- Check for TODO comments added recently: `git diff | grep -i "TODO\|FIXME\|HACK"`
- Check for any stashed changes: `git stash list`

## Step 3: Read Context Files
- Auto memory (MEMORY.md) is loaded automatically — review it for session notes
- Check for any recently modified files: `git diff --name-only HEAD~5`

## Step 4: Summarize
Provide a brief summary

```
## Session Catchup

### Recently Completed
- [commits and their purpose]

### In Progress
- [uncommitted changes and their purpose]

### Next Steps
- [what appears to be remaining work]

### Open Questions
- [anything unclear from context]
```
