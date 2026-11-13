---
id: 0ad30c9b094b
kind: feature
title: C1 Chrome browser Bash# command and skill (chrome.bsh) + bashy-defaults registration + unit tests
seq: 195
status: done
priority: p0
labels:
    - browser
    - windows
    - linux
created: 2026-11-13T01:43:12.714805Z
assignee: agy-gemini3.8-flash
sprint: 628
sprint_id: 7f109b8f-5ed6-5720-a3b6-af9c388650eb
sprint_title: 'Chrome browser Bash# command and skill: cross-platform detect, install, and open across macOS, Linux, and Windows'
closed: 2026-11-13T01:53:29.060208Z
closed_by: agy-gemini3.8-flash
---

Spec: docs/sprint-628-master-execution-plan.md. Implement bashy/examples/chrome/chrome.bsh with detect-first (if installed done), cross-platform install (macOS/Linux/Windows), path, doctor, and open; register chrome and chrome-open in bashy/examples/defaults/bashy-defaults.bsh; add hermetic unit tests in bashy/examples/chrome/chrome_test.go and update bashy_defaults_test.go.
