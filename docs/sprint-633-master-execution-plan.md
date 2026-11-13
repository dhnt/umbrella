# Sprint 633 master execution plan — `agentic <command>`: self-improving skill-scripts as the calling agent's muscle memory

**Primary goal:** `agentic ssh "connect to host gatehost"` answers in one tool call: the first call forges `ssh.bsh` with a training model and verifies it by running it; the second call runs the script with no model; a failure corrects the script and keeps the fix; every agent on the host benefits.

Operator framing (2026-11-13): reverse the usual tool loop. Instead of a central agent repeating the same probing rounds every session, the request goes to a genie-enabled command that does the rounds once, remembers, and sends back the answer. The rule converged to: **`agentic <command> [request...]` == use the agentic tool to run `<command>.bsh` the bashy way.** Any bashy command may have a Bash# skill-script `<command>.bsh`; if it exists `agentic` runs it, if not a premium model generates it from the command's own help, kb and pitfalls, and it is refined over time (request → run → success returns, error → probe, correct the script, return → repeat). That is software shaping at the micro level. The keyword is the specifier; the rule of thumb (commands with subcommands, skill-scripts) only recommends where it pays; simple commands never need it (`agentic cd ~/` must not forge). The model is per skill-script, not per host, and the request → verified-script pairs are a fine-tuning set later.

Plan of record (research, probes, design): `docs/agentic-command-skill-scripts-design.md` (S6 copies it to `bashy/docs/plan-agentic-command-skill-scripts.md`).

## What the code says (verified 2026-11-13)

- `bashy agentic ACTION` (`bashy/internal/agentos/agentic.go`, 115 lines) runs one action with `BASHY_AGENTIC=1`; `agenticCommand` has rungs for a script path, registered/builtin/applet names, front-door verbs and externals, and lowers a non-zero native result to one `input_required` yield (exit 6). Bash# `agentic {}` / `agentic function` are scope marks only; `agentic ssh ...` parses as a plain command and reaches the verb. No parser change.
- Skill-scripts: `.bsh` = `~~~skill as guide` fence + body (`bashy/examples/cast/cast.bsh`); `bashy skill run --adapt --repair-agent CLI` already repairs a failing fixed-shape skill, verifies under the original contract and effect cap and folds the fix into a host overlay; `bashy skill learn DIR` admits a skill only if it runs here. Store dir `~/.config/bashy/skills` (`yoke/pkg/skills/cli.go` DefaultStoreDir); the forge keeps its own `$BASHY_HOME/agentic` so `bashy skill list` never parses half-made scripts.
- Ledger: `bashy graph observe <kind> <target> --outcome ... --data k=v --json`, `graph recall`, `graph pitfalls` work under a temp `BASHY_KB_DIR` (probed).
- `@guard(effects: "read,exec")` on a function running its argv denies `touch` (126) and `sh -c` (unknown effects), so generated scripts must declare the effects of `outpost`/`ssh` explicitly (probed).
- Training tiers probed on the dev box: vendor tier works (`bashy chat --read-only --agent claude -m ...` answered in 2 s); door tier needs `BASHY_LLM_API_KEY` bound in `secrets.map` (`bashy genie -m door-claude-opus5` refused); tool-free `bashy ycode -m MODEL btw TEXT` rejects the flags (bug story below). MCP sampling is deprecated (spec 2026-07-28) and Claude Code never declared it, so the caller tier is the `input_required` yield: the calling agent's own model writes the script and calls `agentic-forge accept`.
- `bashy connect` is a core verb (terminal attach over outpost SSH); `ssh` is not a bashy verb (external rung). `outpost reach HOST` gives route lan|mesh|cloudbox|offline with stable exit codes and no side effects; elevation is `bashy secret exec <HOST>_SSH_PW=P -- sh -c 'printf %s "$P" | outpost connect --stdin HOST'`.

## Stories and waves

| Wave | Story | Depends on | Lane |
|---|---|---|---|
| 1 | S1 `df69643c` core: resolution ring + worth-it gate + forge hand-off (`--no-forge`) | — | claude |
| 1 | S2 `9ab09216` lib.bsh: store, gates, ledger, envelope | — | codex |
| 1 | bug `e100211d` `bashy ycode -m MODEL btw` rejects the flags (root cause first) | — | muse |
| 2 | S3 `4725a53d` forge run/accept/undo/where + caller-tier yield | S2 | codex |
| 2 | S5 `5efc76fc` exemplars ssh.bsh (superset face) + kb.bsh, stub-outpost tests | S2 | agy |
| 3 | S4 `bafd5252` forge make/refine, vendor + door tiers, `--deep` opt-in | S2, S3, bug | glm |
| 3 | S6 `4a826c0d` packaging: register, dag, defaults row, README, docs copy, kb page | S1–S5 | claude |
| 4 | S7 `f5647e3b` live demo cold/warm/refine on the dev box against gatehost | S6 | conductor |
| p3 | `d7042bd6` follow-ups design only: services, MCP elicitation approval, skill learn, fine-tune export, readline rung 2 | — | backlog |

Shaping hook: the learned `CMD.bsh` is the shapeable artifact (copy-on-write versions, `undo`, human-editable, attested when run); composition note: the forge composes existing verbs only (`bashy check`, `graph observe/pitfalls`, `bashy chat`, `bashy genie`, `bashy commands add`, `bashy skill add`), no new core beyond the S1 resolution hook.

## Gate

Per story: the targeted tests of the package or example (`GOWORK=off go -C examples/agentic test ./...`, `go test ./internal/agentos -run TestAgentic`), `bashy check --agent` clean on every `.bsh`, run by the conductor on the merged tree. S1 also keeps the 3-OS e2e dispatch gate green and the Windows cross-build. Close gate: goals `resolution`, `forge`, `demo` green; `script/scrub-gate.sh` passes (hosts by role only). No full suites and no remote gates in coding sessions.

## Decisions only the operator makes

- Pushing `bashy` main and bumping the umbrella pin (one gated step at a time after review).
- Binding the door credential on the dev box for the door tier; any paid training run beyond the vendor seats already in use.
- Graduating the free-text form into a core verb (`bashy connect "..."`) — not in this sprint.
