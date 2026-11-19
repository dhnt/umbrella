# Sprint 666: human–agent group productivity and fleet autonomy

Primary goal: help humans and agents turn group decisions into verified outcomes with less coordination, rediscovery and supervision.

## Authority and delivery

The operator authorized execution after creating the backlog and explicitly requested coordination with other sprint managers. This supersedes the creation-only restriction in S0. Implementation, independent verification and delivery are required; documentation alone does not satisfy feature acceptance. The committed stories remain authoritative. The managed conductor must reconcile this initial plan against source before staffing and record material decisions on the card.

## Existing capabilities and gaps to verify (S0)

| Stories | Reuse | Remaining delivery |
| --- | --- | --- |
| S1 | Meet events/actions/apply and sprint/todo | Explicit, duplicate-safe action adoption, decision reconciliation and evidence-linked return to the original room. |
| S2–S3 | Meet readers/cursors, inbox and ask | Permission-filtered incremental catch-up, initiative attention view and participation preferences that do not grant authority. |
| S4 | Fleet bindings, weave auth/readiness and resource reporting | Exact binding readiness with reasons/freshness; link existing bound-model issue `todo:5b3c245aae22`. |
| S5 | Handoff portable working-state record, weave recovery and ownership | Evidence/decision continuity, single ownership and explicit reconciliation of uncertain external effects. |
| S6 | Existing claims, resource inventory and wait/request mechanisms | Visible resource queues with cancellation, safe stale-owner handling and isolated candidate evidence. |
| S7 | Meet live-seat routing, bus, inbox and roles | Responsibility-directed communication and observer digests with delivery/fallback visibility. |
| S8 | Meet consultation/chair/poll and brainstorm private-write/reveal | Bounded participation, explicit stopping rules, recorded evidence/dissent and authorized adoption. |
| S9 | KB candidate/validation, verified skills and shaping incidents | Deduplicated evidence-backed learning proposals; coordinate existing feedback work `todo:cdae01f261b1`. |
| S10 | Existing gates, collaboration tests and shared validation venues | Three complete workflows with baseline measurements, exact candidates and raw evidence. |

S0 source check (2026-11-19): `yoke/pkg/meet/apply.go` collects `action` events **and secretary synthesis** into a Markdown block and `--write` appends it to a file; its meeting-level duplicate guard does not adopt tracked work or distinguish authorized decisions. `yoke/pkg/meet/api.go` is the shared CLI/browser write API and `observe.go` has participant/kind filters, while `cursor_test.go` covers per-reader cursors. `yoke/pkg/weave/weave_fleet.go` reports installed and optional auth/probe state with timestamps, but the bound-model issue [[todo:5b3c245aae22]] remains relevant. `yoke/pkg/handoff/record.go` carries continuity and working state across tools/hosts, but its task pointer alone does not reconcile external effects. `yoke/pkg/policy/coord/cli.go` has claim request/release/refresh and fencing epochs, but requests notify holders rather than forming an ordered, cancellable queue. These are interface facts, not feature acceptance. Do not create another coordination store.

| Story | Reuse path and source boundary | Gap and dependency |
| --- | --- | --- |
| S0 | Sprint card, todo store, Meet, weave, handoff, claims | Reconcile all interfaces and active ownership before staffing. |
| S1 | `meet/api.go`, `meet/apply.go`, sprint/todo | Adopt only an explicitly authorized action through a stable action ID, with room/work/evidence links; S0. |
| S2 | Meet event reader/cursors and `observe` filters | Bounded, permission checked since-cursor brief that separates proposals, confirmed decisions and dissent; S0, S1 reference contract. |
| S3 | Inbox aggregation, ask/approval records | Initiative grouping and attention preferences without changing approval rights; S0, S2 grouping. |
| S4 | Weave fleet `--auth`/`--probe`, resource inventory and capability catalog | Exact binding readiness, reason and freshness, with the bound-model issue linked rather than copied; S0. |
| S5 | Handoff record, weave recovery, sprint lease | Candidate/evidence transfer and explicit uncertain-effect reconciliation before retry; S0, S4 binding. |
| S6 | Claim acquire/request/release/refresh and resource reporting | Visible fair queue, cancellation and fenced stale-owner recovery; S0, coordinate S4/S5. |
| S7 | Meet live-seat delivery, bus, inbox and role identities | Responsibility-targeted routing, observer digests, delivery/fallback state; S0, coordinate S2/S3. |
| S8 | Meet poll/ask/chair and private brainstorm reveal | Bounded expert selection and stop conditions, retained dissent, proposal-only conclusion; S0, S1/S7. |
| S9 | KB candidate/validation and skill/shaping gates | Verified outcome proposal with deduplication and provenance; S0, S1/S5/S10; coordinate [[todo:cdae01f261b1]]. |
| S10 | Existing gate and evidence commands on exact candidate | Three raw end-to-end workflows and honest baseline metrics; S1–S7 including S7's lower-priority dependency, S8/S9 where delivered. |

Delivery choices: keep the CLI and human web UI on the shared Meet API; prefer small composable JSON `.bsh` commands/examples and shaping hooks where a Go change is unnecessary, per `docs/comms-strategy.md`. A paraphrased or relayed statement is **unverified** for authorization. Sprint 667 owns signed relay chains and principal-bound critical grants; S666 uses current permission and approval checks. No production release or frozen shell/coreutils change is in scope.

## Sequence and boundaries

1. Complete S0: inspect actual source/import boundaries, record feature gaps, link related work, and coordinate ownership with active managers before touching shared sources or pins. Classify gaps as defects, design choices or another owner's scope. Keep unrelated changes intact.
2. Deliver independent P1 lanes: S1 action adoption, S4 readiness, S5 recovery, and S6 resource coordination. Separate files/packages or sequence overlapping changes. Build S2 and S3 on stable decision/reader interfaces.
3. Complete S7 routing and S8 deliberation and S9 learning when prerequisites exist. S10 depends on S7 despite its P2 priority; its P1 label does not license a premature validation run. Record the dependency decision on the card.
4. Freeze an integrated candidate; independently verify S10 and focused regressions. Close each story only against its own acceptance; deliver pushed subproject commits before forward-only umbrella pin bumps. Complete applicable installed-binary smoke and preserve evidence.

Prefer existing composition, configuration and verified skill mechanisms; add code only for actual gaps. Use public wire contracts for private services. Preserve frozen shell/coreutils migration baselines. No official release or production change is authorized by this sprint. Record newly discovered high-impact product choices before spending implementation effort.

## Gates and evidence

The conductor selects existing package/command gates after S0, runs them independently and records exact source identities and venue roles. All remaining build, test and vet work runs on a claimed test host; none runs on the development host. Reuse relevant passing evidence tied to unchanged commits. Reproduce and classify a regression before fixing it.

Required workflow evidence: (1) agreed action → explicit adoption → tracked assignment → verified result in originating room; (2) interrupted agent → replacement with candidate/evidence continuity and reconciliation before retry; (3) competing agents → queued test-host access with clear ownership and uncontaminated candidate evidence. Include cancellation, stale ownership, changed decisions, permission isolation and uncertain effects where relevant.

Establish baseline completion time, human interventions, repeated reads, failed launches, recovery time and coordination overhead before claiming improvement. Mark unavailable measurements honestly. Worker prose, a matching count or an exit code alone is not verified delivery. Keep blockers, owners, remaining checks and next actions on the sprint continuity record.

## MVP closure and separate reference work

The operator's final scope decision limits Sprint 666 to the group productivity MVP. The required end-to-end outcomes are:

1. A room action is explicitly adopted, becomes an assigned story, and returns a verified result to that same room.
2. A failed worker is replaced with its candidate and evidence preserved, with uncertain external effects reconciled before retry.
3. Competing agents use one test host through one visible owner and FIFO queue, without overlapping claims or mixed candidate evidence.

Existing permission, privacy, cancellation, stale-owner and recovery safeguards remain required. A failure in one of these workflows blocks closure. S0–S9 retain their accepted status and their unchanged broad suites need not run again. S10 records exact candidate identities, raw workflow evidence and honest baseline limits.

The only additional code fix required here is #523: the registered resource and equal-named host alias must mutually exclude lease and attached claims using their physical ledger addresses. The reviewed Yoke producer commit `914168c9` changes seven production lines and carries focused regressions; portable test-fixture commit `07ff1477` is test-only. Verify the exact integrated candidate on a claimed test host, publish the producer only after a passing relevant gate, repin and independently validate the standalone Bashy consumer, then move the umbrella gitlinks forward and verify the installed consumer. Do not claim an interrupted or baseline-red broad run as passing.

Existing identifiers, aliases, resolver behavior and authorization stay in place for this MVP. No UUID schema, backfill or data migration has been shown necessary for #523 or the three workflows. Uniform entity reference and discovery work in existing stories #524–#530, with its preserved source, review findings and run links, belongs to planned inactive Sprint 668. No migration branch is integrated or published as part of Sprint 666.
