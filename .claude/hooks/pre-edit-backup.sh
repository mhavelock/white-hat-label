#!/bin/bash
# pre-edit-backup.sh — PreToolUse backup hook (Cowork project level)
#
# PURPOSE: Before any modification to a sensitive file, copies the current version to
#          Cowork/.backups/ so the pre-edit state is always recoverable.
# LOADED FROM: Cowork/.claude/settings.json (PreToolUse, Edit|Write)
#
# SENSITIVE files backed up:
#   /.claude/* directories
#   CLAUDE.md
#   settings.json
#   settings.local.json
#
# BACKUP FORMAT: .backups/YYYYMMDD-HHMMSS-[filename].bak
# EXIT CODES: 0 = always allow (this hook never blocks — backup-only)

INPUT=$(cat)
TOOL=$(echo "$INPUT" | jq -r '.tool_name // empty')

[[ "$TOOL" != "Edit" && "$TOOL" != "Write" ]] && exit 0

FILE_PATH=$(echo "$INPUT" | jq -r '.tool_input.file_path // empty')
[ -z "$FILE_PATH" ] && exit 0

is_sensitive() {
  local p="$1"
  [[ "$p" == *"/.claude"* ]] && return 0
  [[ "$(basename "$p")" == "CLAUDE.md" ]] && return 0
  [[ "$(basename "$p")" == "settings.json" ]] && return 0
  [[ "$(basename "$p")" == "settings.local.json" ]] && return 0
  return 1
}

is_sensitive "$FILE_PATH" || exit 0

# File must exist to back up (Write to new file = nothing to back up)
[ -f "$FILE_PATH" ] || exit 0

BACKUP_DIR="/Users/mat/Claudette/Cowork/.backups"
mkdir -p "$BACKUP_DIR"

TIMESTAMP=$(date '+%Y%m%d-%H%M%S')
BASENAME=$(basename "$FILE_PATH")
BACKUP_FILE="$BACKUP_DIR/${TIMESTAMP}-${BASENAME}.bak"

cp "$FILE_PATH" "$BACKUP_FILE" && echo "[backup] $BASENAME → .backups/${TIMESTAMP}-${BASENAME}.bak" >&2

exit 0
