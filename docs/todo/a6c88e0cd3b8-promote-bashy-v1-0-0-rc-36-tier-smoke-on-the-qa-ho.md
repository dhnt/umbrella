---
id: a6c88e0cd3b8
kind: task
title: 'Promote bashy v1.0.0-rc.36: tier smoke on the QA hosts, verdict, QA refs, bare tag, promote.yml, outpost upgrades'
seq: 378
status: todo
priority: p1
labels:
    - vendor-gateway
created: 2026-11-16T04:31:50.324832Z
---

Carry-over from Sprint 646. v1.0.0-rc.36-dev is published (release.yml 43798181359 success) at bashy f9ff34a8. Sealed Bash 5.3 gate 86/86 in both modes; evidence ~/.bashy/evidence/bashy-rc36 on the dev box. Umbrella candidate tag: candidate/bashy-v1.0.0-rc.36 (b13bb0ae).

Remaining, following kb bashy-release-promotion:
1. Tier smoke on the darwin, windows and linux-wsl QA lanes (home LAN).
2. Write and commit release/tier-verdicts/f9ff34a8.json.
3. Create refs/qa/v1.0.0-rc.36/{linux,darwin,windows}.
4. Push the bare tag v1.0.0-rc.36 at f9ff34a8.
5. Run promote.yml with the verdict URL.
6. Check that checksums match the -dev release.
7. Upgrade the paired outposts.

The Windows test host was unreachable on 2026-11-16 during the operator's class hold.
