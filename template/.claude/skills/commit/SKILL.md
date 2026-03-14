---
description: Stage changes and create a conventional commit
---

Create a well-formatted commit for the current changes.

## Step 1: Verify Before Committing
- Run the project test command — all tests must pass
- Run the project lint command — must be clean
- If either fails, fix issues before proceeding

## Step 2: Review Changes
- Run `git diff --staged` and `git diff` to see all changes
- Identify the logical grouping of changes
- If changes span multiple unrelated concerns, suggest splitting into multiple commits

## Step 3: Stage Changes
- Stage the relevant files with `git add`
- Verify staged changes with `git diff --staged`

## Step 4: Write Commit Message
Follow Conventional Commits format

```
<type>(<scope>): <short description>

<body — what changed and why>

<footer — references to issues, breaking changes>
```

**Type:** feat, fix, docs, style, refactor, test, chore
**Scope:** Component or area affected (e.g., auth, api, ui)
**Description:** Imperative mood, lowercase, no period, max 72 chars

## Step 5: Commit
- Run `git commit -m "<message>"`
- Confirm the commit was created with `git log -1`
