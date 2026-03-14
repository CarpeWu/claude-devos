---
globs: "**/*.ts,**/*.tsx"
---

# TypeScript Code Style — Next.js Project

## Formatting

- Prettier handles all formatting. Do not manually adjust spacing,
  quotes, or semicolons.
- Semicolons: off (Prettier default for this project).
- Quotes: double quotes for JSX attributes, single quotes for imports
  and strings (configured in Prettier).
- Trailing commas: `all`.
- Max line width: 100.

## TypeScript

- **Strict mode.** All strict checks are enabled in `tsconfig.json`.
- **No `any`.** Use `unknown` when the type is genuinely unknown, then
  narrow with type guards or Zod parsing.
- **No `@ts-ignore` or `@ts-expect-error`** without a comment explaining
  why and a linked issue for fixing it.
- **No non-null assertions (`!`)** unless you can prove the value exists
  (e.g., immediately after a null check that TypeScript doesn't narrow).
- Prefer `interface` for object shapes that might be extended. Use `type`
  for unions, intersections, and mapped types.
- Use `satisfies` for type-checking object literals without widening:

```typescript
const config = {
  theme: "dark",
  locale: "en",
} satisfies Config
```

## React Components

- **Functional components only.** No class components.
- **Named exports only.** No `export default` except for Next.js page/layout
  files (which require it).
- Component file names: `PascalCase.tsx`. `UserProfile.tsx`, not
  `user-profile.tsx`.
- Props type: define inline for simple components, named `interface` for
  complex ones:

```typescript
// Simple — inline
function Badge({ label, variant }: { label: string; variant: "info" | "warn" }) {
  ...
}

// Complex — named interface
interface UserCardProps {
  user: User
  onEdit: (id: string) => void
  showActions?: boolean
}

function UserCard({ user, onEdit, showActions = true }: UserCardProps) {
  ...
}
```

- Destructure props in the function signature, not in the body.
- Use `children: React.ReactNode` for components that accept children.

## Server Components vs. Client Components

- Default is Server Component (no directive needed).
- Add `"use client"` only when the component uses:
  - `useState`, `useEffect`, `useReducer`, `useRef` (with DOM)
  - Event handlers (`onClick`, `onChange`, etc.)
  - Browser-only APIs (`window`, `document`, `localStorage`)
- Push `"use client"` boundaries as deep as possible. Wrap only the
  interactive leaf, not the entire page.
- Never import a Server Component into a Client Component.

## Server Actions

- Define in separate files with `"use server"` directive at the top.
- Always validate input with Zod before any database operation:

```typescript
"use server"

import { z } from "zod"

const CreateUserSchema = z.object({
  name: z.string().min(1).max(100),
  email: z.string().email(),
})

export async function createUser(formData: FormData) {
  const parsed = CreateUserSchema.safeParse({
    name: formData.get("name"),
    email: formData.get("email"),
  })
  if (!parsed.success) {
    return { error: parsed.error.flatten() }
  }
  // ... database operation
}
```

- Return `{ error: ... }` or `{ data: ... }` objects, not throwing.
- Call `revalidatePath()` or `revalidateTag()` after mutations.

## Prisma

- Import the Prisma client from `lib/db.ts` (singleton pattern).
- Use `select` or `include` to fetch only needed fields — no bare
  `findMany()` without field selection on large tables.
- Wrap related writes in `prisma.$transaction()`.
- Never expose raw Prisma types in component props — map to DTOs or
  use `Prisma.UserGetPayload<{ select: ... }>` for precise types.

## Imports

- Absolute imports via `@/` path alias: `import { db } from "@/lib/db"`.
- Group: React/Next, then external libraries, then `@/` internal, then
  relative — separated by blank lines.
- Never use barrel files (`index.ts` that re-exports) except for
  `components/ui/index.ts`.

## Zod Schemas

- Define schemas in `lib/validations/`. One file per domain.
- Export the schema AND the inferred type:

```typescript
export const createUserSchema = z.object({
  name: z.string().min(1),
  email: z.string().email(),
})

export type CreateUserInput = z.infer<typeof createUserSchema>
```

- Reuse schemas between client-side form validation and Server Actions.

## Testing

- **Vitest** for unit tests and component tests.
- **React Testing Library** for component rendering tests.
- **Playwright** for E2E tests.
- Test file location: colocated as `Component.test.tsx` or in `tests/`.
- Name: `describe("<Component>")` → `it("should <behavior>")`.
- Query by role, label, or text — never by CSS class or test ID unless
  no semantic alternative exists.
- Test user behavior, not implementation details. Don't test state
  variables — test what the user sees.

## Tailwind CSS

- Use Tailwind utility classes directly in JSX. No CSS modules, no
  styled-components.
- Extract repeated patterns into components, not into `@apply` classes.
- Use `cn()` utility (clsx + tailwind-merge) for conditional classes:

```typescript
import { cn } from "@/lib/utils"

function Button({ variant, className, ...props }: ButtonProps) {
  return (
    <button
      className={cn(
        "rounded px-4 py-2 font-medium",
        variant === "primary" && "bg-blue-600 text-white",
        variant === "ghost" && "bg-transparent text-gray-700",
        className,
      )}
      {...props}
    />
  )
}
```
