#!/bin/bash
# PostToolUse hook: Throttled reminder to run tests after code edits
#
# Uses PostToolUse JSON decision control to communicate with Claude.
# decision: "block" on PostToolUse does NOT undo the tool call (it already ran).
# It prompts Claude with the reason text — the correct mechanism for advisory feedback.
#
# Plain text stdout on PostToolUse exit 0 is only shown in verbose mode.
# This hook uses structured JSON output so the reminder reaches Claude in all modes.

set -euo pipefail

# Verify jq is available
if ! command -v jq &>/dev/null; then
    echo "Hook requires jq but it is not installed." >&2
    echo "Install with: brew install jq (macOS) or apt install jq (Linux)" >&2
    exit 1
fi

INPUT=$(cat)
TOOL_NAME=$(echo "$INPUT" | jq -r '.tool_name')

# Only trigger for Write/Edit/MultiEdit tools
if [[ "$TOOL_NAME" != "Write" && "$TOOL_NAME" != "Edit" && "$TOOL_NAME" != "MultiEdit" ]]; then
    exit 0
fi

# Only trigger for code files, not docs or configs
FILE_PATH=$(echo "$INPUT" | jq -r '.tool_input.file_path // empty')
case "$FILE_PATH" in
    *.md|*.json|*.yaml|*.yml|*.toml|*.txt|*.lock|*.csv|*.svg|*.png|*.jpg)
        exit 0
        ;;
esac

# Compute a project-specific hash for the state file
if command -v md5sum &>/dev/null; then
    PROJECT_HASH=$(echo "$PWD" | md5sum | cut -c1-8)
elif command -v shasum &>/dev/null; then
    PROJECT_HASH=$(echo "$PWD" | shasum | cut -c1-8)
else
    PROJECT_HASH="default"
fi

# Use ~/.claude/hook-state/ for runtime state (writable outside sandbox)
STATE_DIR="${HOME}/.claude/hook-state"
mkdir -p "$STATE_DIR" 2>/dev/null || {
    # If state directory cannot be created, skip throttling silently
    exit 0
}
TIMESTAMP_FILE="${STATE_DIR}/edit-remind-${PROJECT_HASH}"

LAST_REMIND=$(cat "$TIMESTAMP_FILE" 2>/dev/null || echo "0")
NOW=$(date +%s)
ELAPSED=$((NOW - LAST_REMIND))

if [ "$ELAPSED" -gt 120 ]; then
    echo "$NOW" > "$TIMESTAMP_FILE"
    # Use PostToolUse decision control to prompt Claude with the reminder.
    # decision: "block" on PostToolUse prompts Claude with the reason text
    # without undoing the tool call (it already ran).
    cat << 'EOF'
{
  "decision": "block",
  "reason": "Reminder: Code files have been edited. Consider running the project test and lint commands to verify nothing is broken before continuing."
}
EOF
fi

exit 0
