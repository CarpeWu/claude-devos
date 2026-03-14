# System Architecture

> This file is read by Claude on demand when it needs architectural context.
> Keep it updated as the architecture evolves.

## Overview
[PROJECT_NAME] is a [type of application] that [primary purpose].

## Component Map
```
[Draw your system's component diagram here]

Example:
┌─────────┐     ┌─────────┐     ┌──────────┐
│  Client  │────►│   API   │────►│ Database │
│  (React) │     │ (Express)│    │ (Postgres)│
└─────────┘     └────┬────┘     └──────────┘
                     │
                ┌────▼────┐
                │  Queue  │
                │ (Redis) │
                └─────────┘
```

## Key Patterns
- **[Pattern Name]**: [How and where it's used]
- **[Pattern Name]**: [How and where it's used]

## Directory Mapping
| Directory | Contains | Key Files |
|-----------|----------|-----------|
| `src/api/` | API route handlers | `router.ts`, `middleware.ts` |
| `src/models/` | Database models | `user.ts`, `project.ts` |
| `src/services/` | Business logic | `auth.ts`, `billing.ts` |
| `src/utils/` | Shared utilities | `validate.ts`, `format.ts` |

## Data Flow
[Describe how data flows through the system for key operations]

## External Dependencies
| Service | Purpose | Docs |
|---------|---------|------|
| [Service] | [What it does] | [Link] |
