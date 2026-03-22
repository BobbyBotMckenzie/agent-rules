---
description: Testing rules — TDD with vertical slices, behavior over implementation
globs: "**/*.{test,spec}.{ts,tsx}"
---

# Testing Rules

- **Vertical slices**: RED (one test fails) → GREEN (minimal code passes) → repeat
- Never write all tests first then all implementation
- Tests verify **behavior through public interfaces**, not implementation details
- A good test reads like a spec: "user can checkout with valid cart"
- If test breaks on refactor but behavior is unchanged, the test is bad
- Don't mock internal collaborators — mock boundaries (network, DB, filesystem)
- Prefer integration-style tests that exercise real code paths
