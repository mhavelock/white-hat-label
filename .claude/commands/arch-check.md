Before making any code changes, perform an architecture check:

1. Read `docs/architecture/ARCHITECTURE.md` — focus on §"What We Never Do" and the section most relevant to the planned change.
2. Read `docs/architecture/SYSTEM.md` — focus on naming conventions, component patterns, and the section most relevant to the planned change.
3. Identify which architectural rules apply to this change.
4. Confirm the change does NOT:
   - Modify `ios/` directly
   - Use `fetch` for LLM calls (must use XHR)
   - Store API key in Zustand
   - Use `new DOMException` (use plain Error with `.name = 'AbortError'`)
   - Use inline styles (must use StyleSheet)
   - Put metering values in Zustand (module-level Animated.Value)
   - Call `console.*` outside `__DEV__`
5. If the change affects the audio pipeline, verify all 3 AVAudioSession stop paths are still present.
6. Report: "Architecture check complete — no violations" OR list any conflicts found.
