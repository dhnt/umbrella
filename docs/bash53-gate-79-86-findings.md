# Bash 5.3 gate: why "79/86" kept coming back, and how it stays 86/86

Status: findings of record, 2026-11-10. Hosts are named by role.

## Summary

The public 86-fixture GNU Bash 5.3 gate does pass. Most of the times it
was reported as 79/86, the shell was not at fault. The runs used the wrong
environment, compared counts instead of fixture names, and treated a stale
claim as the baseline. Each wrong reading then produced a "fix" aimed at
the wrong cause, and the next run in a different venue "regressed" again.

Measured on bashy a9958c91 on the Linux test host, sealed container,
non-root testee:

| Lane | Result |
|---|---|
| `make test-bash-container` (dialect off, `BASH53_BASHPP=0`) | 86/86 |
| `make test-bash-container-bashpp` (dialect on) | 86/86 |

## The four "79/86"s: different fixtures each time

Every reading had the same count, but the failing fixtures were different
each time. Nobody compared the names, so the readings looked like one
recurring regression.

| Set | Failing fixtures | Real cause | Product defect? |
|---|---|---|---|
| A: venue | execscript, glob-test, intl, new-exp, printf, redir, test | `make test-bash` run as **root** (via `scripts/test-self-container.sh`, which has no `--user`) in a stock image without `hexdump` or locales. Root bypasses permission checks that `redir`, `test` and `execscript` expect to see fail; `printf` and `new-exp` need `hexdump`; `intl` and `glob-test` need locales. | No |
| B: dialect on | comsub, comsub2, errors, func, trap, type, varenv | Historical: the Bash# dialect reserved `func`, so `func() {…}` in a fixture parsed differently. It was fixed in `sh` long ago. The "79 + 7" figure in bashsharp `claims.md` (v0.27.0) was never refreshed, and readers kept quoting it as the current state. | Was, fixed |
| C: engine | various | A July 2026 interpreter regression, fixed at the time. | Was, fixed |
| D: Windows native | various | Native Windows lane gaps (Sprint 253 era), since measured 86/86 on Windows and Linux. | Was, fixed |

Set A and set B share no fixtures. A venue failure (A) blamed on the dialect
(B) gets a parser fix the parser does not need. A dialect failure blamed on
the venue gets waved off as "pre-existing". Both happened.

## How the wrong fixes happened

1. **The wrong lane was used for a verdict.** Native `make test-bash` is a
   host diagnostic. Its result depends on uid, `/tmp`, locales, `hexdump`
   and a controlling terminal. Only the sealed container lane is a release
   verdict. bashy CLAUDE.md already said so, but nothing enforced it.
2. **Counts were compared instead of names.** "79/86, same as baseline"
   was accepted without checking that the same seven fixtures failed.
3. **A stale claim was used as the baseline.** The bashsharp `claims.md`
   "79 + 7" figure made a root-venue 79/86 look expected.
4. **The cause was reasoned out instead of reproduced.** Filed todo
   1b05b83d9c33 guessed "locale/fixture differences". Running the sealed
   lane on the same host at the same commit would have shown 86/86 within
   minutes.

## What now makes it pass every time

| Guard | Where | Status |
|---|---|---|
| `make test-bash` refuses to run as root and points to the sealed gate (`BASH53_ALLOW_ROOT=1` is a deliberate override) | bashy 550fc0ac | done |
| The release gate is the sealed container in **both** modes (`test-bash-container` and `-bashpp`), never the native lane | bashy docs/suites, umbrella CLAUDE.md | in progress |
| One gate target runs both modes and writes evidence with provenance: bashy commit, `sh` pin, image digest, uid, mode, and the list of failing fixtures by name | bashy weave run 69 (`make test-bash-gate`) | in progress |
| The gate compares failing fixtures **by name** against the previous evidence: any new name blocks; matching counts prove nothing | run 69 | in progress |
| Runner preflight: refuse (not fail fixtures) when `hexdump`, the required locales or a PTY are missing, and report the missing prerequisite | run 69 (added to its scope) | in progress |
| `claims.md` refreshed to 86/86 dialect on, with the date and gate | bashsharp cd8b8c9 | done |
| Sprint 610 S14 re-scoped from "fix the parser" to a regression guard plus targeted probes (`func() {…}`, `func () {…}`, `ls //tmp`) | umbrella 95e141d6 | done |

## Rules for anyone reading a test-bash result

- Quote only the sealed lane, both modes, with its evidence record.
- A failing result is a list of fixture names, never just a count. Compare
  the names with the last green evidence before calling anything a baseline.
- An environment failure is fixed in the environment or the preflight,
  never in `sh` or the parser.
- Before changing code for a gate failure, reproduce it in the sealed lane
  at the same commit.
