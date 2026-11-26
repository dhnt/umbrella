---
id: 14bb7d2b5eab
kind: test
title: F2 Deployed suite-to-circle sharing e2e on a satellite (200/403/401, live revoke)
seq: 123
status: wontfix
priority: p1
labels:
    - collaboration-followup
created: 2026-11-11T09:56:30.912325Z
sprint: 724
sprint_id: 4c6a8940-8673-582a-adef-d7665a30d524
sprint_title: 'Consolidated follow-ups after train 1 (supersedes 711, 713, 714, 715, 718, 720): owner-sharing and A/O/C sandbox e2e, site MCP and site attach, deferred integration runs, known reds, MCP 2026-07-28'
closed: 2026-11-26T11:15:42.69885Z
---

Sprint 614 S9 shipped suites and circle shares (cloudbox 07411af server + console, yoke d0ba2a11 bashy suite, outpost ee1c3344 apps share --circle) verified at unit level and against the fake master only. Run once on the Linux test host with the existing cloudbox e2e harness against a satellite built from those commits: owner creates a named circle, a suite of two apps on two hosts, shares the suite with the circle; member in circle gets 200 on both apps, member outside 403, no credential 401; moving the member out of the circle and removing an app from the suite flip to 403 without re-share; console and CLI show the same suites/grants. Evidence tied to candidate commits.

## Sprint 710 H6 (2026-11-24): extended acceptance

Moved from the backlog into Sprint 710 (owner sharing) as its acceptance story. Besides the checks above: the circle is an owner-named custom circle; a publicly published app answers an anonymous visitor and a logged-in non-member identically (as anonymous); re-inviting a pending member delivers the mail; the CLI share listing (H1, S14) matches the console. Record the outpost grant-cache TTL as the "live revoke" bound. Green twice on the Linux test host after H1-H5 merge. Plan of record lives with the sprint card.

## Worker rules (conductor, 2026-11-25, Sprint 710 H6)

Candidate commits (all merged): cloudbox dev 3615810 (H2 re-invite, H3 satellite sign-in, H4 client IP, H5 master share projection; closure bookkeeping ae3a596), outpost 6b4a08d (H1 grant-rule share CLI), yoke 39aef5bc (H2b invite output), bashy 98551856. Start from these heads.

- Extend the existing cloudbox e2e harness: script/e2e_fleet (fleet.py, journeys.py) and script/e2e_multisat.py. H5 already moved its shares to the master. Do not build a new harness. Code inspected: fleet.py share()/unshare() on the master wire; shared_checks; user-complex scenario.
- One scenario covers every acceptance check above. The owner-named custom circle, the suite of two apps on two hosts shared to it, and member-in / member-out / no-credential give 200/403/401. Moving the member out of the circle and removing an app from the suite give 403 without re-share; record the measured latency against the outpost grant-cache TTL (outpost/internal/agent/provision.go). The public app gives an identical answer to an anonymous visitor and a logged-in non-member. Re-inviting a pending member delivers mail: use the harness's existing mail capture or fake (find it; if none exists, report before adding one). `outpost apps shares --json` (H1) lists the same grants as the console API.
- Keep the 'family: satellite host rows' check from user-complex green as written.
- You do NOT run the e2e. Never ssh, scp or remote-exec to any host, and never start background tasks. Verify locally with python -m py_compile and any pure-Python unit checks only. Stage one runnable gate command (script + exact args + the commit pins it needs) and put it in your submit message. The conductor runs it twice on the Linux test host.
- Commit to cloudbox dev via your workspace branch, one commit with Sprint/Story/Story-ID/Agent trailers. Story-ID is this umbrella story; the cloudbox hook may warn that the story is in another store, which is fine. No deploy. No host names, IPs or logins in anything committed to public repos.

## Gate run 1 (2026-11-25, Linux test host): FAIL at fixture setup; root cause recorded

Candidate: cloudbox b2bc5e0 (dev a9c0d79 + H6a a7299b5), outpost 6b4a08d, yoke 39aef5bc, bashy b1d1f9bd (one docs-only commit past 98551856), E2E_LOCAL=1, scenario owner-sharing. It failed before any owner-sharing check ran: `fixture: slice owner-sharing comes up (member invite ...: gotoolchain: fetch release index ... network is unreachable)`.

Root cause: a test-harness defect, not owner sharing. Since bashy 62ee3c74 (2026-11-21), `bashy member` is a yoke adapter (internal/agentos/adapter_dispatch.go:156) that is built on first use, and the build downloads a Go toolchain. The e2e-multisat containers run with --network none, and the stage ships neither Go nor prebuilt adapters. Reproduced outside the harness in an offline container with bashy c450753f, 3535205f, 98551856 and b1d1f9bd: same failure. The last green `members` run on this harness (2026-11-20) predates the adapter change. Classified: test (venue/harness).

Fix (test-only, cloudbox script/; allowed under the 699 train-1 cutoff): build the yoke adapters into the e2e stage at build time and point the containers at them (BASHY_ADAPTER_CACHE or the equivalent bashy mechanism), so the sandbox stays offline. Then rerun owner-sharing twice and user-complex once.

## Gate run os-2 (2026-11-25, Linux test host): FAIL 14/15; moved to Sprint 715

Candidate: cloudbox d318b8b (dev a9c0d79 + H6a a7299b5 + offline-adapter stage fix 64fe617), bashy 237211fd, outpost 6b4a08d, yoke ff326a9d; E2E_LOCAL=1, owner-sharing; 749 s, rc=1. Evidence on the gate host: /root/s710-h6/evidence/os-2/ (FAILURE.md).

These checks passed: custom-circle suite grant, 200/403/401, suite add/remove, revoke propagation at the satellite and the outpost within the pull bounds, direct master grant + CLI unshare, CLI = console listing, and the public app answering anonymous and signed-in non-member visitors the same way.

Failed: "re-invite delivers a second invitation to the pending member and CLI reports it". The mail capture got 0 deliveries, and the CLI printed "invitation mail NOT sent: mailgun: Post https://api.mailgun.net/... network is unreachable". Root cause (confirmed in code; PRODUCT defect): MAILGUN_API_BASE is neither in conf.BoundEnvKeys nor named in hub/config.*.sh, so viper ignores an env-only value and mail falls back to api.mailgun.net. Filed as cloudbox bug e2903321 in Sprint 715. The conductor's H6a review wrongly took the mapstructure tag as proof that the env override works.

Operator 2026-11-25: on failure, file each failure as a new bug in a new follow-up backlog sprint, move H6 and H6a there, and end 710 at 6/8. Follow-up: Sprint 715 (uuid a012b004-c4f7-5815-b743-69b7f122150e). H6a commits are preserved on cloudbox origin branch sprint-715/h6a-owner-sharing-e2e (64fe617); they are not merged to dev. Harness speed: todo e21df12acf97 (after the 699 freeze); runs must finish in minutes.

## Triage 2026-11-25 (consolidated into Sprint 724)

The scenario is on cloudbox dev (5e98236, script/e2e_fleet/owner_sharing.py, 15 checks, fake accounts, offline containers, fake mail capture). Last run os-2: 14/15; the one red is e2903321, still unfixed on dev. Order: fix e2903321, then run twice. The 749 s run time exceeds the minutes budget (todo e21df12acf97, not on this sprint).
