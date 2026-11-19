---
id: a7dbe3e42079
kind: bug
title: bashy browser login with --success-url plus --cookie/--token-selector prints the URL instead of the requested secret (exit 0)
seq: 519
status: todo
priority: p2
labels:
    - browser
    - secrets
created: 2026-11-19T09:01:49.028486Z
---

Where: yoke cmds/browser/browser.go, DetectLoginCompletion + browserLogin output switch. Behaviour: completion conditions are checked in order success-url, token-selector, cookie, and the first match ends the wait. A success-url match returns loginCompletion{URL} with no token or cookie, and the printer then falls back to printing the URL. So 'browser login URL --success-url P --cookie NAME | bashy secret set S' exits 0 and silently stores the landing URL in the vault. Reproduced 2026-11-19 capturing a cloudbox step-up superadmin session: a 38-char URL was stored; with --cookie alone, the 284-char JWT was stored. Expected: when --cookie or --token-selector is given, the success URL only gates completion; keep polling until the requested value is present (or time out with exit 1). Only print the URL when neither is given. --json should carry the value too. Done when: a unit test on DetectLoginCompletion covers success-url + cookie (URL reached, cookie absent -> not done; cookie present -> done with the cookie) and the same for the token selector; the help text says which value is printed; kb/defaults page browser-login-with-success-url-and-cookie-captures-the-url-not-t is updated to say fixed in <version>. Root cause recorded above (product defect, not venue).
