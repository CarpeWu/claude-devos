#!/usr/bin/env bash
set -euo pipefail

# PreToolUse hook: protect-files.sh
# Blocks edits to files that should not be modified by Claude.

INPUT=$(cat)
FILE_PATH=$(echo "$INPUT" | jq -r '.tool_input.file_path // .tool_input.path // empty')

if [ -z "$FILE_PATH" ]; then
    exit 0
fi

PROTECTED_PATTERNS=(
    "Cargo.lock"
    ".env"
    ".env.*"
    "migrations/*.sql"
    ".sqlx/*"
    "target/*"
    "Dockerfile"
    "docker-compose.yml"
    "rust-toolchain.toml"
)

for pattern in "${PROTECTED_PATTERNS[@]}"; do
    case "$FILE_PATH" in
        $pattern)
            jq -n --arg file "$FILE_PATH" --arg pattern "$pattern" '{
                decision: "block",
                reason: ("\($file) is a protected file (matched: \($pattern)). Do not modify it directly. If changes are needed, explain what should change and let the developer handle it.")
            }'
            exit 0
            ;;
    esac
done

exit 0
