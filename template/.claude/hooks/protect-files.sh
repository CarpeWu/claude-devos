#!/bin/bash
# PreToolUse hook: Block modifications to protected files
# Exit 0 = allow, Exit 1 = hook error (non-blocking), Exit 2 = block with message

set -euo pipefail

# Verify jq is available
if ! command -v jq &>/dev/null; then
    echo "Hook requires jq but it is not installed." >&2
    echo "Install with: brew install jq (macOS) or apt install jq (Linux)" >&2
    exit 1
fi

INPUT=$(cat)
TOOL_NAME=$(echo "$INPUT" | jq -r '.tool_name')

# Protected file patterns
PROTECTED_PATTERNS=(
    "package-lock.json"
    "yarn.lock"
    "pnpm-lock.yaml"
    ".env"
    ".env.local"
    ".env.production"
    "*.generated.*"
    "*.gen.*"
    ".github/workflows/*"
    "ci.yml"
    "ci.yaml"
)

check_protected() {
    local file_path="$1"
    for pattern in "${PROTECTED_PATTERNS[@]}"; do
        case "$file_path" in
            *${pattern})
                echo "BLOCKED: Cannot modify protected file: $file_path" >&2
                echo "Protected pattern matched: $pattern" >&2
                echo "If this change is necessary, modify the file manually." >&2
                exit 2
                ;;
        esac
    done
}

# Handle Write and Edit tools — check file_path directly
if [[ "$TOOL_NAME" == "Write" || "$TOOL_NAME" == "Edit" || "$TOOL_NAME" == "MultiEdit" ]]; then
    FILE_PATH=$(echo "$INPUT" | jq -r '.tool_input.file_path // empty')
    if [[ -n "$FILE_PATH" ]]; then
        check_protected "$FILE_PATH"
    fi
fi

# Handle Bash tool — check if command references protected files
if [[ "$TOOL_NAME" == "Bash" ]]; then
    COMMAND=$(echo "$INPUT" | jq -r '.tool_input.command // empty')
    if [[ -n "$COMMAND" ]]; then
        for pattern in "${PROTECTED_PATTERNS[@]}"; do
            # Skip glob patterns (containing *) for Bash command checking —
            # shell globs cannot be reliably matched in regex context.
            # Only check literal filenames.
            case "$pattern" in
                *\**) continue ;;
            esac
            if echo "$COMMAND" | grep -qE "(>|>>|tee|cp|mv|sed\s+-i|chmod|chown).*${pattern}"; then
                echo "BLOCKED: Bash command appears to modify protected file: $pattern" >&2
                echo "Command: $COMMAND" >&2
                echo "If this change is necessary, run the command manually." >&2
                exit 2
            fi
        done
    fi
fi

exit 0
