---
id: abada3962644
kind: feature
title: 'Hosted voice transcription for the desktop wish box (any browser): record in the page, transcribe on the master'
seq: 531
status: todo
priority: p2
labels:
    - desktop
    - voice
created: 2026-11-19T13:10:38.549025Z
---

Follow-up split out of Sprint 641 J1 (badd3f9c73de), which closes as the tiered design that shipped: tier 1 on-device recognition where the browser has a local model (desktop Chrome), tier 0 OS dictation hint elsewhere (Safari, Firefox, phones), no vendor cloud. Gap: most browsers show no mic. Proposal (operator's earlier option 1): MediaRecorder in the page -> POST /api/v1/desktop/transcribe -> transcribe on the master (AWS Bedrock mistral.voxtral-* is available on the same desktop-wish route key and budget, or a Whisper model in the pool), text placed in the box, NOT submitted; a per-person daily cap like the wish allowance; explicit note that audio goes to the master. Needs operator sign-off on the 'never a vendor cloud' principle for this tier and a planned sprint (not Sprint 641).
