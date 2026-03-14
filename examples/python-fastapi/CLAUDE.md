# Project: FastAPI Service

## Identity

This is a REST API backend built with Python, FastAPI, and SQLAlchemy.
It serves as a backend service with async request handling, PostgreSQL
persistence, and Pydantic-based validation.

## Tech Stack

- **Language:** Python 3.12
- **Framework:** FastAPI with Uvicorn
- **ORM:** SQLAlchemy 2.0 (async)
- **Validation:** Pydantic v2
- **Database:** PostgreSQL 16
- **Migrations:** Alembic
- **Package manager:** Poetry
- **Testing:** pytest + pytest-asyncio + httpx
- **Linting:** Ruff
- **Type checking:** mypy (strict mode)
- **Containerization:** Docker + docker-compose

## Project Structure

```
src/
├── main.py                  # FastAPI app factory, lifespan events
├── config.py                # Pydantic Settings, env var loading
├── dependencies.py          # Dependency injection (DB sessions, auth)
├── models/                  # SQLAlchemy ORM models
├── schemas/                 # Pydantic request/response schemas
├── routers/                 # FastAPI route handlers, grouped by domain
├── services/                # Business logic layer
├── repositories/            # Database access layer
└── middleware/               # Custom middleware (logging, CORS, errors)
tests/
├── conftest.py              # Shared fixtures (test DB, async client)
├── unit/                    # Unit tests (services, utils)
├── integration/             # Integration tests (repositories, DB)
└── api/                     # API tests (full request/response cycle)
alembic/
├── env.py
└── versions/
```

## Commands

```bash
# Development
poetry run uvicorn src.main:app --reload --port 8000

# Testing
poetry run pytest                          # all tests
poetry run pytest tests/unit               # unit tests only
poetry run pytest tests/api                # API tests only
poetry run pytest -x --tb=short            # stop on first failure
poetry run pytest --cov=src --cov-report=term-missing

# Linting & formatting
poetry run ruff check .                    # lint
poetry run ruff check . --fix              # lint + autofix
poetry run ruff format .                   # format

# Type checking
poetry run mypy src/

# Database
poetry run alembic upgrade head            # apply migrations
poetry run alembic revision --autogenerate -m "description"

# Docker
docker-compose up -d                       # start services
docker-compose down                        # stop services
```

## Principles

1. **Async by default.** All database operations and HTTP handlers use
   `async`/`await`. Never use synchronous SQLAlchemy calls inside async
   handlers.

2. **Layered architecture.** Routers call services. Services call
   repositories. Repositories call the database. No layer skipping.
   Routers never import `Session` directly.

3. **Pydantic everywhere.** All request bodies, response bodies, and
   configuration use Pydantic models. No raw dicts cross API boundaries.

4. **Dependency injection.** Use FastAPI's `Depends()` for database
   sessions, authentication, and shared resources. No global state.

5. **Test isolation.** Each test runs in a transaction that rolls back.
   Tests never depend on execution order. Use factories, not fixtures
   that share mutable state.

6. **Explicit errors.** Raise `HTTPException` with specific status codes
   in routers. Services raise domain exceptions. Never return `None` to
   signal an error.
