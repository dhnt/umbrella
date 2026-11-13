---
id: 91b6919adc85
kind: feature
title: 'M8-final: commercial final of the locked S627 film + real lip sync'
seq: 256
status: todo
priority: p2
labels:
    - media
created: 2026-11-13T20:33:55.323478Z
---

Moved from Sprint 627 M8 (efd9bc004b56) at sprint close 2026-11-13 (operator: close 627, supersedes further AWS model exploration). Contract: the locked r3 storyboard 'Lanterns on the Harbor' (film lock SHA-256 3b8ea8cb..., 15 shots, EN over Simplified-Chinese subtitles); evidence docs/sprint-627-m8-drafts-evidence.md. Remaining: (1) real visible lip sync - the AWS proof slice (TBDub Student on a g5.xlarge, ~USD 0.29) ran clean but showed no mouth motion (dubbing model, still-derived input); next candidates are true image+audio-to-video models (InfiniteTalk, Wan2.2-S2V) on a 48 GB GPU (g6e had no us-west-2 capacity), or the commercial route; (2) the commercial final ('film final --route browser|api') - operator approval and --yes required; sprint-627 AWS budget used ~USD 0.65 of 50. Follow-ups already in Sprint 634: local translate stage, subtitle font letter spacing.
