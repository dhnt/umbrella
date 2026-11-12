---
id: 35f2b4ad35a7
kind: bug
title: 'outpost git app: upstream error log can carry the host credential (redirect followed)'
seq: 170
status: done
priority: p1
labels:
    - outpost
    - security
created: 2026-11-12T20:22:11.879998Z
closed: 2026-11-12T21:04:09.134147Z
---

Root cause (recorded 2026-11-12, reproduced in isolation at outpost 36262d5 and a78df1f in the offline gate sandbox on the test host): gitUpstreamClient (internal/agent/gitapp.go:110) is a plain http.Client that FOLLOWS redirects. TestGitAppNeverLeaksCredential's redirect case answers with a Location whose fragment carries the Basic credential; the proxy follows it, and when that GET fails (offline: DNS unreachable) gitapp.go:181 logs slog.Warn("git app upstream request failed", err) and the url.Error text includes the credential-bearing URL. Online venues pass only because the followed GET succeeds - so the redirect subtest also never exercises the Location pass-through it claims to (test defect: reaches the internet). Classification: product defect exposed by a realistic offline environment + test defect. Fix in product: CheckRedirect = http.ErrUseLastResponse on gitUpstreamClient (the Location scrub at gitapp.go ~197 then applies) and log a redacted error (containsGitSecret/redaction) instead of the raw err; the test must not depend on external DNS. Pre-existing; not part of S619.

Fixed 2026-11-12: outpost 2a07363 (CheckRedirect=ErrUseLastResponse; error log via redactGitSecrets; redirect subtest asserts the 302 reaches the caller; TestRedactGitSecrets). Strengthened test is red on the old client (redirect status 404, want 302). Gate: loom + bashy oci, offline, on the test host: TestGitAppNeverLeaksCredential passes; the remaining failures are the 8 venue tests of 13774a3f, none new. Umbrella pin 6cdb9004.
