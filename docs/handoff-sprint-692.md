# Handoff: Sprint 677 closed, Sprint 692 (677 closure) ready to start

Date: 2026-11-22. Outgoing conductor: claude+2 (Claude Opus 5.5 session). Incoming: the next
managing agent (takes the Sprint 692 seat with `bashy sprint take 692 --owner <your name>`).

## What Sprint 677 delivered (ended 2026-11-22, merged on main)

The operator's architecture, all on bashy / bashsharp main:

- **bsh** = Bash 5.3 + Bash# + POSIX-required coreutils, its own Go module at
  `bashsharp/cmd/bsh`, zero yoke/bashy/ycode packages (link test, no allowlist). Builds alone with
  `GOWORK=off`; about 44 MB; starts about 2.6x faster than bashy.
- **bashy** = the bsh engine + agentic hooks + a dispatcher. Every non-internal command is a
  few-line Bash# adapter in one of five folders: `optional/` (63), `toolchain/` (20),
  `yoke/` (56, including the coupled verbs inbox, sprint, kb, meet with duplicated glue),
  `examples/` (127+), `custom/` (47). bashy's case calls the adapter; flags, args, output and exit
  codes are unchanged. Each command builds alone with its own pins (dependency test per command).
- **Adapters are embedded** in the bashy binary as the last fallback
  (`internal/agentos/adapterembed`, regenerated with `go generate ./internal/agentos/adapterembed`;
  `TestEmbeddedAdaptersMatchSourceTree` fails on drift). Precedence: shape slot > override >
  source pin > on-disk roots > embedded.
- **productgo in Bash#** beside bsh (`bashsharp/cmd/bsh`, byte-identical overlay test). The Go
  copies in bashy and bash stay until the contract step.
- **Go 1.27.4** across all 14 release modules; official build image rolled to
  `bashy-build:v1.0.0-rc.40-go1.27.4` (image.lock on bashy main).
- **Self install no-downgrade guard** (bashy 130af35e) and **outpost boot-scope service bootstrap**
  (outpost 854dd468): a service restore can no longer silently put an older release over a newer
  build.

Integration evidence (gate host, official image, lane 2):
- `bashy dag build`: PASS.
- Bash 5.3 sealed gate (`bashy dag test-bash-gate`, run on the host, not inside the build
  container): **86 passed, 0 failed, 0 skipped, 0 timed out**, both modes.
- `bashy dag test` with the candidate `./bin/bashy`: **15 go test failures in 4 packages**, the
  reason Sprint 692 exists (below).

## Sprint 692: what is left (11 stories, all moved from 677)

Acceptance is on the card (`bashy sprint show 692`). In priority order:

1. **22d478f9 Adapter env leak (p0, IN FLIGHT as umbrella weave run #143, agy-gemini4-carbon).**
   Root cause recorded: `runCommandAdapter` (bashy `internal/agentos/adapter_dispatch.go`) injects
   `BASHY_SELF=/work/bin/bashy` into the `toolchain/go` adapter; it leaks into binaries `go test`
   builds, so `bashySelfPath()` inside test binaries resolves to bashy and self-re-exec tests run
   the wrong program. Also `jq` missing from the standalone `yoke/dag` adapter. Review #143's
   delivery first: build + its unit tests + dependency test, rebase onto current main, merge.
2. **3043a867 the 15 failures (p0).** First-pass classes on the story: venue (stale go1.27.2 tool
   in the lane cache volume; container caps 8 CPU / 7 GB / pids too small for internal/agentos,
   whose package hits the 10 m go test timeout), likely product (make-fallthrough hints empty:
   bisect against Sprint 660 R4 74100d67; genie recipe profile missing id: bisect the sibling-pin
   sync), expected change (common-options golden: review then `BASHY_UPDATE_COMMON_OPTIONS=1`),
   test defect (bashy-build roll test doubles `/var/cache/` under the container TMPDIR). Many may
   disappear with the env-leak fix: rerun before fixing more.
3. **458628c0 the single integration run (p0):** after 1-2, rerun on the gate host; record results
   on the card.
4. **K1 73dbfa3a / K1b ffd48cc9 / K1c 80b2540c (p0):** bashy supervisord keeps the gate host's WSL
   instance alive while supervised oci jobs run (WSL idles out and kills detached lane jobs).
5. **S2 ec0a696b (p1):** strip symbols on Darwin/Windows builds only.
6. **C 3f6a38f3 / C2 0774dc22 (p0):** dependency bumps for reachable advisories; fresh govulncheck
   on the gate host (never the dev box: it used 21 GB there); narrow the logged override.
7. **40a432e3 (p0) build-time table** per adapter group (warm < 10 s required, < 5 s ideal;
   toolchain exempt). Measurement only.
8. **fa807380 (bashsharp store) bsh vs GNU coreutils benchmark:** reproducible harness under
   bashsharp `bench/` (research and script inventory already merged).
9. **P5 aa693f4a (p2), LAST:** retire the monolith switch (expand -> switch -> contract).

## Clean plate: state at handoff

- **Weave queues:** every dead run abandoned; only umbrella #143 is live. All unintegrated commits
  are preserved twice: `refs/salvage/abandoned-*` in each repo, and verified git bundles in
  `~/.bashy/salvage/2026-11-22/` (one `.bundle` + `.log` per run/repo).
- **Repos:** umbrella, bashy, bashsharp, outpost, yoke, coreutils, bash, sh, ycode clean and at
  origin heads; every umbrella pin equals its repo's origin head (umbrella main 660a7c08).
- **Dev box:** disk about 55 GB free after pruning. Its installed `~/.local/bin/bashy` is still
  the old rc.37 build; an install candidate from current main is built in the outgoing
  conductor's recovery worktree (the operator installs it from their own terminal; agents are not
  allowed to replace the running shell binary).
- **Other sprints:**
  - 652 (outpost reliability): inbox phone-model fix bc800d20 (bashy queue runs abandoned, work in
    salvage refs) and C4 (682) need re-staffing; close-reclaims-everything a52829ea paused.
  - 682: waits on C4.
  - 690 (Demo Queue): merged, its own manager live; in-room rehearsal open.
  - 660: done except the parent story.
  - 616: done.
  - 684, 688: queued after 692.

## Rules that bind this sprint (all in the umbrella CLAUDE.md or on the card)

- **Start every story on current heads:** check `bashy mod drift`, bump pins, resolve first,
  rebase before submit; redo a stale workspace rather than repair it; coordinate pin bumps.
- **Unit tests per story; integration only at the milestone.** No per-story suites or gates.
- **Root cause before any fix**, recorded on the story; a venue problem is fixed in the venue.
- **Heavy runs only on the gate host** (claim a lane), never the dev box. At most 2-3 headless
  weave runs on the dev box at once: on 2026-11-21 the dev box (24 GB) hit a kernel watchdog panic
  from memory and swap exhaustion with a nearly full disk.
- **Expand -> switch -> contract;** duplicate before de-duplicating; no command depends on
  another command.
- **Ask the operator decisions as plain text or a bashy form, never a terminal question dialog**
  (steers into a steerable session can answer the dialog).
- **Public repo:** describe hosts by role; the scrub gate is fail-closed.

## Known traps

- A finished headless run does not act on `weave say`/steer; put rework in the story text and
  relaunch.
- `weave add --from-todo` sets the story owner to the operator; set `--owner` back to the worker
  before `weave start`.
- When running `bashy dag test` in the official image, use the candidate `./bin/bashy`, not the
  image's bundled bashy (the target re-invokes `$BASHY`).
- The sealed Bash gate needs host podman: run it on the gate host, not inside the build container.
- Agent turns time out at 40 minutes: keep stories small; do not make a worker wait on a long
  gate-host job inside one turn.
- Bump umbrella pins only forward (check the origin head descends from the current pin).

## Open operator items

- Install the fresh bashy on the dev box, then restart the agy, codex and muse sessions.
- Unattended reboot validation of the outpost boot-scope fix (deferred to Sprint 652's milestone).
