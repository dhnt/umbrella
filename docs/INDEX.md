# Umbrella docs — index

- `plan-s568-master-execution.md` — Sprint 568 design plan for shared human/agent membership and bidirectional service communication

- `build.md` — hydrate once, build each subproject from its root; sibling-replace convention; gotchas

- `plan-s571-posix-certification-readiness.md` — Sprint 571 resolution of 67 residual test purposes and POSIX certification dossier readiness
- `plan-s575-master-execution.md` — Sprint 575 layer separation (Classic ← Bash# ← Yoke) with shrink-only import ratchets; follow-ups 581 and 582

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
- `brand/README.md` — product marks for cloudbox, satellite, outpost and bashy: rules (45° mirror axis, one square size, shape before color) and per-mark files
- `sprint-622-master-execution-plan.md` — Sprint 622 master execution plan: software shaping as the one theme (canonical definition, aligned READMEs, qiangli/bash for sh + coreutils, cloudbox/satellite/outpost/bashy product marks); planning only
- `sprint-627-m2b-weights-evidence.md` — Windows test host model staging: disk preflight, immutable revisions, sizes, hashes and elapsed time.
