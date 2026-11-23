---
id: 944ee28287ee
kind: feature
title: 'LAN install MVP-3: bashy mcp serve LAN bind with a bearer token so agents get the live skill from the organizer host'
seq: 636
status: assigned
priority: p2
labels:
    - install
    - lan
    - mcp
    - post-rc40
created: 2026-11-22T20:35:35.810517Z
assignee: claude-fable5.1
sprint: 694
---

yoke/mcp/transport.go loopbackListenAddress: accept a non-loopback --listen only when --token FILE|- is given (constant-time bearer check in authenticate); without a token the existing post-1.0 refusal stands. bashy mcp serve plumbs --token; release-mirror mcp starts it and prints the claude mcp add --transport http ... --header line. Tools run on the organizer host: agents read skill show bashy / self fetch --print-url there, then run the web one-liner locally. Needs yoke push + bashy repin; coordinate with the 692 manager, not on the frozen rc.40 candidate.
