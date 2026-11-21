---
id: ee056056de3e
kind: refactor
title: 'Convert commands to folder adapters: bashy dispatch calls per-folder Bash# adapters (optional/toolchain/yoke/examples/custom)'
seq: 588
status: todo
priority: p0
created: 2026-11-21T09:22:07.571881Z
assignee: agy-gemini4-carbon
sprint: 677
sprint_id: 334e4662-d75c-5c5f-8671-7b62ea882de1
sprint_title: Fast build, small core binary, and shapeable Yoke CLI modularization
---

FINAL STRUCTURE (operator 2026-11-21 typed, via conductor claude+2; supersedes all earlier versions of this story):
(1) bsh = Bash 5.3 + Bash# + POSIX-required coreutils, own module/build in bashsharp - DONE (bashsharp 5848aff, accepted).
(2) bashy = bsh + dispatcher + INTERNAL verbs (bashy's own: commands, app, skill, agent/tool/model, self, inspect, doctor, version and similar) which STAY in bashy untouched - do NOT convert internal verbs.
(3) The dispatcher routes every non-internal command through the SAME few-line Bash# adapter pattern into folder-organized entries in the bashy repo: optional/ (non-POSIX classic commands/tools: GNU extras, jq, tar...), toolchain/ (third-party toolchains: go, node, python, rust, cmake...), yoke/ (agentic verbs: weave, sprint, kb, mb, meet...), examples/ (example apps/commands), custom/ (managed/registered external CLIs: registry aws/gcloud/kubectl/helm/gh, podman/ollama engines, otel, agent CLIs claude/codex/agy, user-registered commands).
(4) Command flags/options/args/output/exit codes UNCHANGED; bashy's calling code switches from in-process constructor calls to the command's adapter, argv through unchanged.

WORK: STAGE 0 pilot - one command (from optional/ or yoke/) end to end: folder entry (few-line Bash# adapter; minimal Go main calling the existing constructor only where a Bash# wrapper does not fit, say why) + its dispatch case calling the adapter; parity evidence (help/args/output/exit identical) + standalone build GOWORK=off; commit. Then folder by folder, commit per command/cluster, fast unit tests written+run per cluster. Commands that do not fit the adapter pattern go on a short EXCEPTION LIST here (verb + root cause). FINAL STAGE: drop the unused generator/dispatcher code (internal/cmdgen, tools/cmdgen, internal/agentos/cmdcatalog + seam) - keep build-speed caches; prove unused via grep/build/tests. One integration run at sprint end only. Sync rule: current origin heads, rebase before submit, drift clean on touched modules. Producer first, bashy dispatch next, umbrella pins last.

INDEPENDENCE RULE (operator 2026-11-21, via conductor claude+2): no non-internal command depends on another command. Each command (optional/, toolchain/, yoke/, examples/, custom/) builds ALONE and links only shared libraries (yoke pkg/*, coreutils, bsh), never another command's package. A command needing another calls it via 'bashy <verb>' across the process boundary; shared state stays in existing stores/wire. Shared logic lives in libraries - duplicate first where needed (e.g. mb's sprint lookup, dag's sprint capacity). ACCEPTANCE ADDITION: a per-command dependency test (like bsh's link test) asserting no other command's package appears in go list -deps for the converted command; the test ships with the command's cluster and runs in its fast unit set.

INDEPENDENCE RULE REFINED (operator 2026-11-21: 'even it means duplicate code; notepad and viewer may share same pkg, but they must be able to be independently built'): sharing a library package IS allowed. Each command must build ALONE from its own entry with its OWN pinned library versions (its adapter module pins what it uses), so changing/shaping one command never rebuilds or breaks another. A change one command needs in shared code goes into a copy local to that command or a new library version ONLY it pins - never an edit that silently alters other commands. Acceptance per command (final form): (a) builds alone GOWORK=off from its own entry; (b) dependency test shows no OTHER COMMAND's package in go list -deps (shared libraries yoke pkg/*, coreutils, bsh are fine). This refines the earlier independence paragraph where they differ.
