---
id: d14c4bb6ee34
kind: feature
title: 'M7 film.bsh: storyboard lock, oss draft and --final commercial re-render, agy QA review'
seq: 187
status: assigned
priority: p1
labels:
    - vendor-services
    - media
created: 2026-11-12T23:18:29.106968Z
assignee: claude-opus5.5
sprint: 627
sprint_id: 21c05c41-833f-598c-ab0b-3aab12cfbd8f
sprint_title: 'Music-video showcase: film pipeline with oss draft -> commercial final (song, image, animate, narrate, subtitles)'
---

Spec: docs/sprint-627-master-execution-plan.md (pipeline, economic flow). Depends M2, M4 or M5, M6, Sprint 626 S6. Final re-renders only generative stages from the locked storyboard.

SPEND/VENUE RULE (conductor per operator mb:13538/mb:13557, 2026-11-13): build film.bsh (storyboard lock, draft on oss, --final on a commercial route, agy QA via 'bashy video --json') and test it on the dev host with fixture rods only (register stub rods for song/image/animate/narrate/transcribe that emit fixture artifacts; see examples/oss-rods tests and examples/service-door browser_rod_test.go). NO model downloads or live model/ollama/podman runs here; NO paid or browser generation; never pass --yes yourself. Real oss drafts run on a claimed test host (story M2b); the commercial --final is an operator-approved remaining check. Assembly uses media cards/subs/cut (M6). Contract: bashy docs/service-rod-contract.md.
