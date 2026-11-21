# Umbrella docs — index

- `sprint-656-release-handoff.md` — Next-TUI RC38 handoff: operator hold, accepted infrastructure, remaining security/candidate qualification, release route and preserved POSIX evidence.

- `sprint-656-master-execution-plan.md` — RC38 release-pipeline reconciliation: delivered infrastructure, exact benchmark limits, remaining QA work and current operator release hold.

- `plan-posix-certification-after-separation.md` — Sprint 675 follow-up: investigate all 67 S575 residual results and prepare evidence-backed POSIX certification packets using the tagged baseline.

- `sprint-666-evidence.md` — Sprint 666 exact source identities, installed smoke, three workflow traces, honest measurements and remaining native-host gates

- `plan-cooperative-chunk-transfer.md` — Planning-only MVP for desync-based file transfer, owner/mutual-member download groups, cooperative chunk scheduling, and signed GitHub bashy distribution

- `bashy-bashsharp-yoke-position.md` — Architectural opinion: portable shell environments, language composition, and coherent verified workflows across tools, agents, and machines

- `plan-self-contained-offline-bashy.md` — Sprint 654 master execution plan for protected offline bootstrap, reused artifact services and platform acceptance

- `plan-s568-master-execution.md` — Sprint 568 design plan for shared human/agent membership and bidirectional service communication

- `build.md` — hydrate once, build each subproject from its root; sibling-replace convention; gotchas

- `plan-s571-posix-certification-readiness.md` — Historical S561 readiness plan; outstanding R1-R7 investigations continue in Sprint 675 against the S575 evidence
- `plan-s575-master-execution.md` — Sprint 575 complete Bash ← Bash# ← bashy split, minimum changes, standalone fixed-dependency gates and owned-fork option
- `s575-separation-review.md` — Source-checked parser/runtime and catalog coupling findings before minimum-change separation
- `s575-runtime-boundary.md` — Independently reviewed owned-language-engine design with a narrow shared handler boundary

- `plan-windows-csharp-powershell-followup.md` — Sprint 573 continuation of Windows, C# and PowerShell coverage deferred explicitly from Sprint 562
- `media-desk-reference.md` — Reference for PDF, drawing, image, audio, video, and Desk team-collaboration tools, plus verification and competition workflows
- `plan-s595-master-execution.md` — Sprint 595 bashy CLI consistency fixes and capability-shaping plan: root causes, scopes, delegation, gates
- `sprint-597-master-execution-plan.md` — Sprint 597 Klatch participant CLI, bashy integration, and sandbox e2e delivery plan
- `sprint-598-master-execution-plan.md` — Sprint 598 satellite CLI scope, managed delivery sequence, and verification plan
- `satellite-operations-workflow.md` — Account selection, satellite discovery, paired-host inspection, explicit invite/transfer, and software shaping
- `sprint-598-verification.md` — Exact candidate revisions and remote fixture, regression, and read-only service smoke results
- `research-xonsh-python-fence.md` — Research: which xonsh Python/shell interop features the Bash# Python fence should adopt (two gaps; rest already covered)
- `agentic-cli-support.md` — Reference for bashy agentic CLI support across the built-in fleet catalog, install-agent wiring, ambient detection, and custom examples/fleet/tools/ recipes (including dsh)
- `bashsharp-review-agy.md` — External SOTA research (by `agy`) on modern programming language traits (2025–2026) and architectural/codebase gap evaluation for `Bash#` (`G1`–`G11`)
- `bashsharp-review-muse.md` — Agentic-era language trait re-ranking (by `muse`) from MultiPL-E / type-constrained generation evidence, plus Bash# gap evaluation (traits 1–11)
- `bashsharp-review-claude.md` — Bash# gap evaluation (by `claude`) against an evidence-ranked agentic-era trait list; G1–G7 with dialect-on superset path
- `bashsharp-review-codex.md` — Bash# agentic-era gap evaluation by `codex`: current-source reproductions, checking and runtime boundaries, research basis, and prioritized recommendations

- `sprint-610-master-execution-plan.md` — Sprint 610 story sequence, planned ownership, compatibility gates and planning-only scope
- `sprint-617-master-execution-plan.md` — Sprint 617 bashy shaping dogfood: source-verified baseline, P0–P6 wave with P7–P9 split off, vendor lanes, readiness ladder, session-slot workspaces and the classgo example split (planning only)
- `sprint-616-master-execution-plan.md` — Sprint 616 collaboration follow-ups: source-verified scope, vendor lanes, waves and gates (planning only)
- `bash53-gate-79-86-findings.md` — why the Bash 5.3 gate kept reading 79/86 (four disjoint fixture sets, wrong venue, stale claim) and the guards that keep it 86/86
- `bash-command-invocation-counts.md` — Every bash command sorted by invocations from the bashy execlog (2.84 M records, Aug–Nov 2026) plus the one-day OTel spool; where command telemetry actually lives and how to reproduce the tally
- `otel-agent-introspection-review.md` — What bashy's OTel machinery gives agentic tools for self-healing during and after a session, stage by stage; six gaps measured live and mapped to Sprint 611 stories
- `strands-shell-gap-analysis.md` — strands-agents/shell (in-process Rust shell, VFS, MCP) vs bashy: comparison table, six adopted gaps filed as todos (MCP per-call timeout, SSRF-safe egress, URL-prefix credential injection, indirect-exec guard coverage, agent wrapper test, read_file) and what was deliberately not adopted
- `sprint-615-master-execution-plan.md` — Sprint 615 free cloud workspaces (Codespaces first) as the casual user's session-scoped shaping host; requirements, stories, vendors, verification; planning only
- `bashy-agent-permissions.md` — per-agent authorization discussion: full CRUD+X command/flag matrix vs binding existing Atlas effect caps to the principal (recommended MVP), the bashy-as-sole-gateway vision, and HTTP method semantics incl. QUERY (RFC 10008) as prior art; discussion only
- `comms-strategy.md` — Sprint 620 strategy for two-way human/agent communications: CLI for agents + required web UI (PWA) for humans, instant clipboard/link switching into Klatch or the web UI, US-legal channel waves (web UI, ntfy, email, Klatch; then Discord/Slack/Telegram, SMS); planning only
- `sprint-621-master-execution-plan.md` — Sprint 621 master execution plan for Software Shaping TDD (`Red → Green → Refactor`), `shape-tdd.bsh` Bash# skill-script, `dag.md` test graph, and sprint retro loop; planning only
- `sprint-626-master-execution-plan.md` — Sprint 626 vendor services through one generic service door (`--provider`/`--route`, `bashy-svc-v1`), vendor lanes and measured seeds; planning only
- `sprint-626-acceptance.md` — Sprint 626 S7 client × door × service matrix (opencode, genie, ycode × shell, MCP, llm API slash=) with raw outcomes and root-caused findings
- `tool-commands-overlay-example.yaml` — tool-command spellings and unmeasured commands kept out of the yoke baseline (one command per name); the claude `/plan` TUI spelling
- `sprint-627-master-execution-plan.md` — Sprint 627 music-video showcase: `film` pipeline, oss draft → commercial final, permissive open-model picks; planning only
- `sprint-634-master-execution-plan.md` — Sprint 634 film follow-ups: local recorded translate + text stages, bilingual subtitle Latin-font fix; approved plan
- `sprint-635-lipsync-evidence.md` — Sprint 635: first visible lip sync (EchoMimicV3 on one rented GPU, then the full film with six lip-synced close-ups at zero cost on the Windows test host), pinned recipe, the twelve attempts root-caused, spend, what remains
- `sprint-636-master-execution-plan.md` — Sprint 636 bashy apps UI: Apps under Recent on the landing page, hand-authored Flow mark on the Shape button; filed plan
- `plan-sprint-655-one-app.md` — Sprint 655 one app MVP: normative command contract plus a minimum shapeable checker; conformance optional, tiers the declarer's choice; S2-S8 deferred
- `plan-sprint-662-shaping-friction.md` — Sprint 662: four shaping frictions found by Sprint 655 (contained checks, agent identity, git, jq); filed plan
- `plan-agentic-tool-support.md` — Sprint 671: official agentic tool set (11 built-in seeds), demotions to examples, kimi rename, dsh graduation, latest models; filed plan
- `plan-sprint-672-token-minting.md` — Sprint 672: owner minter token, bearer token edit, CLI parity for access tokens, rotation; filed plan
- `brand/README.md` — product marks for cloudbox, satellite, outpost and bashy: rules (45° mirror axis, one square size, shape before color) and per-mark files
- `sprint-622-master-execution-plan.md` — Sprint 622 master execution plan: software shaping as the one theme (canonical definition, aligned READMEs, qiangli/bash for sh + coreutils, cloudbox/satellite/outpost/bashy product marks); planning only
- `sprint-627-m2b-weights-evidence.md` — Windows test host model staging: disk preflight, immutable revisions, sizes, hashes and elapsed time.
- `sprint-627-m2b-image-evidence.md` — Windows test host image draft: pinned model completion, offline generate/edit results, envelopes, timing, memory and checksums.
- `sprint-627-m2b-narrate-evidence.md` — Live offline Chatterbox narration render on the claimed Windows test host, with envelope, resource measurements and artifact checksum.
- `sprint-627-m2b-transcribe-evidence.md` — Offline WhisperX SRT render on the Windows test host: local model binding, service envelope, time, memory, disk and checksum.
- `sprint-627-m2b-song-b-evidence.md` — Offline-by-default OSS rod fix, hermetic fixture gate and ACE-Step Windows-host render with zero transfer markers.
- `sprint-627-m3b-animate-evidence.md` — Native Windows Wan2.2 spike: GPU VAE decode stall, reused weights, bounded render and route decision.
- `sprint-627-m8-drafts-evidence.md` — M8: native ROCm 10 1280×720 FLUX verify passed, two oss drafts rendered and the storyboard locked (zero cost, no TDR); earlier blocked attempt kept.
- `shapeable-apps-worker-brief.md` — Sprint 631 worker brief (+ Sprint 632 addendum): fork-or-build rules (permissive license only, custom command in bashy/examples, job-only wording), shaping contract pointers, done means.
- `files-fbembed-quantum-port.md` — Sprint 631 S2b: the fbembed seam ported into a fork of the active Apache-2.0 File Browser upstream (four small patches + `backend/fbembed`), evidence, binary cost, consumer migration plan and open decisions
- `whiteboard-fork-no-phone-home.md` — Sprint 632 S5b: the excalidraw pin repinned so it has no phone-home of its own (Sentry, Firebase, analytics, Excalidraw+ and the vendor font CDN removed in the fork, not by the install patch), the before/after evidence, the by-name test comparison, and the whiteboard UI→CLI parity re-check
- `shapeable-app-catalog.md` — the shapeable app catalog from Sprint 631: notes, form, clips, site (+ chat template), board, whiteboard, table, plus files on the maintained fork; shared rules and what is still open.
- `sprint-632-master-execution-plan.md` — Sprint 632 shapeable apps phase 1: CLI parity for the eight catalog apps, outpost app-list integration, bugs; waves, lanes, gate; evaluation deferred to phase 2
- `agentic-command-skill-scripts-design.md` — Sprint 633 design of record: `agentic <command>` runs or forges a self-improving Bash# skill-script `<command>.bsh` (resolution ring, worth-it gate, forge make/run/refine/accept/undo, three training tiers, micro-shaping loop, SOTA basis)
- `sprint-633-master-execution-plan.md` — Sprint 633 `agentic <command>`: self-improving skill-scripts as the calling agent's muscle memory; what the probes showed, stories in four waves with lanes, gate, operator decisions
- `website-shaping-integration.md` — Sprint 638 design of record: an existing website joins shaping through an engine-hosted copy plus a link badge; engine review, 2026 survey, link contract, shaping levels and invariants, dogfood, follow-ups
- `sprint-638-master-execution-plan.md` — Sprint 638 website shaping: nine stories in three lanes (prefill, badge, scaffold, SPA fallback, promotion remote, policy levels, personalization, docs, dogfood), gates, seven verification steps, operator decisions
- `trove-content-app-design.md` — Sprint 639 design of record: Trove, an owner's shaped content space over local dirs, outpost hosts, git/GitHub, Drive and agent artifacts; one `bashy-node-v1` tree for agents and the explorer page for humans; members and agents contribute under per-mount rules in cloudbox's circle grammar, evaluated by trove from the relationship outpost stamps (alternatives weighed); present-on-the-fly with canned-or-generated renders; rod not fish; views, presenters and source adapters as the shaping hooks; two test cases, risks, follow-ups
- `sprint-639-master-execution-plan.md` — Sprint 639 Trove, planning only: operator framing (general app, scenarios are test cases), fourteen product stories plus two test cases (tree verbs, present, contribute, drive/gh, artifacts, circle-protected mounts, explorer, shapeable in all forms, media, lens recipe seam, docs, mail/cal, outpost relationship stamp, outpost share rule-form fix; T1 note by email, T2 contributed submissions), lanes, gates and venues, verification, decisions
- `docs/sprint-641-master-execution-plan.md` — Sprint 641, the try-now MVP: one end-to-end slice composed from Sprints 638, 639, 621 and 617 — a visitor shapes the ai.dhnt.io showcase inside the owner-declared feature list, proven Red-on-base then Green-on-candidate, quota'd and resettable, carried upstream as a pull request.
- `docs/sprint-641-feature-matrix.md` — Sprint 641's feature × audience matrix: what public/guest, member, satellite owner and dhnt staff may change on the showcase site, on apps on the owner's host, and on the hosted periscope/cloudbox SPAs; the four modes, the invariant floor that binds staff too, and the recommended MVP cut.
- `docs/dhnt-journey-design.md` — the dhnt journey: dhnt.io as the free desktop a person shapes by asking, then attaches their own machines to as the backend; the eight laws, the six rungs (arrive, shape your desktop, attach your machine, make your own app, share locally, run your own satellite), how shaping itself does the teaching, and the rung-1 detail the MVP rests on.
- `docs/vendor-chat-gateway-mvp.md` — Sprint 646 MVP: one Cloudbox remote MCP gateway (OAuth 2.1 + DCR, seven text-first tools, dynamic sync/pull routing) lets Claude, ChatGPT Work and Gemini chat steer the full stack, while claude/codex/agy/muse run on owner subscriptions as outpost workers; supersedes Sprints 642–645
- `docs/sprint-646-master-execution-plan.md` — Sprint 646 triage: dependency waves, per-story agent assignment across claude/codex/muse/agy, worker rules, merge and gate
- `docs/client-setup-claude.md` — Sprint 646 client setup guide: claude.ai web, desktop, and mobile reuse (custom connector, OAuth 2.1, redirect allowlist, scopes, revocation)
- `docs/client-setup-chatgpt-work.md` — Sprint 646 client setup guide: ChatGPT Work plugin (web, iOS/Android qualification, OAuth 2.1, redirect allowlist, scopes, revocation)
- `docs/client-setup-gemini.md` — Sprint 646 client setup guide: Gemini web Custom Connected App & mobile auto-sync (personal account, US, English, Keep Activity gates, OAuth 2.1, redirect allowlist, scopes, revocation)
- `docs/muse-connector-submission-pack.md` — Sprint 646 Muse Connector Platform submission pack: tools classed Read/Write/Sensitive-write from bashy effects, reviewer test account plan, and data terms
- `docs/software-shaping-paradigm-comparison.md` — Software shaping compared with CI/CD, vibe coding, spec-driven development, malleable software and other paradigms; 2025–2026 evidence, risks, levers, and the N:N and decide-after-seeing principles
- `docs/release-failure-ledger.md` — Release failure ledger: every test failure met while releasing, with last-green/first-red commits for bisecting, cause, class (product, test, metadata, venue) and fix commit
- `shaping-enable-a-website.md` — Owner guide: shaping-enable a static site through a private companion repo (assess, enable, edit, host, register, link), four visitor tiers, verify and graduate
- `sprint-667-master-execution-plan.md` — Sprint 667 provable relays: signed statements and relay-by-reference across outposts and satellites; planning only
- `docs/plan-one-agent-genie-hub.md` — Sprint 679 `bashy genie` ("One Agent"): unified agentic TUI and co-served HTTP/REST/A2A/MCP/ACP hub with direct `--agent` delegation and ephemeral `--cligw` LLM proxy; planning only
- `plan-s678-make-dag-bridge.md` — Sprint 678 make → dag bridge: generated teaching Makefile forwarder (`bashy dag --makefile`) + no-makefile fallthrough; pilot in yoke
- `plan-s660-generated-makefiles.md` — Sprint 660: replace hand-written Makefiles with generated dag forwarders (R1 bash/outpost, R2 bonsai/gfy/nadir/readline, R3-R4 bashy with release-gate equivalence)
- `plan-s681-live-session-commands.md` — Sprint 681: run a controlled agent's declared vendor session commands (clear/exit/resume/rename/compact/status) on its live session
- `plan-s682-consumer-shaping-example-apps.md` — Sprint 682: make every bashy example app consumer-shapeable (viewer/chart/session to --type shaped, genie.examples, member wish e2e, general runbook)
- `plan-group-participation.md` — Group shaping epic (Sprints 684 rod, 685 coverage + cross-outpost steering): the one-world pitch, shaping degrading to wiki-style revisions on artifacts, the shared-item contract (APP/ITEM, circle rule grammar, roles, agent members owned by a human, open invites inside a circle), delivery rules, dependencies, risks
- `sprint-688-master-execution-plan.md` — Sprint 688 worker supervision round 2: `mb --history` tail fast path, live session state detection and wakeups, deterministic rate-limit handoff (MVP), `agentos` MCP test leak fix, subscription/spend watermark alerts; §2a quota-exhaustion design and the observe-only point/band budget experiment
