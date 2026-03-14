# Project: Go API Service

## Identity

This is an HTTP API service written in Go using only the standard library.
It follows the Go philosophy of simplicity, explicit error handling, and
minimal dependencies. The service provides a JSON API with PostgreSQL
persistence.

## Tech Stack

- **Language:** Go 1.22
- **Framework:** `net/http` (stdlib) with Go 1.22 routing patterns
- **Database:** PostgreSQL 16 via `database/sql` + `pgx` driver
- **Migrations:** `goose`
- **Testing:** `testing` package + `go test`
- **Linting:** `golangci-lint`
- **Build:** `go build`, Makefile
- **Containerization:** Docker multi-stage build

## Project Structure

```
cmd/
└── server/
    └── main.go              # Entrypoint, config loading, server startup
internal/
├── config/
│   └── config.go            # Environment-based configuration
├── handler/                  # HTTP handlers (one file per domain)
├── middleware/                # HTTP middleware (logging, auth, recovery)
├── model/                    # Domain types and business logic
├── repository/               # Database access (queries, transactions)
├── service/                  # Business logic orchestration
└── server/
    └── server.go             # Server setup, route registration, graceful shutdown
migrations/
├── 001_create_users.sql
└── ...
tests/
└── integration/              # Integration tests (require running DB)
```

## Commands

```bash
# Development
go run ./cmd/server                        # run the server
make run                                   # same, via Makefile

# Testing
go test ./...                              # all tests
go test ./internal/service/...             # specific package
go test -race ./...                        # with race detector
go test -count=1 ./...                     # no test caching
go test -cover ./...                       # with coverage
go test -v -run TestCreateUser ./...       # single test

# Linting
golangci-lint run                          # lint all packages
golangci-lint run --fix                    # lint + autofix

# Build
go build -o bin/server ./cmd/server
make build

# Database
goose -dir migrations postgres "$DATABASE_URL" up
goose -dir migrations postgres "$DATABASE_URL" create add_index sql

# Formatting
gofmt -w .                                # format (usually automatic)
goimports -w .                            # organize imports
```

## Principles

1. **Standard library first.** Do not add a dependency unless the
   standard library genuinely cannot do it. `net/http`, `encoding/json`,
   `database/sql`, `log/slog` cover most needs.

2. **Explicit error handling.** Every error must be checked. Use
   `fmt.Errorf("context: %w", err)` to wrap errors with context.
   Never discard errors with `_`. Never `panic` in library code.

3. **Flat package structure.** Packages in `internal/` are organized
   by responsibility, not by type. Avoid deeply nested packages.
   Avoid package names like `util` or `common`.

4. **Accept interfaces, return structs.** Function parameters should
   use the smallest interface they need. Return concrete types so
   callers can see what they get.

5. **No global state.** No `init()` functions, no package-level
   mutable variables. All dependencies are passed explicitly via
   constructor functions or method parameters.

6. **Table-driven tests.** Use `[]struct{ name string; ... }` test
   tables for testing multiple cases. Each test must be independent
   and parallelizable with `t.Parallel()`.
