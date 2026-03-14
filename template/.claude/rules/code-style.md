---
description: Coding standards for all source files
globs: "src/**/*.{ts,tsx,js,jsx}"
---

# Code Style

## TypeScript
- Use `interface` for object shapes, `type` for unions and intersections
- Prefer `const` over `let`; never use `var`
- Use explicit return types on exported functions
- Prefer named exports over default exports

## Functions
- Max function length: 40 lines (extract helpers if longer)
- Max parameters: 3 (use an options object for more)
- Pure functions preferred; isolate side effects

## Naming
- `camelCase` for variables and functions
- `PascalCase` for types, interfaces, classes, components
- `UPPER_SNAKE_CASE` for constants
- Prefix boolean variables with `is`, `has`, `should`

## Error Handling
- Never swallow errors silently
- Use custom error classes for domain errors
- Always include context in error messages

## Imports
- Group: external packages → internal modules → relative imports
- Separate groups with a blank line
- No circular dependencies
