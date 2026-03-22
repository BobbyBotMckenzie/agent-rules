---
description: Global product context and quality standards
globs: "**"
---

# Quality Standards

## Before Writing Code
- Read `.agents/skills/code-quality/SKILL.md` for standing rules
- Read `.agents/skills/no-use-effect/SKILL.md` for React work
- Read `.agents/skills/tdd/SKILL.md` for test-driven development

## Quality Gates (run before every commit)
```bash
pnpm typecheck   # must pass
pnpm lint        # must pass
pnpm test        # must pass
```
If ANY fails, fix before committing. Run lint after every logical change.
