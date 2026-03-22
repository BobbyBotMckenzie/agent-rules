# CLAUDE.md — Project Instructions

## Quality Gates (Non-Negotiable)

Before every commit, run all three:
```bash
pnpm typecheck   # TypeScript strict — must pass
pnpm lint        # Biome linter — must pass
pnpm test        # Tests — must pass
```

If ANY gate fails, fix it immediately. Do not commit broken code.
Run lint after every logical change, not just at the end.

## TypeScript Rules

- **Zero `any`** — use proper types, `unknown` with type guards, or specific types
- No `as any` — use `as SpecificType` with a comment
- No `// @ts-ignore`, `// @ts-expect-error`, `// biome-ignore` — fix the actual issue
- Prefer `unknown` over `any`, then narrow with type guards
- Prefer `satisfies` over `as` for type checking

## React Rules

- **Never use `useEffect` directly** — see `.agents/skills/no-use-effect/SKILL.md`
  - Derive state inline (don't sync with effects)
  - Use React Query / SWR for data fetching
  - Event handlers for user actions
  - `useMountEffect` for external system sync
  - `key` prop to reset state on prop change
- Component order: hooks → state → computed → handlers → early returns → render

## Testing Rules

- Tests verify behavior through public interfaces, not implementation
- Vertical slices: one test → one implementation → repeat
- Never write all tests first then all code
- Don't mock internals — mock boundaries (network, DB, filesystem)

## Architecture Rules

- No god files (>400 lines → split it)
- Deep modules over shallow wrappers
- Composition over inheritance
- Collocate related code

## Skills Available

Read these before relevant work:
- `.agents/skills/no-use-effect/` — React effect patterns
- `.agents/skills/tdd/` — Test-driven development
- `.agents/skills/code-quality/` — Standing quality rules
