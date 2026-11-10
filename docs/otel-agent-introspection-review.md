# OTel introspection for agentic tools — review of record

Reviewed 2026-11-10 on the dev box, against the running code and live stores.
Question: what does bashy offer an agentic tool to introspect its own
problems, during and after a session, for the purpose of self-healing and
self-enhancement? Companion to `bash-command-invocation-counts.md`, which
records where the telemetry actually lives.

## The loop this is measured against

Self-healing needs five stages to connect: **detect** a failure, **explain**
it, **recover** from it, **learn** what worked, and **reuse** the lesson next
time. Each stage below names the surface, the store it reads, and whether it
works for a bashy session today.

| Stage | Surface | Reads | Works for a bashy session today? |
|---|---|---|---|
| Detect, live | space-time advisor hints on stderr; `service.status` state-change rollups; coach intervention spans | the failing command's own result; status state machine; tool-call stream | yes |
| Detect, post | `bashy otel failed`, `bounds`, `guessed`, `cost`, `why-slow` | VictoriaTraces and VictoriaMetrics only | no: every verb returns 0 matches |
| Detect, post | `bashy graph history --failed --since D --episode E` | execlog, 91 days | yes, verified live |
| Explain | `why-slow` trace tree; `bound.*` and `value.*` spans | the stack | only for outpost HTTP spans |
| Recover | `bashy skill run --adapt --repair-agent` | the skill's own contract and effect cap | yes, but reads no telemetry |
| Learn | `kb observe`, `kb validate --from-gate`, `kb note add --candidate`, `kb retro`; execlog-to-kb pipe; `graph pitfalls` | kb journal events; execlog bigram transitions | yes, by hand |
| Reuse | host-local skill overlays; kb pages; `bashy kb context --for` | kb and skill stores | yes |

## Measurements behind the table

| Fact | Value |
|---|---|
| `bashy otel failed` / `bounds` / `guessed` / `cost` against the live stack | 0 matches each |
| Query the `failed` verb runs | `name:exec*`, one-hour window, traces backend |
| Exec error spans in the spool that day | 1,677 (`status_message` is `exit N`, nothing else) |
| Exec spans carrying `agent_principal` | 6,455 of 25,848 |
| Exec spans carrying an episode, turn or parent span id | 0 (each exec span is its own root trace) |
| Callers of `telemetry.BoundHit` / `telemetry.Provenance` | 2 (`pkg/chat/coach.go`, `pkg/sota`) |
| Non-test code implementing `TRACEPARENT` propagation | none |
| `graph history --failed --since 6h` | answers correctly from execlog |
| Inputs the skill repair loop reads from execlog or spans | none |

## Findings

1. **The post-session OTel verbs are blind to bashy.** Every verb queries
   the stack; exec spans never leave the file spool. The one real
   post-session surface is `bashy graph history`, which answers *what ran
   and what failed*, not *why* or *what fixed it*.
2. **Exec spans are flat.** No parent, no episode, no turn. Without a
   trajectory, `why-slow` and any error-to-recovery classification cannot be
   computed from OTel even after the spool is drained. The `gen_ai.turn`
   parenting, `TRACEPARENT` propagation and benign-probe classification are
   designed in `agent-turn-recovery-and-bashsharp-kb-plan.md` and tracked on
   Sprint 590; they are not duplicated here.
3. **Error spans say almost nothing.** `exit N` is the whole message. A
   failed `grep` and a failed `go test` look alike.
4. **Recovery never consumes telemetry.** The skill repair loop is the one
   genuine self-healing mechanism and its shape is right: a headless agent
   proposes steps, the original contract and effect cap gate acceptance, the
   fix is saved as a host-local overlay every agent brand reuses, promotion
   is human-reviewed. But it fires only on a skill contract failing, and
   nothing hands it a failed command trajectory.
5. **Learning is manual and address-only, by design.** The execlog-to-kb
   pipe carries a claim plus an address, never records. `kb validate
   --from-gate` needs an explicitly recorded gate event. The one automatic
   learner, the execlog transition bigram, powers next-command hints, not
   pitfalls.
6. **Bounds and values barely exist.** With two callers, `otel bounds` and
   `otel guessed` would be nearly empty even with the drain in place.

## What is genuinely strong

The execlog: 91 days, structural redaction, canonical templates that make
counting possible, per-episode filtering, visible lost and malformed tallies.
The spool's file-first design, which loses nothing while the stack is down.
The status rollup and the coach, which intervene at the producer seam rather
than mining afterward. The skill overlay model, which is the correct shape
for self-enhancement.

## Bridging the gaps — Sprint 611 stories

Sprint 611 (epic lern-psic, uuid `7de44c27-d277-58b6-b42d-e5fabc9d668f`)
carries the stories. Ids are the story files' `id:` in each repo's
`docs/todo/`.

| Gap | Story | Repo | Kind |
|---|---|---|---|
| VictoriaLogs empty: outpost never installs its slog bridge | `1003a2cac080` | outpost | bug |
| Exec spans never reach the stack | `12e9009d3244` drain the span spool into VictoriaLogs | yoke | feature |
| Verbs blind to bashy (finding 1) | `0d43fd1f9d65` answer `failed`/`bounds`/`guessed`/`why-slow` from spool and execlog when the stack has no exec spans | yoke | feature |
| Error spans say nothing (finding 3) | `742fd57377db` exec error spans carry episode, principal, template and a scrubbed stderr excerpt | yoke | enhancement |
| Recovery reads no telemetry (finding 4) | `55730ebaf952` hand a failed command trajectory to the repair loop | yoke | feature |
| Bounds and values empty (finding 6) | `2568c9bf9ff3` instrument the limits that actually bind | yoke | enhancement |
| Learning is manual (finding 5) | `f8832a5cfe98` repeated failures become kb pitfall candidates automatically | yoke | feature |
| Spans are flat (finding 2) | Sprint 590: `TRACEPARENT`, `gen_ai.turn`, benign probes | yoke | not duplicated |

Order that closes the loop: spool drain and local-store fallback first (an
agent can then see its own failures after the fact), Sprint 590's turn
parenting and benign classification next (failures become trajectories),
then the repair trigger and automatic pitfalls (trajectories become fixes and
lessons).

## Reproduce

```bash
bashy otel failed --since 6h                      # 0 matches for a bashy session
bashy graph history --failed --since 6h --limit 20
jq -r 'select(.status=="Error") | .status_message' ~/.agents/otel/spool/spans.jsonl | sort | uniq -c
jq -r 'select(._msg|startswith("exec ")) | keys[]' ~/.agents/otel/spool/spans.jsonl | sort | uniq -c | sort -rn
```
