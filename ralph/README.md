# Ralph Orchestrator Config

Drop `ralph.yml` in your project root and you get a full planning → building → review pipeline with backpressure.

## Setup

```bash
# Install Ralph
npm install -g @ralph-orchestrator/ralph-cli

# Copy config to your project
cp ralph.yml /path/to/your/project/

# Verify
cd /path/to/your/project
ralph doctor
```

## Usage

```bash
# Create a task
echo "# Build user authentication with email/password" > PROMPT.md

# Run the full pipeline (PRD → Plan → Build with TDD → Review)
ralph run

# Or run specific hats
ralph run --hat builder        # Skip planning, just build
ralph run --hat triager         # Investigate a bug
ralph run --hat architect       # Architecture review
```

## The Pipeline

```
work.start → PRD Writer → Planner → Builder (TDD) → Reviewer
                                        ↑                |
                                        └── changes_requested
```

1. **PRD Writer** — Explores codebase, writes a PRD to `.ralph/specs/prd.md`
2. **Planner** — Breaks PRD into tracer-bullet vertical slices
3. **Builder** — Implements using TDD (red-green-refactor), runs quality gates
4. **Reviewer** — Re-runs gates, reviews code quality, approves or rejects

## Specialty Hats

- **Griller** — Stress-test a plan (trigger: `plan.review`)
- **Triager** — Investigate a bug (trigger: `bug.reported`)
- **Architect** — Architecture review (trigger: `arch.review`)
- **Glossarist** — Extract domain language glossary (trigger: `lang.extract`)

## Backpressure

The Builder hat **cannot** declare done without passing all gates:
- `pnpm typecheck` (or `npx tsc --noEmit`)
- `pnpm lint` (or `npx biome lint --diagnostic-level=error .`)
- `pnpm test` (or `npx vitest run`)
- `pnpm build`

The Reviewer hat **re-runs** all gates independently. If anything fails, it sends the work back to the Builder.

## Customization

Edit the quality gate commands in `ralph.yml` to match your project:

```yaml
# If you use npm instead of pnpm:
# Change: pnpm typecheck → npm run typecheck
# If you use eslint instead of biome:
# Change: pnpm lint → npx eslint .
```

The guardrails and hat instructions reference skills from `.agents/skills/`. Install those too (see the root README).
