# Handoff — Sprint 694: promote the thin bashy as v1.0.0-rc.41

Written 2026-11-23 by the Sprint 692 conductor (claude-fable5.1) for the next
sprint manager. Sprint 692 is closed; this card inherits its one undelivered
outcome: a promoted release. Read `docs/plan-sprint-692-release-thin-bashy.md`
(goal, done-when, gate loop rules 1–8) and
`docs/sprint-677-integration-evidence.md` (every gate run, dist, receipt, tier
verdict) before touching anything. Public repo: hosts by role only.

## Where things stand

| Item | State |
|---|---|
| `v1.0.0-rc.40-dev` | Published as a GitHub **pre-release**, 34 assets, 5 platforms, targeted at bashy `6c36c0a7` (pins bashsharp `b1a3183`, outpost `a1c9307`, yoke `3eb700cd`, bash `42efe303`). Notes carry a "not promoted" section and the Windows known issue + workaround. **Do not promote it.** |
| Tier verdict for `6c36c0a7` | **FAIL** — bashy `release/tier-verdicts/6c36c0a7.json` (commit `e230d065`). Linux PASS (tier1/2/3). Windows FAIL (product). macOS INCOMPLETE (venue). `releaseeligibility --tier-verdict` rejects it, as designed. |
| Windows defect | Fixed on bashy main `802c5f40` (story 5cb66dcf, closed): the dispatcher exports `BASHY_ADAPTER_CACHE` in drive form on Windows; before, every Go adapter's first-use build handed an MSYS-form `$HOME` path to `go.exe`. Proven on the Windows lane: `mktemp`, `jq`, `seq` cold-build rc=0 with the default cache path. |
| macOS venue | The QA host had exhausted its ephemeral TCP ports (about 39k TIME_WAIT) before the tier run; it cleared by itself the same evening (TIME_WAIT 30). Check before the run: `netstat -an \| grep -c TIME_WAIT`. |
| Local release pipeline | Proven end to end once: `bashy dag dist` (208 s warm, budget 300 target / 1800 cap), `scripts/local-release-gate.sh` receipt (vuln override retired), Git note `refs/notes/bashy-local-gates`, draft pre-release targeted at the commit, `release.yml` dispatch with `evidence_commit`. `release.yml` preflight needed `permissions: contents: write` (fixed in bashy). The last publish step (cloudbox webhook) returned 403 once: stale URL secret, cloudbox todo e9ef68b9; it does not undo the publish. |
| Heads (2026-11-23 morning) | bashy main `c8650eb4` (= `802c5f40` fix + `e230d065` verdict + story docs); umbrella main `673cc2d53` pins it. Bash gate inputs (bash, bashsharp, sh, coreutils pins) unchanged since the sealed 86/86 runs. |

## Stories on this card (in order)

1. **282834655193 Release** (p0, carried over; the MVP of this sprint). Its body has
   the full PROCEDURE and a done / not-done record. Deliver as **rc.41**: the
   candidate is current bashy main (or a frozen tip you choose), never a
   release branch.
2. **deade8cd / f280256c / 944ee282 LAN install MVP** (p1/p1/p2). Branches
   `lan-install-mvp` exist on bashy (`092e1dce`) and outpost (`e821361`), not
   merged. Merge after the rc.41 tag, then pin bumps. Plan:
   `docs/plan-effortless-install.md`. 944ee282 is not started.
3. **41997de0 adapter cold build inherits exported GOOS/GOARCH** (p2). Fix in
   the adapter builder: force host GOOS/GOARCH/CGO_ENABLED regardless of the
   caller's environment.
4. Everything in the card's primary goal (per-command `go.mod`, build-time
   targets, catalog dispatch, WSL keep-alive) is **planning-only** until the
   operator reviews it — a mass change needs its own written plan (CLAUDE.md).
   Recommend: rescope the card with the operator to "rc.41 release + LAN
   install merges" first; keep round-2 as a separate planned sprint.

Also filed, no sprint: bashy todo 661878f4 — `bashy -s` with the script on a
pipe drops the rest of a command list after an external child that inherits
stdin (pre-existing; GNU bash does not). Not a release blocker; the tier kit is
immune (probes run with `</dev/null`).

## rc.41 recipe (what to rerun, per gate loop rule 2)

The candidate differs from `6c36c0a7` by the Windows fix (adapter path) and by
Sprint 693's `site` commits on bashy main (new product code under the
examples/shaping area). Therefore:

- **Leg 2 `dag test`**: rerun in full on a gate-host lane in the official image
  with the candidate `./bin/bashy` as the outer runner (`-timeout 30m`, rule 5).
- **Leg 4 dispatch e2e, 3 OS, fresh install, cold adapter cache**: rerun. Add a
  Windows case that leaves `BASHY_ADAPTER_CACHE` unset — the existing e2e
  exports a native cache path itself, which is how the rc.40 defect slipped
  through.
- **Sealed Bash gate (leg 3)**: engine inputs unchanged → reuse rerun-3 evidence
  and say so in the evidence doc by run number (rule 2).
- **Leg 5 shaping smoke**: rerun if the site commits touch it; otherwise reuse.
- Then: CHANGELOG — turn the `[1.0.0-rc.40] (candidate)` section into
  `[1.0.0-rc.41]` (rc.40 was never promoted; say so in one line) and add the
  Windows fix under Fixed; `dag dist` (fresh build cache for the final run,
  warm module cache, rule 3/6); `local-release-gate.sh` receipt;
  `scripts/verify-local-release-gate.sh` offline preflight; draft pre-release
  at the commit with the 34 assets; push the `-dev` tag; **one** `release.yml`
  dispatch (rule 7).
- Tier verdict on three lanes with the rc.37 tier-smoke kit (uncommitted; it
  lives in the `tier-kit-s692` folder beside the umbrella checkout on the dev
  box, with the rc.40 runs under its `.gfy-out`). Install the candidate from a
  LAN copy, never a second download. Write
  `release/tier-verdicts/<c8>.json`, commit V on bashy main, umbrella tag
  `candidate/bashy-v1.0.0-rc.41`.
- Promotion: `refs/qa/v1.0.0-rc.41/{linux,darwin,windows}` → V, bare tag at the
  candidate commit, `promote.yml` with the raw verdict URL at V — **only on the
  operator's typed go**. Expect the final webhook-registration step to 403
  until cloudbox todo e9ef68b9 lands.

## Venues and traps (learned 2026-11-22/23)

- **Gate host** (Windows machine, WSL lane root `/root/lanes/lane{1,2,3}`):
  official image named by `tools/bashy-build/image.lock`; `tools/bashy-build/run.sh SRC -- CMD`
  mounts SRC at `/work` with the shared `bashy-build-cache` volume (one cache
  per host, rule 6). A detached job dies when no WSL session is attached:
  launch with `nohup setsid … &` and keep an attached polling loop (each
  remote call under 590 s). Elevation to the host expires about hourly;
  re-elevate from the vault (`bashy secret exec … outpost connect --stdin`).
  Copy binaries per file with `outpost scp` (tar over the ssh channel corrupts
  them); the Windows-side path is required. Lane 2 is shared with Sprint 693 —
  check `bashy claim list` and the board first; the cloudbox multisat e2e
  script wipes its own tree, never a lane.
- **Windows lane** (the Windows QA machine): its login-PATH `bashy` is the
  outpost-managed copy; outpost's supervisor rolls a swapped-in bashy back to
  its own release within 10 s and restarts its service tree (sshd down ~40 s).
  **Update outpost on the lane first**, or run the candidate by absolute path.
  Its mDNS name answers; the plain ssh alias times out at the banner. `go.exe`
  is installed. To probe a dev-version binary without a source fetch, point
  `BASHY_ADAPTERS_ROOT` at the lane's existing source pin checkout.
- **macOS QA host**: check TIME_WAIT before the run (above). A peer sprint may
  hold a claim on it (`bashy claim list`).
- **Dev box**: edits, targeted package tests, orchestration only. No builds,
  no suites (operator rule 8). Its login `bashy` is a dirty dev build that
  routes `jq` to an adapter and fails on a stale source pin; the tier kit was
  orchestrated with a published rc.27 bashy on PATH.
- **Weave**: `bashy weave pull N` merges the umbrella side and **deletes the
  workspace**, including unpushed commits the worker made inside a submodule.
  Fetch or `format-patch` those first (the rc.40 verdict commit had to be
  reassembled from the fold evidence).
- **Stories**: bashy-store stories close only through
  `bashy sprint claim/submit/accept N ID --repo bashy`; umbrella stories use
  `--repo .`. `sprint end` refuses on the pre-existing consumer pin drift
  (yoke nested modules, sibling pins); close with `sprint goal rm` (reason:
  moved) for outcomes carried elsewhere, then `sprint move N done --force --reason`.
  `bashy mb post` needs `BASHY_AGENT=<name>` exported and `--as <name>`.
- **Commits**: trailers `Sprint:/Sprint-ID:/Story:/Story-ID:/Agent:` or
  `Adhoc:`; the umbrella pre-commit scrub gate needs bash ≥ 4 first on PATH
  (`PATH=/opt/homebrew/bin:/usr/bin:/bin:$PATH /usr/bin/git commit …`). Host
  `gh` is the Homebrew binary; bashy's `gh` adapter rejects `--json`. A Go file
  named `*_windows.go` is GOOS-constrained.

## Clean-up candidates (not done)

- Tier scratch folders `tier-smoke-rc40` on all three lanes; the rc.40 OCI
  image on the Linux lane; the rc.40 login-PATH installs on the Linux lane and
  the macOS QA host (`bashy.prev` kept beside each).
- Gate-host images: many old `bashy-build`/lane images remain (about 63 GB).
  Keep the image the lock names and the shared cache volumes.
- A lapsed gate-host lane 3 claim under claude-fable5.1
  (release did not clear it; harmless).
