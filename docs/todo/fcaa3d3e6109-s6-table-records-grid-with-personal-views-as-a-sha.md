---
id: fcaa3d3e6109
kind: feature
title: 'S6 table: records grid with personal views as a shapeable custom command'
seq: 212
status: done
priority: p2
labels:
    - shaping
created: 2026-11-13T11:33:42.183391Z
weave: 54
assignee: codex-gpt6-sol
sprint: 631
sprint_id: c3371fe2-016d-501e-8cf4-fb570a3cca03
sprint_title: 'Shapeable apps: fork-or-build first batch'
origin: shape
shape:
    - app: table
      candidate: 251d3ed9a6a7fd62
      version: 73a9581dfe7bf7a23b9d2cd8f82be8ad400c9b1e
      actor: codex-gpt6-sol
      represented_user: device:requester
      evidence: shape-evidence:73a9581dfe7bf7a23b9d2cd8f82be8ad400c9b1e
    - app: table
      candidate: fe7c0085088c2a45
      version: 85d4e5af6e743929629bd2af524e1bd3d1710289
      actor: codex-gpt6-sol
      represented_user: device:requester
      evidence: shape-evidence:85d4e5af6e743929629bd2af524e1bd3d1710289
closed: 2026-11-13T14:26:49.158395Z
closed_by: claude-opus5.5-s631
---

READ docs/shapeable-apps-worker-brief.md FIRST (rules, shaping contract, done means). Scope: Linux + web UI only this sprint. Fork-or-build rule: permissive license only (MIT/Apache-2.0/BSD/ISC, LICENSE file read, no open-core ee/), >=1k stars, maintained -> fork + make shapeable; else build. Ships as a custom command in bashy/examples/<job>/, never core. Neutral job-only wording in public files. Candidate review: private spec of Sprint 631. Done = shaping demo (wish, candidate, verify, preview, approve, undo; visible only to the requester) + license re-verified. Base: gristlabs/grist-core (Apache-2.0); fallback Baserow MIT core only. Uses the S3 template.

TEMPLATE (S3, accepted 2026-11-13): copy bashy/examples/notes (notes.bsh install/start/stop/status/source, pinned fork under qiangli/<name>-shape, install-time pin + LICENSE + no ee/ checks, web-prefix.patch, shaped.json, contract.bsh, checks/, register.sh, notes_test.sh). Also run script/no-phone-home.sh on the pinned source and explain every hit; remove third-party telemetry and use bashy OTel (owner-only, env-gated).

VENUE (conductor 2026-11-13): a demo container ran on the dev box during run #49; the conductor stopped and removed it. Runtime/container proof only on the claimed gate host; dev-box container evidence does not count. If no gate host is available, finish code + unit tests and mark the runtime proof open.

RELAUNCH (conductor 2026-11-13): run #49 was stopped for running containers on the dev box (venue rule, see brief). Start from bashy branch salvage/s6-table-run49 (9f2570c3: examples/table wip, fork qiangli/grist-core-shape @a3c557a). Linux runtime proof only on the claimed gate-linux resource; otherwise finish code + unit tests and mark the runtime proof open.

## Worker evidence (2026-11-13)

- Fork: `qiangli/grist-core-shape` at `a3c557ac1bc4bd55b9b9d4333842bec255586ff4`. The pinned `LICENSE.txt` was read as SPDX `Apache-2.0`. The upstream GitHub API reported 12,092 stars, an active repository, and a 2026-11-13 push. No `ee/`, `premium/`, `enterprise/`, or `ext/` directory was accepted by the install build.
- Source scrub: `script/no-phone-home.sh` reported 1,410 broad hits on the pinned source and 1,408 after the patch. The latter comprise 773 application references, 338 locale strings, 289 test references, seven Storybook references, and one binary test fixture. The patch removes the vendor telemetry and tag-manager transports and disables version lookup routes. Other application hits are local telemetry/update symbols, user-opened support links, or optional integrations; locale, test, Storybook, and fixture matches are inert. Owner OTLP is opt-in through `OTEL_EXPORTER_OTLP_ENDPOINT`.
- Targeted checks: `bash table_test.sh`, `bash -n` on the command scripts, Linux amd64 Go adapter cross-build, source pin/license/community checks, and `git diff --check` passed.
- Claimed Linux gate: the community `yarn install --frozen-lockfile` and `yarn build:prod` completed under a 4 CPU/3 GB cap. A capped `--network=none` runtime served HTTP 200 HTML with the shaped CSS link; the server log reported telemetry off. The container, build tree, and task image were removed, and gate claims released. The earlier dev-box container run is not counted.
- Shaping lifecycle in an isolated source fixture: candidate `fe7c0085088c2a45` changed the requester's grid CSS; `shape verify` passed, `shape preview` issued a requester-scoped URL, `shape approve` activated revision `85d4e5af6e743929629bd2af524e1bd3d1710289` for `device:requester`, `device:other` stayed on base `13b0a1868fcc262d781e114d8851968a2749e430`, and `shape undo` restored the requester to base. A first fixture candidate failed because an ignored community marker was absent from the verifier snapshot; the installer force-adds that marker.
- Open: the preview URL was not rendered in a paired browser. The lifecycle's scoped activation was checked through the CLI; the web preview needs a paired-browser assertion before this story meets its full done condition. Commits: bashy `3260ebc0`, umbrella pin `e5730e7e`; neither was pushed.
