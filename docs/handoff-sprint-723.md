# Handoff: Sprint 723 (spec to source calibration), mid-sprint

*2026-11-25, from the conductor that ran Sprint 722 and planned 723. A warm
handoff: the operator left the timing to the conductor.*

## Start here (reading order)

1. The 723 card (`bashy sprint show 723`): its goal, acceptance and every
   operator ruling, in order.
2. `docs/plan-spec2src-calibration.md`: the gap catalogue G1–G7, stories,
   ladder and decisions.
3. `docs/shapeware-qualification-process.md`: the standing process, the
   system view (specs, measured min-band, band certification, runbooks) and
   the band composite (its design is deferred to Sprint 559).
4. `docs/shapeware-spec-v0.md` §5 (`effort`), §19 and §20 (soundness
   criteria).
5. `docs/conform-phase-b-protocol.md`: the Sprint 722 protocol. Its
   amendments record every venue trap. Reuse them.

## Operator rulings in force

- **Goal:** prove story/spec → source and the drafting of the shapeware
  spec. Improve over time; MVP, no gold plating.
- **Order:** spec creation and the builder ladder first. The judge study
  (S9) comes after, and the band weighting waits for Sprint 559.
- **D1–D5:**
  - D1: keep YAML and add an example.
  - D2: extra keys are allowed on create outputs; outputs stay closed where
    that protects content (F-02).
  - D3: conform in the loop for builders.
  - D4: judge bar ≥ 90 % agreement plus both known judge defects found.
  - D5: OpenAI starts at gpt6.2-sol and steps up to gpt6.2-astra.
- **Ladder (price prior; Meta by naming):**

  | Vendor | Start | Step down | Step up |
  |---|---|---|---|
  | Anthropic | sonnet5.5 | sonnet5 | opus5.5, then fable5.2 |
  | OpenAI | gpt6.2-sol | gpt6.1-terra, then gpt6-luna | gpt6.2-astra |
  | Google | gemini4-carbon | gemini4-neon, then hydrogen, then 3.8-flash | none listed |
  | Meta | muse-ember | muse-spark1.3 | muse-wonder |
  | Zhipu | glm-5.3 | glm-5.3-flash | none listed |

  Open question: is ember below wonder in Meta's lineup? All registry bands
  are seeded.
- **Effort points** (Fibonacci) on every feature; minutes per point are
  measured.
- **Runbooks to write:** S12 (reverse: app → spec), S13 (the builder's
  guide), S10 (the drill). S13 is not given to subjects in 723.

## Story status

| Story | Status |
|---|---|
| S1 criteria (spec §20) | done (umbrella c0c055e59) |
| S2 form spec v2 | **done**: bashy 44c4d966 on main. The reference certifies against contract v2 (14/14 PASS, cli+ui, 0 noisy over 3 runs, seal fb15af33) and kills 109/109 mutants; acceptance.bsh exits 0; the fence and adapter tests pass |
| S3 hidden cases v2 | next. Private, in dhnt/docs `docs/conform/form-hidden-v2`: each case on its own form, HI-01 on a JSON form, one YAML case with flow lists, controls, digests |
| S4 harness v2 | next. The fixture adds `examples/contact.yaml`; a standalone `conform` (cmd/conform v0.1.1) on the agent PATH; TASK.md v2 mentions it; re-freeze the adapters (the copy was deleted); protocol v2; smoke with codex-gpt6-sol |
| S5 / S6 | the L4 batch, then one step per vendor |
| S7 | validator, static criteria 1–3 only (MVP) |
| S8 | report book |
| S9 | judge study; after the builder half |
| S10, S12, S13 | runbooks |

## Mechanics and traps (all learned in 722)

- **Scripts:** the conductor's private evidence directory on the dev box (`s722-conform/scripts/`), not public.
  - `phaseb-run.sh`: one run with every fixed condition (guard, Keychain
    opt-ins, auto-update off, adapter cache).
  - `verify-conform.sh`, `form-record.sh`, `render-page.sh`: lane helpers.
  - The private grader is `dhnt-docs docs/conform/form-hidden/grader/`.
- **Credentials and launch:**
  - `BENCH_CLAUDE_KEYCHAIN`, `BENCH_AGY_KEYCHAIN` and `BENCH_MUSE_KEYCHAIN`
    must be 1, or logins are invisible in the arm.
  - `bashy weave fleet --probe` can falsely report Claude as needing sign-in
    (bashy todo ef897e5f).
  - `bashy chat` cannot start on a fresh cache (cbce9995), so freeze a
    prebuilt adapters dir and set `BASHY_ADAPTER_CACHE`.
  - Set `OPENCODE_DISABLE_AUTOUPDATE=1`. Batch 1 upgraded the host's brew
    opencode and ripgrep.
- **Guard:** `guard.sb` in that private evidence directory denies reading
  the projects tree and the private evidence directory (adapters excepted) and writing HOME,
  /opt/homebrew and /usr/local. `BENCH_GUARD` applies it.
- **Lane:**
  - Grading only on the gate host lane2, inside `unshare -n`, with an xdg-open
    stub and one grade at a time (a lock in `grade-on-lane.sh`).
  - `conform --fresh-home` leaks the app's daemons (conform todo 20ee398e).
    Kill `form serve` after every run.
  - Never put builds or tests on the dev box.
- **Judge audit:** render a failing page before trusting a UI FAIL. Two
  walker false negatives were found that way (conform v0.1.1).
- **Commits in shared checkouts:**
  - Commit by pathspec.
  - For `docs/INDEX.md` and `README.md`, which hold other sessions' edits,
    stage only your own lines via `git hash-object` and
    `update-index --cacheinfo`, then commit from the index.
  - On a non-fast-forward push, cherry-pick in a temporary worktree and push
    from there. Never stash.
- **Lease:** the lease goes stale often. Run `bashy sprint take 723 --owner
  <you>` before checkpointing. The token is in the private evidence directory (`s723/`).

## Held resources

- Claim the gate host lane2 (Sprint 723 S2). Release it, or take it over.
- No worktrees or branches are held. Stories S1 and S2 are accepted.
