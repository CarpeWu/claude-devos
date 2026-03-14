---
globs: "**/*.py"
---

# Python Code Style — FastAPI Project

## Formatting

- Ruff handles all formatting. Do not manually adjust line breaks, quotes,
  or import order.
- Maximum line length: 88 characters (Ruff default).
- Use double quotes for strings. Single quotes only inside f-strings or
  to avoid escaping.
- Trailing commas on all multi-line collections, function parameters, and
  function arguments.

## Imports

- Standard library, then third-party, then local — Ruff enforces this via
  isort rules.
- Always import modules, not individual names, for standard library:
  `import os` not `from os import path`.
- FastAPI/Pydantic imports may use `from` style:
  `from fastapi import APIRouter, Depends, HTTPException`.
- Never use wildcard imports (`from module import *`).

## Type Annotations

- All function signatures must have full type annotations (parameters and
  return type).
- Use `T | None` syntax (Python 3.10+ union), not `Optional[T]`.
- Use `list[str]`, `dict[str, int]` (lowercase builtins), not
  `List[str]`, `Dict[str, int]`.
- Pydantic models serve as type annotations for request/response bodies.

## Async Patterns

- All route handlers must be `async def`, never `def`.
- All database calls must use `await` with async SQLAlchemy sessions.
- Use `asyncio.gather()` for concurrent independent operations.
- Never call `time.sleep()` — use `asyncio.sleep()` if needed.
- Never use `run_in_executor` unless wrapping a genuinely blocking
  third-party library.

## FastAPI Conventions

- Group routes in `APIRouter` instances, one per domain module.
- Use `Depends()` for all shared dependencies. No global variables.
- Response models: always specify `response_model` on route decorators.
- Status codes: use `status.HTTP_201_CREATED`, etc., not bare integers.
- Path parameters: use type-annotated path params, not manual parsing.

```python
# YES
@router.post("/items", response_model=ItemResponse, status_code=status.HTTP_201_CREATED)
async def create_item(
    body: ItemCreate,
    db: AsyncSession = Depends(get_db),
) -> ItemResponse:
    ...

# NO
@router.post("/items")
def create_item(body: dict, db=Depends(get_db)):
    ...
```

## Pydantic Models

- All schemas inherit from a project `BaseSchema` (which sets
  `model_config = ConfigDict(from_attributes=True)`).
- Use `Field()` for validation constraints, not custom validators when
  a constraint suffices.
- Separate `Create`, `Update`, and `Response` schemas. Never reuse one
  schema for all three.
- Use `Annotated[str, Field(min_length=1)]` for constrained types used
  in multiple schemas.

## SQLAlchemy Models

- All models inherit from a shared `Base` with `DeclarativeBase`.
- Use `Mapped[T]` and `mapped_column()` (SQLAlchemy 2.0 style), never
  `Column()`.
- Table names: lowercase plural (`users`, `order_items`).
- Always define `__repr__` returning a useful identifier.

## Error Handling

- Routers catch domain exceptions and translate to `HTTPException`.
- Services raise specific exception classes, never `HTTPException`
  (services don't know about HTTP).
- Never use bare `except:` or `except Exception:` without re-raising
  or logging.

## Testing

- Test files mirror source structure: `tests/unit/services/test_user.py`
  tests `src/services/user.py`.
- Test function names: `test_<action>_<scenario>_<expected>`.
  Example: `test_create_user_duplicate_email_raises_conflict`.
- Use `httpx.AsyncClient` for API tests, not `TestClient`.
- Use factories (or `factory_boy`) for test data, not raw dicts.
- Assert specific status codes and response shapes, not just `200 OK`.
