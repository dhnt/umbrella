---
id: 6e5b0e27b4cc
kind: feature
title: 'M4 browser rods: song, animate and image vendor web apps via bashy browser --mode live'
seq: 184
status: done
priority: p2
labels:
    - vendor-services
    - media
created: 2026-11-12T23:18:28.664525Z
weave: 23
assignee: agy-gemini3.8-flash
sprint: 627
sprint_id: 21c05c41-833f-598c-ab0b-3aab12cfbd8f
sprint_title: 'Music-video showcase: film pipeline with oss draft -> commercial final (song, image, animate, narrate, subtitles)'
closed: 2026-11-13T01:42:10.933867Z
closed_by: claude-opus5.5-s627
---

Spec: docs/sprint-627-master-execution-plan.md. Depends M1. Claim chrome-browser; operator's logged-in subscriptions; same envelope; no posting without --yes.

SPEND/VENUE RULE (operator mb:13557, 2026-11-13): this drives the operator's real logged-in Chrome. Take 'bashy claim chrome-browser' before ANY live-mode action and release it after. Build and test the rods with --dry-run and recorded page fixtures. Do NOT submit any generation on Suno/Kling/ChatGPT (spends subscription credits) and do not post anything; never pass --yes yourself. A live generation smoke is a remaining check for the operator to approve - record it in the submit. No model downloads or live model/ollama/podman runs on this dev host (mb:13538). Contract: bashy docs/service-rod-contract.md (M1).

REWORK 1 (conductor review of run umbrella#22, bashy f131d2a5, 2026-11-13): request-changes. The operator rule limits what YOU run while building and testing; it does not change the PRODUCT.
1. Live path with --yes must really generate: submit, wait for completion (bounded timeout), download the real artifact into BASHY_SVC_OUT, check it (ffprobe for audio/video, image decode for PNG), and report only that file. Without --yes keep refusing (exit 2): the operator's --yes is the consent gate.
2. Never write a placeholder artifact in the live path or report a file the vendor did not produce (song-suno.bsh:182, image-chatgpt.bsh:174, animate-kling.bsh). Placeholders belong only to the fixture path.
3. No '|| true' on live browser steps (song-suno.bsh:169 and siblings): a failed step exits non-zero with the step named (fail, not degrade).
4. Tests: add recorded fixtures for the completed/result page so the submit -> wait -> download -> verify path is exercised offline. You still must NOT submit any live generation, never pass --yes yourself, and claim chrome-browser before any live-mode action.
5. Rebase onto current bashy origin/main before submitting.
6. Start from your first attempt: bashy branch s627-m4-rework-base (f131d2a5), not from scratch.
