# bashy agent permissions: CRUD+X, effect caps, and the gateway vision

**Status:** design discussion, 2026-11-11. Nothing is implemented and no sprint is filed.
**Guidelines applied:** KISS/MVP, rod not fish, Unix philosophy, software shaping.

## 1. The question

Can bashy have consistent, CLI-level authorization for agents? An operation would be classified as **create / read / update / delete / execute** (CRUD+X), and a principal could run it only if it holds those operations. The canonical example: `rm` is a delete, so only agents allowed to delete may run it.

The classification could key on the command, a subcommand, a flag or an option. In every case it comes from a **predefined matrix** and is never decided ad hoc.

## 2. What bashy already has (survey)

There are 13 separate guard mechanisms, but no single policy gates every agent command. The relevant ones:

| Mechanism | Where | What it does |
|---|---|---|
| Command Atlas effects | `yoke/pkg/atlas/atlas.go` (atoms `:137-149`, assignments `:1487-1745`) | 11 effect atoms per command: `pure read write destroy net exec cred priv remote persist spend`. Example: `destroy` = `dd rm shred truncate unlink …`. |
| Atlas reversibility | `atlas.go:164-196` | `readonly idempotent reversible compensable irreversible`. |
| @guard cap | `bashy/internal/agentos/audit.go:98-125`; `yoke/pkg/policy/advice/cap.go` | Refuses with exit 126 when a command's effects exceed the cap. Unknown commands are denied. Caps only narrow (`WithCap` intersects). |
| @effects | `decorators_std.go:252-280` | A function declares its effects. This also classifies commands the Atlas does not know. |
| @confirm / approvals | `confirm.go` | High impact (`destroy spend cred priv` or unclassified) needs a human yes. Headless runs go to the `bashy approve` queue. |
| MCP `--allow` | `yoke/mcp/policy.go:40-80` | Refuses `destroy spend cred priv` unless granted. Script and session tools are tagged only `exec`. |
| Dry-run | `dryrun.go` | Shell-level preview. Destruction analysis covers `rm` only. |
| Per-tool `--dry-run` | `coreutils/tool/effect.go` | 12 coreutils tools gate mutations through `rc.Effect`. |
| Adapter rows | `yoke/pkg/fleet/baseline/adapters/*.yaml` | Argv-prefix matched (`kubectl apply`). They use their own effect strings (`fs.delete`, `remote.write`), which are not validated. |
| AWS op classes | `yoke/external/aws/services.go` | Read/write/dry-run per AWS service. This is the only per-operation table. |
| Shaped-app boundary | `yoke/pkg/shape/boundary` | The only path-level read/write/exec guard, and only for shaped apps. |
| contain / limit / host floor | `contain.go`, `limit.go` | Network isolation, resource floor. |
| Claim / weave guards | `coord.go`, `weaveguard.go` | Git-write coordination between agents. |

**Key facts**
- **Granularity.** Effects are per `argv[0]` and are the **worst case** over all flags. `git status` and `git push` are classified the same. The Atlas says outright that per-invocation refinement does not belong in it (`atlas.go:156-160`).
- **Identity is never used to authorize.** The principal comes from env (`BASHY_PRINCIPAL`, `BASHY_AGENT_ID`/`BASHY_AGENT`, harness markers) via `principal.Resolver.Self` (`yoke/pkg/principal/resolve.go:46`). No guard grants or denies by who the agent is. Caps come only from decorators, dag targets or `BASHY_ADVICE`.
- **There is one deny point already.** `auditHandler` sits in the observing chain, so it covers both in-shell commands and front-door `bashy <verb>`.

**Gaps found**
- **A.** The deny check's `effectsFor` (`audit.go:73`) skips registered custom commands, so it treats them as unknown. @confirm does consult them, which makes the two paths inconsistent.
- **B.** `find -exec` and `xargs` exec children directly and bypass the ExecHandler (todo `631dee43ad59`).
- **C.** There is no session-wide cap per agent.
- **D.** MCP script and session tools hide the effects of the commands inside them behind `exec`.
- **E.** Redirections (`> f`) are not classified.
- **F.** `coordHandler` is defined but never wired in.

## 3. Option considered: a full CRUD+X matrix

The first design took the request literally.

**Ops vocabulary**
- Five letters, `crudx`, written like `rwx` mode bits.
- By default they are a projection of the Atlas effects:

  | Atlas effect | Ops |
  |---|---|
  | `read` | `r` |
  | `write` | `cu` |
  | `destroy` | `d` |
  | `exec` | `x` |
  | `pure` | none |

- An unknown command maps to `?`, which needs `crudx` (fail-closed).
- `net cred priv remote spend persist` stay as Atlas atoms.

**Predefined matrix**
- An embedded YAML baseline with argv-prefix rows (longest match wins, reusing `adapt.Build`). Flag predicates add ops, and delegator rows (`find`, `xargs`, `env`, `timeout`) classify their inner command recursively:
  ```yaml
  - match: [git, push]
    ops: u
  - match: [sed]
    ops: r
    flags: {"-i,--in-place": u}
  - match: [find]
    ops: r
    flags: {"-delete": d, "-exec,-execdir,-ok": x}
    inner: find-exec
  - match: [xargs]
    ops: x
    inner: tail
  ```
- About 30 seed rows: read-only subcommands, write subcommands, in-place flags, mixed commands (`cp`=`cu`, `mv`=`cud`), and the delegators.
- **Invariant:** a row may only narrow the Atlas worst case.
- An operator-only overlay directory can add rows for new CLIs.

**Policy**
- A plain text file, `~/.config/bashy/perm/policy`, with lines of `principal-glob  ops`. The first match wins.
  ```
  claude*  crudx
  codex*   cru-x
  *        r---x
  ```
- No file means no enforcement. Writes to the policy directory are always denied in agent mode.

**Enforcement and verb**
- One check, `perm.Classify(argv)` plus `perm.Allowed(principal, ops)`, called from `auditHandler` and from the `OpenHandler` for redirections. A denial exits 126.
- A small verb: `bashy perm check -- ARGV`, `bashy perm show`, `bashy perm rows`.

## 4. Honest assessment: overkill today

The idea is sound, but the full matrix costs more than it delivers today:

1. **It is not security yet.** Agents run as the operator's OS user and also have other shells. An agent that wants to get past the matrix can unset its identity env, edit the policy file, or run `/bin/rm` from Python. Real enforcement is the OS: a separate uid, `contain --fs repo`, a podman sandbox. A command-level matrix only guides a cooperative agent, so it must be cheap.
2. **It duplicates what exists.** The Atlas already tags `rm` as `destroy`. @guard already denies with 126, and @confirm plus `bashy approve` already handle high-impact commands. A second vocabulary (`crudx`), a second table and a second verb would be parallel machinery for the same concept.
3. **Create vs update adds little for a shell.** `> file`, `cp` and `tar -x` are both. The distinctions that matter for authorization are read / write / destroy / exec / net / cred / priv / spend, and those already exist.
4. **The matrix never ends.** Every new CLI needs rows. A wrong row produces a false deny, and agents learn to route around denials. That is worse than no table.

## 5. Recommended MVP (when built)

**Bind the existing @guard cap to the principal. Add no new vocabulary.**
- **Policy file.** `~/.config/bashy/policy`, with lines of `principal-glob  effects`, written in Atlas vocabulary and parsed by the existing `advice.ParseCap`:
  ```
  claude*  pure,read,write,destroy,exec,net
  codex*   pure,read,write,exec,net
  *        pure,read,exec
  ```
  - The first match wins.
  - No file or no match means no cap, so behavior is unchanged and the policy is opt-in.
  - The parser refuses unknown extra columns, so a future path-scope column cannot be misread by an old binary.
- **Install.** At session start, put the cap on ctx with `advice.WithCap`, on the in-shell runner, the front-door path and the MCP runner. Decorators can still only narrow it.
- **Close the real gaps:**
  - **A:** one shared effect lookup for @guard and @confirm, including registered commands.
  - **B:** classify the child commands of `find -exec` and `xargs` before exec.
- **Visibility.** The denial message names the principal, the missing effect and the policy line. The effective cap is shown through the existing `bashy inspect context --json`, so no new verb is needed.
- **Result.** The `rm` example works: a principal without `destroy` gets exit 126.

## 6. The vision: bashy as the sole gateway

Eventually bashy may be the **only** way agents reach the platform and OS: the bashy CLI locally and bashy MCP remotely. On that day, enforcement stops being cooperative, because the agent has no other way to exec. The deferred pieces then earn their cost:

- **Argv refinement rows** for the cases where the worst-case-by-name rule gives false denials, added one row at a time from observed denials. The first likely one is `git status` vs `git push`.
- **Path-scoped rules** such as "destroy only under the repo", built on `contain --fs repo` (todo `64b1b2b1128a`).
- **An `ask` verdict** that routes to the existing `bashy approve` queue instead of a hard deny.
- **The MCP principal** taken from the authenticated client rather than env.
- **Per-call classification on the remote gateway** (see §7).

The MVP is chosen so it does not block any of these. It uses the Atlas vocabulary, sits at the single deny point, and has a policy format that can be extended.

## 7. Prior art: HTTP method semantics (researched 2026-11-11)

The **IANA HTTP Method Registry** (last updated 2026-06-17) classifies each method by two properties, **safe** and **idempotent**, rather than by a CRUD matrix.

**Core methods (RFC 9110, plus PATCH from RFC 5789):**

| Method | CRUD sense | Safe | Idempotent |
|---|---|---|---|
| GET | read | yes | yes |
| HEAD | read (headers only) | yes | yes |
| OPTIONS | read (capabilities) | yes | yes |
| TRACE | diagnostic | yes | yes |
| POST | create / any processing | no | no |
| PUT | create or replace | no | yes |
| PATCH (RFC 5789) | partial update | no | no |
| DELETE | delete | no | yes |
| CONNECT | tunnel | no | no |
| **QUERY (RFC 10008, June 2026)** | **read with a body** | **yes** | **yes** |

**Recent change: QUERY.**
- RFC 10008 (June 2026, Proposed Standard) is the first new general-purpose HTTP method since 2010. It is by Reschke, Snell and Bishop, from `draft-ietf-httpbis-safe-method-w-body`.
- It carries a request body like POST but keeps GET's semantics: safe, idempotent and cacheable.
- `Content-Type` is mandatory.
- It adds the `Accept-Query` response field, which advertises the query formats a resource accepts.
- It replaces two workarounds: POST-as-search, which loses cacheability and safety, and GET with oversized URLs.

**Other registered methods (WebDAV / DeltaV / bindings).**
- Safe: PROPFIND, REPORT, SEARCH.
- Idempotent but not safe: ACL, BIND, CHECKIN, CHECKOUT, COPY, LABEL, MERGE, MKCALENDAR, MKCOL, MOVE, PROPPATCH, REBIND, UNBIND, UNLOCK, UPDATE, VERSION-CONTROL and others.
- Neither safe nor idempotent: LOCK. PRI is the HTTP/2 connection preface, not a real method.

**Takeaways for bashy**
- HTTP authorizes and caches on **method plus two properties**. That is a smaller model than CRUD+X, and it has stood the test of time.
- The Atlas already carries the same two properties. Reversibility `readonly` corresponds to *safe*, and `idempotent` to *idempotent*. bashy needs no new vocabulary to talk about "safe reads" vs "mutations".
- When the remote gateway (bashy MCP/HTTP) needs per-call authorization, map each call to a method class: safe read → GET/QUERY, create → POST/PUT, update → PATCH, delete → DELETE. Derive the class from Atlas effects plus reversibility rather than writing it by hand. QUERY fits naming read-only structured operations such as search, `kb search` and `inspect`.

**Sources**
- IANA HTTP Method Registry: https://www.iana.org/assignments/http-methods/http-methods.xml
- RFC 10008 coverage (InfoQ): https://www.infoq.com/news/2026/09/http-query-method/
- Draft lineage: https://datatracker.ietf.org/doc/draft-ietf-httpbis-safe-method-w-body/
- RFC 9110 (HTTP Semantics), RFC 5789 (PATCH), RFC 7237 (initial method registrations)

## 8. Decisions and open questions

**Decided**
- No CRUD+X vocabulary and no matrix now.
- The MVP is a per-principal effect cap in Atlas vocabulary.
- Refinement rows and path scope wait for the sole-gateway vision.

**Open**
- When should the MVP be scheduled?
- Should the policy become default-on under `BASHY_AGENTIC`, and if so, when?
- Should MCP get its principal from the authenticated session, and when?
