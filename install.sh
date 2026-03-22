#!/bin/bash
# Install agent-rules into the current project
# Usage: bash install.sh [--strict|--relaxed] [--claude|--kiro|--cursor|--all]

set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PROJECT_DIR="$(pwd)"
STRICT=true
AGENTS=()

# Parse args
while [[ $# -gt 0 ]]; do
  case $1 in
    --relaxed) STRICT=false; shift ;;
    --strict) STRICT=true; shift ;;
    --claude) AGENTS+=("claude"); shift ;;
    --kiro) AGENTS+=("kiro"); shift ;;
    --cursor) AGENTS+=("cursor"); shift ;;
    --all) AGENTS=("claude" "kiro" "cursor"); shift ;;
    --hooks) INSTALL_HOOKS=true; shift ;;
    *) echo "Unknown option: $1"; exit 1 ;;
  esac
done

# Default to all agents if none specified
if [ ${#AGENTS[@]} -eq 0 ]; then
  AGENTS=("claude" "kiro" "cursor")
fi

echo "🔧 Installing agent-rules into $PROJECT_DIR"
echo ""

# 1. Copy skills
echo "📚 Installing skills..."
mkdir -p "$PROJECT_DIR/.agents/skills"
for skill in "$SCRIPT_DIR/skills"/*/; do
  skill_name=$(basename "$skill")
  cp -r "$skill" "$PROJECT_DIR/.agents/skills/$skill_name"
  echo "   ✓ $skill_name"
done

# 2. Copy lint config
echo ""
echo "🔍 Installing lint config..."
if [ "$STRICT" = true ]; then
  cp "$SCRIPT_DIR/lint/biome.json" "$PROJECT_DIR/biome.json"
  echo "   ✓ biome.json (strict — any = error)"
else
  cp "$SCRIPT_DIR/lint/biome.json" "$PROJECT_DIR/biome.json"
  cp "$SCRIPT_DIR/lint/biome-relaxed.json" "$PROJECT_DIR/biome-relaxed.json"
  # Merge relaxed overrides
  echo "   ✓ biome.json (relaxed — any = warn)"
fi

# 3. Copy agent configs
echo ""
echo "🤖 Installing agent configs..."
for agent in "${AGENTS[@]}"; do
  case $agent in
    claude)
      cp "$SCRIPT_DIR/claude/CLAUDE.md" "$PROJECT_DIR/CLAUDE.md"
      echo "   ✓ CLAUDE.md"
      ;;
    kiro)
      mkdir -p "$PROJECT_DIR/.kiro/steering"
      cp "$SCRIPT_DIR/kiro/steering/"*.md "$PROJECT_DIR/.kiro/steering/"
      echo "   ✓ .kiro/steering/ (product, typescript, react, testing)"
      ;;
    cursor)
      cp "$SCRIPT_DIR/cursor/.cursorrules" "$PROJECT_DIR/.cursorrules"
      echo "   ✓ .cursorrules"
      ;;
  esac
done

# 4. Setup hooks if requested
if [ "$INSTALL_HOOKS" = true ]; then
  echo ""
  echo "🪝 Installing pre-commit hooks..."
  bash "$SCRIPT_DIR/hooks/setup.sh"
fi

echo ""
echo "✅ Done! Agent rules installed."
echo ""
echo "Next steps:"
echo "  1. Install biome: pnpm add -D @biomejs/biome"
echo "  2. Add scripts to package.json:"
echo "     \"lint\": \"biome lint --diagnostic-level=error .\""
echo "     \"check\": \"pnpm typecheck && pnpm lint && pnpm test\""
echo "  3. Run --hooks to add pre-commit enforcement:"
echo "     bash install.sh --hooks"
