# Project: Next.js Application

## Identity

This is a full-stack web application built with Next.js 14 (App Router),
TypeScript, and Prisma. It uses React Server Components by default, with
client components only where interactivity is required.

## Tech Stack

- **Language:** TypeScript 5 (strict mode)
- **Framework:** Next.js 14 (App Router)
- **UI:** React 18, Tailwind CSS
- **Database:** PostgreSQL 16 via Prisma ORM
- **Authentication:** NextAuth.js v5
- **Validation:** Zod
- **State management:** React Server Components + `nuqs` for URL state
- **Testing:** Vitest + React Testing Library + Playwright (E2E)
- **Linting:** ESLint (next/core-web-vitals + typescript-eslint)
- **Formatting:** Prettier
- **Package manager:** pnpm

## Project Structure

```
app/
├── layout.tsx               # Root layout (providers, global styles)
├── page.tsx                 # Home page
├── (auth)/
│   ├── login/page.tsx
│   └── register/page.tsx
├── dashboard/
│   ├── layout.tsx           # Dashboard layout (sidebar, nav)
│   └── page.tsx
├── api/
│   └── [...route]/route.ts  # API route handlers
└── globals.css              # Tailwind directives, global styles
components/
├── ui/                      # Generic UI primitives (Button, Input, Card)
├── forms/                   # Form components with validation
└── layouts/                 # Layout-specific components (Sidebar, Nav)
lib/
├── db.ts                    # Prisma client singleton
├── auth.ts                  # NextAuth configuration
├── validations/             # Zod schemas
├── actions/                 # Server Actions
└── utils.ts                 # Shared utility functions
prisma/
├── schema.prisma            # Database schema
└── migrations/
types/
└── index.ts                 # Shared TypeScript types/interfaces
tests/
├── unit/                    # Vitest unit tests
├── components/              # React Testing Library tests
└── e2e/                     # Playwright E2E tests
```

## Commands

```bash
# Development
pnpm dev                                   # start dev server (port 3000)
pnpm build                                 # production build
pnpm start                                 # start production server

# Testing
pnpm test                                  # run Vitest
pnpm test:watch                            # Vitest in watch mode
pnpm test:coverage                         # Vitest with coverage
pnpm test:e2e                              # Playwright E2E tests
pnpm test:e2e --ui                         # Playwright interactive UI

# Linting & formatting
pnpm lint                                  # ESLint
pnpm lint:fix                              # ESLint + autofix
pnpm format                                # Prettier format
pnpm format:check                          # Prettier check (CI)

# Type checking
pnpm typecheck                             # tsc --noEmit

# Database
pnpm prisma migrate dev                    # create + apply migration
pnpm prisma migrate deploy                 # apply migrations (prod)
pnpm prisma generate                       # regenerate Prisma Client
pnpm prisma studio                         # database GUI
pnpm prisma db seed                        # seed database

# Dependencies
pnpm install                               # install dependencies
pnpm update                                # update dependencies
pnpm audit                                 # check for vulnerabilities
```

## Principles

1. **Server Components by default.** Every component is a React Server
   Component unless it needs `useState`, `useEffect`, event handlers,
   or browser APIs. Add `"use client"` only when required and push it
   as far down the tree as possible.

2. **Type everything.** TypeScript strict mode is enabled. No `any` types.
   No `@ts-ignore`. Use Zod schemas for runtime validation and infer
   TypeScript types from them with `z.infer<typeof schema>`.

3. **Server Actions for mutations.** Use Next.js Server Actions for all
   create/update/delete operations. Validate input with Zod on the server
   side. Never trust client-side validation alone.

4. **Colocation.** Keep components, styles, and tests close to where
   they're used. Route-specific components live in the route directory,
   not in a global `components/` folder.

5. **Prisma as the source of truth.** The database schema is defined in
   `schema.prisma`. Never write raw SQL. Use Prisma Client for all
   queries. Keep queries in `lib/actions/` or `lib/queries/`, not in
   components.

6. **Progressive enhancement.** Forms should work without JavaScript.
   Use `<form action={serverAction}>` with Server Actions. Add client-side
   enhancements (optimistic UI, loading states) on top.
