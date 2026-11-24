---
id: 08ee6df70b5d
kind: bug
title: Pass the adapter cache location to the ycode knowledge-base command
seq: 690
status: todo
priority: p1
labels:
    - ycode
created: 2026-11-24T10:52:07.697277Z
---

Run 220 at ycode 8ad8cd19: TestHarnessStreamWaitsForAppendNotifications fails 5/5 with the gate runner at 9db42aa8 and passes 3/3 with the older Step 0 runner. The kb command now uses a Go adapter. The command environment in examples/agent.yaml omits its cache location and the Go build cache. The adapter cannot find its binary or compile it in that environment, returns empty knowledge through the fallback, and adds 1.19–1.26 seconds before provider start. Required repair: pass only the necessary cache location variables, retain the one-second test deadline, prove real kb context reaches the command caller, and pass all 83 ycode short-test packages on the gate. Supervisor approval recorded on Sprint 684 at 10:51. Keep the fix in ycode.
