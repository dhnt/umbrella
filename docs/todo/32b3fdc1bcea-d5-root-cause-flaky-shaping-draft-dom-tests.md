---
id: 32b3fdc1bcea
kind: test
title: 'D5 root-cause: flaky shaping draft DOM tests'
seq: 619
status: todo
priority: p2
labels:
    - shaping
created: 2026-11-21T21:59:33.583949Z
---

Problem: two draft edit-session DOM tests are flaky or failing (yoke/pkg/webconsole genie_draft*_dom_test.go, verifydom tag). Identify them by name, check the venue, bisect, record product/test/environment cause before any fix, skip or quarantine.

## Unlinked to the backlog (2026-11-24, operator: close Sprint 703)

A known failing test is tracked, never closed as won't do (root-cause rule). It is not on the MVP path; fix it when it blocks a release gate, with the root cause recorded here.
