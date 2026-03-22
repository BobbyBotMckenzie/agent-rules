---
name: no-vi-mock
description: Ban vi.mock(), vi.stubGlobal(), and vi.spyOn() in tests. Use constructor or parameter dependency injection instead. ACTIVATE when writing or reviewing test files.
---

# No vi.mock

**Never use `vi.mock()`, `vi.stubGlobal()`, or `vi.spyOn()`.** Use dependency injection instead.

## Why

These methods monkey-patch modules at the import level. This means:
- Tests are coupled to the *import graph*, not behavior
- Refactoring internal module structure breaks tests even when behavior is unchanged
- Tests become order-dependent and fragile
- You can't tell from the test what the actual dependency boundary is

## The Rule

```
vi.mock()       → banned
vi.stubGlobal() → banned
vi.spyOn()      → banned
```

**Use constructor or parameter dependency injection instead.**

## Examples

### Data fetching

```typescript
// BAD — mocking the import
vi.mock('./api', () => ({
  fetchUsers: vi.fn().mockResolvedValue([{ id: 1, name: 'Alice' }])
}));

test('shows users', async () => {
  render(<UserList />);
  expect(await screen.findByText('Alice')).toBeInTheDocument();
});

// GOOD — inject the dependency
test('shows users', async () => {
  const mockFetch = async () => [{ id: 1, name: 'Alice' }];
  render(<UserList fetchUsers={mockFetch} />);
  expect(await screen.findByText('Alice')).toBeInTheDocument();
});
```

### Service classes

```typescript
// BAD — spying on internal methods
const service = new OrderService();
vi.spyOn(service, 'calculateTotal');
service.placeOrder(items);
expect(service.calculateTotal).toHaveBeenCalled();

// GOOD — inject collaborators, test output
const fakePricing = { getPrice: (id: string) => 10.00 };
const service = new OrderService(fakePricing);
const order = service.placeOrder(items);
expect(order.total).toBe(30.00);
```

### External services

```typescript
// BAD — stubbing globals
vi.stubGlobal('fetch', vi.fn().mockResolvedValue({
  json: () => Promise.resolve({ data: 'test' })
}));

// GOOD — inject an HTTP client
const fakeClient = {
  get: async (url: string) => ({ data: 'test' })
};
const service = new ApiService(fakeClient);
```

## When you think you need vi.mock

Ask yourself:
1. **Am I testing behavior or implementation?** If you need to mock an internal module, you're probably testing implementation.
2. **Can I inject this dependency?** Almost always yes — pass it as a parameter, constructor arg, or React prop.
3. **Is this a boundary?** Network, filesystem, database — these are real boundaries. But inject the client, don't mock the import.

## The pattern

```typescript
// Production: uses real dependency
const service = new MyService(new RealHttpClient());

// Test: uses fake dependency
const service = new MyService(fakeHttpClient);
```

This is just good software design. The test is forcing you to make your dependencies explicit — which makes the code better, not just the test.
