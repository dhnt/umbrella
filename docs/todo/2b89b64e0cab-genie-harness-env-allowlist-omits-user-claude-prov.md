---
id: 2b89b64e0cab
kind: bug
title: 'genie harness env allowlist omits USER: claude providers report Not logged in on macOS'
seq: 193
status: todo
priority: p1
labels:
    - vendor-services
created: 2026-11-13T02:18:41.385076Z
---

S626 S7 F7 (docs/sprint-626-acceptance.md). ycode/examples/genie/agent.yaml and agent-yolo.yaml line 431 environment names lack USER/LOGNAME; claude on macOS reads its Keychain credential by user. A/B: env -i HOME PATH claude -p -> 'Not logged in'; adding USER -> answers. A variant with USER, LOGNAME passed 9/9 service calls on the shell door for genie and ycode. Fix: add USER and LOGNAME to both profiles.
