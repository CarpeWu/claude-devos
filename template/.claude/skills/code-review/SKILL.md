---
description: Review code changes against specification and project standards
---

Review the current changes for correctness, style, and completeness.

## Step 1: Gather Context
- Run `git diff` to see all current changes
- Read the relevant spec in `docs/specs/` if one exists
- Read `.claude/rules/code-style.md` for style standards

## Step 2: Review Checklist
For each changed file, check:

### Correctness
- [ ] Logic is correct and handles edge cases
- [ ] Error handling is present and appropriate
- [ ] No obvious bugs or race conditions

### Style
- [ ] Follows project code style rules
- [ ] Naming is clear and consistent
- [ ] No dead code or commented-out blocks

### Testing
- [ ] New code has corresponding tests
- [ ] Tests cover happy path and error cases
- [ ] Existing tests still relevant

### Security
- [ ] No hardcoded secrets or credentials
- [ ] Input validation present where needed
- [ ] No SQL injection, XSS, or other vulnerabilities

## Step 3: Report
Output findings in this format

```
## Code Review: <summary>

### Critical Issues (must fix)
- [ ] File:line — description

### Suggestions (should fix)
- [ ] File:line — description

### Nitpicks (optional)
- [ ] File:line — description

### Positive Notes
- [Things done well]
```
