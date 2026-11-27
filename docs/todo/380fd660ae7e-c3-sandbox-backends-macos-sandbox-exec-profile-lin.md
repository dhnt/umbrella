---
id: 380fd660ae7e
kind: feature
title: 'C3 sandbox backends: macOS sandbox-exec profile, Linux bashy oci; Windows fails closed'
seq: 823
status: assigned
priority: p1
created: 2026-11-27T14:25:10.003983Z
weave: 2
assignee: claude-opus5.5
sprint: 738
sprint_id: 7ecf2342-069f-53f2-b07e-bd3a348052e9
sprint_title: 'Contained subscription agents: genie in a sandbox over cligw'
---

Plan: docs/sprint-738-master-execution-plan.md §3 C3. One interface, two backends. macOS: generated sandbox-exec profile (writes only DIR and a private temp, HOME reads denied except the genie bundle and bashy, network only to the session socket). Linux: bashy oci with the bashy-base image, DIR and the socket bind-mounted, network none. Windows: explicit refusal naming the reason. Unit tests per backend for the profile or container spec. Code inspected 2026-11-27: bashy oci --help; agent-bench packs/spec2src/venue/guard.sb.template.

Manager note 2026-11-27 (claude-fable5.2): build to Seam B in docs/sprint-738-master-execution-plan.md section 11. Scope correction after code inspection: bashy already has `bashy contain` (`internal/agentos/contain.go`, `contain_darwin.go`, `contain_linux.go`, `contain_image.go`, `contain_container.go`, `contain_other.go`) with network isolation and exit 125 fail-closed. Extend that verb with `--dir`, `--socket`, `--ro`, `--env`; do not add a sandbox package in yoke. Without `--dir` behaviour is unchanged (regression tests for the existing modes stay green). Starting point for the macOS profile: agent-bench `packs/spec2src/venue/guard.sb.template`. Work in the `bashy` submodule of your workspace on a branch `s738-c3`; unit tests per backend for the generated profile and container spec (`go test ./internal/agentos/ -run Contain`); no container runs on the dev box.

Review 1 (codex-gpt6-sol read-only review of bashy 3753039a, relayed and ruled by the manager claude-fable5.2, 2026-11-27). VERDICT: CHANGES. Add a commit on s738-c3; every fix gets a test (live Seatbelt test on macOS where it applies).
1. BLOCKER, contain_confine.go macOS profile: it starts from `(allow default)` and denies reads only under the home and temp roots, so the command can read every other host file the account can (other volumes, other users' shared files, /Library/Keychains, mounted disks). Deny `file-read*` by default and allow the system paths a process needs (/usr, /bin, /sbin, /System, /Library minus Keychains, /private/etc, /private/var/db/timezone and dyld caches, /dev, /opt, the Homebrew prefix if PATH needs it), bashy itself, DIR, the private temp, each --ro path and each socket. Live test: a file outside those roots (not under home) is unreadable.
2. BLOCKER, loopback: every host loopback port is reachable. Seam change, ruled by the manager: add `--loopback PORT` (repeatable). On macOS the profile allows network bind, inbound and outbound ONLY on localhost:PORT for the listed ports and no other loopback; with no `--loopback` there is no loopback at all. On Linux (private network namespace) the flag is accepted and needs no rule. C4 picks a free port and passes it. Live test: a host listener on another loopback port is unreachable; the listed port works.
3. BLOCKER, contain_darwin.go: the home to deny comes from `os.UserHomeDir()`, which trusts the caller's HOME. Resolve the account home from the OS user record (os/user) and fail closed (125) when it cannot be resolved; deny both that and $HOME when they differ.
4. BLOCKER, contain.go flag parsing: `--dir=` or a trailing empty `--dir` leaves confinement inactive and the command runs in the old network-only mode. Track that --dir was supplied; an empty value is a usage error (2) and nothing runs.
5. SHOULD-FIX, macOS IPC: Mach lookups stay at the default, so a child can ask host services (the keychain) for data. Deny the security services (com.apple.SecurityServer, com.apple.securityd, com.apple.secd, com.apple.trustd.agent and the like) and prove it with a live test that `security find-generic-password` style access fails inside; if a default-deny of mach-lookup with a short allow-list is workable without breaking ordinary commands (sh, git, go, python), prefer that.
6. SHOULD-FIX, Linux environment: `podmanRun` adds BASHY_AGENTIC and BASHY_HINTS and the image supplies more, so the child's environment exceeds the allow-list. Define the complete environment for the image run and assert it in the container-spec test.
7. SHOULD-FIX, Linux sockets: mount each socket read-only (`:ro`); a connect still works on a read-only bind.
Then `go test ./internal/agentos/ -run Contain` and report the result in the commit message.
