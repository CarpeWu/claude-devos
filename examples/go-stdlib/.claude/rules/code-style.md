---
globs: "**/*.go"
---

# Go Code Style — Stdlib Project

## Formatting

- `gofmt` is law. Never manually format Go code in a way that differs
  from `gofmt` output.
- `goimports` handles import grouping: stdlib, then blank line, then
  third-party, then blank line, then internal packages.
- No line length limit enforced, but break long function signatures
  at the parameter level for readability.

## Naming

- **Packages:** lowercase, single word, no underscores. `handler`, not
  `http_handlers`. Package name should not repeat the parent directory.
- **Exported names:** `PascalCase`. The package name is part of the
  qualified name — `handler.Create`, not `handler.CreateHandler`.
- **Unexported names:** `camelCase`.
- **Interfaces:** name by behavior, not by the implementing type.
  `Reader`, `Validator`, `Store` — not `IUserService`.
- **Acronyms:** all caps when exported (`HTTPClient`, `UserID`),
  all lower when unexported (`httpClient`, `userID`).
- **Receivers:** short, consistent, one or two letters derived from
  the type name. `func (s *Service) Create(...)`, never `func (self *Service)`.

## Error Handling

- Always check errors. Never assign to `_` for error returns.
- Wrap errors with context using `fmt.Errorf("operation: %w", err)`.
- Use sentinel errors (`var ErrNotFound = errors.New(...)`) for errors
  that callers need to check with `errors.Is`.
- Use custom error types only when callers need `errors.As` to extract
  structured information.
- Never use `panic` for expected error conditions.

```go
// YES
user, err := s.repo.FindByID(ctx, id)
if err != nil {
    return nil, fmt.Errorf("finding user %s: %w", id, err)
}

// NO
user, _ := s.repo.FindByID(ctx, id)
```

## Structs and Interfaces

- Accept interfaces, return structs.
- Define interfaces at the point of use (in the consumer package), not
  next to the implementation.
- Keep interfaces small — one to three methods.

```go
// In handler package (consumer), not in repository package
type UserFinder interface {
    FindByID(ctx context.Context, id string) (*model.User, error)
}
```

## Functions

- Context is always the first parameter: `func (s *Service) Get(ctx context.Context, id string)`.
- Return the error as the last return value.
- Constructors: `func New(deps ...) *Type` — not `func Create` or `func Init`.
- No more than 5 parameters. Use an options struct for more.
- Use functional options (`func WithTimeout(d time.Duration) Option`)
  for optional configuration.

## HTTP Handlers (net/http)

- Handlers are methods on a handler struct that holds dependencies.
- Use Go 1.22 routing patterns: `mux.HandleFunc("GET /users/{id}", h.GetUser)`.
- Always call `defer r.Body.Close()` is unnecessary (`net/http` handles it) —
  do NOT add it.
- Write JSON responses with a helper that sets Content-Type and encodes:

```go
func writeJSON(w http.ResponseWriter, status int, v any) {
    w.Header().Set("Content-Type", "application/json")
    w.WriteHeader(status)
    json.NewEncoder(w).Encode(v)
}
```

## Database (database/sql + pgx)

- Always pass `context.Context` to queries.
- Use `sqlx` or plain `database/sql` — no ORM.
- Query functions return `(T, error)`, not `(*T, error)`, unless `nil`
  is a meaningful distinct value.
- Use `sql.ErrNoRows` — check with `errors.Is(err, sql.ErrNoRows)`.
- Transactions: accept a `*sql.Tx` parameter or use a callback pattern.

## Testing

- Table-driven tests with `t.Run` subtests.
- Call `t.Parallel()` in every test and subtest unless shared state
  makes it impossible.
- Test file is in the same package (white-box) for unit tests.
- Test file is in `_test` package (black-box) for API contract tests.
- Name: `Test<Function>_<scenario>`. Example: `TestCreateUser_DuplicateEmail`.
- Use `t.Helper()` in all test helper functions.
- Assert with `if got != want { t.Errorf(...) }` — no assertion libraries.

```go
func TestCreateUser(t *testing.T) {
    t.Parallel()
    tests := []struct {
        name    string
        input   CreateUserInput
        wantErr bool
    }{
        {name: "valid input", input: validInput(), wantErr: false},
        {name: "empty name", input: emptyName(), wantErr: true},
    }
    for _, tt := range tests {
        t.Run(tt.name, func(t *testing.T) {
            t.Parallel()
            // ...
        })
    }
}
```

## Concurrency

- Never start a goroutine without a clear shutdown mechanism.
- Use `errgroup.Group` for concurrent operations that can fail.
- Prefer channels for communication, mutexes for state protection.
- Always use `context.Context` for cancellation propagation.
