---
description: Rust coding standards for Axum project
globs: "**/*.rs"
---

# Rust Code Style

## Error Handling
- Use `Result<T, E>` for all fallible operations
- Use `?` operator for error propagation
- Never use `unwrap()` or `expect()` in production code
- Use `thiserror` for custom error types

## Async
- Use `tokio` as the async runtime
- Prefer `async fn` in traits (now stable)
- Use `async move` for closures that capture ownership

## Naming
- `snake_case` for functions, variables, modules
- `PascalCase` for types, traits, enums
- `SCREAMING_SNAKE_CASE` for constants
- Module names should be single words when possible

## Memory Management
- Prefer borrowing over owning (`&str` over `String`)
- Use `Cow<str>` for borrowed-or-owned strings
- Use `Arc<Mutex<T>>` only when necessary for shared state

## Testing
- Write unit tests in `#[cfg(test)] mod tests`
- Write integration tests in `tests/` directory
- Use `#[tokio::test]` for async tests

## Documentation
- All public items must have `///` doc comments
- Include examples in doc comments
