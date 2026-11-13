# Sprint 632 master execution plan — shapeable apps phase 1

**Primary goal:** every web action of the eight catalog apps has a bashy verb, each app can be put on outpost's app list through one verb, and the listed bugs are fixed with their root causes recorded.

Operator re-scope 2026-11-13: phase 1 is (1) bashy CLI parity for the shapeable apps, (2) seamless integration with other apps, starting with outpost's app list, (3) bugs. Evaluation E0–E4, the blog variant and the Sprint 631 QA carry-over are deferred to phase 2 and sit on the card at p3. Worker rules: `shapeable-apps-worker-brief.md` (Sprint 632 addendum). Parity rule: `bashy/docs/ui-cli-parity.md`.

## What the code says (verified 2026-11-13)

- notes, board, whiteboard and table custom commands expose only `install/start/stop/status/source`; form, clips and site have action verbs. The parity doc has rows only for whiteboard (stale), form and files.
- bashy's app registry (`yoke/pkg/fleet`, console `/<name>/`) and outpost's (`conf.AppConfig`, `outpost apps add`) are separate; only `site publish-outpost` and vlog bridge them. No catalog app is on outpost's list; files is outpost built-in.
- `outpost apps add --url` drops the URL path (todo `ce971c6f`), and every shaped app is served under a console path prefix, so outpost exposure is blocked until that fix lands.
- `bashy sprint goal link` never stores a first-time link (todo `af8ee492`); the card shows linked stories as uncovered until it is fixed.

## Stories and waves

| Wave | Story | Depends on | Lane |
|---|---|---|---|
| 1 | B0 `ce971c6f` outpost keeps the URL path (p0) | — | claude |
| 1 | A1 `8ab0eb81` parity audit, rows + gaps | — | agy |
| 1 | A2 `57624adf` notes data verbs (sets the verb grammar) | — | codex |
| 1 | S2c `360426ad` files Ace CDN re-check | — | opencode |
| 1 | `af8ee492` sprint goal link first-link bug (yoke) | — | muse |
| 2 | A3 `c2f2f915` board verbs | A2 grammar | opencode |
| 2 | A4 `c49679cb` table verbs | A2 grammar | claude |
| 2 | A5 `876cd327` whiteboard verbs | A2 grammar, S5b | muse |
| 2 | B1 `94f21a18` shared publish-outpost helper | B0 merged + pin | claude |
| 2 | S4b `152dcd98` board telemetry stub, console buildable | — (same fork as A3) | opencode |
| 2 | S5b `88e82436` whiteboard telemetry removal in the pin | — (same fork as A5) | muse |
| 3 | A6 `e736fdb1` form/clips/site gaps | A1 rows | agy |
| gate | S11 `f9f0bc10` no-phone-home gate on every touched fork | — | conductor |

Deferred (p3, goal `phase2-deferred`): E0 `bd375df7`, E1–E4, S10 `bc104437`, Q1 `f839e007`.

## Gate

Per story: the targeted unit tests of the command or package, run by the conductor on the merged tree, plus the story's own evidence. Fork runtime proofs only on the claimed gate venue (never the dev box). Every fork-touching merge also needs `script/no-phone-home.sh <app dir>` with zero unexplained hits. Close gate: goals `parity`, `outpost`, `bugs` green; `phase2-deferred` is not part of the close gate.

## Decisions only the operator makes

- Pushing a subproject `main` and bumping umbrella pins (conductor does it one gated step at a time, after review).
- Any paid or live-service run (none planned in phase 1).
