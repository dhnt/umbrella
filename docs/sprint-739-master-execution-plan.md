# Sprint 739: commands as a service (offer bashy commands to your trusted group)

*Master execution plan · 2026-11-27 · backlog, operator review before start.*

## 1. The gap

In teamwork, one member has what another lacks: an LLM subscription, a video or
transcription provider, a GPU, an installed tool. Today each member has to install
and configure everything locally. In the A/O/C case (O owner and approver, A an
account member with no machine in the mesh, C a contractor with one), C usually
holds the LLM and the tools, while O's host runs the shaping and has none.

The goal: a member **offers** a bashy command to their trusted group, and the other
members **run it remotely on the offerer's machine**, on demand, with no local
install or config. LLM sharing is one case of this; the sprint covers any bashy
command:

- (a) members without an LLM use an offered `llm`;
- (b) a member offers a feature others lack: `video`, `transcribe`, image
  generation;
- (c) any registered custom command (`bashy commands add`).

It works in every direction (C to O, O to C, any member to any member of the
group).

## 2. What already exists (code inspected 2026-11-27)

CaaS generalizes the peer door; it is not a new plane.

| Piece | Where |
|---|---|
| Door: authenticated HTTP front door per host, reachable over the outpost mesh or as the cloudbox satellite app `llm` (credential in the path) | `yoke/pkg/broker/door`, `yoke/pkg/broker/share.go` |
| Per-peer credential (principal `peer:NAME`), deny by default, `share allow/deny`, `revoke`, caps on tokens/day, USD/month, RPM, member check `--email --circle` | `yoke/pkg/broker/peercmd.go`, `peershare.go`, `peerlimit.go` |
| Grant delivery and import | `bashy llm share PEER` (mesh or cloudbox; `--print` for a host it cannot reach) → `bashy llm door import`; consumer peers file `toolcmd/peers.json` (0600) |
| Remote command run on a peer | `bashy tool cmd run --capability X --peer NAME` (`yoke/pkg/toolcmd/peer.go`, `cmd.go:278`), served by the peer's door (`yoke/pkg/cligw/capability.go`) through the slash path, so routing, quota, guards and the reply shape already apply |
| Declared commands as YAML data, typed args, async jobs | `yoke/pkg/toolcmd` (`BindHTTPArgs`, `jobs.go`); capabilities `video`, `transcribe`, `image-generation` already declared (`yoke/pkg/fleet/baseline/tools/*.yaml`) |
| An LLM through a shared door with no config | `MODEL@DOOR` (`broker.ResolveDoorModel`, `model_source.go`), used by genie (`bashy/internal/agentos/genie_external.go:50`) |
| Shaping runs on the owner's host | `yoke/pkg/shape/delegate.go` (headless `bashy delegate`, pinned `tool:model`, env allow-list) |

Gaps between this and CaaS:

1. A peer run selects by `--capability` only, not by a named command.
2. Only vendor-tool commands run, not bashy verbs or registered commands.
3. Results are text only. Video and transcription need input files uploaded and
   output files returned.
4. There is no offer step: the offerer edits YAML and the peers file by hand, and
   a consumer cannot list what a peer offers.

## 3. Design

**Offerer**

```
bashy offer CMD [--to MEMBER | --circle NAME] [--limit ...] [--for 2h]
bashy offer list
bashy offer stop CMD
```

- An offer is a declared ToolCommand with a new runner kind `bashy`, which execs a
  bashy verb or registered command with the bound arguments. It is written to the
  host's offers set. Admission reuses `peer add/share` for the members, the caps
  and the door audit.
- `bashy offer llm` is the special case: it shares the inference routes, which
  already exist.
- `--for` and `stop` bound an offer to the session. Nothing is offered implicitly.

**Consumer**

```
bashy offers [PEER]                                   # what peers offer me
bashy tool cmd run video:generate --peer C -- --prompt ... --in clip.wav
bashy remote C -- video generate ...                  # thin alias
```

- Hint, not magic: when a local command is missing or unconfigured, its error
  names the peers offering it (`also offered by C: bashy remote C -- ...`). LLM
  keeps its existing transparent `MODEL@DOOR` path.

**Execution on the offerer**

- Arguments are bound against the offer's declared schema (`BindHTTPArgs`
  style). Raw shell is never accepted.
- Each run gets a fresh scratch directory. The offerer's workspace and
  environment are not exposed (same allow-list idea as `shape/delegate.go`
  `delegateEnv`). The command runs as the offerer with the offerer's provider
  login, which is the point of sharing.
- Inputs are uploaded into scratch (size cap). Outputs come back as an
  `artifacts` list in the result, downloaded into the consumer's current
  directory. Long runs use the existing async job verbs.
- Authorization is a door token per member, never an OS password. Only members
  of the named circle are admitted, and the caller principal is recorded in the
  door audit.

## 4. Stories

| Story | What | Repo |
|---|---|---|
| **K1** named peer runs | `tool cmd run TOOL:NAME --peer`, selected by name; door listing endpoint `GET /v1/commands` for shared peers | yoke `pkg/toolcmd`, `pkg/cligw` |
| **K2** `bashy` runner kind | offered bashy verbs and registered commands; schema-bound args, scratch directory, env allow-list | yoke `pkg/toolcmd`, `pkg/fleet` |
| **K3** files | input upload, `artifacts` result, consumer download, size caps, async jobs for long runs | yoke `pkg/toolcmd`, `pkg/cligw` |
| **K4** offer verbs | `bashy offer` / `offers` / `remote`: compose `peer add/share/limit/revoke` and `llm share` delivery, an offers file, the "offered by" hint in missing-command errors | yoke `pkg/broker`, bashy |
| **K5** A/O/C e2e (acceptance) | sandbox, fake accounts, fake transcribe provider: C offers `llm` and `transcribe` to the circle; O (no LLM) shapes and A's wish runs on C's LLM; O runs `bashy remote C -- transcribe in.wav` and gets the artifact; a non-member is refused, revoke gives 401, a limit gives 429; O offers to C | bashy (`test-group-shaping-e2e` lane) |

Order: K1, then K2 and K3 in parallel, then K4, then K5. Each story is
delivered on yoke first, then the bashy pin is bumped.

## 5. Non-goals (not in MVP)

- Transparent fallback for non-LLM commands.
- Load balancing across several offerers.
- Container sandboxing of offered runs (`bashy oci`; a follow-up, see Sprint
  738 for the sandbox backends).
- Offers to anyone outside the group.
- Billing.

## 6. Verification and venues

- Unit tests per story on the branch.
- K5 runs in the sandbox e2e on the gate host with fake accounts and fake
  providers, within the e2e minutes budget.
- No paid provider runs.

## 7. Risks

- **Running commands for others on the offerer's machine.** Mitigated by
  declared schemas only, a scratch directory, the env allow-list, deny by
  default, caps, and audit.
- **Cross-owner delivery.** `llm share` pushes over `outpost ssh` to an owned
  host. For a member's host use the cloudbox exposure and `--print` → `door
  import`. K4 records whether that is enough or a member-token push is needed.
