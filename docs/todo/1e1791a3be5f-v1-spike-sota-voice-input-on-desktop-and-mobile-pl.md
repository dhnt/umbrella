---
id: 1e1791a3be5f
kind: spike
title: 'V1 Spike: SOTA voice input on desktop and mobile; plan integration with software shaping'
seq: 172
status: todo
priority: p2
labels:
    - software-shaping
    - voice
created: 2026-11-12T20:44:18.301989Z
sprint: 624
sprint_id: 89e4b41e-66b1-5c54-b427-8a2877a0eb56
sprint_title: 'Voice input for software shaping: SOTA survey + integration plan'
---

Research the state of the art in voice input on macOS, Windows, Linux, iPhone and Android, and plan how speech becomes a software shaping request ("say what you want changed"). Research and plan only; no product code. Build on the existing replaceable transcription adapters (bashy `internal/transcribecontract`, `internal/transcribeseed` whisper adapter admitted via binmgr, `examples/transcribe/pipeline.bsh`, `docs/transcribe-contract.md`, `docs/transcribe-seed-adapters.md`) rather than starting over. Relates Sprint 620 (comms web UI / PWA, C1) and Sprint 519 (Klatch phone apps). Planned worker: claude-opus5.5.

### Survey (per platform: accuracy, latency, streaming, offline/on-device, languages, license, cost, privacy)
- **macOS:** Apple Speech framework / SpeechAnalyzer (on-device), system Dictation.
- **Windows:** Windows speech recognition / Voice Access, voice typing (Win+H), on-device options.
- **Linux:** no native stack; whisper.cpp, faster-whisper, Vosk.
- **iPhone:** on-device Speech framework, keyboard dictation, PWA mic access in Safari.
- **Android:** SpeechRecognizer (on-device), Gboard voice typing, on-device model options.
- **Cross-platform open models:** Whisper large-v3 / turbo, Distil-Whisper, NVIDIA Parakeet / Canary, Moonshine and similar small streaming models; Ollama/sphere hosting fit.
- **Browser:** Web Speech API and MediaRecorder → local transcribe, for the PWA/web UI path.
- **Hosted APIs:** optional providers only, never a default dependency.

### Integration plan (rod, not fish)
- One provider-agnostic capture → text mechanism on the existing transcribe contract; providers are shapeable adapters, not a vendor catalog in core.
- Small `--json` verbs (e.g. a live/push-to-talk capture verb emitting JSONL text) composed by a Bash# skill-script into `bashy shape` as a shaping request; examples/ first, core only if necessary.
- Mobile route: PWA mic or Klatch phone apps → outpost/satellite, same pairing and circle grants.
- Interaction: push-to-talk vs wake word, read-back/confirmation, destructive shapes gated by /approve.
- Local-first privacy default; explicit boundary for remote transcription; licensing checklist for models and binaries.
- Cross-OS parity: the documented workflow matches on Windows/macOS/Linux; unavailable capability fails, never silently degrades. UI→CLI parity one-way.

### Deliverable
- `docs/voice-input-shaping.md` (abstract in `docs/README.md`, line in `docs/INDEX.md`): comparison table, recommended default per OS/device, go/defer verdict, security/privacy boundary, and follow-up implementation stories filed on Sprint 624.
