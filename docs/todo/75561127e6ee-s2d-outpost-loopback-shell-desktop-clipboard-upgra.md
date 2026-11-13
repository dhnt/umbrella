---
id: 75561127e6ee
kind: task
title: 'S2d outpost: loopback /shell, /desktop, /clipboard, upgrade/repair/warm and X-Periscope-Role trust only via the tunnel ingress'
seq: 219
status: assigned
priority: p0
created: 2026-11-13T12:33:54.597383Z
assignee: claude-opus5.5-s631
sprint: 631
sprint_id: c3371fe2-016d-501e-8cf4-fb570a3cca03
sprint_title: 'Shapeable apps: fork-or-build first batch'
---

Follow-up of S2a 41637a46. internal/agent/routes.go sets TrustPeriscopeRole: true on the loopback listener ('matrix tunnel is the sole way in'). After S2a the tunnel arrives on the private unix ingress, so a local process connecting to the loopback TCP listener may be able to forge X-Periscope-Role/User for /shell and /ssh. Verify first (name the code path and a test that reproduces it); record root cause before any fix. Fix belongs in outpost: trust the headers only when ViaTunnelIngress(ctx).
