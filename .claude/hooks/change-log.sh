#!/bin/bash
# change-log.sh — PostToolUse hook for Edit/Write operations
#
# PURPOSE: Creates a timestamped change log after every file modification.
# LOADED FROM: .claude/settings.json (PostToolUse, Edit|Write)
#
# LOG LOCATION: $COWORK_LOG_DIR if set (cross-project aggregation),
#               otherwise <project-root>/.claude/logs/ (project-local default).
#
# FORMAT: <log-dir>/YYYYMMDD-HHMMSS-[tool]-[filename].log
#   Edit: records old_string → new_string (full diff)
#   Write: records file path + first 50 lines of content
#
# NOTE: Log files should be treated as append-only — recommended deny rules in
#       settings.json block Edit/Bash modifications to the log dir.

INPUT=$(cat)
TOOL=$(echo "$INPUT" | jq -r '.tool_name // empty')

[[ "$TOOL" != "Edit" && "$TOOL" != "Write" ]] && exit 0

LOG_DIR="${COWORK_LOG_DIR:-${CLAUDE_PROJECT_DIR:-$PWD}/.claude/logs}"
mkdir -p "$LOG_DIR"

FILE_PATH=$(echo "$INPUT" | jq -r '.tool_input.file_path // empty')
[ -z "$FILE_PATH" ] && exit 0

# Skip logging changes to the log dir itself (avoid recursion)
[[ "$FILE_PATH" == "$LOG_DIR"* ]] && exit 0

TIMESTAMP=$(date '+%Y%m%d-%H%M%S')
BASENAME=$(basename "$FILE_PATH")
TOOL_LOWER=$(echo "$TOOL" | tr '[:upper:]' '[:lower:]')
LOG_FILE="$LOG_DIR/${TIMESTAMP}-${TOOL_LOWER}-${BASENAME}.log"

{
  echo "=== ${TOOL}: ${FILE_PATH} ==="
  echo "=== $(date) ==="
  echo ""

  if [[ "$TOOL" == "Edit" ]]; then
    echo "--- REMOVED ---"
    echo "$INPUT" | jq -r '.tool_input.old_string // ""'
    echo ""
    echo "+++ ADDED +++"
    echo "$INPUT" | jq -r '.tool_input.new_string // ""'
  elif [[ "$TOOL" == "Write" ]]; then
    echo "--- CONTENT (first 50 lines) ---"
    echo "$INPUT" | jq -r '.tool_input.content // ""' | head -50
    LINE_COUNT=$(echo "$INPUT" | jq -r '.tool_input.content // ""' | wc -l | tr -d ' ')
    [ "$LINE_COUNT" -gt 50 ] && echo "... [${LINE_COUNT} lines total, truncated at 50]"
  fi
} > "$LOG_FILE"

exit 0
