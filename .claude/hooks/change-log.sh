#!/bin/bash
# change-log.sh — PostToolUse hook for Edit/Write operations
#
# PURPOSE: Creates a timestamped change log in Cowork/logs/ after every file modification.
# LOADED FROM: Cowork/.claude/settings.json (PostToolUse, Edit|Write)
#
# FORMAT: Cowork/logs/YYYYMMDD-HHMMSS-[tool]-[filename].log
#   Edit: records old_string → new_string (full diff)
#   Write: records file path + first 50 lines of content
#
# NOTE: Log files are append-only — deny rules in Cowork settings.json block
#       Edit and Bash-based modifications to Cowork/logs/. Only Write (new files) allowed.

INPUT=$(cat)
TOOL=$(echo "$INPUT" | jq -r '.tool_name // empty')

[[ "$TOOL" != "Edit" && "$TOOL" != "Write" ]] && exit 0

LOG_DIR="/Users/mat/Claudette/Cowork/logs"
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
