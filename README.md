# Agent Rules

Opinionated guardrails for AI coding agents. Works with Claude Code, Kiro, Codex, Cursor, and any agent that reads project-level config.

**Problem:** AI agents write code that *looks* right but ignores your linter, sprays `any` everywhere, abuses `useEffect`, skips tests, and commits garbage that passes vibes-check but fails every quality gate.

**Solution:** Don't trust instructions — enforce with tooling. Three layers of defense:

1. **Skills** — Methodology the agent reads before writing code
2. **Lint rules** — Hard enforcement that blocks commits
3. **Pre-commit hooks** — The agent literally cannot commit violations

## Quick Start

```bash
# Clone into your project
npx degit callummckenzie/agent-rules .agent-rules

# Or cherry-pick what you need
cp -r .agent-rules/skills/no-use-effect .agents/skills/
cp -r .agent-rules/skills/tdd .agents/skills/
cp .agent-rules/biome.json .
```

## What's Included

### Skills (methodology)

| Skill | What it does |
|---|---|
| `no-use-effect` | 5 replacement patterns for useEffect — agents stop reaching for it as default |
| `tdd` | Red-green-refactor with vertical slices, not horizontal layers |
| `grill-me` | Stress-test a plan before committing to implementation |
| `write-a-prd` | Interactive PRD creation through codebase exploration |
| `prd-to-plan` | Break PRDs into tracer-bullet vertical slices |
| `triage-issue` | Structured bug investigation with root cause analysis |
| `improve-codebase-architecture` | Deep module analysis — find shallow modules, improve testability |
| `ubiquitous-language` | DDD glossary extraction for naming consistency |
| `code-quality` | Standing rules for TypeScript, React, and general code quality |

### Lint Configs

Pick the linter your project uses. All three enforce the same core rules:

| File | Linter | Notes |
|---|---|---|
| `lint/biome.json` | Biome | Fastest. Single tool for lint + format. Recommended for new projects. |
| `lint/biome-relaxed.json` | Biome | Same but `any` as warning — for gradual adoption on existing codebases |
| `lint/eslint.config.mjs` | ESLint (flat config) | Most ecosystem support. Needs `typescript-eslint`, `eslint-plugin-react`, `eslint-plugin-react-hooks`. |
| `lint/oxlint.json` | oxlint | Rust-based, very fast. Good as a complement to ESLint or standalone. |

**Core rules enforced by all three:**
- `no-explicit-any` → error
- `no-ts-ignore` / `ban-ts-comment` → error
- `no-unused-vars` / `no-unused-imports` → error
- `jsx-key` → error
- `vi.mock()` / `vi.spyOn()` / `vi.stubGlobal()` → banned in test files
- `useEffect` → banned via `no-restricted-imports` (ESLint/oxlint) or skill enforcement (Biome)

### Git Hooks

| File | What it does |
|---|---|
| `hooks/pre-commit` | Runs lint + typecheck on staged files before every commit |
| `hooks/setup.sh` | Installs husky + lint-staged with the right config |

### Agent Configs

| File | What it does |
|---|---|
| `claude/CLAUDE.md` | Claude Code project instructions with quality rules |
| `kiro/kiro.yml` | Kiro agent config with equivalent rules |
| `cursor/.cursorrules` | Cursor rules file |

## Philosophy

1. **Don't prescribe how — create gates that reject bad work** (backpressure)
2. **Skills teach methodology — hooks enforce it** — the agent can ignore a skill, it can't bypass a pre-commit hook
3. **Vertical slices over horizontal layers** — one test → one implementation → repeat
4. **Tests verify behavior, not implementation** — test public interfaces, not internal details
5. **Zero `any`, zero `useEffect`** — these are the two biggest agent sins in TypeScript/React
