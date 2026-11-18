---
id: bff1b5da0ad0
kind: test
title: 'S16 independent review: site-shaping server and outpost relationship stamp'
seq: 482
status: done
priority: p1
labels:
    - shaping
    - security
    - review
created: 2026-11-18T21:09:24.981709Z
weave: 81
assignee: agy-gemini3.8-flash
sprint: 615
sprint_id: 899fe465-c505-558d-a1f3-44a74a977e92
sprint_title: 'Shaping-enabled simple site: showcase MVP on the operator''s résumé site'
closed: 2026-11-18T21:28:14.568451Z
closed_by: claude-opus5.5-s615
---

Planned vendor: agy. READ-ONLY review, no code changes. Review bashy/examples/shaping/website/template/*.go and public/shaping.js plus outpost internal/agent/apps.go and grants.go (commit c4e1154) for: identity spoofing (unsigned or forged headers granting a tier); a non-member's email reaching the app or its logs; audience bypass (a group widening across circles; an empty audience leaking); private data in model prompts beyond the caller's tier; XSS in shaping.js (it must use DOM nodes only); open redirect or SSRF through the proxy (upstream path handling); cache poisoning across tiers (the proxy cache keys on path only: confirm per-tier data is never cached). Write findings as a comment on this story via: bashy todo edit <id> --note with severity, file:line and a concrete failure scenario for each; 'none found' is a valid result. Run GOWORK=off go -C bashy/examples/shaping/website/template test ./... to confirm green. COMMIT RULES: work only in the files named here; separate commit in the named subproject on its default branch with trailers Sprint: #615 / Story: #<this seq> / Story-ID: <this id> (plus your Agent trailer); never touch other stories' files, never git add -A, never push the umbrella, never bump pins (the conductor does). Targeted unit tests only (GOWORK=off go test for the touched package); no full suites, no containers or VMs on this machine. Public repo: no hostnames, IPs, home paths or real emails; use example.com. Spec: docs/sprint-615-master-execution-plan.md.

### Independent Security Review Findings (S16)

Overall verdict: none found. The implementation across outpost (commit c4e1154) and the site-shaping template fails closed, enforces strict relationship signing, preserves stranger privacy, and isolates proxy caching from tier data.

1. Identity Spoofing (unsigned or forged headers granting a tier):
- Finding: none found.
- Verification:
  - outpost `internal/agent/apps.go:232-246, 625-627, 639-718`: Outpost strips all `identityHeaders` (both legacy SSO and v2 relationship headers) from incoming requests unconditionally before forwarding. It only stamps identity when requests arrive via the authenticated matrix tunnel (`viaTunnel`) with `X-Forwarded-Prefix` and `TrustCloudIdentity` enabled. The v2 relationship tuple (`v2\n<kind>\n<circle>\n<groups>\n<visitor>\n<user>\n<prefix>\n<ts>`) is signed using HMAC-SHA256 with the app's secret into `X-Outpost-Relationship-Sig`.
  - template `identity.go:49-97` (`resolveCaller`): Caller identity resolves to `TierAnonymous` unless `SITE_SSO_SECRET` is configured, `prefix`, `ts`, `sig`, and `kind` are all present, timestamp skew is within +/-60s, and the HMAC signature validates with `hmac.Equal`. Unsigned, tampered, or mismatched headers fail closed to anonymous.

2. Non-member Email Reaching App or Logs:
- Finding: none found.
- Verification:
  - outpost `internal/agent/grants.go:212-249` & `apps.go:656-661`: When `Relationship(user)` resolves to `RelSignedIn` (signed-in non-member), `user` and `role` are explicitly cleared (`user, role = "", ""`), preventing `Remote-User`, `Remote-Email`, `Remote-Name`, and `X-Periscope-User` from being set on the outgoing request. Outpost stamps only `X-Outpost-Visitor` (keyed HMAC pseudonym: stable per app, unlinkable across apps).
  - template `identity.go:85-95` & `main.go`: For `TierSignedIn`, `c.Email` remains empty and `c.ID()` uses `"v:" + c.Visitor`. Neither outpost nor `site-shaping` logs caller email addresses or request details.

3. Audience Bypass (group widening across circles; empty audience leaking):
- Finding: none found.
- Verification:
  - template `audience.go:22-52`: `Audience.empty()` checks `!a.SignedIn && len(a.Circles) == 0 && len(a.Groups) == 0 && len(a.Emails) == 0`. An empty audience admits only `TierOwner`, failing closed for all other tiers (`c.Tier != TierMember || a.empty()`).
  - template `audience.go:40-52` & outpost `internal/agent/grants.go:47-63`: Circle admission is an explicit gate (`len(a.Circles) > 0 && !slices.Contains(a.Circles, c.Circle)` returns `false`). A member in an admitted group whose circle does not match is rejected before group or email checks run. Groups cannot widen access across circles.

4. Private Data in Model Prompts Beyond Caller's Tier:
- Finding: none found.
- Verification:
  - template `main.go:138-149, 194-218` & `view.go:68-81`: `s.allowedViews(c)` returns nil for `TierAnonymous` (forbidding anonymous model calls). `s.view()` filters private facts strictly through `s.allowedFields(c)`, which admits only fields matching `f.Audience.Admits(c)`. `viewPrompt` injects only the public page text and allowed fields; caller identity and unadmitted fields are omitted.

5. XSS in shaping.js:
- Finding: none found.
- Verification:
  - template `public/shaping.js:1-120`: The script constructs DOM elements exclusively using `document.createElement()`, `node.textContent`, and `document.createTextNode()`. No sinks such as `innerHTML`, `outerHTML`, `document.write()`, or `eval()` are used. Markdown rendering parses headers, lists, paragraphs, and bold text into native DOM nodes with textContent.

6. Open Redirect or SSRF Through Proxy (upstream path handling):
- Finding: none found.
- Verification:
  - template `proxy.go:33-97`: The upstream URL is constructed by joining the statically configured `u.base` with `r.URL.EscapedPath()`. Requests cannot escape the target host. Upstream redirects are not re-emitted (no `Location` header is forwarded).
  - outpost `internal/agent/apps.go:554-575`: Outpost's `ModifyResponse` rewrites only relative path redirects (starting with `/`, not `//`) to prepend `X-Forwarded-Prefix`, keeping navigation within the public mount without creating open redirects or SSRF.

7. Cache Poisoning Across Tiers:
- Finding: none found.
- Verification:
  - template `proxy.go:42-65, 92` & `main.go:106-126`: `upstream.cache` is keyed solely on path (`p`) and stores only the public static site response fetched anonymously from `u.base` (no credentials or tier headers sent upstream). Dynamic per-tier endpoints (`/_shaping/api/me`, `/_shaping/api/fields`, `/_shaping/api/view`) are handled by dedicated routes in `main.go` that do not touch `upstream.cache` and always set `Cache-Control: no-store`.
