# `agentic <command>`: every bashy command gets a self-improving skill-script (design, Sprint 633)

Approved design of record for Sprint 633 (operator session 2026-11-13). The sprint plan is `sprint-633-master-execution-plan.md`; S6 copies this file into `bashy/docs/`.

## Context

Today a calling agent (Claude Code, Codex, a weave worker, genie) reaches a goal
such as "connect to host gatehost" by running many probing rounds itself
(claim, `outpost doctor`, `outpost reach`, elevation from the vault, `outpost
ssh exec`) and re-learns the pitfalls every session; every other agent on the
host repeats the same rounds. The operator's reversal: the request goes to a
genie-enabled command that does the rounds once, remembers, and answers in one
call. Over this session the rule converged to:

> **`agentic <command> [request...]` == use the agentic tool to run
> `<command>.bsh` the bashy way.** Any bashy command may have a corresponding
> Bash# skill-script `<command>.bsh`. If it exists, `agentic` runs it. If not,
> a premium model generates it ("pretraining" from the command's own help, kb
> and pitfalls), and it is refined over time: a request comes, the script runs;
> success returns the result; an error triggers probing, the script is
> corrected, the result is returned; repeat. That is software shaping at the
> micro level: the command learns to perform and to fix its own script, and
> every agent on the host benefits.

Model choice is per skill-script, not per host: the model need not be local;
each script declares its best fit (a registry/door model or a band), and the
accumulated request → verified-script pairs are a fine-tuning set for a small
model later.

### State of the art this builds on (researched this session)

| Finding | Source | Used as |
|---|---|---|
| Procedural memory as script-level abstractions distilled from trajectories; add / validate / reflect / prune; strong-model memory transfers to weak models | Memp (ACL Findings 2026) | the memory IS the Bash# script; a premium model writes it, anything replays it |
| Learn from failures too: distilled pitfalls cut ~3 steps per task | ReasoningBank (Google 2025) | `graph pitfalls` in every refine prompt; failed probes recorded |
| Subagents beat in-context skills when the skill has a clear I/O contract | "Subagents vs Agent Skills" (2026); agent-as-tool pattern | `agentic CMD` is one tool call returning one envelope |
| Tool round-trips are 30-60% of agent token spend | MCP tool-tax studies, Cloudflare Code Mode | one call instead of N rounds |
| Execution-based verification beats model self-report | NL2SH-ALFA (NAACL 2025), LAST-X 2026 | a generated/corrected script is kept only after it ran and passed its contract |

### What exists (verified in code)

- `bashy agentic ACTION` (`internal/agentos/agentic.go`, 115 lines) runs one
  action with `BASHY_AGENTIC=1`; `agenticCommand` already has rungs for a
  script path, registered/builtin/applet names, front-door verbs, externals;
  a non-zero native result is lowered to one `input_required` proposal.
  Inside Bash#, `agentic {}` / `agentic function` are scope marks only
  (`sh/syntax/bashpp_agentic.go`); `agentic ssh ...` as a command line parses
  as a plain command and reaches this verb. No parser change needed.
- Skill-scripts: `.bsh` = `~~~skill as guide` fence + body (`examples/cast/
  cast.bsh`); `bashy commands add` registers; `bashy skill add` catalogs;
  `bashy skill run --adapt --repair-agent CLI` already repairs a failing
  fixed-shape skill, verifies under the original contract and effect cap, and
  folds the fix into the host overlay (`~/.config/bashy/skills`) reused by any
  agent on the host; `bashy skill learn DIR` admits a skill only if it runs here.
- Model paths: `bashy genie [-m MODEL] -- "MSG"` (tool-enabled governed turn),
  `bashy ycode [-m MODEL] btw "TEXT"` (tool-free), registry/door models via
  `bashy model list` (e.g. `door-claude-opus5`, `glm-5.3`).
- Ledger: `bashy graph observe <kind> <target> --outcome success|failure
  --data k=v --json`, `graph recall`, `graph pitfalls` (`yoke/cmds/graph/
  contrib_verbs.go`); `BASHY_KB_DIR` makes it host-local.
- Static/dynamic gates: `bashy check --agent FILE` (bashy-check-v1), `BASHY_AGENTIC=1
  bashy --dry-run -c` manifest, `@guard("effects")` caps (exit 126), attestation.
- Host-reach verbs for the example: `outpost reach|doctor|peers status|connect
  --stdin|ssh exec`, `bashy secret exec`, `bashy claim host:NAME`. `ssh` is NOT
  a bashy verb today (falls to the external rung), `bashy connect` is.

## Design

### 1. Resolution: `agentic CMD ARGS...`

Rod-thin change in `agenticCommand` (core, ~20 lines, the one core touch —
the operator asked for the `agentic` keyword to carry this): before the
existing rungs, resolve `CMD.bsh` in the skill-script ring, first match wins:

1. `$BASHY_AGENTIC_SKILLS/CMD.bsh` (explicit dir)
2. `~/.config/bashy/skills/CMD/CMD.bsh` (host overlay, where learned scripts live)
3. a registered command whose `exec` ends in `CMD.bsh` (examples registered via `bashy-defaults`)
4. embedded `skills/bashy/recipes/CMD.bsh` (shipped, read-only)

Found → `exec bashy --bashsharp CMD.bsh ARGS...` with `BASHY_AGENTIC=1`
(existing script rung). Not found → hand off to the forge (below) with the
original argv; `--no-forge` keeps today's behaviour. Everything else in
`agentic.go` stays.

### 2. The forge: generate, run, refine (examples-tier, no more core)

`examples/agentic/forge.bsh`, registered as `agentic-forge` (and used by the
core hook). Three verbs:

- `agentic-forge make CMD` — pretraining. Prompt a premium model
  (`metadata.model` default from `AGENTIC_FORGE_MODEL`, e.g. `door-claude-opus5`)
  with: `bashy CMD --help --format mcp` (or `bashy commands --agentic` row,
  or `CMD --help` for an external), related kb pages (`bashy kb search CMD`),
  `graph pitfalls cmd:CMD --json`, the skill-script conventions (the fence,
  `@guard`, `--json`, `--no-input`, allowlist = CMD's own subcommands plus the
  verbs the help names), three shipped exemplars. Output: one `CMD.bsh`.
  Gate before saving: `bashy check --agent`, the fence parses (`--skill`
  prints), `--help` exits 0, effects declared ⊆ CMD's atlas effects. Saved to
  the host overlay as version 1; `graph observe forge cmd:CMD --outcome success`.
- `agentic-forge run CMD ARGS...` — the loop: run `CMD.bsh ARGS`; exit 0 →
  return its output unchanged. Non-zero → `refine` once (bounded by
  `--attempts`, default 2) → rerun → return. Always emit `bashy-agentic-v1`
  envelope under `--json` (`source: script|refined|forged`, `version`,
  `duration_ms`, `model`, `exit`, `answer`).
- `agentic-forge accept CMD --from FILE` — the caller-tier return path: run
  the gates on FILE, save it as the next version, rerun the pending invocation
  recorded in the yield (`~/.config/bashy/skills/CMD/pending.json`).
- `agentic-forge refine CMD` — micro-shaping. Prompt: the current script, the
  failing argv, exit, stderr tail, probe transcript (the script's own
  `--probe` output when it defines one), pitfalls. Output: the corrected whole
  script. Same gate as `make`, plus it must pass the failing invocation when
  rerun. Saved copy-on-write (`CMD.bsh`, `CMD.1.bsh`, …); `agentic-forge undo
  CMD` restores; `graph observe refine cmd:CMD --outcome ... --data
  version=N failed_argv=... --evidence <path>` is the ledger.

Model calls are pluggable (`AGENTIC_FORGE_MODEL_CMD`) so tests use a stub;
default is `bashy ycode -m "$model" btw "<prompt>"` (tool-free: the forge,
not the model, runs and verifies scripts). A tool-enabled `bashy genie --`
turn is reserved for `refine --deep` (opt-in; `--yolo` only when unattended).

Safety rules enforced by the forge, not the model: a script may call only its
allowlist (static `bashy check` inventory ⊆ allowlist), declares `@guard` with
effects within CMD's atlas effects, secrets appear only as refs (`bashy secret
exec NAME=VAR --`), hosts by alias, no network beyond what CMD itself has.
Every saved version is attested when run (`skill run` machinery) and
human-readable; a person or any agent can edit it by hand.

### 3. The example: `agentic ssh "connect to host gatehost"`

No `ssh.bsh` exists and `ssh` is not a bashy verb, so the first call forges
one from `outpost ssh --help`, `outpost reach --help`, the kb pages on
outpost ssh (elevation cookie, exec cap, Windows quoting) and
`graph pitfalls cmd:ssh`. The generated `ssh.bsh` is a **superset face** of
the command: it accepts the command's ordinary flags, options and operands
exactly as an agent that already knows the parameters would call them
(`agentic ssh gatehost -- uptime`, `agentic ssh -J jump dev@gatehost`), and
it accepts a sentence (slot extraction by regex, model fallback). Native argv
runs the learned recipe parameterised by those values (probing, elevation
and route choice still wrap the call); a sentence fills the same slots first.
The forge prompt requires both forms in every generated script (usage shows
them side by side), so a caller never has to learn a new syntax. Then:
`outpost doctor` →
`outpost reach HOST` → `outpost ssh exec HOST --timeout 30s -- true` → on
"elevation cookie"/"no TTY": `bashy secret exec <HOST>_SSH_PW=P -- sh -c
'printf %s "$P" | outpost connect --stdin HOST'` → retry → answer
`{route, user, exec: "outpost ssh exec HOST --timeout 10m -- CMD"}`.
Second call: the script runs straight through (no model). When the route
moves or the daemon is old, the script fails, `refine` corrects it (e.g.
adds the mesh-first step or the relay fallback), the fix is kept.

Also shipped as the exemplar in `skills/bashy/recipes/ssh.bsh`? No: the
hand-written exemplar goes in `examples/agentic/exemplars/` and is what the
forge prompt shows the model; the overlay copy is whatever the host learned.

### 3b. Where the training model comes from: three tiers

The operator asked whether the "train" can use the same model as the agent
calling the command. Researched this session: MCP **sampling** (a server
asking the client to run its own model) is deprecated in the MCP 2026-07-28
spec; Claude Code never declared it, Codex and OpenCode have only open feature
requests, VS Code / Copilot CLI are the sole implementers. MCP **elicitation**
(a server asking the client's *user* for structured input) is supported by
Claude Code (since 2.1.76), Codex CLI, OpenCode, Cursor, Copilot CLI and
others, but it reaches the human, not the model. So no protocol lets a tool
borrow the caller's model directly. What every agent CLI does do is read the
tool result and act on it, and bashy already standardises that as the
`input_required` yield (`bashy agentic` lowers failures to one proposal,
exit `ExitInputRequired`; Bash# `return 6`). The forge uses it:

| Tier | `--train` | How the model is reached | Cost | When |
|---|---|---|---|---|
| caller | `caller` (default when no forge model is configured, or `BASHY_AGENTIC=1` and no `-m`) | the forge emits a `bashy-forge-request-v1` yield on stdout: kind `make` or `refine`, the command's help/mcp doc, allowlist, contract, exemplar, pitfalls, failing context, and the exact follow-up call; the calling agent's own model writes the script and calls `agentic-forge accept CMD --from FILE` (gates run, version saved, the original invocation reruns) | none extra: same session, same model as the caller | agentic sessions |
| vendor | `claude`, `codex`, `agy`, … | `bashy chat --read-only --agent X -m PROMPT` (the `skill run --adapt --repair-agent` precedent) | a fleet seat | unattended runs on a host with that CLI |
| door/local | a registry model or band (`door-claude-opus5`, `glm-5.3`, `L3+`, a local pull) | `bashy ycode -m MODEL btw PROMPT` | metered through the door | services, hosts without an agent CLI |

Every tier ends in the same gates and the same overlay, so a script trained
by Claude in one session is replayed by a weave worker on a local model the
next day. Follow-up: when `bashy mcp serve` fronts `agentic`, use MCP
elicitation to put the human approval of a new or changed `.bsh` in the
caller's UI (the shaping approve step), since 13 clients support it today.

### 4. Which commands get a `.bsh`: the keyword decides, the rule of thumb only recommends

The `agentic` keyword is the specifier: whoever writes `agentic CMD` opts
that invocation in. The rule of thumb (commands with subcommands such as
outpost, kb, sprint, llm, the satellite; and skill-scripts) is only a
recommendation of where it pays: tasks that otherwise cost an agent dozens
of turns to get right. Simple commands never need it, and forging one is a
waste of tokens and time (`agentic cd ~/`). So the forge has a cheap
"worth it" gate that spends no model call:

- no `.bsh` and CMD is a builtin, a keyword, or an applet/verb with no
  subcommands and only local effects (`read,write,exec` in its atlas row) →
  run CMD as today, no forge, no yield (`agentic cd ~/` just changes
  directory);
- no `.bsh` and CMD has subcommands, or declares `net`/`cred`/`destroy`, or
  is an unknown external (`ssh`) → forge (per the training tier);
- an explicit `agentic-forge make CMD` always forges, so an operator can
  override the gate for a simple command they want faced.

`CMD.bsh` for a subcommand-rich verb is its "plain-English face": allowlist =
its subcommands. Services (outpost daemon, satellite) can host the same loop
behind their door later; design doc first.

## Files

- `bashy/internal/agentos/agentic.go` (edit): the ring lookup + forge hand-off
  (`--no-forge`), help text; `agentic_test.go` for the resolution order.
- `bashy/examples/agentic/forge.bsh` (new): `make | run | refine | undo | where`.
- `bashy/examples/agentic/lib.bsh` (new): prompt builders, gates (`check`,
  allowlist, effects ⊆ atlas), copy-on-write store, ledger writes, envelope.
- `bashy/examples/agentic/exemplars/{ssh.bsh,kb.bsh}` (new): hand-written
  exemplars shown to the model; `ssh.bsh` is also the live demo's seed.
- `bashy/examples/agentic/register.sh`, `dag.md` (edit/new; the dir already
  holds `actions.bsh`, `summarize.bsh`, `typed.bsh`), `go.mod` +
  `forge_bsh_test.go` (new, own module like `examples/cast`).
- `bashy/examples/defaults/bashy-defaults.bsh` (edit): row
  `agentic-forge|examples/agentic/forge.bsh|read,write,exec,net` near line 100.
- `bashy/examples/agentic/README.md` (new) and `bashy/docs/plan-agentic-command-skill-scripts.md`
  (copy of this plan) + one line in `bashy/docs/INDEX.md`; kb page via `bashy kb add` after it works.

## Implementation steps

1. Probes (read-only): `bashy ycode -m door-claude-opus5 btw "..."` outside a
   session, stdin from `/dev/null` (plain text? exit?); where `skill run
   --adapt` writes its overlay (`yoke/pkg/skills`) so the ring path matches;
   `graph observe ... --json` + `graph pitfalls` shapes under a temp
   `BASHY_KB_DIR`; `@guard` on a function that runs `"${argv[@]}"`.
2. `lib.bsh`: store (resolve/save/undo), gates, ledger, envelope. No model.
3. `forge.bsh run` over an existing script (ring lookup in shell for now).
4. `forge.bsh make` + `refine` with the prompts and the stubbed model command;
   `--attempts`, `--deep` behind a flag.
5. Core hook in `agentic.go` + unit test of the ring order and `--no-forge`.
6. Exemplars `ssh.bsh`, `kb.bsh`; tests with a stub `outpost` on PATH, a stub
   model, temp overlay + `BASHY_KB_DIR`:
   - resolution: overlay beats registered beats embedded; `--no-forge` falls
     through to today's rungs;
   - worth-it gate: `agentic cd /tmp`, `agentic echo hi`, `agentic ls` run
     as today with zero model calls and no yield; `agentic ssh ...` and
     `agentic outpost ...` reach the forge;
   - forge make: stub returns a script → gates pass → saved v1 → run answers;
     stub returns a script calling a verb outside the allowlist / failing
     `bashy check` → refused, nothing saved, exit 1;
   - warm: second run makes zero model calls;
   - refine: stub outpost flips route/cookie → script fails → stub model
     returns corrected script → verified by rerun → v2 saved, v1 kept, `undo`
     restores, ledger has both outcomes;
   - caller tier: with no model configured, `agentic ssh ...` exits
     `ExitInputRequired` with a `bashy-forge-request-v1` yield naming the
     follow-up call; `agentic-forge accept ssh --from FILE` with a good script
     saves v1 and reruns the pending argv; with a bad script it refuses and
     leaves the pending request in place;
   - native argv: `agentic ssh gatehost -- true` runs the recipe with the
     stub outpost and never calls a model; a sentence fills the same slots;
   - secrets never in any saved version; `--json` envelope schema;
   - `agentic ssh` through the real `bashy agentic` binary (e2e tag like
     `commands_e2e_test.go`).
7. register.sh, dag.md, defaults row, README, docs copy + INDEX line.
8. Live check on the dev box with `-m door-claude-opus5`: `bashy claim
   host:gatehost`, `agentic ssh --json "connect to host gatehost"` cold then
   warm; record both envelopes (scrubbed) in the README.

## Verification

- `GOWORK=off go -C examples/agentic test ./...` (stubs only); `go test
  ./internal/agentos -run TestAgentic`; `BASHY_TELEMETRY_QUIET=1 go test -tags
  e2e -run TestE2EAllListedCommandsDispatch ./internal/agentos` (3-OS gate
  still green: no new verb, one changed one); `CGO_ENABLED=0 GOOS=windows
  GOARCH=amd64 go build ./cmd/bashy`.
- `bashy check --agent examples/agentic/*.bsh examples/agentic/exemplars/*.bsh` clean.
- `bashy dag examples/agentic smoke` with `AGENTIC_SMOKE_HOST=gatehost`: cold
  forges, warm answers with `model: none`.
- `script/scrub-gate.sh` passes (role names only).

## Follow-ups

- MCP elicitation approval gate in `bashy mcp serve` for new/changed scripts
  (no elicitation support exists in bashy's MCP server today).
- Services: outpost daemon / satellite host the same loop behind their door
  (`outpost ask "..."`); memory per daemon / per owner. Design doc first.
- `bashy skill learn` admits a stable overlay script as a fixed skill; `graph
  learn`-style promotion of refine failures to kb gotchas.
- Fine-tuning export: request → verified-script pairs per command
  (`agentic-forge export --pairs`); a small model takes over `refine`.
- Sharing overlays between hosts via the kb transfer path, scrubbed.
- Readline: free-text lines at the interactive prompt routed to `agentic`
  (`pkg/ladder` rung 2; `bind` is a stub today).

## Open questions / risks

- The core hook is the one asked-for core change; keep it to resolution +
  hand-off (no generation in Go). Confirm `--no-forge` default for
  non-interactive callers without a model (today's behaviour must not regress).
- Genie's default policy asks on network; the forge therefore uses tool-free
  model calls and runs scripts itself under declared effects. `refine --deep`
  (tool-enabled) stays opt-in until a narrower profile exists.
- `btw` outside a session is unprobed (step 1); fallback is `bashy genie --`
  with a "do not run commands, answer with the script" instruction.
- Dev box has no engines build: live checks use a door model; local-model runs
  belong on gatehost or a droplet.

## 5. Designated feedback inbox per genie-enabled command (operator addition, design)

Requirement (operator, 2026-11-13): other agents must be able to report and
give feedback on a genie-enabled command in real time; the same channel
carries software-shaping requests from humans on the web UI and reports from
agents that are themselves driven by another agent; `refine` consumes all of
it. Nothing new is invented; the forge wires four surfaces that exist:

| Source | Entry | Lands in | Consumed by |
|---|---|---|---|
| human on the web console, or any CLI user | `bashy shape wish CMD "…" [--evidence --expected --reproduction]` (the console wish form is the same call) | the command's shaping candidates/wish log; every forged `CMD.bsh` is registered as a shaped app (`bashy app add CMD --type shaped`, source = the overlay dir) | `refine` reads open wishes; an accepted version is `shape approve`, a bad one `shape undo` |
| the script itself, or a worker that ran it | `bashy shape incident CMD "message" --kind script` | incidents (existing repair policy: root cause before fix) | `refine` reproduces first, then corrects; closes the incident with evidence |
| another agent on the host, real time | `bashy bus publish --topic agentic.CMD '{"who","argv","exit","stderr_tail","host_role","version"}'` (one line, scrubbed) | the host room timeline (no daemon to be down) | `agentic-forge run` drains `bus watch --topic agentic.CMD` before deciding to refine; dedup by (argv template, exit, version) |
| an agent driven by another agent | the forge's own `input_required` yield already carries the report; the driver may forward it with `agentic-forge report CMD --from AGENT …` | same as the bus line | same |
| status to the human | `bashy inbox human send --topic agentic --ref <overlay path> "…"` | the human mailbox | the human acks; nothing waits on it |

Rules: reporters are identified by their bashy principal; reports are
scrubbed (hosts by role, secrets as refs) before they are stored; the same
failure from many agents collapses to one open item with a count; a rate
limit (N refines per command per hour) stops a loop from flooding the forge;
versions produced from a report are still gated (S2) and, when the forge is
fronted by `bashy mcp serve`, a human approval can be asked through MCP
elicitation before the version is accepted. Open points for the design doc
delivered by story D1: cross-host reporter identity, which reports need a
human before acceptance, and whether a wish from the web UI should run the
caller tier (the human's own agent) or the command's declared model.

## 3c. The second exemplar: `agentic oci` / `agentic sandbox` (operator addition)

The gate venue's podman machine has no bashy on PATH, which blocked every
runtime proof in Sprint 632 and has hurt earlier sprints; agents never learn
it. `oci.bsh` is the genie-enabled face of `bashy oci` (alias `sandbox`):
native argv passes through (`agentic oci run --rm IMG CMD`), a sentence fills
slots (`agentic sandbox "run the bash gate in the gate machine"`), and the
script encodes what the kb already knows and keeps learning: put the exact
candidate binary on PATH inside the machine and record where, one podman
machine per host, never the default podman of a host that runs live services,
claim the venue first and release after, apply memory/cpu/pids caps, no
`make` inside the VM. Every failure is a pitfall that `refine` folds into the
next version. Story S5b.
