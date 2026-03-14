# DevOS Examples

This directory contains fully-customized reference configurations for common technology stacks. Use them as a reference for what `CUSTOMIZE.md` produces, or copy the relevant files directly into your project.

## Available Stacks

| Stack | Directory | Description |
|-------|-----------|-------------|
| Python/FastAPI/pytest | `python-fastapi/` | REST API with FastAPI, SQLAlchemy, pytest |
| Go/stdlib | `go-stdlib/` | HTTP service with stdlib net/http |
| Rust/Axum | `rust-axum/` | Web service with Axum, Tower, sqlx |
| TypeScript/Next.js | `typescript-nextjs/` | Full-stack app with Next.js, Prisma, Vitest |

## Files in Each Stack

Each stack contains these 4 files:

| File | Purpose |
|------|---------|
| `CLAUDE.md` | Project identity, stack, commands, principles |
| `.claude/settings.json` | Hook registration, command permissions |
| `.claude/rules/code-style.md` | Language-specific coding standards |
| `.claude/hooks/protect-files.sh` | Protected file patterns (lockfiles, etc.) |

## How to Use

### Option 1: Copy directly
```bash
# Copy the entire stack configuration
cp -r examples/python-fastapi/.claude your-project/
cp examples/python-fastapi/CLAUDE.md your-project/
```

### Option 2: Use as reference
Read the files to understand the customization patterns, then adapt for your specific project.

### Option 3: Run CUSTOMIZE.md
Use the `CUSTOMIZE.md` prompt in your project to get a fully customized configuration based on these patterns.
