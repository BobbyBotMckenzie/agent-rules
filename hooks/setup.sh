#!/bin/bash
# Setup pre-commit hooks for agent-proof quality gates
# Run from your project root: bash .agent-rules/hooks/setup.sh

set -e

echo "Installing husky + lint-staged..."

# Detect package manager
if [ -f "pnpm-lock.yaml" ]; then
  PM="pnpm add -D -w"
elif [ -f "yarn.lock" ]; then
  PM="yarn add -D"
else
  PM="npm install -D"
fi

$PM husky lint-staged

# Init husky
npx husky init

# Copy pre-commit hook
cp "$(dirname "$0")/pre-commit" .husky/pre-commit

# Add lint-staged config to package.json
node -e "
const pkg = require('./package.json');
pkg['lint-staged'] = {
  '*.{ts,tsx,js,jsx}': ['biome lint --diagnostic-level=error --no-errors-on-unmatched'],
  '*.{ts,tsx}': ['bash -c \"npx tsc --noEmit\"']
};
require('fs').writeFileSync('package.json', JSON.stringify(pkg, null, 2) + '\n');
console.log('Added lint-staged config to package.json');
"

echo ""
echo "✅ Pre-commit hooks installed."
echo "   Commits will now be blocked if lint or typecheck fails."
echo "   Test it: echo 'const x: any = 1;' > test.ts && git add test.ts && git commit -m 'test'"
