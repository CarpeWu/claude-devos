#!/usr/bin/env bash
set -euo pipefail

# claude-devos installer
# Copies DevOS template files into the current directory.
# Run from your project root: /path/to/claude-devos/install.sh

# ── Locate the repo root (where this script lives) ──────────────────────────

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TEMPLATE_DIR="$SCRIPT_DIR/template"

# ── Verify we have what we need ──────────────────────────────────────────────

if [ ! -d "$TEMPLATE_DIR" ]; then
    echo "Error: template/ directory not found at $TEMPLATE_DIR"
    echo "Make sure you're running this from a cloned claude-devos repo."
    exit 1
fi

if [ ! -f "$TEMPLATE_DIR/CLAUDE.md" ]; then
    echo "Error: template/CLAUDE.md not found. The repo may be incomplete."
    exit 1
fi

# ── Guard against running inside the repo itself ─────────────────────────────

if [ "$(pwd)" = "$SCRIPT_DIR" ]; then
    echo "Error: don't run this inside the claude-devos repo."
    echo "cd into YOUR project directory first, then run:"
    echo "  $0"
    exit 1
fi

# ── Copy template files ─────────────────────────────────────────────────────

echo "Installing DevOS into $(pwd) ..."
echo ""

# Top-level template files
cp -n "$TEMPLATE_DIR/CLAUDE.md" ./CLAUDE.md 2>/dev/null || true
cp -n "$TEMPLATE_DIR/CLAUDE.local.md.example" ./CLAUDE.local.md.example 2>/dev/null || true
cp -n "$TEMPLATE_DIR/CLAUDE.local.md.zh.example" ./CLAUDE.local.md.zh.example 2>/dev/null || true

# .claude directory tree
if [ -d ".claude" ]; then
    echo "Warning: .claude/ directory already exists. Merging without overwriting."
    cp -rn "$TEMPLATE_DIR/.claude/" ./.claude/ 2>/dev/null || true
else
    cp -r "$TEMPLATE_DIR/.claude" ./.claude
fi

# CUSTOMIZE.md (from repo root, not template/)
cp -n "$SCRIPT_DIR/CUSTOMIZE.md" ./CUSTOMIZE.md 2>/dev/null || true

# ── Set permissions ──────────────────────────────────────────────────────────

chmod +x .claude/hooks/*.sh 2>/dev/null || true

# ── Update .gitignore ────────────────────────────────────────────────────────

touch .gitignore

if ! grep -qxF "CLAUDE.local.md" .gitignore 2>/dev/null; then
    echo "CLAUDE.local.md" >> .gitignore
fi

if ! grep -qxF ".claude/settings.local.json" .gitignore 2>/dev/null; then
    echo ".claude/settings.local.json" >> .gitignore
fi

# ── Check for jq ─────────────────────────────────────────────────────────────

echo ""
if command -v jq &>/dev/null; then
    echo "✓ jq is installed"
else
    echo "⚠ jq is not installed. Hooks will not function."
    echo "  Install: brew install jq (macOS) or apt install jq (Linux)"
fi

# ── Report ───────────────────────────────────────────────────────────────────

echo ""
echo "Installed files:"
echo "  CLAUDE.md"
echo "  CLAUDE.local.md.example"
echo "  CUSTOMIZE.md"
echo "  .claude/"
echo "    ├── settings.json"
echo "    ├── rules/        (2 files)"
echo "    ├── hooks/        (3 scripts)"
echo "    ├── skills/       (6 workflows)"
echo "    ├── agents/       (3 agents)"
echo "    └── knowledge/    (3 templates)"
echo ""
echo "Next steps:"
echo "  1. Open Claude Code in this directory"
echo "  2. Paste the contents of CUSTOMIZE.md"
echo "  3. Claude will customize everything for your project"
echo ""
echo "Or customize manually — see GUIDE.md in the claude-devos repo."