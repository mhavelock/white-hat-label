---
paths:
  - "hooks/**/*.ts"
---

# Hooks — Audio Pipeline & Session Management

## Audio Pipeline

```
Microphone → 3s chunks → expo-speech-transcriber (SFSpeechRecognizer / Analyzer fallback)
           → transcript buffer → LLM (Anthropic / Google) → TTS output
```

- Record `.caf` (MPEG4AAC, 16kHz, metering enabled, 200ms poll)
- Chunk timer uses `setTimeout` chain — NOT `setInterval`. Guarantees each chunk is exactly `CHUNK_DURATION_MS`.
- **CRITICAL:** Transcribe BEFORE calling `prepareToRecordAsync()` — expo-audio reuses the same file path
- `setAudioModeAsync({ allowsRecording: true })` required before `recorder.record()`
- `SpeechTranscriber.requestPermissions()` must be called before transcribing
- Falls back from `SFSpeechRecognizer` to `SpeechAnalyzer` on iOS 26+
- Mic pauses during TTS playback to avoid feedback loop; resumes cleanly after
- AppState listener stops the pipeline when app is backgrounded

## AVAudioSession — Critical Release Pattern

AVAudioSession MUST be released on every stop path:
```ts
setAudioModeAsync({ allowsRecording: false, playsInSilentMode: false })
```
Called in three places in `useListeningPipeline.ts`:
1. Toggle-off
2. Background handler
3. Unmount cleanup

Without this: Bluetooth headphones stay in SCO mono (hands-free) and other apps remain ducked after listening ends.

**Resume after TTS:** Both resume paths (correction resume + roast fallback resume) must call:
```ts
await setAudioModeAsync({ allowsRecording: true, playsInSilentMode: true })
```
BEFORE `recorder.prepareToRecordAsync()`. Without this, iOS AVAudioSession isn't reliably back in recording mode after `speakWithFullVolume`, causing `RecordingDisabledException`.

## UIBackgroundModes — Intentionally Absent

`UIBackgroundModes: ["audio"]` is NOT set in `app.json`. The pipeline stops on background (AppState listener), so background audio capability is not needed. Declaring it would unnecessarily raise AVAudioSession priority and may flag during App Store review.

## Pipeline Guards (in order)

In `scheduleAnalysis()` setTimeout callback, checks fire in this order:
1. `if (isInterrupting) return;` — FIRST. Transmission-layer suppression.
2. `if (isProcessing) return;`
3. Buffer length / word count gate
4. Rate limit check
5. Dispatch to LLM

## Stale Result Guards

- **Segment IDs (P1):** `segmentIdRef` increments at each `analyseTranscript` dispatch. LLM echoes `segment_id`. Stale check: `result.segmentId < segmentIdRef.current` → discard.
- **Epoch IDs (G3):** `epochIdRef` increments on every TTS fire. Stale check: `epochIdRef.current > thisEpochId` → phase-shift stale → discard.
- Both counters reset on all stop paths.

## audioLevel

NOT in Zustand. Module-level `Animated.Value` in `services/audioLevel.ts`. Pipeline hooks write via `audioLevelAV.setValue(level)`. Components subscribe via `addListener` or `getAudioLevel()`. Eliminates ~10 React re-renders/sec.
