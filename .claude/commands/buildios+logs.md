# /buildios+logs — Build iOS + pipe logs to file

Builds the app on the connected iPhone and pipes all Metro/JS console output to a log file that Claude Code can read directly without any copy-paste.

## What to tell Mat

> Run this in your terminal:
> ```
> npx expo run:ios --device 2>&1 | tee ~/projects/white-hat-label/logs/expo-logs.txt
> ```
> Then tap around / speak test phrases. When you want me to check the logs just say "check logs" and I'll read `~/projects/white-hat-label/logs/expo-logs.txt` directly.

## What Claude does

When Mat says "check logs" or similar, run:
```bash
tail -100 ~/projects/white-hat-label/logs/expo-logs.txt
```

Read the output and analyse — no paste needed.

## Notes

- Log file persists until deleted or Mac restarts
- Run `/delete-ioslogs` at session end to clean up (or ask Mat)
- **Always ask at session end:** "Shall I delete the iOS build logs?"
- Gemini (Cursor peer review, 2026-04-03) removed some `[DEBUG_LOG]` console statements during the review session because Cursor has native terminal integration and didn't need them. If logs seem sparse, check whether useful `console.log` lines were stripped in the Gemini review commits.
