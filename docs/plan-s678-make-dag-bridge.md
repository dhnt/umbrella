# Sprint 678 — make → dag bridge (plan)

Operator decisions, 2026-11-20:
- Many agents look for a Makefile, and type `make`, before anything else. Meet them there.
- Teach them, and move them over, to `bashy dag`.
- Generate the Makefile from dag.md and give it explanatory comments.

This amends the 11-17 Makefile-removal ruling (todo 5bc29f7f, Sprint 660): a
hand-written Makefile is replaced by a GENERATED forwarder, not deleted outright.

## Gap (verified 2026-11-20 on rc.38 code)

In yoke, which has a dag.md and no Makefile:
- `make help` fails with "don't know how to make help".
- `type make` reports `/usr/bin/make`, while bashy actually runs its own
  coreutils `make` applet.

`bashy dag --list`, `--dry-run` and `--skill DIR` already exist (yoke `pkg/dag`).

## Stories

### S1 fa9fcc8d — `bashy dag --makefile` generator, piloted in yoke

Code: yoke `pkg/dag`, beside `skill.go`.

1. **Output.** `bashy dag --makefile [-o FILE]` writes a POSIX Makefile generated
   from the dag.md in the cwd (or from `-f FILE`). It runs no target body.
2. **Header.** The file opens with a comment that teaches the agent:
   - it is GENERATED from dag.md: do not edit it; edit dag.md and regenerate;
   - tasks live in dag.md, and the native way to run them is
     `bashy dag <target>`, `bashy dag --list`, `bashy dag --dry-run <target>`;
   - `bashy dag --skill DIR` exports an Agent Skill.
3. **One rule per dag target.**
   - Its comment is the target's dag description.
   - Its recipe is `bashy dag <target>` (forward `$(MAKEFLAGS)`-relevant
     variables only if trivial).
   - No logic and no prerequisites: dependency order is dag's job.
4. **Fixed `help` target.**
   - Prints `bashy dag --list`.
   - Then prints a one-line pointer to `bashy dag <target>`, `--skill` and
     `bashy help`.
   - A dag target named `help` takes precedence and is used instead.
5. **`.DEFAULT: ; bashy dag $@`.** Unknown targets reach dag and get dag's
   error, which lists the available targets.
6. **No GNU-only features.** It must run under both the coreutils POSIX `make`
   and GNU make.
7. **Missing bashy.** Each recipe guards with
   `command -v bashy >/dev/null || { echo "requires bashy: https://github.com/qiangli/bashy"; exit 127; }`.
8. **Staleness check.** `bashy dag --makefile --check` exits non-zero when the
   file differs from what would be generated, and says to regenerate.
9. **Pilot in yoke.**
   - Commit the generated `yoke/Makefile`.
   - Add a dag target, or extend `fmtcheck`/lint, that runs `--makefile --check`.
10. **Tests.**
    - Unit tests: the generated text for a fixture dag.md, the `help`
      precedence, `.DEFAULT`, `--check` on a stale file.
    - Smoke test in yoke:
      - `make help` lists exactly the `bashy dag --list` targets;
      - `make -n test` prints the forward without running it;
      - `bashy dag --skill $(mktemp -d)` writes SKILL.md;
      - GNU make (if on PATH) gives the same `help` output.

### S2 d9bf47e9 — no-makefile fallthrough + truthful `type make`

Code: bashy command dispatch, before the coreutils make applet. Coreutils stays
POSIX-only and must not import yoke.

Behaviour is as specified in the story (operator-approved 2026-11-17):
- **Makefile present:** POSIX make runs, unchanged.
- **No makefile but a dag.md:** `make X` runs `bashy dag X`, and the agents'
  usual flags are mapped. `make help` and `make` with no target behave like
  `dag --list`, plus the same one-line pointer.
- **`type make` and `command -v make`** name what actually runs.

Tests:
- unit tests for each mapped flag;
- a directory with a Makefile is byte-identical to today;
- POSIX make conformance is unchanged (coreutils make unit tests).

## Non-goals

- Rolling the generated Makefile out to the other repos, and removing the
  hand-written Makefiles. Both stay in Sprint 660 (5bc29f7f), which will use S1.
- Converting existing Makefile logic into dag.md.

## Delivery

- **Worker:** muse (operator choice), one story at a time, S1 then S2, in its
  own worktree.
- **Process:** root cause/design note first, then targeted unit tests only on
  the dev box (`GOWORK=off`). No full suites, no make-based tests, no push.
- **Conductor:** reviews, re-runs the tests, merges, bumps pins (bashy → yoke
  for S1, then S2).
- **Evaluation:** the worker's performance is logged to the conductor's
  evaluation ledger, for a later band proposal.
- **Release:** none authorized here.
