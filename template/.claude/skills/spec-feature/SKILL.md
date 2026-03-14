---
description: Write a detailed feature specification document
---

Write a feature specification following this process:

## Step 1: Understand
- Ask clarifying questions if the request is ambiguous
- Read relevant existing code to understand current state
- Identify affected components

## Step 2: Write Specification
Create a spec file at `docs/specs/<feature-name>.md` with this structure:

```markdown
# Feature: <Name>

## Summary
[One paragraph describing what this feature does and why]

## Requirements
- [ ] Requirement 1
- [ ] Requirement 2

## Technical Design
### Affected Components
[List files/modules that will change]

### API Changes
[New or modified endpoints/interfaces]

### Data Model Changes
[New or modified database tables/schemas]

## Edge Cases
[List edge cases and how they should be handled]

## Testing Strategy
[What tests are needed: unit, integration, e2e]

## Open Questions
[Anything that needs decision before implementation]
```

## Step 3: Review
- Verify the spec covers all requirements from the request
- Ensure edge cases are addressed
- Confirm the technical design is feasible given the current architecture
  (read `.claude/knowledge/architecture.md` if needed)
