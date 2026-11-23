---
id: a1333108286e
kind: bug
title: outpost AppRegistry ReverseProxy drops tunnel X-Forwarded-For when ingress RemoteAddr is Unix socket '@'
seq: 662
status: todo
priority: p1
labels:
    - outpost
created: 2026-11-23T12:48:26.054163Z
---

Found during Sprint 696 story f25719a13f6f (join code + handle@address) by codex-gpt6.2-sol and verified in outpost/internal/agent/apps.go:609-617: httputil.ReverseProxy strips inbound X-Forwarded-For from pr.Out before calling Rewrite(pr), and Rewrite only restores pr.In.Header.Values("X-Forwarded-For") inside 'if clientIP, _, err := net.SplitHostPort(pr.In.RemoteAddr); err == nil'. On the default Unix-socket tunnel ingress (outpost/internal/agent/ingress.go), pr.In.RemoteAddr is '@', so SplitHostPort fails and cloudbox's X-Forwarded-For chain is dropped completely instead of re-emitting strings.Join(prior, ", ") when ViaTunnelIngress(pr.In.Context()) holds. Impact on page (Sprint 696): owner/member (Remote-User) and signed-in (X-Outpost-Visitor) satellite callers are unaffected because their identity key is the principal/visitor pseudonym; anonymous callers on a --public tunnel app lack forwarded client IPs until outpost preserves prior X-Forwarded-For on Unix tunnel ingress. Outpost changes are out of scope for Sprint 696 per delivery rule 7.
