---
paths:
  - "components/**/*.tsx"
---

# Components — UI Design & Patterns

## Single Screen Layout

```
┌─────────────────────────────────┐
│                                 │
│       [LISTEN BUTTON IMAGE]     │  ← thataiguy-button.png, pulsing
│       "Tap to Activate"         │
│       "CAN I HELP?"             │
│                                 │
│       DORMANT / MONITORING      │  ← status (colour-coded)
│                                 │
│   CORRECTIONS ─────────────     │
│   ◀ card  card  card ▶          │  ← horizontal FlatList
│                                 │
│ ──────────── NAV ────────────── │
│  [HOME icon]    [⚙ SETTINGS]   │
└─────────────────────────────────┘
```

## App States

| State | Visual |
|-------|--------|
| Idle | Dark screen, LISTEN button with slow pulse, status `#333` DORMANT |
| Activating | 3-ring multicolour spinner while intro TTS plays |
| Listening | Button pulse + 5 audio-reactive rings, speech bubbles floating, status `#888` MONITORING |
| Triggered | Glass CorrectionCard springs up from history deck with typewriter text + red glow |
| History | Swipeable cards at bottom, FlatList |
| Roasting | Dark orange theme, flame background, RoastingScreen |

## Glass / Liquid Glass UI Pattern

- Background: `#060810` (deep blue-black)
- BlurView pattern: `<BlurView intensity={N} tint="dark" style={StyleSheet.absoluteFill} />` + `<View style={absoluteFill, backgroundColor: 'rgba(...)' }/>` tint overlay as first children
- Components with BlurView need `overflow: 'hidden'` if they have `borderRadius` (for clip)
- Surfaces using BlurView: BottomNav pill, SettingsModal sheet, CorrectionCard, RoastVictimSheet

## Settings Panel

- In-tree animated bottom sheet — NOT `Modal`. BottomNav stays visible below it.
- Apple glass style: `rgba(14,14,20,0.97)` + `rgba(255,255,255,0.12)` top border
- Slide-up spring animation / ease slide-down on close
- Close ✕ button top-right; Home tab press auto-closes
- Contains: Pedantry level (1–5), Voice picker, API key input, Clear History, Response Packs

## ListenButton Rings

5 rings, spring-to-scale per ring driven by audioLevel (0–1 from metering dB):
- Base scales: 1.10/1.25/1.45/1.70/2.05 → Loud: 1.75/2.15/2.65/3.20/3.90
- Outer 2 rings have slow rotation drift (±8° and ±14°) for organic flowing feel
- Ambient glow orb behind button breathes with audio (opacity + scale animated)

## WaveGridBackground

3D perspective wave grid mesh, `#045ada`, audio-reactive via `audioLevel`.
- Visible during `isListening + isInterrupting`, hidden during `isRoasting`
- Uses `react-native-svg` Polyline + Path + RadialGradient

## CorrectionCard

- Springs up from history deck (`bottom: 195`), glass style with BlurView
- Typewriter effect, red glow
- `interruptionPhrase` field in Zustand store shown above correction text

## FloatingBubbles

5 staggered glass pill bubbles rise during `isListening && !isInterrupting`. Pop animation at end of rise.

## Styling Rules

- StyleSheet only — no Tailwind (React Native constraint)
- No inline styles unless driven by dynamic values (e.g. `audioLevel`)
- All animations via `Animated.Value` — not `useNativeDriver` for layout props, `useNativeDriver: true` for opacity/transform
