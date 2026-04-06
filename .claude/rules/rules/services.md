---
paths:
  - "services/**/*.ts"
---

# Services — LLM, Audio, Security

## LLM Integration

- **Models:** `claude-haiku-4-5-20251001` (Anthropic) or `gemini-2.0-flash` (Google) — user's choice via `PROVIDER_CONFIG` in `constants.ts`
- **HTTP:** `XMLHttpRequest` in `llmClient.ts` — NOT `fetch`. Avoids React Native blob resolution errors. Never switch to fetch.
- **System prompts:** Built dynamically at call time via `buildSystemPrompt(level, enabledPacks)` in `pedantEngine.ts`
- **Pedantry levels:** 1–5 (1 = major factual errors only; 5 = everything including myths/filler words)
- **Input safety:** Transcript sanitised (control chars stripped, capped at 600 chars) + rate limited (25 calls/min rolling window)
- **Output safety:** Interruption phrases validated against static whitelist before TTS — LLM cannot inject arbitrary speech
- **XHR abort:** Bridged via `signal.addEventListener('abort', () => { xhr.abort(); reject(abortError) })`. AbortError is a plain `Error` with `.name = 'AbortError'` — NOT `new DOMException(...)`, which throws ReferenceError in Hermes.
- **Google API key:** Sent as `x-goog-api-key` header (NOT URL query param)

## Pedantry Categories (typed union in `types.ts`)

`'grammar' | 'usage' | 'factual' | 'logic' | 'jargon' | 'general'`

## Interruption Phrases (TTS — validated whitelist in `ttsOutput.ts`)

"Excuse me." | "I beg your pardon." | "I don't think so." | "Actually..." |
"Well, technically..." | "One moment." | "That's not quite right." | "Oh, I think not." |
"Good heavens, no." | "Oh dear." | "I must stop you there." | "Wrong." | "Incorrect." | "Absolutely not."

LLM cannot add to or override this list. Phrases are selected randomly before the LLM call.

## Security Rules

- API key stored in `expo-secure-store` only — never in Zustand, never in source or git
- Both pipeline hooks call `SecureStore.getItemAsync` at call time — store holds `hasApiKey: boolean` only
- `setApiCredentials` writes to SecureStore + sets `hasApiKey: true`
- Transcript sanitised before LLM call: control chars stripped, length capped at `MAX_TRANSCRIPT_CHARS`
- Rate limiting: `MAX_API_CALLS_PER_MINUTE` rolling 60s window in `useListeningPipeline.ts`
- `isFetching` guard in roasting pipeline prevents concurrent API calls
- SecureStore errors logged at warn level — never silently swallowed
- `clearAllData()` wipes all SecureStore keys + resets all Zustand state to defaults

## Response Packs

- 5 toggleable packs in `responsePacks.ts`, gated by `isPro` via `iapService`
- IAP product: `com.thatguy.app.pro` — non-consumable $0.99 via `react-native-iap` v14
- Packs passed to `buildSystemPrompt` to adjust LLM behaviour
