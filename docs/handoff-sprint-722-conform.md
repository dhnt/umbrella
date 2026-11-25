# Handoff: Sprint 721 closed → Sprint 722 (dhnt/conform, then spec → source)

*2026-11-25 · from the Sprint 721 conductor · warm handoff (operator request).*

## Start here (reading order)

1. `docs/conform-plan.md`: the Sprint 722 plan, including the 2026-11-25
   rescope section (Phase A build conform, Phase B the spec → source
   experiment, with the reviewer's design fixes).
2. `docs/shapeware-spec-v0.md` section 19: "shaping is certification"
   (proposed v0.2). It maps the POSIX certification practice to shaping rules
   and adds CLI first, the CONTRACT.md format, and equivalence, not identity.
3. The Sprint 721 thread (`bashy sprint show 721`): every operator decision of
   2026-11-25, in order.
4. The Sprint 722 card (`bashy sprint show 722`): rescoped title, goal and
   acceptance.

## Operator rules for Sprint 722

- **Review before start:** present the plan and confirm with the operator
  before assigning anything.
- **The first story creates the public repo `github.com/dhnt/conform`.** The
  operator owns the `dhnt` org. Check that the `gh` login can create repos
  there.
- **Equivalence is behavioural.** Measure the artifacts' behaviour, never the
  artifacts. Similarity scores are diagnostics only.
- **CLI first.** The CLI contract is the golden standard. A thin UI gate
  (DOM inventory read by the shipped walker, plus a few real interactions)
  checks UI→CLI parity.
- **The suite ships with bashy as an invariant**, usable by agents while they
  build and by graders when they certify. Only hidden assertion data stays
  with the grader.
- **Models for Phase B:** the cheapest L3 binding per vendor:
  - claude-sonnet5
  - codex-gpt6-luna
  - agy-gemini3.8-flash
  - muse-spark1.2
  - opencode-glm-5.3-flash

  Run n=3 each, in small batches with a gate between batches, rerunning only
  the affected cells after a harness or venue glitch.
- **Results go to a bashy viewer book** (the operator reads there).

## Inputs ready for Phase A

- **Contract prototype:** agent-bench branch `salvage/s721-p2b-wip` (a6a90e23).
  It has `packs/shapeware/t4-lifecycle/` (`CONTRACT.md`, `grader/grade.py`,
  reference) and `packs/shapeware/grader_lib.py`. Its `selfcheck.py` is
  broken: it still references the removed t3 `feature-spec.yaml`.
- **Pack infrastructure** (on agent-bench main eedad82): `packs/shapeware`
  (t1–t3), the arm wiring and the self-check. This is the harness Phase B can
  reuse.
- **The reference app:** bashy `examples/desk/form` on main, in the shapeware
  v0.1 layout:
  - SKILL.md, the `dag.md` lifecycle, and `features.yaml` with acceptance
    lines in CLI form;
  - `checks/acceptance.bsh` and `checks/candidate.bsh`;
  - `shaped.json` with a `server.digest` core pin (yoke `appserver`
    `Server.Digest`, d617ba6a);
  - `form add --open`.

## What Sprint 721 delivered

| Goal | Story | Landed |
|---|---|---|
| g1 skills read `metadata.type` | yoke cb1a95c4 | yoke 2551a847 |
| g2 `bashy dag` runs in-process on a fresh HOME | bashy 117bbf2c | bashy f0605535 |
| g3 Markdown `@effects` cannot raise a shapeware cap | yoke 52bf65e9 | yoke f1b0c1c8 |
| g4 shapeware units without declared effects run read-only | yoke bda57930 | yoke aa30ef9a + 086d2bed |
| g5 form flags, rebuild, owner key, `--timeout`, store isolation | bashy 64ef2626 | bashy 06dfd56c |
| g6 todo `known` status (#3230 is KI-1) | cc4a1a40 | yoke ed1e6417, bashy 3f5f3190 |
| g7 form as shapeware (implementation) | bashy 9643d77f | bashy b8a10a29, 6906a25f, 97e7d5c3 |
| g7b measurement pack | agent-bench df3c2212 | agent-bench eedad82 |
| g7c pack follow-up | agent-bench 7b3b2ec4 | wontfix: superseded by 722 |

Umbrella pins at close: e9647e4a3.

## Open items carried forward

- **bashy todos:**
  - fd7a7738: viewer rebuild on unpublished desk modules, and its sprint-card
    parse (moved to 722);
  - 90a9343b: `form answer` cannot set multi fields; KI-1's tracked defect
    (standalone);
  - dd30a16e: hint test inherits `BASHY_HINTS=off` (standalone);
  - 9968c20f: MCP typed-tool test fails on the gate lane, cause pending
    (standalone).
- **yoke todo 4c7cada3:** agenthub jq `--arg` test under the bashy shell
  (pre-existing).
- **bashsharp → yoke pin drift:** pre-existing (57ea4c79); bump with the next
  yoke pin round.
- **Follow-up ideas (not filed as stories):**
  - desk-kit in-page probe (DOM snapshot plus recorded `/api/action` calls,
    compared with the CLI);
  - port the runner and walker into bashy core (covered by 722 story 5);
  - a drift metric and a regressions-introduced metric (deferred
    measurements).

## Venue notes (learned in 721)

- **Builds and heavy tests** run on the gate host lanes
  (`/root/lanes/gate-lane.sh env` in its Linux distro, lane claimed via
  `bashy claim`), never on the dev box. Run yoke tests under a real bash with
  the full PATH: the bashy shell's built-in `jq` lacks `--arg`.
- **agy sessions end at 40 minutes** (exit 3, WIP kept). Keep agy stories
  under about 30 minutes, and keep heavy verification out of the worker
  session.
- **Landing worktrees:** accepting stories with `--repo` pointing at a landing
  worktree registers it as a story root. The next assign then fails with
  "resolves to 2 stores". Remove landing worktrees when done.
- **`src pr verify`** sets HOME and TMPDIR to the clone root. Go ignores a
  `go.mod` in the temp root, so checks must isolate TMPDIR (see
  `checks/go.bsh`).
