---
description: TypeScript rules — zero tolerance for any, suppression comments
globs: "**/*.{ts,tsx}"
---

# TypeScript Rules

- **Zero `any`** — use proper types, `unknown` with type guards, or generics
- No `as any` — use `as SpecificType` with a comment explaining why
- No `// @ts-ignore` or `// @ts-expect-error` — fix the actual type error
- No `// biome-ignore` or `// eslint-disable` — fix the actual lint issue
- Prefer `unknown` over `any`, narrow with type guards
- Use discriminated unions over type assertions
- Prefer `satisfies` over `as` for type checking without widening

```typescript
// BAD
const data: any = await fetch(url).then(r => r.json());

// GOOD
const data: unknown = await fetch(url).then(r => r.json());
function isUser(val: unknown): val is User {
  return typeof val === 'object' && val !== null && 'id' in val;
}
```
