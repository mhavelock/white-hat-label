#!/bin/bash
# protect-commands.sh — PreToolUse Bash hook (Cowork project level)
#
# PURPOSE: Block shell commands that must never run autonomously.
# LOADED FROM: Cowork/.claude/settings.json AND ~/.claude/settings.json (runs twice in Cowork sessions — known redundancy)
#
# PROTECTIONS:
#   DROP TABLE   — prevents accidental SQL table destruction (case-insensitive match)
#   git push     — blocks any upstream push without explicit confirmation from Mat
#   wrangler ... --branch=main  — blocks Cloudflare production deploys without confirmation
#
# EXIT CODES: 2 = block, 0 = allow

INPUT=$(cat)
COMMAND=$(echo "$INPUT" | jq -r '.tool_input.command')

if echo "$COMMAND" | grep -qi "drop table"; then
  echo "Blocked: dropping tables is not allowed" >&2
  exit 2
fi

if echo "$COMMAND" | grep -qE "^git push"; then
  echo "Blocked: git push requires explicit confirmation from Mat" >&2
  exit 2
fi

if echo "$COMMAND" | grep -qE "npx wrangler pages deploy.*(--branch[= ]main)"; then
  echo "Blocked: production deploy (--branch=main) requires explicit confirmation from Mat" >&2
  exit 2
fi

exit 0  # exit 0 = let it proceed

# https://code.claude.com/docs/en/hooks-guide