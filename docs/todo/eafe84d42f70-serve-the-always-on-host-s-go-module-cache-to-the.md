---
id: eafe84d42f70
kind: feature
title: Serve the always-on host's Go module cache to the LAN as a GOPROXY, so dev and test hosts never re-download modules
seq: 390
status: todo
priority: p2
created: 2026-11-17T12:01:00.128252Z
---

Operator 2026-11-17: internet downloads cost real money (about $10 per 50 GB) and got the dev box rate-limited by the ISP. The always-on Windows test host has 2 TB and keeps a permanent Go module cache in its WSL distro. Serve that cache to the LAN as a module proxy (GOPROXY=http://<host>:<port>,direct with a fallthrough to the internet only on a miss, filling the cache) and point the dev box, the second Windows host and gate containers at it. Prefer a bashy verb or skill-script over a third-party proxy (bashy is all you need); the protocol is simple static files (list, .info, .mod, .zip). Acceptance: a cold build on another host fetches no module from the internet when the cache already holds it.
