#!/bin/bash
# protect-files.sh — PreToolUse Edit/Write hook (Cowork project level)
#
# PURPOSE: Block direct writes to files that Claude must never modify.
# LOADED FROM: Cowork/.claude/settings.json (Edit/Write operations only)
#
# PROTECTIONS:
#   .env              — secrets file; Claude must never write API keys or credentials
#   package-lock.json — npm lock file; manual edits corrupt reproducible installs (use npm install)
#   .git/             — git internals; direct edits corrupt repository history
#
# LIMITATION: Only catches paths passed as tool_input.file_path. Does not intercept Bash-based writes (echo > .env etc).
# EXIT CODES: 2 = block, 0 = allow

INPUT=$(cat)
FILE_PATH=$(echo "$INPUT" | jq -r '.tool_input.file_path // empty')

PROTECTED_PATTERNS=(".env" "package-lock.json" ".git/")

for pattern in "${PROTECTED_PATTERNS[@]}"; do
  if [[ "$FILE_PATH" == *"$pattern"* ]]; then
    echo "Blocked: $FILE_PATH matches protected pattern '$pattern'" >&2
    exit 2
  fi
done

exit 0