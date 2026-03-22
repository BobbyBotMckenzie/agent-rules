---
name: code-quality
description: Standing rules for TypeScript and React code quality. ACTIVATE on every coding task. Covers type safety, React patterns, testing approach, and commit discipline.
---

# Code Quality Rules

These rules are non-negotiable. Read before writing any code.

## TypeScript

- **Zero `any`** — use proper types or `unknown` with type guards
- No `as any` casts — use `as SpecificType` with a comment explaining why
- No `// @ts-ignore` or `// @ts-expect-error` — fix the actual issue
- No `// biome-ignore` or `// eslint-disable` — fix the actual issue
- Prefer `unknown` over `any` for truly unknown types, then narrow with type guards
- Use discriminated unions over type assertions
- Prefer `satisfies` over `as` for type checking without widening

```typescript
// BAD
const data: any = await fetch(url).then(r => r.json());
const user = data as User; // hope for the best

// GOOD
const data: unknown = await fetch(url).then(r => r.json());
function isUser(val: unknown): val is User {
  return typeof val === 'object' && val !== null && 'id' in val;
}
if (isUser(data)) { /* safe */ }
```

## React

- **Never use `useEffect` directly** — see the `no-use-effect` skill for 5 replacement patterns
- Derive state inline instead of syncing with effects
- Use query libraries (React Query / SWR) for data fetching, never `useEffect` + `fetch`
- Event handlers for user actions, not effect-based flag patterns
- `useMountEffect` for the rare external system sync case
- `key` prop to reset component state, not effects watching prop changes

### Component structure

```typescript
export function Component({ id }: Props) {
  // 1. Hooks
  const { data, isLoading } = useQuery(['item', id], () => fetchItem(id));

  // 2. Local state
  const [isOpen, setIsOpen] = useState(false);

  // 3. Derived/computed values (NOT useEffect + setState)
  const displayName = data?.name ?? 'Unknown';

  // 4. Event handlers
  const handleClick = () => setIsOpen(true);

  // 5. Early returns
  if (isLoading) return <Loading />;

  // 6. Render
  return <div>...</div>;
}
```

## Testing

- Tests verify **behavior through public interfaces**, not implementation details
- A good test reads like a specification: "user can checkout with valid cart"
- If your test breaks when you refactor but behavior hasn't changed, the test is bad
- **Vertical slices**: one test → one implementation → repeat (never all tests then all code)
- Don't mock internal collaborators — mock boundaries (network, DB, filesystem)
- Prefer integration-style tests that exercise real code paths

## Commit Discipline

**Before every commit, run:**
```bash
pnpm typecheck   # or: npx tsc --noEmit
pnpm lint        # or: npx biome lint --diagnostic-level=error .
pnpm test        # or: npx vitest run
```

If ANY gate fails, fix it before committing. Do not commit broken code.
Do not batch up lint fixes at the end — run lint after every logical change.

## Architecture

- Prefer **deep modules** (rich functionality, simple interface) over shallow wrappers
- No god files — if a file exceeds 400 lines, it probably needs splitting
- No copy-paste — extract shared logic into composable functions/hooks
- Composition over inheritance
- Collocate related code — tests next to source, types next to usage
