---
id: 0f7159d16115
kind: feature
title: Outpost reports native Windows suspend and resume observations
seq: 595
status: todo
priority: p2
created: 2026-11-21T10:43:33.792201Z
---

Follow-up to Sprint 652 story daa99f1f5a8e. Use PowerRegisterSuspendResumeNotification with callback registration and release the handle on shutdown. Report authenticated power events only when observed. Validate callback ordering and noninteractive service behavior with fixture tests and a claimed native Windows venue. [Microsoft power notification API](https://learn.microsoft.com/en-us/windows/desktop/api/powerbase/nf-powerbase-powerregistersuspendresumenotification)
