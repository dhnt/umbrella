---
id: badd3f9c73de
kind: feature
title: 'J1 Voice in the desktop''s own wish box: vendor the one voice module into the hosted SPA'
seq: 318
status: assigned
priority: p1
labels:
    - software-shaping
    - voice
created: 2026-11-15T03:01:52.018985Z
assignee: claude-opus5.5-s641
sprint: 641
sprint_id: d8aa925c-ba20-5705-ba28-33bc35700909
sprint_title: 'MVP: the dhnt journey — iteration 1, dhnt.io is the free desktop you shape by asking'
---

Phase A is voice input AND cosmetics, so the desktop must be speakable — and the gap is concrete: Sprint 624 V2 put the mic in yoke's INJECTED component (pkg/webconsole/artifact/genie.js), while the desktop's wish box is cloudbox's own bundle. Without this story a person can speak to a shaped app on their own console but not to the free desktop, which is the one surface phase A is about.

What makes it cheap: V2 was built as one dependency-free module exposed as window.bashyVoice.attach(textarea, {say, cls, hintCls}) plus markButton(), precisely so a second host could reuse it. It auto-detects (secure context + SpeechRecognition.available with processLocally and quality dictation), shows the mic only where the device can recognize speech locally, puts the OS-dictation hint there otherwise, and never calls a vendor cloud.

Scope: extract the module from genie.js into a vendorable file with no console dependencies; vendor it into the hosted desktop beside its wish box; the mic badge on the desktop's shaping affordance; Alt+Shift+V; the spoken text lands in the same box and is NOT submitted. One implementation, two hosts — a divergent copy is the failure mode to avoid, so the extraction keeps a single source and a test in each host.

Acceptance: on desktop Chrome/Edge/Firefox the desktop's wish box shows the mic and a spoken sentence fills it; on Safari and on phones the mic is absent and the OS-dictation hint appears (and OS dictation does fill the box); the module is one file with one copy of the logic; yoke's existing TestDOMGenieVoice still passes; the hosted side has an equivalent check.
