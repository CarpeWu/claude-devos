# Project: Rust Axum Service

## Identity

This is a web API service built with Rust, Axum, and SQLx. It provides a
typed, performant HTTP API with compile-time query checking, strong error
handling via the type system, and PostgreSQL persistence.

## Tech Stack

- **Language:** Rust (latest stable, 2021 edition)
- **Framework:** Axum 0.7
- **Database:** PostgreSQL 16 via SQLx (compile-time checked queries)
- **Serialization:** serde + serde_json
- **Async runtime:** Tokio
- **Error handling:** thiserror + anyhow (app-level)
- **Configuration:** `config` crate + environment variables
- **Migrations:** SQLx CLI (`sqlx migrate`)
- **Testing:** `cargo test` + `tower::ServiceExt` for handler tests
- **Linting:** `clippy`
- **Formatting:** `rustfmt`
- **Containerization:** Docker multi-stage build

## Project Structure

```
src/
├── main.rs                  # Entrypoint: config, DB pool, router, server start
├── config.rs                # Configuration structs, env loading
├── error.rs                 # AppError type, IntoResponse impl
├── state.rs                 # AppState (shared dependencies)
├── routes/
│   ├── mod.rs               # Router assembly
│   ├── users.rs             # /users handlers
│   └── health.rs            # /health endpoint
├── models/                  # Domain types (DB row structs)
├── dto/                     # Request/response types (Deserialize/Serialize)
├── services/                # Business logic
└── repositories/            # SQLx query functions
migrations/
├── 001_create_users.sql
└── ...
tests/
├── common/mod.rs            # Shared test setup (test DB, app instance)
├── api/                     # Full integration tests against running app
└── ...
```

## Commands

```bash
# Development
cargo run                                  # run the server
cargo watch -x run                         # run with auto-reload

# Testing
cargo test                                 # all tests
cargo test -- --test-threads=1             # sequential (for DB tests)
cargo test --lib                           # unit tests only
cargo test --test api_tests                # specific integration test
cargo test user                            # tests matching "user"

# Linting & formatting
cargo clippy -- -D warnings               # lint (deny all warnings)
cargo clippy --fix                         # lint + autofix
cargo fmt                                  # format
cargo fmt -- --check                       # format check (CI)

# Type checking / build
cargo check                                # type check without building
cargo build                                # debug build
cargo build --release                      # release build

# Database
sqlx migrate run                           # apply migrations
sqlx migrate add <name>                    # create new migration
cargo sqlx prepare                         # generate offline query data

# Dependencies
cargo update                               # update Cargo.lock
cargo audit                                # check for vulnerabilities
```

## Principles

1. **Leverage the type system.** Use newtypes for domain identifiers
   (`UserId(Uuid)`), enums for state machines, and `Option`/`Result` for
   all fallible operations. If the compiler can catch it, don't rely on
   tests.

2. **Errors are types, not strings.** Define error enums with `thiserror`
   for each module. Implement `IntoResponse` on the top-level `AppError`
   to map errors to HTTP status codes. Never use `.unwrap()` in
   production code.

3. **Compile-time query checking.** Use `sqlx::query_as!` macros for all
   database queries. Run `cargo sqlx prepare` before committing if
   queries change. Never build raw SQL strings.

4. **Extractors for input, IntoResponse for output.** Route handlers
   accept Axum extractors (`Json<T>`, `Path<T>`, `Query<T>`, `State<S>`)
   and return `Result<impl IntoResponse, AppError>`.

5. **Thin handlers, thick services.** Handlers extract input, call a
   service, and format output. Business logic lives in service functions
   that take typed parameters and return `Result<T, DomainError>`.

6. **Test at the HTTP boundary.** Integration tests construct the full
   app router and use `tower::ServiceExt::oneshot` to send requests.
   This tests serialization, routing, middleware, and handlers together.
