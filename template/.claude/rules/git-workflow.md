---
description: Git commit and branch conventions
---

# Git Workflow

## Commit Messages
Follow Conventional Commits format:

```
<type>(<scope>): <description>

[optional body]
```

**Types:** `feat`, `fix`, `docs`, `style`, `refactor`, `test`, `chore`
**Scope:** Component or area affected (e.g., auth, api, ui)
**Description:** Imperative mood, lowercase, no period, max 72 chars

## Branches
- `main` — production-ready code only
- `feat/<name>` — feature branches
- `fix/<name>` — bug fix branches
- `chore/<name>` — maintenance tasks

## Rules
- Never commit directly to main (use feature branches)
- Each commit should be a single logical change
- Run tests before committing
- Include related test changes in the same commit as the code change
