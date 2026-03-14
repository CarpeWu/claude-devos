---
description: Create a step-by-step implementation plan from a specification
---

Create an implementation plan from an existing specification.

## Step 1: Read the Spec
- Find and read the relevant spec in `docs/specs/`
- If no spec exists, suggest running the spec-feature skill first

## Step 2: Analyze the Codebase
- Read the files listed in the spec's "Affected Components"
- Understand current patterns and conventions
- Identify dependencies and potential conflicts

## Step 3: Write the Plan
Output a numbered plan with this format:

```
## Implementation Plan: <Feature Name>
Based on: docs/specs/<spec-file>.md

### Step 1: <Description>
- File: `path/to/file.ts`
- Change: [what to add/modify/remove]
- Why: [brief rationale]

### Step 2: <Description>
...

### Verification
- [ ] All tests pass
- [ ] New tests cover requirements from spec
- [ ] Lint clean
- [ ] Matches spec requirements
```

## Guidelines
- Order steps to minimize broken intermediate states
- Each step should be a committable unit if possible
- Include test-writing steps alongside implementation steps
- Flag any spec ambiguities discovered during planning
