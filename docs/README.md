# Umbrella docs — catalog

- [dhnt.io renovation pilot](dhnt-site-renovation-pilot.md) — Sprint 707 tests everyday language and the developer promise by shaping the existing homepage. Its form pilot covers personal scope, understandable refusal, voluntary adoption and one upstream update.

- **`sprint-656-master-execution-plan.md`** — Current RC38 pipeline and QA-follow-up status, preserving the original rc.37 venue plan. Separates accepted infrastructure from frozen-candidate security/build/upload qualification, records the warm-cache benchmark limits, and leaves unresolved defects, design work and operator-held publication explicit.

- **`sprint-675-master-execution-plan.md`** — Review of Sprint 675 before start and its master execution plan. Records that Sprint 575 story `ca76921cf9e5` is the evidence source and Sprint 571 only the origin of the story identities; that the sealed evidence archive was located and checksum-verified and is indexed in the private harness kit; the frozen-source, toolchain, mixed-engine and no-licensed-venue constraints; the phase order (Phase 0 verification, R1 ledger, R2-R5 in parallel, conditional R6, R7 handoff); output placement and stop conditions; and the operator decisions still open (go, reviewer, probes). Planning only.
- **`sprint-675-posix-readiness.md`** — Public preparation matrix for the S575 baseline and separately authorized post-repair S675 engineering run. Lists all 67 raw residual identities and derived dispositions, the nine applicant manual decisions, current official kit/program requirements, and the authority, license, formal-journal and submission blockers. It makes no certification claim.

- **`plan-posix-certification-after-separation.md`** — Sprint 675 reuses seven unfinished S571 story identities against the completed S575 baseline: four `more` failures, 54 unresolved results and nine manual inspections. Defines the exact retained evidence, cause-first investigation, existing authority/manual packet reuse, conditional repair proposals and honest readiness handoff. Planning only; no implementation, test expansion, submission or RC38 release.

- **`sprint-666-evidence.md`** — Sprint 666 delivery evidence with pushed producer/consumer identities, standalone, installed-binary and real-backend browser checks, completed managed group-work trace, managed same-host recovery and queued-worker traces, raw manifest checksums, honest baseline limits, and the still-open native shared-host gates. It records accepted stories separately from S10 closure.

- **`plan-cooperative-chunk-transfer.md`** — Sprint 657 closed as won’t do. The plan preserves the cooperative transfer design and records the LAN workaround of serving artifacts from the satellite or the owner’s outpost.
- **`plan-effortless-install.md`** — Inventory, gaps and plan for installing bashy effortlessly, local first: the organizer host runs bashy as the LAN web server (`bashy release-mirror fetch|build|publish|serve`), participants or their agents install or upgrade from one line (`curl .../install.sh | sh`, `irm .../install.ps1 | iex`) with the installers honouring `BASHY_RELEASE_BASE`, and the served README is the live bashy skill. Records the pairing-stamp rule (`self install` requires bashy and a release-stamped outpost at one version), the decision not to publish package managers, the classroom MVP delivered 2026-11-22 (stories 634-636 on sprint 692, post-rc40), and the planned stories: release-source engine in binmgr, fresh-latest fix, promote glob fix, mesh peer serve/consume, skill refresh, LAN-bound MCP with a bearer token, loom as a channel, docs cleanup. Defers chunking/signing to sprint 657 and offline bootstrap to sprint 654.

- **`bashy-bashsharp-yoke-position.md`** — Codex's architectural position on bashy, Bash#, and yoke: three complementary unification promises, explicit portability and language boundaries, and integration priorities for capability contracts, execution lifecycles, verified improvement loops, and complete workflow evidence. Distinguishes existing foundations from recommendations and Sprint 653's planned runner work.

- **`plan-self-contained-offline-bashy.md`** — Sprint 654 master execution plan: ORAS/bbolt/goproxy/Athens reuse, protected rebuild inputs, internal module publication and regeneration, sealed bootstrap and recovery, OCI/model retention, tier policy, resource automation, dependency-ordered stories and platform acceptance.
- **`offline-bashy-contracts-v1.md`** — Sprint 654 S0 authoritative contract specification: `bashy-offline-profile-v1` and `bashy-artifact-manifest-v1` schemas, Loom publication refs, epoch/PID-bound GC leases, confinement-preserving tier fallback, permissive dependency provenance, `tools/bashy-build` (`go1.27.4` + `go-product.sh`) coexistence, and synchronized baseline evidence.

One entry per doc with its abstract. `INDEX.md` is the one-line index.

- **`plan-s568-master-execution.md`** — Sprint 568's operator-agreed design scope, six-story sequence and acceptance matrix for ordinary human/agent membership, service-specific accounts, and bidirectional routing between application conversations and local MB, Meet and sprint sessions. Preserves direct human use of bashy and existing local workflows; implementation follows separately.
Stories live in `docs/todo/` (the committed repo store `bashy todo --repo`
reads and writes; a story carries its sprint as `sprint_id`).

- **`build.md`** — How the umbrella builds: no `go.work`, no root Makefile;
  hydrate submodules once, then build/test each subproject from its own
  root; the flat sibling-replace convention and its gotchas (nested `yoke`
  externals, TTY-bound tests, foreign suites never run natively).

- **`plan-s571-posix-certification-readiness.md`** — Historical S561 readiness plan, retained with its evidence and decision history. Its seven unfinished investigation/readiness story identities now continue in Sprint 675 against the tagged S575 evidence; the earlier R8 documentation-delivery record remains on Sprint 571.
- **`plan-s575-master-execution.md`** — Sprint 575's approved complete Bash ← Bash# ← bashy separation, minimum necessary changes, clean origin-synchronized baseline, canonical product homes, owned-fork option, standalone fixed-dependency gates, and fleet delivery sequence. Includes the engine extraction formerly deferred to 581; the release-QA expansion remains outside this sprint.
- **`s575-separation-review.md`** — Read-only Codex/Muse findings, checked by the manager: private parser/runtime coupling prevents naive package moves, catalog dependencies invalidate the dependency-free-leaf assumption, and neutral coreutils helpers must remain below. Records the operator's revised minimum-change and owned-fork scope; does not claim fresh suite qualification.
- **`s575-runtime-boundary.md`** — Codex's owned-language-runtime design, independently reviewed by Muse: a canonical Bash module, a Bash# parser/AST/evaluator with pinned neutral foundation dependencies, dual handler-context views and finite environment/status aliases, preserved private default handlers, and complete cold/warm/MCP/DAG composition coverage. Implementation and preservation gates remain pending.

- **`plan-windows-csharp-powershell-followup.md`** — Sprint 573 preserves outstanding Windows, C# and PowerShell inventories, source-bound evidence and required modes while Sprint 562 completes its remaining language work. Describes safe test-host execution, exact carryover and final acceptance without treating deferral as a pass.

- **`media-desk-reference.md`** — Reference inventory and sufficiency verification of `bashy` support for PDF, drawing/whiteboard/charts, image, audio, video, and the Desk team-collaboration suite (`notepad`, `viewer`, `form`, `replyform`, `chart`, `whiteboard`, `tutor`). Documents production workflows and prioritized enhancements for competition dossiers and demo videos.
- **`plan-s595-master-execution.md`** — Sprint 595's reviewed plan: six bashy CLI audit bugs traced to their root causes with disjoint repo scopes and per-vendor owners (Phase 1), then capability discovery/shaping guidance split into four delivery stories (Phase 2). Records the bashsharp and cursor-seam exclusions and the remote-host gates.
- **`sprint-597-master-execution-plan.md`** — Sprint 597's three-story plan for a Klatch participant CLI, bashy example integration, and public sandbox e2e coverage. Defines MVP boundaries, remote-only verification, and producer-before-pin integration.
- **`sprint-598-master-execution-plan.md`** — Sprint 598's four-story satellite CLI delivery scope, remote verification plan, and managed integration sequence.
- **`satellite-operations-workflow.md`** — Account, satellite, and paired-host discovery followed by explicit invite/transfer, with the existing software-shaping lifecycle.
- **`sprint-598-verification.md`** — Reviewed source revisions, built CLI digest, remote E2E and regression gates, and deployed service compatibility limit.
- **`research-xonsh-python-fence.md`** — Research-only comparison of xonsh 0.25.0 Python↔shell interop against the Bash# `~~~python` fence. Bash# already matches or beats xonsh shell→Python (explicit boundary, typed calls, xonsh's callable-alias return convention). Two gaps are worth taking in: every process a fence spawns (all fence languages) runs through bashy as the shell, with spawned commands required to be bashy built-ins or registered commands; and per-call environment propagation (the worker environment is fixed at launch today). Mode detection and raise-by-default are explicitly rejected.
- **`agentic-cli-support.md`** — Architecture and inventory of agentic CLI support across `bashy` and `yoke`: active and retired built-in fleet tools (`yoke/pkg/fleet/baseline/tools/`), `bashy install-agent` shell/MCP/inbox-hook wiring, `DetectTool` ambient environment markers and `{state_dir}` launch isolation, and the 17 ready-made custom fleet tool recipes in `bashy/examples/fleet/tools/` (including DeepSeek Harness `dsh`).
- **`bashsharp-review-agy.md`** — State-of-the-art external research and codebase gap evaluation (authored by `agy`) organized in two parts: (1) a survey of the 12 defining features and architectural traits of modern programming languages across memory/ownership (affine/linear types, Perceus RC, Mutable Value Semantics in Hylo), type/effect systems (algebraic effects in Koka/OCaml 5, object-capability security in Austral/WASI), concurrency/metaprogramming (Swift 6 region isolation, Zig `comptime`, C++26 `std::meta`, Mojo MLIR), compiler/interop architecture (Salsa query compilers, Wasm Component Model WIT), and neurosymbolic verification (Verus, Dafny, Lean 4, Verse, Unison); and (2) a concrete architectural and code-level gap analysis (`G1`–`G11`) evaluating `Bash#` (`bashsharp`, `sh`, `bashy`) against those traits with prioritized recommendations.
- **`bashsharp-review-claude.md`** — Gap evaluation (authored by `claude`) of Bash# as a language for the agentic era, against a trait list ranked by 2025–2026 evidence (verification loop, enforced types, corpus + stability, explicitness, supply chain, effects, machine surfaces). Main gaps: the static check is optional, shallow and split from transpile's type rules (G1); diagnostics lack positions/JSON for parse errors (G2); the strict-superset claim holds only with the dialect off, with a lookahead + E-dead/E-live activation path to a dialect-on superset (G3); effects are runtime middleware, not language (G4); stability, supply-chain and strict-mode defaults (G5–G7).
- **`bashsharp-review-codex.md`** — Research-informed evaluation by `codex` against ten agentic-era language traits. Records exact reviewed revisions, successful checks of invalid mixed functions, the M12 wrong-result reproduction, host-dependent contracts, effect versus containment boundaries, diagnostic fragmentation, reproducibility, concurrency and performance limits. Distinguishes fresh focused checks from historical conformance and agent-outcome evidence, and prioritizes reliable checking and portable guarantees over additional syntax.

- **`sprint-610-master-execution-plan.md`** — Master plan for fourteen Bash# correctness, checking and execution-guarantee stories. Records dependencies, planned owners, strict dialect-on parity, candidate-bound verification, external sprint boundaries and design-only deliverables; keeps the sprint unstarted.
- **`sprint-617-master-execution-plan.md`** — Master plan for bashy shaping itself (local installations → qiangli staging → dhnt upstream). Records the source-verified baseline (no installation identity, host-bound evidence, no org-before-upstream enforcement), the two-wave cut (P0–P6 now, P7–P9 to a follow-up sprint), the dhnt required-check verifier decision, vendor lanes, the R0–R5 readiness ladder, per-installation session slots built on weave (trust and memory policy), and the classgo public-example split into check-in and the rest with a pull-by-default private adopter; keeps the sprint unstarted.
- **`sprint-616-master-execution-plan.md`** — Master plan for the eight Sprint 614 carry-over stories (calendar example, deployed suite-to-circle e2e, browser e2e and TestToolFence root causes, cloudbox macOS build, fleet probe, weave/sprint friction, disk hygiene). Records findings verified in the code, file-disjoint vendor lanes, a three-wave sequence with one final Linux validation pass, and open operator decisions; keeps the sprint unstarted.
- **`sprint-626-master-execution-plan.md`** — Master plan for exposing vendor agent CLI features (claude, codex, agy, muse) as bashy services. Generalizes the transcribe provider selector into `bashy providers`, adds a `route` (oss/vendor/browser/api) with the economic auto order, ships service verbs as bootstrap-registered default custom commands behind one door body and envelope, and lists measured-seed stories per vendor plus client acceptance by opencode, genie and ycode; keeps the sprint unstarted.
- **`sprint-626-acceptance.md`** — S7 acceptance record. opencode, genie and ycode each call one seeded service per category (plan, search, image selection, draw, pdf, video, transcribe, email.read, drive.read) through `bashy <verb> --json`, `bashy mcp serve` and the llm API `slash=` filter, from be7118e6 in an isolated registry. Records the pass/fail matrix with raw outcomes, the venue (private door, genie env-allowlist variant), and root causes: llm API argv splitting (flag injection), harness preflight and missing USER for genie/ycode, transcribe not reachable over MCP, and design-scope refusals.
- **`tool-commands-overlay-example.yaml`** — Example tool-command overlay. The yoke baseline seeds one measured command per name per tool; this file keeps the other spellings (today the claude `/plan` TUI command, measured 2026-09-28) with their measurement notes and explains how to splice an entry into a full local tool record.
- **`sprint-627-master-execution-plan.md`** — Master plan for a music-video showcase built on Sprint 626 services: reference analysis, stage pipeline, three routes per generative stage (local open-source drafts, commercial final from one locked storyboard), permissive model picks with licence exclusions, hardware venue and acceptance; keeps the sprint unstarted.
- **`sprint-634-master-execution-plan.md`** — Master plan for the Sprint 627 M8 follow-ups: a local, recorded translate stage (oss route over native ollama) and an optional local text-drafting stage so a film draft is fully local with auditable provenance, plus the burned-subtitle Latin-font fix; steps, worker split, venue and rules.
- **`sprint-635-lipsync-evidence.md`** — Evidence for the Sprint 635 lip-sync proof: EchoMimicV3 Flash (Apache-2.0) animating a locked still to the locked song on one self-terminating g5.xlarge, the pinned recipe (sources, weights, Python stack, the two inference patches), the motion metric against the motionless S627 clip, a table of the twelve attempts with root causes, spend against the cap, and the remaining full-length pass, assembly and commercial final.
- **`sprint-636-master-execution-plan.md`** — Plan for the bashy apps UI fixes requested 2026-11-13: reorder the landing page so Apps follows Recent with Cloud and Neighborhood below, and replace the traced Shape-button mark with one hand-authored Flow SVG used by the genie button and the Shape page; records the Tutor tile removal as host config.
- **`plan-sprint-652-outpost-reliability.md`** — Starts with read-only diagnosis of the Windows test host outage, then covers Outpost service recovery, owner notifications for reachability and disk pressure, and alert deduplication for reachability and disk usage.
- **`plan-sprint-655-one-app.md`** — Operator-reviewed MVP plan for Sprint 655: "one app" is a contract on observable behavior (syntax, common options, one result envelope, exit codes, effects, UI-to-CLI parity), not an implementation requirement. Delivers the contract doc with a small yoke reference package and a minimum checker written as a shapeable Bash# skill-script that shaping may use on request; conformance stays optional, tiers stay the declarer's choice, and the ledger, MCP, provider-family, app, claim and tier-transparency stories are deferred to the backlog.
- **`plan-sprint-662-shaping-friction.md`** — Tracking plan for Sprint 662: separates Sprint 655's test-isolation setup from real friction for any user, and files four stories: make the contract check a one-line opt-in inside contained shaping checks, get a new agent to shaping in one documented step without weakening accountability, and close bashy git (`-c`, `--allow-empty`) and jq (`--arg`, `--argjson`, `-s`, `-R`, `inputs`) gaps in yoke.
- **`plan-agentic-tool-support.md`** — Tracking plan for Sprint 671: bashy officially supports ycode/genie, claude, codex, opencode, agy, muse, zcode, kimi, dsh, hermes and openclaw as built-in fleet seeds. Drops Cursor, demotes aider, gemini-cli, copilot, cline and goose to custom examples, renames the kimi-cli seed to kimi, graduates dsh to built-in, and refreshes the official set's models from vendor sources. Seven stories, scope, non-goals, compatibility, acceptance and rollback.
- **`plan-sprint-672-token-minting.md`** — Tracking plan for Sprint 672: per-host scoped tokens as the policy layer; an owner minter token kept in the vault lets the bashy CLI mint, edit, list and revoke host tokens (bearer edit endpoint added for console parity); the first minter is bootstrapped once from the console; the dev box's session token is re-minted with a bounded lifetime and four exposed satellite attachment tokens are rotated.
- **`bash53-gate-79-86-findings.md`** — Findings of record for the recurring 79/86 Bash 5.3 gate reading: four disjoint failing-fixture sets (root/no-hexdump/no-locale venue; historical dialect-on `func`; a fixed July engine regression; Windows native gaps) misread as one regression because counts, not fixture names, were compared and a stale claim served as baseline. Records the 2026-11-10 measurement (sealed container, both modes 86/86), the guards (root refusal, preflight, both-mode sealed gate with provenance and name-based comparison) and the rules for reading a result.
- **`bash-command-invocation-counts.md`** — Findings of record for "which bash commands run most": the OTel exec spans survive only in the per-day spool (the trace store holds outpost HTTP spans only), so the authoritative source is the bashy execlog (`~/.bashy/exec`, 2.84 M records, 2026-08-05 → 2026-11-10). Full 1,245-command tally sorted by invocations, the one-day OTel spool tally, reading notes (versioned claude basenames, bashy verbs counted as commands, polling floor) and the reproduction commands.
- **`otel-agent-introspection-review.md`** — Review of what bashy offers an agentic tool to introspect its own failures during and after a session, measured against the self-healing loop (detect, explain, recover, learn, reuse). Live reflexes and the execlog work; every post-session OTel verb returns nothing for a bashy session because exec spans never leave the spool, spans are flat, error spans say only `exit N`, the skill repair loop reads no telemetry, and learning is manual. Maps each gap to a Sprint 611 story (or to Sprint 590 where already tracked).
- **`strands-shell-gap-analysis.md`** — Gap analysis of strands-agents/shell, a Rust in-process Bourne shell with a default-deny VFS, SSRF-safe resolver, URL-prefix credential injection and an MCP server, against bashy. Records the different design centres (mediation layer vs real Bash 5.3 drop-in), a dimension-by-dimension table, the gaps adopted as standalone todos (MCP per-call timeout, `contain --net public`, egress-proxy credential injection, indirect-exec guard coverage, agent Bash-tool wrapper regression test, optional MCP read_file) plus a filesystem-confinement discussion todo, and why the VFS, SDK bindings, Lua and differential tests were not adopted.
- **`sprint-615-master-execution-plan.md`** — Sprint 615 plan: casual bashy users shape apps on a free cloud dev workspace (Codespaces first, Gitpod second) as a session-scoped shaping host. A private GitHub repo is the backstore, with Google identity and data access via BYOP; attaching to a shared satellite is optional. Apps that need always-on graduate to a satellite. Seven stories with planned vendors and manual verification on real free accounts. Planning only.
- **`bashy-agent-permissions.md`** — Design discussion of consistent per-agent CLI authorization ("only agents allowed to delete may run `rm`"). Surveys bashy's 13 existing guards and their gaps (no per-principal cap, registered commands unknown to the deny check, `find -exec`/`xargs` bypass), lays out a full CRUD+X matrix keyed by command/subcommand/flag, and judges it overkill while agents still have other shells. Recommends an MVP that binds the existing @guard effect cap to the principal through a plain-text policy in Atlas vocabulary, defers refinement rows and path scope to the bashy-as-sole-gateway vision (CLI locally, MCP remotely), and records HTTP method semantics, including the new QUERY method (RFC 10008), as prior art. Discussion only; no sprint or code.
- **`comms-strategy.md`** — Sprint 620 covers the terminal workflow for a Cloudbox-shared app, per-app grants, candidate review and cross-client handoff. The plan records the disposition of all eight original stories and preserves the earlier communications proposal.
- **`sprint-621-master-execution-plan.md`** — Master execution plan for Sprint 621 defining Software Shaping around the Test-Driven Development (`Red → Green → Refactor`) lifecycle in the bashy way: (a) `bashy sprint`/`bashy todo` orientation with KB context traps and disjoint vendor lanes (`T1`–`T6`), (b) composable Bash# skill-script (`examples/shaping/tdd/shape-tdd.bsh`) and portable `dag.md` test graph (`examples/shaping/tdd/dag.md`), and (c) iterative sprint retro loop (`triage → replan → kb observe/validate/retro → repeat`). Closed won't do 2026-11-24 (operator decision); kept as a design record.
- **`brand/README.md`** — The product-mark family chosen in Sprint 622: cloudbox (a square in a circle), satellite (the same square on a 45° orbit), outpost (two squares stacked up the 45° diagonal) and bashy (an app grid whose turned top-right square is the shaped app). It gives the rules (one mirror axis, one 24-unit square, recognizable at 16 px in one color) and lists the SVG, PNG and favicon files per mark.
- **`sprint-622-master-execution-plan.md`** — Master execution plan for Sprint 622, which makes software shaping the one theme across bashy, Bash#, yoke, outpost and satellite/cloudbox. It covers a draft definition (one-liner, loop, eight guidelines, technologies by repo, shipped vs in-progress features, the Shapeable badge checklist), the README alignment stories R1–R4, the `qiangli/bash` superproject for sh + coreutils (built for POSIX certification, not certified), and the L1 product-mark family (cloudbox, a distinct satellite variant, outpost, bashy). Planning only; Sprint 622 stays in backlog.
- **`sprint-627-m2b-weights-evidence.md`** — Evidence for staging Sprint 627 OSS model weights on the Windows test host, including venue, disk headroom, model revisions, cache paths, sizes, hashes and elapsed time. No render evidence is claimed here.
- **`sprint-627-m2b-image-evidence.md`** — Sprint 627 image draft evidence on the Windows test host: one-time completion of the pinned FLUX.2 model, offline generate and edit results, service envelopes, timing, memory, disk and artifact checksums.
- **`sprint-627-m2b-narrate-evidence.md`** — Evidence for a live offline Chatterbox narration clip through the OSS service door on the claimed Windows test host: staged-weight verification, native-first venue decision, service envelope, wall time, peak memory, disk change and WAV checksum.
- **`sprint-627-m2b-transcribe-evidence.md`** — Evidence for one offline WhisperX SRT from a speech fixture on the Windows test host. Records the staged checkpoint check, venue, service envelope, wall time, peak memory, disk change, artifact hash and focused gate limitation.
- **`sprint-627-m2b-song-b-evidence.md`** — Evidence for the offline-by-default OSS rod fix, hermetic no-fetch fixture, and live ACE-Step render with staged weights and LM disabled.
- **`sprint-627-m3b-animate-evidence.md`** — Native Windows Wan2.2 GPU spike: post-denoise VAE decode stall, verified reuse of staged weights, bounded render and no OSS animate route.
- **`sprint-627-m8-drafts-evidence.md`** — The M8 two-draft run on the Windows test host. After the operator's GPU fix, a native ROCm 10 FLUX.2 klein 1280×720 verify passed with no TDR. Two oss drafts then rendered (wall time, per-stage time, SHA-256, zero cost) and the storyboard was locked. Also records four root-caused venue failures before the drafts, the `media cards` short-video defect, the subtitle-timing gap, and the remaining checks. The first, blocked attempt (GPU VAE-decode TDR that rebooted the host) is kept as history.

## shapeable-apps-worker-brief.md

The one brief every Sprint 631 worker reads first: the Linux + web UI scope; the hard permissive-license rule; each job ships as a custom command in bashy/examples (never core) with job-only wording; fork targets are pinned forks under our account, build targets extend an existing example; how to earn the Shapeable badge (docs/software-shaping.md, yoke/pkg/shape, the hello-world reference); and what done means (shaping demo, targeted tests, evidence, commit trailers).

## files-fbembed-quantum-port.md

Sprint 631 story S2b record: the base verified (Apache-2.0, 9.1k stars, `v2.0.2-stable`), the fork branch and its two commits (four behavior-preserving upstream seams; the `backend/fbembed` package with a committed frontend), the old-vs-new seam behavior table, fresh test and build evidence, the measured binary cost of the move (14.9 MB to 42.9 MB stripped, 90 to 299 packages), the four-consumer migration plan, the decisions left to the S2 owner and the frontend work still to port.

## whiteboard-fork-no-phone-home.md

Sprint 632 story S5b record. Why the whiteboard pin was not safe on its own (a plain build of it embedded the Sentry DSN, the Firebase hosts, the analytics loader and the Google Fonts preconnect; only the install-time patch removed them), and the two review premises that did not survive checking (`build:app` forced tracking on, and the fonts came from a vendor CDN the scrub gate does not know about). Lists the three fork commits and the new pin, what was removed and what was deliberately kept, the before/after gate and bundle evidence, the by-name comparison that proved the pre-existing 306-failure vitest set is an environment problem rather than a regression, the consumer changes in `bashy/examples/whiteboard` (patch 358 → 31 lines), the runtime proof still owed on the gate venue, and the whiteboard UI→CLI parity re-check that found no CLI path for any board, scene or room action.

## shapeable-app-catalog.md

The first batch of shapeable apps (Sprint 631): eight bashy custom commands (notes, form, clips, site with a chat template, board, whiteboard, table) and the files app on the maintained File Browser fork. For each: the job, the pinned permissive fork or own build, and the license. Lists the shared rules (shapeable, fork-or-build, no hidden phone-home, owner-only OTel, Linux + web UI) and the items still open in Sprint 632.

## sprint-632-master-execution-plan.md

Sprint 632, phase 1 (operator re-scope 2026-11-13): bashy CLI parity for the eight catalog apps, one verb that puts any catalog app on outpost's app list, and the carried bugs. States what the code showed (lifecycle-only commands, two separate app registries, the outpost URL-path bug, the goal-link bug), the stories in three waves with their lanes and dependencies, the per-story and close gates, and what is deferred to phase 2.

## agentic-command-skill-scripts-design.md

Design of record for Sprint 633. Reverses the usual tool loop: instead of a central agent repeating the same probing rounds, `agentic <command> [request...]` runs the command's own Bash# skill-script `<command>.bsh`, forging it with a training model when it does not exist and correcting it when it fails, so the learned script is the calling agent's muscle memory and every agent on the host benefits. Covers the resolution ring and the one core hook, the worth-it gate that never forges a simple command, the forge verbs with their gates and ledger, the three training tiers (caller via the `input_required` yield, vendor CLI, door or local model) and why MCP sampling is not one of them, the `ssh.bsh` example as a superset face over outpost, the micro-shaping loop, the research it builds on, and the follow-ups.

## sprint-633-master-execution-plan.md

Sprint 633: `agentic ssh "connect to host gatehost"` answers in one tool call, forging `ssh.bsh` on the first call and running it with no model on the second, correcting it on failure. States what the probes showed on the dev box (which training tiers work, the `ycode btw` flag bug, guard-cap behaviour), the nine stories in four waves with lanes and dependencies, the shaping hook and composition note, the per-story and close gates, and the decisions reserved for the operator.

## website-shaping-integration.md

Design of record for Sprint 638. How an existing live website, hosted wherever it is, joins software shaping with close to zero change: reviews what the engine does today (managed checkout, per-principal lines, static tree, Go-only servers, the six-repo promotion list, the Genie's same-origin reach), surveys the 2026 approaches (DOM-patching widgets, per-user AI userscripts, click-to-source editors, edge injection, WebMCP, widget hygiene) and why the runtime ones fail "fool-proof", and decides on an engine-hosted shaped copy plus a link badge in two tiers. States the public link contract, how a built single-page app is hosted, the shaping levels (owner, member, public) with the invariants that hold at every level and a public level that never creates code, the company-website dogfood, risks and follow-ups.

## sprint-638-master-execution-plan.md

Sprint 638, planning only: a member clicks Shape on the company website and approves their own verified version at the engine; the owner pushes a pull request; visitors only personalize what the owner declared. States what the code showed, the nine stories in three lanes with vendor and acceptance (Shape page prefill, badge, website scaffold, SPA fallback, promotion remote, policy levels, public personalization, docs, dogfood), the gates and venues, the seven verification steps and the decisions reserved for the operator.

## trove-content-app-design.md

Design of record for Sprint 639. An owner keeps a trove, a private collection of the content that matters to them wherever it lives (local directories, hosts behind outpost, git and GitHub, Google Drive, later mail and calendar) plus the artifacts agents produce, presented the same way to agents (small `--json` verbs over `bashy-node-v1` rows, the analogue of ls/find/cat) and to humans (an explorer page on the desk kit). Reviews what exists (the shaping engine and app pattern, the single-scope files app, the read-only lens provider seam whose recipe registry admits only oci/k8s, the google/gh/fetch verbs, the service roles, the per-app grants), then states the model (mounts in `trove.json`, entries with provenance and the caller's grant), the sources, contributing by owner, members and agents with provenance, circle protection (what the public wire says about circles, groups and grant rules; the decision for one rule grammar, two enforcement points and the relationship stamped by outpost; the alternatives weighed), present-on-the-fly (canned, then generated through the service doors, then cached with provenance), the rod-not-fish rule, the shaping hooks (views, presenters, source adapters) that let each user shape the app into their own form, the explorer page, the two test cases, risks and follow-ups.

## sprint-639-master-execution-plan.md

Sprint 639, planning only: every bashy user owns an agent-friendly trove, members and agents contribute into it under grants, agents and humans see one tree, any entry is presented on the fly, and the app takes any shape through its views, presenters and source adapters. States the operator framing (general app; the two scenarios are test cases needed within weeks), what the code showed, the fourteen product stories (including the two outpost prerequisites for circle protection) and two test cases with vendor and acceptance, the lanes, gates and venues, verification and the decisions taken.

- **`docs/sprint-641-master-execution-plan.md`** — Sprint 641, the try-now MVP, composed from four existing cards rather than designed anew. ai.dhnt.io showcases software shaping by inviting people to practice beside traditional learning, so the acceptance is one paragraph: a person who is not the owner arrives, is invited, asks for a change by typing or speaking it, sees it proven Red on the base revision before Green on the candidate, approves it as their own version and resets it — everything they may touch being the owner's declared feature list, with the app's contract refused by feature name — and the owner carries a change upstream as a pull request, all worked in a GitHub-backed space an agentic tool can land in. Fifteen stories with their origins kept, the boundary design (shaped.json features with flags and invariants over the surface verifier that already exists, paired with 638's levels as who-versus-what), the practice ceiling that a public wish needs before it can be public, seven lanes, gates and venues, closure, and the one dependency this card does not own: the operatorSession privilege finding, without which no refusal to a stranger can be trusted. Tracking card; planning only.

- **`docs/dhnt-journey-design.md`** — Design of record for how a person meets the ecosystem without being handed a manual: dhnt.io is the free desktop in a browser, and as they attach their own machines those machines become its backend, until the hosted plane is the thin relay the vision always described. States the eight laws that keep a journey from becoming a wizard (one growing subject; invitations earned not pushed; nothing lost at a boundary; every rung reversible; no dead ends or silent degradation; one invariant floor that binds staff too; economics as a rung property rather than a paywall; every UI action with a CLI path). Lays out six rungs from the badge on the landing page to running your own satellite, with what each one teaches, and shows the ladder is mostly assembly of what already exists. Details rung 1 — the MVP — as a small, flexible foundation: a declared cosmetic schema, a per-account property document resolved over an ordered list of layers, every property settable without a model, the same verbs rung 3 uses, no separate preview, and a journey state that records competence rather than traffic.

- **`docs/vendor-chat-gateway-mvp.md`** — Sprint 646, the buildable merge of the four vendor planning sprints (642 OpenAI, 643 Anthropic, 644 Google, 645 Meta). Goal A: each vendor's own web, mobile and chatbox client is the UI for Cloudbox, Satellites, Outposts and Bashy, including software shaping. Goal B: each vendor's official CLI on the owner's subscription is the outpost agent. Records the settled decisions: one vendor-neutral gateway on the Cloudbox master with a minimal OAuth 2.1 authorization server; per-call routing that proxies synchronously through an authorized attached satellite and otherwise records a durable task the outpost pulls, falling back without double execution; seven tools where a generic `run` reaches every bashy verb under effect gating; direct verbs before agents; documented headless subscription credentials only, never an API-key fallback; poll plus task id instead of push. Lists clients in scope, the open live checks and the nine stories.

- **`docs/sprint-646-master-execution-plan.md`** — Sprint 646 execution plan. Triages the nine stories into two dependency waves plus a QA pass, using the task wire contract in the design doc as the seam that lets the gateway and outpost work proceed in parallel. Assigns each story to a fleet agent matched to its difficulty (claude for the OAuth server and router, codex for the conductor directives, the outpost app and the MCP endpoint, muse for the cross-vendor worker adapter and approvals, agy for client guides), and states the worker rules and the merge and gate recipe.

- **`docs/client-setup-claude.md`** — Client setup guide and architecture reference for Anthropic's claude.ai (web custom connector, desktop, and mobile reuse) driving Cloudbox, Satellites, Outposts and Bashy. Documents remote MCP over Streamable HTTP, OAuth 2.1 with PKCE S256, redirect allowlist (`claude.ai/api/mcp/auth_callback` and RFC 8252 loopback for CLIs), scopes (`mcp:read`, `mcp:write`, `mcp:host`), revocation via disconnect and token revocation, the seven text-first tools, and outpost Claude Code execution on subscription credentials with open live checks.

- **`docs/client-setup-chatgpt-work.md`** — Client setup guide and architecture reference for OpenAI's ChatGPT Work plugin (web and qualified mobile app access) driving Cloudbox, Satellites, Outposts and Bashy. Documents remote MCP over Streamable HTTP, OAuth 2.1 with PKCE S256 and Dynamic Client Registration, RFC 8252 loopback redirect allowlist with ChatGPT callback as an open live check, no-push durable task recovery via polling, scopes (`mcp:read`, `mcp:write`, `mcp:host`), revocation via disconnect and token revocation, and outpost Codex CLI execution on subscription credentials under `CODEX_HOME` with open live checks.

- **`docs/client-setup-gemini.md`** — Client setup guide and architecture reference for Google's Gemini web Custom Connected App and mobile auto-sync driving Cloudbox, Satellites, Outposts and Bashy. Documents mandatory consumer account gates (personal `@gmail.com`, US, English, Keep Activity ON), remote MCP over Streamable HTTP, OAuth 2.1 with PKCE S256 and Dynamic Client Registration, redirect allowlist (`vertexaisearch.cloud.google.com/oauth-redirect`, `antigravity.google/oauth-callback`, and RFC 8252 loopback for CLIs), scopes (`mcp:read`, `mcp:write`, `mcp:host`), revocation via disconnect and token revocation, and outpost Antigravity (`agy`) CLI execution on persisted subscription credentials with open live checks.

- **`docs/muse-connector-submission-pack.md`** — Directory submission pack and Meta AI integration specification for the Muse Connector Platform (muse.ai web chatbox, mobile apps, and WhatsApp channel via Muse Personal Agent). Maps the seven gateway tools into Read, Write, and Sensitive-write safety tiers based on bashy effect policies; defines a dedicated reviewer test account plan with reproducible sequence against the staging fake; details data terms (minimization, no model training, outpost Contributor mode pinned OFF, retention/deletion); details the WhatsApp channel architecture decision; and specifies open live checks.


- **`docs/software-shaping-paradigm-comparison.md`** — Reference summary of a review comparing bashy software shaping with fifteen paradigms across engineering-led (waterfall/MDE, CI/CD, GitOps, progressive delivery, TDD), user-led (end-user programming, low-code/SaaS configuration, plugins, forking, malleable software) and AI-era (vibe coding, agentic PR bots, spec-driven development, ephemeral generative UI) families, with a matrix on who changes, what decides, blast radius, way back and divergence. Records what shaping inherits, pros and cons sorted into paradigm-bound versus immaturity, the 2025–2026 evidence (SaaS build-vs-buy shift, AI code security, METR, Karpathy's verification loop, the open-source slop crisis, token costs, the Cyber Resilience Act), competing bets, the levers and falsification signals, two principles carried forward from past paradigms (producers and consumers are many-to-many; decide after seeing, not before) and the unbuilt proposals that follow (variants and compare, peer remotes and subscribe, a rebased per-person shape stack, opt-in approval signals). Claims only what the definition page marks shipped.

- **`docs/release-failure-ledger.md`** — Ledger of every test failure met while preparing a release, kept so a future regression can be bisected from a known point. Each row names the test and repository, the symptom, the last green and first red commit and how they were found, the recorded cause, its class (product defect, test defect, metadata defect) and the fixing commit. Venue failures (missing tools, small tmpfs, platform-only builds) are listed apart, so they are fixed in the venue and never in code. It opens with how to bisect with `git bisect run` and why the system git is needed there.

## sprint-691-master-execution-plan.md

Sprint 691, planning only, rescoped 2026-11-23 from a capacity spike: the middle tier between public shaping of a site (no account needed) and full shaping on a paired outpost. A cloudbox-registered user with no paired outpost, or whose outpost is offline, calls bashy from any agentic tool through the existing gateway and the call runs on a dhnt-provisioned on-demand bashy instance acting as that user, with vault credentials projected for the call and personal data reached through one virtual drive, the trove: a path-keyed JSON of mount points over outpost paths, Google Drive and GitHub, tokens and layout in the vault, no storage of its own. States the three tiers, what the review showed, where hosted state lives, the trove layout, nine stories with vendor and acceptance, lanes, gates and venues, decisions and what is not done here.

## shaping-enable-a-website.md

Owner guide for shaping-enabling a static site: the four relationships and what the site learns from each, what the owner needs (a static site, a GitHub account, a cloudbox account, a satellite, one OpenAI-compatible route), and the standard steps — `website.bsh assess`, `enable` into a private companion repo, editing `site.json` and `fields/*.md` with fail-closed audience front matter, hosting on a Codespace with three secrets or on the owner's own machine with `shaping-host up` plus `website serve`, registering for owner shaping with `bashy shape`, and adding the one engine-face link to the static site — then verify and graduate to an always-on host. To be amended with what actually happened after the live run.

### sprint-667-master-execution-plan.md

Plan for provable relays: every relayed message between humans and agents on any outpost or satellite carries the original signed statement by reference, so a recipient can verify who said it, who relayed it, what it authorizes and until when. Planning only.

### plan-one-agent-genie-hub.md

Sprint 679 design and execution plan positioning `bashy genie` as the "One Agent" front door alongside `bashy` (One System), `Bash#` (One Language), and `yoke` (One App). Summarizes the baseline audit of MCP, ACP, A2A, `cligw`, `chat`, `meet`, and `ycode` web/TUI surfaces, then defines a single-process `yoke/pkg/agenthub` + `bashy genie` architecture that runs as a unified BubbleTea TUI app while co-serving selectable `http` (Web UI), `rest`, `a2a` (v1.0), `mcp`, and headless `acp` (v1 `stdio`) protocols over one shared `SessionHub`, supporting both Mode (a) direct `--agent` delegation across official fleet tools and Mode (b) isolated ephemeral `--cligw` LLM proxy + `genie` harness execution in six bounded stories. Planning only.

### plan-s678-make-dag-bridge.md

Sprint 678 plan for agents that reach for make: `bashy dag --makefile` generates a POSIX, forward-only Makefile from dag.md whose comments teach the native `bashy dag` usage (with a `--check` staleness mode), piloted in yoke; and `bashy make` falls through to `bashy dag` where no makefile exists but a dag.md does, with a truthful `type make`. Amends the Makefile-removal plan: hand-written Makefiles are replaced by the generated forwarder.

### plan-s660-generated-makefiles.md

Sprint 660 plan, written by the conductor: inventory of every bashy-family Makefile, its dag.md coverage and the scripts/CI still calling make; four bounded stories replace each hand-written Makefile with the generated, teaching forwarder from `bashy dag --makefile`, ending with bashy behind the release-gate equivalence check. The sh repo is skipped as legacy.

### plan-s681-live-session-commands.md

Sprint 681 plan: extend the existing tool-command declarations (`commands:` in tool YAML, the canonical vocabulary) to session-control commands, measured per vendor, and add `bashy chat command <session> <name>` so a manager can clear, rename, resume or exit a live controlled session without restarting it, with the declared commands discoverable in `bashy chat sessions --json`.

### sprint-682-evidence.md

Wire-level evidence for Sprint 682: the accepted stories with their delivery SHAs and verification, the kb runbook walkthrough, and the 2026-11-23 gate-host preflight of the C4 member matrix (frozen candidate identity, disposable installation, Bedrock GLM-5 route smoke, two paired synthetic device principals, dry run) that went RED at the first app request because the console cannot build any desk example app as a shaped member instance (sibling `replace` directives unresolved in the extracted tree); no paid row was started.

### sprint-682-master-execution-plan.md

Closure plan for Sprint 682 (written 2026-11-23 after review): where the seven stories stand (five accepted; C4 member e2e open with the runbook walkthrough passed but the five-app live matrix never green; C4b submitted and unaccepted), the review findings (the ycode Genie receiver half of the approved framing fix never landed on main and is landed as C4c; stale runs and branches; four bypass entries; install-wrapped rows outside the approval; venue contention with Sprint 697), the nine closure steps with spend and status, the recipe for the one approved paid matrix run, the `sprint end` gates, and the decisions left to the operator. Design and story spec of record remains `plan-s682-consumer-shaping-example-apps.md`.

### plan-s682-consumer-shaping-example-apps.md

Sprint 682 plan: surveys the shaping state of each bashy example app (viewer, chart and session are plain proxies, so the console injects no Genie button), and brings all of them to consumer shaping (per-member wish, verify, preview, approve, undo) using the existing shaped-app registration and manifest, ending with a member-principal e2e and a general "enable an app for consumer shaping" runbook. Owner/producer shaping is Sprint 683.

### plan-group-participation.md

Planning record for the group shaping epic, revised 2026-11-20. States the pitch (bash unifies platforms, Bash# languages, yoke and shaping apps, genie agents, group shaping everything under one roof: one world for humans and agents), the model (shaping on an artifact degrades to wiki-style viewing and editing with revisions, never a live merge), the shared-item contract (an item is `APP/ITEM`, the Sprint 619 rule grammar for audience, roles, console admits and app enforces, named agents registered as members owned by a human, open invites inside a circle with an owner-only escape hatch), the cross-outpost steering inventory (chat, shared session, herald/A2A, ACP, MCP, outpost ssh), and the two sprints: 684 the rod proven on Klatch and Notepad, 685 coverage of every app as a test case plus cross-outpost steering. Sprints 686 and 687 were folded into 685.

### sprint-688-master-execution-plan.md

Sprint 688 covers a one-shot worker and account status view and a timed watch with optional differences. The plan records existing CLI behavior and the disposition of all six original stories.

### sprint-689-master-execution-plan.md

Filed plan for Sprint 689 (backlog, 2026-11-21). Records the shaping workflow model agreed in the 2026-11-21 review: individual (consumer, producer, one owner on many devices), group (shared real-time input plus per-app group features, Sprints 684/685) and team (sync and rebase onto the primary owner's line plus an approval rule). Delivers the missing individual multi-device case: an own-device line remote whose push is a compare-and-swap against the line authority (satellite, else primary outpost), rebase and re-verify on pull, offline work with catch-up on reconnect, plus root-causing the release-offer bug and the draft DOM flakes and one 1a/1b evidence record. A writer lease is needed only for several simultaneous writers on one shared draft (filed under 684 as G4); OS-provided inputs such as speech are ordinary text input.

### sprint-693-master-execution-plan.md

Review and rescope (2026-11-22) of Sprint 693, the dhnt.io pilot for navigation and shaping by people and agents. Records what the live site serves today (one single-page shell for `/` and `/about`, no revision, no negotiation, no robots.txt), the Nov-2026 state of the art with verdicts (server-rendered HTML with declared section ids and `Accept: text/markdown` at the origin carry weight; llms.txt, `rel=alternate` and WebMCP do not, so they are cheap or non-gating), and the decision: one public content module (`dhnt/site`) with one renderer for HTML, Markdown and JSON under one revision, consumed by the hosted plane for the live pages and registered unchanged as a shaped app on the owner's engine. Stories S0 generic site template in bashy (`site.bsh`), S0b `dhnt/site` as the first `<owner>/site` instance, S1 non-breaking live publication, S2 discovery evidence for the clients bashy works with plus the `dhnt-site` skill, S3 owner round trip on the engine (depends on S0b only); WebMCP dropped by the operator; the citation record, wish-provenance and home-content contracts; venues; the operator decisions recorded 2026-11-22.

### handoff-sprint-684-685.md

Handoff written at the close of Sprints 684 and 685 (2026-11-24) for the next conductor of the release train (Sprint 699) or the follow-up sprint (703). One table of sprint states; the four checks that must pass before any freeze, tag or release cut, because the dependency pins were not at heads when the sprints closed; the known red tests with their tracking stories; how to use the gate venue script; what to start next; and the management lessons from the two sprints.

### sprint-684-685-master-execution-plan.md

Story review and execution plan for Sprints 684 and 685 (group shaping), cut to the MVP with the operator on 2026-11-23/24. Grounds every decision in the code: shaping already keeps revisions (immutable versions, an active/previous pointer, undo, restore), Page and Klatch already share one group model (the roster is the app's audience on the host; owner and member; guests join by name at the owner's discretion). The rod is that revision model applied to a shared item, in the desk kit, delivered on Page and Session first and Notepad after (S1–S4); Sprint 685 keeps the `meet poll` fix and the coverage matrix (C1–C2). Stories close on unit tests with no judge pass; the integration runs are Sprint 699 stories I1 and I2. Lists what was unlinked or deferred (per-item roles, the draft lease, cross-outpost steering, whiteboard and storyboard co-editing) and why.

### sprint-699-master-execution-plan.md

Sprint 699, release train 1 (filed 2026-11-23): one coordinated hosted-plane deploy for the changes Sprints 682 and 697 merged to dev, tested once on the frozen dev commit, deployed once with operator go, with the deferred live verifications (A2 edge matrix, A5 feel-at-home on dhnt.io, C4 member matrix) as its stories and checklist. Records the no-deploy-per-sprint rule.

### sprint-697-master-execution-plan.md

Execution plan for Sprint 697 (backlog, planning only, reviewed with the operator 2026-11-23): the seven stories that make shaping-enabled sites explorable by any agent (A1 template channels incl. `/agents.txt`, A2 hosted-plane release incl. the same-origin `/mcp` proxy, A3 MCP engine side via `bashy mcp serve` profile `site`, A3b bashy `site` verbs, A4 bashy identity to sites, A5 feel-at-home acceptance matrix, A6 docs), their vendors and points, the three waves, the gates and venues, the rules carried from Sprint 693, the story review of 2026-11-23 (eight findings with proposed story changes: statuses, A3b priority, A3 title, the unowned hosted-plane proxy, A1 size, A4 dependency, vendor load, decision lists), a start checklist, and the decisions settled or still reserved.

### design-shape-offer-audience.md

Proposed design for Sprint 683 open decisions 3 and 4, input to Sprint 705 S3.
An offer's audience uses the grant-rule grammar (circles AND (groups OR
emails)) that sharing and `shape scope` already use, checked at request time
against the verified member stamp, so offers are members-only by construction.
`--all` means every member, which fixes the bug where anonymous callers could
see `--all` offers. A page release pins the shared releases of the components
it embeds on the same host and is verified against them; a suite stays the
access unit, not the version unit. Records the D4 root-cause hypothesis:
releases are principal-private by default. Future input, not stories (operator,
2026-11-24: filed only when a real need appears).

### access-tiers.md

Design of record (operator decisions 2026-11-24) for who a caller is across the cloudbox and bashy stacks: three levels (anonymous; account = a logged-in cloudbox account without a live host, served by the hosted plane; owner = an account with a host paired with the master, a satellite being a kind of outpost), four per-host relationships on the outpost stamp (anonymous < account < member < owner; the wire value `signed-in` becomes `account`, "user" is reserved for the OS user), owner-defined app roles, six invariants (identity mandatory for any kept change, cloudbox the only authority, no second permissions engine, refusals demote), a sixteen-case coverage table, and the three shaping workflows (anonymous configures declared features; group shaping on the owner's host with the owner's LLM; team shaping as group shaping with contributing owners as members of the primary owner). Lists what exists, the gaps filed as Sprint 706 R1-R8, and the sprints retired by the model (639, 640, 667, 669, 679, 689).

### sprint-683-master-execution-plan.md

Sprint 683 (backlog, held until Sprints 701 and 705 S3 settle the agent UI; repositioned 2026-11-24 on one shapeable page whose embedded components are equally shapeable, the model for any website). The owner/producer verbs (release, offer, adopt, submit) already work for every shaped app, and the 682 build blocker is fixed on bashy main, so the sprint is now about evidence: O0 confirms the fix and closes its todo, O1 runs an owner publish e2e on the apps the operator uses most (form/poll, then viewer, then brainstorm), and O2 writes the owner kb runbook. Also covers why form definitions are data rather than shaping, the dependencies on Sprints 703 and 706, what is not done, and open decisions.

### sprint-706-master-execution-plan.md

Sprint 706 (backlog, planning only, reviewed with the operator 2026-11-24): the access-tier gaps as stories R1-R8 (stamp value `account` with alias and conformance fixture; the account tier live through a satellite, blocked on the cloudbox admission ticket; vocabulary sweep; stale plan headers; group and team shaping on shape routes with the owner's LLM, absorbing Sprint 640 T1/T8; the public personalization wish list from 615 S21; the consented access request from 665/669; the shaping evidence baseline from 689 D6), the R5 defaults awaiting operator confirmation, dependencies, venues, and the record of the six sprints closed with it.

### sprint-732-master-execution-plan.md

Sprint 732 (backlog, planning only, awaiting operator review): a shared shaping ledger for group shaping in the A/O/C workflow. Borrowing the record from the Self-Improvement Memory paper (arXiv 2611.18856) without its performance claim, it derives a per-app ledger from the version line and the candidate and incident records, keyed by problem, with each attempt's agent, request, rationale, prediction, observed verdict and standing (active, undone, restored, superseded, rejected, failed), so undo and restore never leave it stale. Records the code inspection at current heads, the gaps (nothing assembles or shows the records; no rationale or prediction; rejects forgotten; a contractor's push carries the patch only), the design (shown in both briefs and the work clone, viewer-filtered, size-bounded), the triage of five stories and two linked todos, the sequence, checks, open points and risks.

### sprint-709-master-execution-plan.md

Sprint 709 lets a member with the shape scope work on the owner's app from their own machine: `bashy mcp connect` bridges the member's local MCP client to the owner's site MCP with the member's cloudbox account token exchanged on the satellite (identity only; the share and the scopes stay the owner's, per app, and no OS password is used), the site MCP gains `shape_pull` and `shape_push` (a patch on a base revision, refused when stale, verified on the owner's host, approved by the owner), and the A/O/C sandbox e2e covers the path.

### sprint-637-master-execution-plan.md

Sprint 637 (backlog, planning only, reviewed with the operator 2026-11-25): a reminder set through any bashy front door either fires or tells the user why not. Records the code inspection at current heads (no engine-state check exists; the schedule unit is opt-in; jobs on the dev box stopped firing silently), the triage (R1 engine state and hint, R2 stale comment, R4 kb runbook, R6 operator hygiene kept; R3 overdue-todo alarm and R5 desktop toast moved out as standalone todos), the decision to change the one scheduler code base in coreutils rather than duplicate it, the coordination steps with the POSIX certification sprint manager before any code, the sequence, targeted tests, checks and risks.

### handoff-sprint-706-703.md

Vendor-neutral handoff (2026-11-24) for the next conductor of Sprint 706 (access tiers) or Sprint 703 (group shaping follow-ups): where to start, both cards in one screen with story ids, priorities and dependencies, the operator decisions still to confirm (R5 defaults), the open cloudbox tickets named by id, the six sprints closed that day and where their pieces went, and the mechanics (provenance trailers, the backlog-sprint closing recipe, verb gotchas, the gate venue). Nothing in it depends on any agent's private memory.

### agent-ready-sites.md

Design of record for making a shaping-enabled website explorable by any agentic tool the way a repository with `AGENTS.md` is. Grounded in the Sprint 693 live matrix and a review of shipped agent behavior: no agent probes well-known files or follows link relations, every agent reads the body it receives, and content negotiation decides that body. Design: an in-page agent block placed first in every representation (the first-contact rule, including error pages), Markdown-first serving to agent `Accept` headers and user agents without cloaking, a pointer layer of existing conventions, an owner-set MCP endpoint served by `bashy mcp serve --transport http --tools site --site-app <app>` (or `--site-dir <dir>`; `--outpost` behind outpost's `<app>/mcp` proxy) so an agent switches protocol instead of downloading a binary, bashy as the reference consumer (`bashy site key`, `--sign` RFC 9421 Web Bot Auth, `site.json` `trusted_bot_keys`/`trusted_key_directories`/`trusted_origins`), and a feel-at-home acceptance matrix. Stories A1–A6 + A3b on Sprint 697; Decisions 1–3 settled (Decision 3: A4 landed optional signing + verification alongside stable `bashy-fetch/<version>` / `bashy-site/<version>` user agents), Decision 4 reserved.

### sprint-697-evidence.md

Sprint 697 shipped-contract record: A1 template channels, A3 same-origin `/mcp` endpoint, A3b `bashy site` verbs, A4 Web Bot Auth identity with Decision 3 settled, A6 docs and the `make-your-site-agent-ready` kb runbook, with verification gates.

### sprint-693-evidence.md

Wire-level evidence for Sprint 693: the live before-state of the company pages (one single-page shell for `/` and `/about`, Accept ignored, no robots.txt or llms.txt, no revision), then one row per story with the worker's delivery (commit ids) and the conductor's own verification, and the sections that the live release, the discovery matrix and the owner round trip fill in. Hosts by role; no hosted-plane internals.

## plan-sprint-692-release-thin-bashy.md

Sprint 692 plan of record after the operator rescope of 2026-11-22: one goal, release v1.0.0-rc.40 with bashy as the invariant core (bsh plus dispatcher and internal verbs) and every other command an independently built, shapeable binary behind its adapter. Lists the done-when criteria, the kept stories with vendor owners, the three fleet waves, and the binding rules; records what was closed wontfix and the deferred per-command module split.

## handoff-sprint-694.md

Handoff from Sprint 692 to the Sprint 694 manager. State of record: `v1.0.0-rc.40-dev`
published as a pre-release only, tier verdict FAIL (Windows product defect, since fixed on
bashy main; macOS venue), nothing promoted. Gives the rc.41 recipe (which gate legs to
rerun and which to reuse, dist, receipt, one release run, three-lane tier verdict,
promotion on the operator's go), the carry-over stories in order, the venue facts and
traps learned on 2026-11-22/23, and the clean-up candidates.

## handoff-sprint-692.md

Handoff from the Sprint 677 conductor (2026-11-22): what 677 delivered (bsh module, per-command Bash# adapters, embedded adapters, Go 1.27.4, image roll, no-downgrade guard), the integration evidence, the 11 stories carried to Sprint 692 in priority order with recorded root causes, the clean-plate state, the binding rules and known traps.

## page-live-group-page.md

Design of record for the `page` desk app (planning-only sprint, software-shaping epic, filed 2026-11-23). A facilitator needs, while the group is present, one page everyone opens once, forms that collect information, votes, a timer, chat and demo links, and a record afterwards; today that is five tools and five URLs. The page composes the existing engines as live blocks (native blocks over the desk-contract apps form/poll, viewer, notepad, brainstorm and chart; embeds for whiteboard, table, Klatch and demo-queue), served through one SSE stream with revisions, never merges. Both doors are first class: the satellite door with the signed identity stamp and the LAN door with a fixed port and mDNS name, each under a short join code that is the page's path. Anonymous participants join with a handle bound to their client address for the session, authenticated participants are known from the stamp, and that identity is the respondent key for every tally and form collection; the export writes handles, never addresses. States the two speeds of "on demand" (data verbs run by the facilitator's agent in seconds; block kinds and templates shaped through `bashy shape wish` in minutes), the rejected alternatives, the eleven stories (including the organizer dual view) with the MVP aimed at a weekly class, rules, non-goals, follow-ups and the operator decisions.

## group-shaping-coverage-matrix.md

Sprint 685 story C2. One row per registered app and CLI-only tool (page, session, notepad, form, brainstorm, chart, viewer, whiteboard, film, video, board, table, notes, site, clips, files, klatch): artifact, who may write, guest door, shaping hook, bashy entry point and revision adoption, each with file and line evidence from the code; the verdict column is filled by the Sprint 699 I1 run. Links the standalone follow-up todos for the gaps that are not small (whiteboard, film/video storyboards, brainstorm shaped registration, table Linux-only). Includes the steering inventory: a shared-session directive reaches a weave run on another host but not a bashy chat session, no inbound A2A server is wired, and cross-outpost steering (X1, X2) waits for Sprint 679.

## sprint-712-shapeware-exploration-2026-11-25.md

Full record of the 2026-11-25 Sprint 712 exploration session, kept so the operator can revisit and finalize it later. It covers:
- the reverse-SDLC thesis (field shaping loop; fix then use; TBD features built on demand)
- the shapeware model (faces in standard languages; delivery channels; statuses; the release spectrum from requirements to traditional; critical features)
- UI as restricted semantic HTML/CSS alongside the converter path, and meshing with the web through companion files
- the operator decisions D1–D14, including the band floor for field building, QA of skills against low-end local models, and packaging a release as a skill folder ("shapeware is a skill with a contract")
- four dev-box experiments with their findings: the UI fence, the hello-world SDLC walkthrough, the two-sense visual/audio rendering, and fence-language support
- the todos filed and the open questions

The appendices hold the experiment sources. The skill draft itself lives on story b35b89620f88.

## handoff-sprint-712-shapeware-spec.md

Handoff at the end of the 2026-11-25 Sprint 712 exploration session. It covers:
- what to read first (story b35b89620f88 with the shapeware skill draft, then the exploration record)
- the current state (backlog sprint, pilot todo, four bug todos, the shapeware name and GitHub org; nothing left running)
- the next task: defining the shapeware spec layout and structure, meaning the skill-folder layout, frontmatter metadata keys, the feature-list and known-issue schemas, the checks/ contract, UI assets and the trusted-core reference
- which decisions are settled, the existing conventions to inspect and reuse, the rules for the next session, and the open questions that bear on the spec

## sprint-712-master-plan.md

The operator-approved master execution plan for Sprint 712 (2026-11-25). It covers:
- a review of where the sprint stands against its story acceptance, and five review findings
- Phase 0: start, and recording the operator rulings D15–D17 (a shapeware folder is a superset of an Agent Skill folder; missing parts take defaults; `SKILL.md` declares `type: shapeware` and carries a standard "how to run" block for any agent)
- Phase 1: the shapeware spec v0, meaning the layout, metadata keys, the defaults table, the feature and known-issue schemas, the checks contract, UI assets, the trusted core, and versions and upgrades
- Phase 2: the recommendation doc that completes the story; Phase 3: operator review and close; Phase 4: proposed follow-ons
- non-goals and verification

## shapeware-spec-v0.md

The draft shapeware spec v0.1 from Sprint 712 (2026-11-25): what a shapeware release is on disk. v0.1 applies the cross-vendor review (codex, agy, muse, GLM; 28 findings, D20) and adds the minimal lifecycle in `dag.md` (source, build, test, install, run; D21). It covers:
- the governing rules: a superset of an Agent Skill folder (D15), defaults for missing parts (D16), a self-describing `SKILL.md` with `metadata.type: shapeware` and a standard run block by intent (D17), and four trust rules (text is data; the installed folder grades its copies; fail closed; the owner activates)
- one layout for the repo and the skill: skill directory names as defaults, `metadata` path keys where a repo already uses those names, and a zero-touch `skills/<name>/` alternative
- the frontmatter keys, the known-issue and feature schemas, the checks contract, the effect cap as the verifier reads it, UI assets and the trusted core
- versions and upgrades mapped onto the existing `bashy shape` refs, adopt and undo; the defaults table; the computed release class; and enabling an existing repo
- what code was inspected, the validation results (including two runs by agents with no shapeware context) and the findings for follow-on
- the hello example and the lint and release-class skill-scripts, verbatim, in the appendices

## sprint-712-recommendation.md

The Sprint 712 story deliverable (2026-11-25, for operator review). It answers whether software should ship as shapeware: yes, for a bounded class, starting with a narrow pilot on `form`; no-go for scale until signing and provenance exist. It covers:
- definitions and a lifecycle map walked end to end with the hello example
- the three schemas (the manifest is the spec, the known issue, and a minimal field-session record)
- tabletop simulations of the #3230 timing defect, agents with no shapeware context using hello, and the form launch baseline
- a comparison with the current release train, risks with mitigations, the status-quo dissent, and what stays conventionally frozen
- the recommendation, the metrics, and a prioritized follow-on split with proposed owners and venues

## sprint-719-evidence.md

The one shared evidence record for the bashy v1.0.0-rc.41 candidate (bashy 0665ffb3). It lists each gate leg with its run, commit, result and digests (build, `bashy dag test`, sealed Bash gate, Linux and native-Windows dispatch e2e, shaping smoke, dist, local release receipt), proves why the sealed Bash gate evidence from an earlier commit still applies, and records the findings with their root causes (desk modules, advisories, the quic-go build break, venue reds, the macOS QA host clock wrap). Hosts are named by role.

## conform-plan.md

Plan for `dhnt/conform`, a public Go module holding the invariant suite behind shapeware spec section 19 (shaping is certification): the CONTRACT.md runner, normalization rules, one DOM walker (Go and JS), the reference noise baseline, the mutation harness, and sealed evidence records. It states the gap, dependency direction (conform imports nothing; bashy ships it), scope and non-goals, six bounded stories, acceptance on the gate host, risks and rollback. Rescoped at the Sprint 721 close: Phase A builds conform; Phase B runs one experiment, "the spec reproduces the app" (spec only -> source, judged behaviourally by conform, cheapest L3 per vendor, n=3).

## handoff-sprint-722-conform.md

Warm handoff written at the Sprint 721 close for the conductor of Sprint 722. It gives the reading order (conform plan, spec section 19, the 721 thread, the 722 card), the operator's rules for 722, the inputs ready for Phase A (the contract prototype on an agent-bench salvage branch, the shapeware pack, the form reference in the v0.1 layout), what 721 delivered, the todos carried forward, and venue notes learned during the sprint.

## conform-phase-b-protocol.md

The Sprint 722 Phase B protocol, fixed before any run, so that outcome and accounting cannot be tuned after seeing results. It defines:

- the question and the narrow claim;
- the five subject bindings, with n=3 each; no subject touches conform in Phase A;
- the primary outcome: a per-run PASS when the conform verdict is PASS on all three layers (the visible CLI contract, hidden parameterized CLI cases, and the UI inventory plus interactions and JSON API checks);
- the secondary measures, including the visible-hidden gap as an overfitting signal;
- the accounting kept for every attempt, failures included;
- identical isolated conditions and integrity: the grader and the hidden cases live outside the agent's reach, in the private docs repository;
- the reference, mutant and null controls;
- the rerun rules (venue failures only);
- the batches and the viewer-book report.

## shapeware-workflow-findings-2026-11-26.md

Input material for Sprint 728, which plans the complete shapeware workflow and its standard processes. It is not the plan. It records:

- what was measured: spec to source on `form` (Sprints 722 and 723) and instructions to spec on the notepad stories (Sprint 727);
- twelve findings, each with its evidence, such as the spec deciding the outcome more than the model tier, most surprises being venue faults, and instructions to spec being fast but not deterministic;
- what the findings imply: the spec review as the human gate, the first passing build as the reference, small judged passes, independent cases, fixed venue conditions, recorded roles, and budgeted quota;
- the eight questions the plan must answer, and the list of existing plans, protocols, runbooks and tools.

## shapeware-workflow-standard.md

The shapeware workflow as one standard, first draft (Sprint 731, stories W1 and W2), for the operator review. It answers the eight questions of the findings and uses bashy's `form` app as the proof, stage by stage:

- the terms, defined once, and the rules: the lifecycle (`dag.md`) is part of the spec with effects and a measured band per step, a spec is compiled before it is built, the contract is the end-to-end test on the build and on the installed app, two human gates, failures classified by cause;
- the eight stages (instructions to spec, compile, spec to source, build, test, install, run or serve, field shaping), each with who does it, the artifact, the gate, the evidence and whether it is proven, partly proven or not yet proven on `form`, with the source;
- what done means for one shaping pass, using the format's release classes ("verified with tbd" is normal);
- the agent roles and the people (owner, account member, contractor) with the gates they hold;
- hidden cases when no reference app exists, and where records live per app and per binding;
- how an app enters: an existing app by the reverse step, a new one by the instructions step, each with what must exist before a builder is asked and its proof state;
- the dogfood order in waves, each its own sprint with a one-line entry condition (`form`, a second app with agents in every role, `chart`/`page`/`viewer`, then the other examples), with `kit`, `gallery` and `evidence` left to their own decision;
- how a new tool or model joins: the builder drill on certified specs, its cost in runs, session time and shared plan quota, the record it leaves and what is not built;
- the open items for the operator review (Sprint 726, the notepad forward test, the judge study, the Sprint 723 carry-overs, Sprint 730), each with options and one recommendation, and what is deliberately left out.

## handoff-sprint-731.md

Handoff note for Sprint 731, written when the conductor seat changed on 2026-11-26. It gives the reading order, the operator rulings in force, the stories triaged into two independent tracks (the trip on `form`, and the standard documents) with what to do for each, the one item still in flight with its owner, the mechanics and traps of running a drill, the held resources and the backlog outside the sprint.

## plan-reverse-sdlc-workflow.md

Plan for operator review, written at the close of Sprint 723. It sets out how software shaping becomes one repeatable workflow ("reverse SDLC") and how it is dogfooded on bashy's applications:

- what Sprints 722 to 725 established, and the eight gaps (W1 to W8) between that and an end-to-end workflow;
- the roles (spec author, judge, builder, conductor) and how each qualifies;
- iteration 2, the MVP loop: an agent writes the spec for a second app, another vendor's agent writes the hidden cases, two bindings rebuild it, and the measured minimum band is recorded;
- what is deliberately not in the MVP, and the later sprints in order;
- budget (quota), venue, risks and the decisions needed.

## sprint-723-report.md

The Sprint 723 result, narrow by design: with spec v2 of bashy's `form` and the judge available to the builder, agents from three vendors rebuilt the app, and so did the tier one step below each. It gives:

- the per-vendor table (start tier, one step down, the bound), with Google and Zhipu left open by quota;
- every run with its session time and note;
- the failures by cause: one agent defect, four runs decided by harness conditions that were then fixed, three quota refusals, no spec gap and no judge defect;
- the controls, digests and limits.

## spec2src-protocol-v2.md

The Sprint 723 protocol, fixed before any scored run. It replaces the Sprint 722 Phase B protocol for the model ladder and defines:

- the question: which model tier of each vendor reproduces `form` from spec v2 with the judge's tool in the loop;
- the ladder: each vendor's start binding three times, then one step down or up three times, with results reported as bounds;
- the primary outcome over three layers, with every hidden case independent of the others;
- the conditions (spec v2 fixture, a standalone `conform` on the subject's PATH, the 30-minute cap, the guard) and the grading venue, where each phase runs in its own namespace;
- the reference, null and mutant controls, and the grader digests;
- the classification and rerun rules, the batches with their seeds, and the disclosures.

- **`plan-sprint-698-outpost-reliability.md`** — Describes the owner-scoped master read path, Windows and WSL disk reporting, alert and retention fixtures, and delivery within the sprint time box.

## sprint-726-protocol.md

The protocol for the Sprint 726 notepad builds, fixed before any builder ran. It adds to protocol v2: the four role bindings (spec author, judge, two builders, from four vendors), the `t3-notepad` task and its one venue difference (`bashy lens` as the converter the contract names), two verdicts per run reported apart (behaviour and lifecycle), the pass rule, the controls with their digests, and what is disclosed (reference defects no case asserts, the smoke run).

## plan-spec2src-calibration.md

Plan for Sprint 723, from the Sprint 722 results. It classifies every Sprint 722 failure by cause (spec gap, agent defect, judge) into seven spec gaps: an undemonstrated YAML requirement, undefined `--fields` semantics, implicit open vs closed outputs, no page-interaction acceptance line, accessibility rules buried in one bullet, undescribed definition shapes, and behaviour mixed with reference operation. From these it proposes soundness criteria for a shapeware spec. It plans form spec v2, independent hidden cases v2, conform available to the agent while building, and a model ladder that starts at the latest middle tier per vendor and steps down or up to find the minimal tier (at least 2 of 3 PASS).

## shapeware-qualification-process.md

The proposed standing process behind Sprint 723. It has two coupled halves, modelled on POSIX certification. The first is how a shapeware spec is created (author, validate statically, certify the reference, write independent hidden cases, check that qualified builders reproduce the app, publish with evidence). The second is how an agentic tool and model binding is qualified for a role (builder, judge, spec author) through drills with a protocol fixed before runs, an isolated guarded harness, grading only on the lane, a judge audit and narrow reports. Qualifications are recorded per binding, role and spec version, and feed the bashy agent bands. The cycle is bootstrapped from one reference app, a certified spec, frozen hidden cases and an adjudicated reference judgement. Sprint 723 is iteration 1, on `form`.

## handoff-sprint-723.md

The mid-sprint warm handoff for Sprint 723. It gives the reading order (card, plan, process doc, spec sections 5/19/20, the 722 protocol), every operator ruling in force, and the story status. S1 (criteria) and S2 (form spec v2) are done: the reference certifies against contract v2 (14/14 PASS, 109/109 mutants). The next stories are hidden cases v2, harness v2 and the L4 batch. It also carries the Sprint 722 mechanics and venue traps (Keychain opt-ins, the adapter cache, the auto-update switch, the sandbox guard, lane-only grading, the daemon leak, safe commits in shared checkouts) and the resources held.

## sprint-731-report.md

The result of taking bashy's `form` the whole way by agents (Sprint 731): the stage table with who did each stage, the gate, the result and the band; what was built for it (a lifecycle for the app as a spec, a lifecycle check in the grader, the operate drill, a runner that cleans up); every run; seven findings, among them that the lifecycle steps need no model, that a service app needs a defined serve and stop, and one venue fault that looked like a build failure; the limits; the questions for the operator review.

## handoff-sprint-726.md

The handoff note for Sprint 726, written by the Sprint 731 conductor after triaging its stories: the operator's rulings (the spec author writes the lifecycle, no required owner step, a mechanical end-to-end test of the lifecycle after the spec and after each build, the kb runbooks used and improved), the master execution plan (six steps, each with who does it, what is delivered and its gate), what already exists from the form drills, the traps found in Sprint 731, and what is left out.
