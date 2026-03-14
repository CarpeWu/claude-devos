#!/usr/bin/env bash
set -euo pipefail

# Stop hook: verify-completion.sh
# Checks whether Claude performed verification steps (tests, lint)
# before finishing. If not, blocks the stop and outputs a verification
# checklist.
#
# Uses two mechanisms:
# 1. stop_hook_active — documented field in Claude Code's Stop hook
#    input. True when Claude is already continuing due to a stop hook.
#    Used as a hard exit to prevent infinite loops.
# 2. transcript_path — path to the session transcript JSONL file.
#    Read to check for evidence that verification was performed.

# ── Parse input ──────────────────────────────────────────────────────────────

INPUT=$(cat)

# ── Loop guard: stop_hook_active ─────────────────────────────────────────────
# If Claude is already continuing because this hook previously blocked,
# allow the stop unconditionally. This prevents infinite loops.

STOP_HOOK_ACTIVE=$(echo "$INPUT" | jq -r '.stop_hook_active // false')
if [ "$STOP_HOOK_ACTIVE" = "true" ]; then
    exit 0
fi

# ── Read the transcript ──────────────────────────────────────────────────────
# transcript_path is a documented common field pointing to a JSONL file.

TRANSCRIPT_PATH=$(echo "$INPUT" | jq -r '.transcript_path // empty')

if [ -z "$TRANSCRIPT_PATH" ] || [ ! -f "$TRANSCRIPT_PATH" ]; then
    # If we can't locate the transcript file, fall through to the
    # stop_hook_active guard on the next pass rather than silently
    # allowing an unverified stop. Blocking here means Claude will
    # perform the checklist, On the second stop attempt
    # stop_hook_active will be true, guaranteeing exit.
    jq -n '{
        decision: "block",
        reason: "Could not read session transcript to verify completion. Please run tests and lint before finishing."
    }'
    exit 0
fi

# ── Check for verification evidence ─────────────────────────────────────────
# Scan the transcript file for signs that tests and lint were run.

TRANSCRIPT=$(cat "$TRANSCRIPT_PATH")
EVIDENCE_COUNT=0

# Look for signs that tests were run
if echo "$TRANSCRIPT" | grep -qiE '(npm test|pytest|go test|cargo test|make test|yarn test|pnpm test|bun test|test.*pass|tests.*pass|all.*tests|test suite|✓.*test|PASS)'; then
    EVIDENCE_COUNT=$((EVIDENCE_COUNT + 1))
fi

# Look for signs that lint was run
if echo "$TRANSCRIPT" | grep -qiE '(npm run lint|eslint|ruff|golangci-lint|clippy|make lint|yarn lint|pnpm lint|lint.*pass|lint.*clean|no.*lint.*error)'; then
    EVIDENCE_COUNT=$((EVIDENCE_COUNT + 1))
fi

# Look for signs that the result was confirmed against the request
if echo "$TRANSCRIPT" | grep -qiE '(verified|confirmed|matches.*request|satisfies|implemented.*correctly|changes.*look.*correct|review.*complete)'; then
    EVIDENCE_COUNT=$((EVIDENCE_COUNT + 1))
fi

# ── Decide ───────────────────────────────────────────────────────────────────

if [ "$EVIDENCE_COUNT" -ge 2 ]; then
    # Sufficient evidence of verification — allow stop
    exit 0
fi

# Insufficient evidence — block and request verification
jq -n '{
    decision: "block",
    reason: "Before finishing, please complete this verification checklist:\n\n1. Run the project'\''s test command and confirm all tests pass\n2. Run the project'\''s lint command and confirm no errors\n3. Review your changes against the original request\n4. Confirm the implementation is complete\n\nOnce you'\''ve completed these steps, you can finish."
}'
exit 0
