# Sprint 739 report: tools as a service (TaaS)

*2026-11-28 · manager claude-opus5.5 · 10 of 10 stories closed · plan: `docs/sprint-739-master-execution-plan.md`.*

## Result

A member offers a fleet model, a tool, an agent or a designated folder to their trusted group as a typed tool call. Other members' agents mount and call it on the offerer's machine, and read a folder in place, with no install, config or copy. Every call is metered on both sides, the owner's included, with no price: Sprint 740 adds only payment on top.

To an agent everything here is a tool: `bashy llm call` and the `agent` tool (over `bashy delegate`) one-shot, `bashy offer NAME` to offer, `bashy remote call HOST NAME` to call, `bashy remote add HOST NAME` to put an offer in the agent's own tool list (`bashy mcp tools`), `bashy files share NAME` for a folder (the typed tool `files-NAME`), `bashy offer usage` and `bashy remote usage` for the meter.

Final heads: yoke `744d2263`, bashy (this sprint's last push, see the end), umbrella pins bumped with it. Sprint 742 (bashy shape, yoke `pkg/shape` and `pkg/src`) ran alongside; the two managers posted every merge SHA first and rebased onto each other.

## What each story delivered

| Story | Delivered | Author | Integration |
|---|---|---|---|
| **K1** named peer runs | `PeerShare.Commands` allow-list (empty denies; fixes a pre-existing exposure), `bashy llm peer set --command`, caller `DispatchPeerCommand` | codex-gpt6-sol | clean |
| **F2** folder CLI | yoke `pkg/sharedfiles`: `bashy files share/unshare/shares` (HOME, its ancestors and the bashy home refused without `--force --reason`), `ls/stat/cat/get/link`, `bashy://` links | codex-gpt6.2-astra | clean |
| **M1** one-shot calls | `bashy llm call` (one request through the door, `MODEL@DOOR` included); the typed tools `llm` and `agent` (the agent tool is `bashy delegate --json --read-only`; no new agent verb); delegate reports usage | claude-fable5.2 | trailer corrected |
| **F1** folder tool | the door serves each share as the typed tool `files-NAME` (`ls`, `stat`, `read`, `link`) and a byte route (`os.OpenInRoot`, Range, ETag); outpost unchanged | agy-gemini4-carbon | clean |
| **K3** by reference | peer inputs must be `bashy://` links (host paths refused; fixes a pre-existing hazard), fetched into scratch; artifacts published to `files-offers` as links with size and sha256 | codex-gpt6-sol | clean |
| **K2** offerable set | fleet partition (internal verbs refused), one typed definition per offer with digest and tags; registered commands run on the door through a hidden `offers` tool bound to a pseudo model (the herald pattern) | codex-gpt6.2-astra | repair: 4 regressed tests |
| **K4** offers as apps | one door route per offer, `POST /offers/NAME` (and `?definition`); members admitted by the outpost-signed stamp and relationship with the offer app's own secret; agent token cap through `delegate --max-tokens`; `bashy offer`, `bashy remote call`; `share.go` keeps `require_login` | codex-gpt6-sol | clean |
| **T2** mount | `bashy remote add/remove/list`: a local registered record wrapping `remote call`, typed in `bashy mcp tools`, digest-pinned (a changed definition is refused and names the fix) | claude-fable5.2 | clean |
| **T1** meter | tool, class, unit, units and digest on every door run record; the usage returned to the caller, who keeps a copy; `offer usage` (by member or tool) and `remote usage` (by host or tool); limits count in the offer's unit | codex-gpt6.2-astra | repair: corrupted struct tag |
| **K5** acceptance | `tests/taas-e2e`: the A/O/C scenario in one sealed container (fake satellite, fake model, fake speech-to-text, codex stub) | claude-opus5.5-s588 (author), manager (gate iteration) | 20 gate runs |

## What integration found

Workers ran targeted tests; the manager reran the full packages touched on the combined head, and the e2e ran on the gate lane. Each finding below has its root cause in its commit message.

1. **K2**: four existing tests regressed (a gateway name-branch ratchet, CLI schema goldens, the hidden-tool list, the seeds-off tool set). The worker's verify ran `-run Offer` only. Later briefs required full package runs.
2. **T1**: a struct tag had import lines pasted into it; it compiled and passed tests but failed `go vet` and wrote the usage row's time under the wrong key.
3. **A registered command could not meter seconds**: the record had no unit (K5 author's gap 1). Commands now declare `unit` (call, seconds or bytes) and `output: file:<glob>` for artifacts (gap 4).
4. **A registered command's JSON stdout came back empty**: print mode reads JSON lines as an agent event stream. The offers tool now keeps the command's stdout as its result.
5. **The door had no offer runner, and a folder share registered no app**: `pkg/offer` wires both in its `init`, and the bashy `llm` and `files` adapters did not link it.
6. **`bashy remote call --json` was refused by the front door**: the command parses its argv by hand and declared no flags.
7. **A failed seconds-metered run reported only the missing unit**: the error now names the run's outcome.
8. The rest were harness fixes: the fixture could not shadow the shipped `transcribe` verb (renamed `stt`); the sealed image needs prebuilt adapters; the fake model must be an API model with a key reference; the fake satellite stores share rules; the grant copy names apps by offered name; mounts use `--as` because both hosts share one container; `bashy mcp tools --json` is an envelope; a mounted tool is called by its registered name.

## Evidence

- Unit: the full packages each story touched (yoke `pkg/broker`, `offer`, `cligw`, `fleet`, `toolcmd`, `sharedfiles`, `chat`, `mcp`), `go vet`, and a build of every buildable yoke package, on every merge.
- bashy: full `go test ./internal/agentos` and linux, darwin and windows builds on the Windows test host lane, for the verb mounts and again for the final head.
- e2e: `tests/taas-e2e` green in 34 s with 45 checks, T1 and T2 included (`TAAS_T1=1 TAAS_T2=1`). The raw evidence log is kept privately with the manager.

## Limits a user will meet

- The agent token cap is enforced by `bashy delegate --max-tokens`, which refuses an adapter that cannot enforce it; in the e2e the codex stub refused, so agent metering is covered by unit tests, not the e2e.
- Offer `--limit` counters live in the door's memory and reset when the door restarts.
- After `files unshare` the offer app is gone, so a member gets 404 (unknown app) rather than 403.
- A caller keeps a usage copy only for calls made through bashy; a raw HTTP fetch of an artifact link is counted by the offerer alone.
- The artifact link carries the offerer's OS host name, not a fleet host name. A caller saves a peer door by writing its peers file (no CLI yet). `llm env --from HOST --member` is deferred; use `bashy remote call HOST MODEL`.
- No discovery listing of offers: the offerer posts the printed `bashy remote call` line (`bashy mb`). That listing, prices and credits are Sprint 740.
