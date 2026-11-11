---
id: 2871d6c52994
kind: feature
title: 'contain --net public: SSRF-safe egress mode'
seq: 143
status: todo
priority: p2
labels:
    - security
created: 2026-11-11T22:01:36.161295Z
---

Gap 2 of docs/strands-shell-gap-analysis.md. Reuse the egress proxy (bashy/internal/agentos/contain_egress.go). Acceptance: dial-time refusal of loopback, RFC1918, link-local, CGNAT, cloud metadata and IPv4-mapped/6to4/Teredo/NAT64 encodings; every redirect hop re-checked; --allow-url PREFIX escape; fails closed with exit 125 where it cannot be enforced; tests per address class on all three OSes.
