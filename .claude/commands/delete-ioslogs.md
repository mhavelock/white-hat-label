# /delete-ioslogs — Delete iOS build logs

Cleans up the Metro log file written during a build session.

## What to run

```bash
rm -f ~/projects/white-hat-label/logs/expo-logs.txt && echo "iOS build logs deleted."
```

## When to use

- At the end of any session where `/buildios+logs` was used
- If log file is growing large and cluttering output
- Claude should **always ask** at session end: "Shall I delete the iOS build logs?"
