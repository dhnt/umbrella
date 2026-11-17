---
id: b93cd4673799
kind: task
title: 'macOS QA host: outpost ssh asks for a password (no TTY) — restore unattended tier-lane access'
seq: 425
status: done
priority: p1
created: 2026-11-17T19:25:28.79431Z
assignee: claude-opus5.5-s656-mac
sprint: 656
sprint_id: b220aade-5c96-5625-9a68-a0b7619c418a
sprint_title: 'rc.37 QA venue: gate-host OTel env leak + macOS QA host ssh auth'
closed: 2026-11-17T19:28:05.944072Z
closed_by: claude-opus5.5-s656
---

Seen 2026-11-17: outpost ssh <user>@<macOS QA host> -- echo ok -> 'ssh handshake to <host>:2222 (lan-direct): handshake failed: no TTY for password prompt (set OUTPOST_SSH_PASSWORD)'. The rc.35 tier kit reached the host as its admin account on port 22. Do: root-cause (wrong user/port in the probe vs the kit, key auth not offered, daemon auth config changed, vault password route); fix the venue or the kit; verify the kit's darwin remote() path runs non-interactively. The host is reachable only from the home LAN.

## ROOT CAUSE 2026-11-17

Cause: the failing probe was wrong, not the venue. It named the dev box's own login (an account that does not exist on the macOS QA host: `id <user>` -> no such user) and gave no port, so outpost ssh went lan-direct to the host's outpost ssh unit on 2222. That unit offers password,publickey and does not hold the dev-box key for any account, so outpost fell back to a password prompt and, with no TTY, failed. The tier kit never uses that route: its darwin remote() targets the host's admin account on port 22 (the host's OpenSSH), where the dev-box ed25519 key is authorized.

Classification: probe/operator error (environment of the check), not a product defect and not a kit defect. Venue unchanged: mDNS resolves, ports 22 and 2222 open; plain ssh BatchMode diagnostics: admin@22 -> "Server accepts key", authenticated publickey; <devbox-user>@22 and any user @2222 -> Permission denied (key not accepted). No elevation cookie or vault password involved.

Fix: none needed in venue, kit, or product. Probing rule: reach the macOS QA host the way the kit and the release-hosts list do (admin account, explicit :22); a bare user@host means outpost's own unit on 2222.

Verification (dev box, LAN, outpost rc.35-dev): kit darwin route `outpost ssh <admin>@<host>:22 -- env PATH=... bashy -s` with stdin `echo ok; bashy --version`, run twice in a row: both rc=0, stdout "ok" + bashy 5.3.0(1)-bashy-dev (653c13a), stderr 0 lines both runs (no OTel parse-url lines). Wrong probe re-run: rc=1, same no-TTY password error, reproduced and classified.
