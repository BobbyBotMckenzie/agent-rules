---
description: React rules — no useEffect, proper component structure
globs: "**/*.{tsx,jsx}"
---

# React Rules

## Never use useEffect directly

Five replacement patterns:

1. **Derive state inline** — don't `useEffect(() => setX(derive(y)), [y])`
2. **React Query / SWR** for data fetching — never `useEffect + fetch`
3. **Event handlers** for user actions — no flag-based effect patterns
4. **`useMountEffect`** for external system sync on mount
5. **`key` prop** to reset state when props change

If you need `useMountEffect`:
```typescript
function useMountEffect(effect: () => void | (() => void)) {
  useEffect(effect, []);
}
```

## Component structure

```typescript
export function Component({ id }: Props) {
  // 1. Hooks
  const { data, isLoading } = useQuery(['item', id], () => fetchItem(id));

  // 2. Local state
  const [isOpen, setIsOpen] = useState(false);

  // 3. Computed values (NOT useEffect + setState)
  const displayName = data?.name ?? 'Unknown';

  // 4. Event handlers
  const handleClick = () => setIsOpen(true);

  // 5. Early returns
  if (isLoading) return <Loading />;

  // 6. Render
  return <div>...</div>;
}
```
