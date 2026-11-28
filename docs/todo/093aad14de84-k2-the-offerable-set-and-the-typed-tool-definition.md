---
id: 093aad14de84
kind: feature
title: 'K2 the offerable set and the typed tool definition: model, tool, agent, registered command (ToolCommand overlay, no new runner kind)'
seq: 830
status: done
priority: p1
created: 2026-11-27T15:34:19.121048Z
assignee: codex-gpt6.2-astra
sprint: 739
sprint_id: 2a232332-0066-5763-8821-db4148f8dd1e
sprint_title: 'Commands and folders as a service: offer bashy commands and designated folders to your trusted group'
closed: 2026-11-28T07:19:36.702646Z
closed_by: claude-opus5.5
---

Plan: docs/sprint-739-master-execution-plan.md §3.1, §4 K2. Two parts.

(1) The offerable set and the typed tool definition (moved here from Sprint 740 G1). Eligibility is one test: NAME is a fleet model, a fleet tool or agent, or a registered command (bashy commands add). bash, Bash#, coreutils and bashy internal verbs (read, write, edit, search, ast, kb, todo and the like) are refused, naming the reason. The class (model | tool | agent) comes from the fleet record, not a flag. Every offer carries one typed tool definition: name, class, model-facing description, typed input schema (the record args), output shape, effects, unit (token for model and agent; call or a named output unit for a tool). An offer with only an untyped argument list is refused naming what is missing. Definition digest = the existing tool-definition SHA-256 (yoke mcp policy.go ToolsSHA256 canonical form), computed for the one definition.

(2) No new runner kind: for a registered command generate a user-overlay ToolCommand (tool binary bashy, mode print, exec: bashy NAME {args}, effects + timeout from the registered record; herald.yaml pattern); bashy binds the record's own schema (registered.go:390). FIRST verify the door routes a model-less bashy tool row (cligw catalog.go:280-315 deriveInventory needs a tool+model binding); if not, that catalog change is part of the story.

Accept: unit tests per class (definition and digest for a model, a tool, an agent, a registered command), internal-verb refusal, untyped refusal, digest changes when the description or schema changes. Not in MVP: typed schemas for bashy's untyped built-in verbs; source digests and published source (Sprint 740 G1).

Code inspected 2026-11-27 (revised after review): yoke pkg/fleet commands.go command_schema.go types.go toolcommand.go baseline/tools/, pkg/toolcmd print.go:84-90, pkg/cligw catalog.go, mcp direct.go:56-64,179-309 policy.go; bashy internal/agentos registered.go. Revised at the sprint review 2026-11-27 (operator: every offer is a typed tool call in one of three classes, model, tool or agent; every call is metered whether free, shared or paid; Sprint 740 adds only the payment layer).

Tags (operator 2026-11-27, plan §3.1): the definition carries an optional tags list of free words (bashy offer NAME --tag a,b), like todo labels: no fixed list, no hierarchy. The fleet record's existing capability word (toolcommand capability:, e.g. transcribe, video, image-generation) is always included. Tags are covered by the definition digest. bashy offer tags shows the words in use; bashy offer list --tag filters. Tags are for finding and grouping only: no admission, refusal or limit reads them (effects stay the authority), and equivalence between offers is by name or capability, never by tag. Accept adds: unit tests for the capability word auto-included, the digest changing with a tag, --tag filtering, a tag never changing admission. Code inspected 2026-11-27: yoke pkg/fleet/baseline/tools/*.yaml (capability:), pkg/atlas atlas.go:396 (Effects); bashy todo labels as the pattern.

Revised 2026-11-27 night (operator: to an external agent everything is a tool; the bashy CLI calls any LLM and agent one-shot). The Model and Agent classes take the typed definitions of M1 (49ae75a9a181): llm (bashy llm call) and agent (bashy agent call); K2 adds no second definition for them. Depends on M1.

Seam (conductor, 2026-11-27; after K1 and M1 merged into yoke main):
- New file pkg/fleet/offer.go: type ToolDefinition {name, class (model|tool|agent), description, input (JSON schema), output (JSON schema), effects ([]string, the same vocabulary as mcp.RegisteredCommand.Effects, e.g. net, read, spend), unit (call|token|seconds|bytes), tags []string}; Digest() = sha256 of its canonical JSON (tags sorted, the fleet record's capability word always included). func (c *Catalog) Offerable(name string) (ToolDefinition, error): a fleet model -> class model, built from M1's broker.MCPCommand() (llm) with the model fixed; a fleet agent -> class agent, built from M1's chat.MCPAgentCommand() (agent) with the agent fixed and a token_cap field (maps to delegate --max-tokens); a registered command (pkg/fleet commands.go) with a typed args schema -> class tool, input from CommandSchema; a fleet tool command with a typed schema -> class tool. Everything else refused with a typed error naming why: an internal verb (bash, Bash#, coreutils, bashy built-in nouns: the names bashy itself mounts) or an untyped record (name the missing field). Reuse M1's definitions; do not redefine llm/agent. If pkg/fleet importing broker or chat would cycle, put Offerable in a small new package (e.g. pkg/offer) instead.
- A registered command must run on the door through slash=NAME. Prefer the herald pattern (pkg/fleet/baseline/tools/herald.yaml): a hidden baseline tool `offers` (binary bashy, its Commands generated from the offered registered commands as exec: bashy NAME {args}, mode print, effects and timeout from the record) bound to a pseudo model, so cligw deriveInventory sees an ordinary agent row; only if that is larger, change deriveInventory/hasLaunchContract for model-less rows. Record which and why in the Delivery.
- No CLI in this story (K4 adds bashy offer); expose Offerable for K4 and T2.
- Tests: GOWORK=off go test ./pkg/fleet/ -run Offer and ./pkg/cligw/ -run 'Slash|Inventory'.

Worker rules (conductor claude-opus5.5, 2026-11-27; KISS/MVP):
- Read yoke/CLAUDE.md first. Work in the yoke submodule of your workspace on branch s739-k2, based on current origin main (fetch first). Change only what this story needs; no refactors, no renames, no new dependencies.
- Tests: targeted unit tests only (see the Tests line above). No full suites, no e2e, no network, no podman.
- Commit in yoke with trailers: Sprint: #739 / Story: #830 / Story-ID: 093aad14de84 / Agent: codex-gpt6.2-astra. Do not push main, do not bump any pin, do not edit other repos.
- Finish by appending a "Delivery" paragraph to docs/todo/093aad14de84-k2-the-offerable-set-and-the-typed-tool-definition.md (files changed, test command and result) and commit it in the umbrella workspace with the same trailers.
- Budget about 40 minutes. If blocked, write the blocker in the story, commit, and stop.

Delivered (conductor record): yoke main 098f9429 (worker commit 752683bc by codex-gpt6.2-astra, cherry-picked) + conductor repair 567a9efc. Root cause of the repair: the worker verified with -run Offer only; four existing tests regressed (cligw name ratchet, fleet CLI goldens, hidden-tool --builtin list, seeds-off tool set); fixed with fleet Tool.IsOffers, regenerated goldens and updated expectations (offers is first-party mechanism). Gate: go test ./pkg/fleet ./pkg/cligw ./pkg/broker ./pkg/chat ./pkg/toolcmd ./pkg/sharedfiles ./mcp ok.
