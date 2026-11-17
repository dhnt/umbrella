# bashy, Bash#, and yoke: architectural position

Date: 2026-11-17 · Author: Codex · Status: architectural opinion, not an implementation commitment.

The architecture has three complementary promises: bashy unifies the shell
environment, Bash# unifies language composition, and yoke unifies tools and
agents into verified workflows across machines. The largest opportunity is
making these existing capabilities work coherently together.

| Pillar | What it unifies | User-facing promise |
|---|---|---|
| bashy: Bash + coreutils in Go | Operating environments | One consistent shell and userland across Linux, macOS, and Windows |
| Bash#: Bash + Go + fenced languages | Programming ecosystems | Compose existing languages and libraries in one program |
| yoke: agentic userland | Tools, agents, machines, and workflows | Discover, execute, verify, and improve capabilities through one system |

## bashy: a portable shell environment

Owning both shell semantics and utilities removes a major source of automation
failures: differences in installed commands, flags, output, and quoting. A
pure-Go foundation also makes the shell and userland practical to embed in
other Go applications.

The defensible promise is to unify the shell environment across operating
systems. Filesystems, permissions, signals, terminals, and native dependencies
still differ. Go alone does not establish behavioral equivalence; portability
needs explicit boundaries and evidence.

The [conformance statement](../bashy/docs/conformance-statement.md) distinguishes
shell coverage, utility-provider coverage, measured results, and certification.
Those distinctions should remain visible in product claims. This position
does not establish new conformance results or claim official certification.

## Bash#: composition across language ecosystems

Bash# is strongest as a composition language: Bash handles orchestration, Go
handles typed logic, and fenced languages provide access to existing libraries.
Users can adopt it incrementally without rewriting their existing code.

The [language overview](../bashsharp/README.md) and
[fence specification](../sh/docs/bashpp-polyglot-fences.md) describe substantial
support already present: callable exports, typed or dynamic wrappers, managed
workers, and runtime integration. Fences also have language-specific
restrictions and dependencies. They do not make every language feature
interchangeable, and process isolation is not a security sandbox.

The priority should be predictable boundaries: value conversion, errors,
cancellation, dependency resolution, source diagnostics, and interpreted versus
compiled behavior. Additional language adapters are useful when these
boundaries remain understandable and verifiable.

## yoke: unify capabilities and execution

The [yoke overview](../yoke/README.md) already covers discovery, managed tools
and runtimes, agent registries, memory, orchestration, MCP, and verified,
reversible software shaping. These are substantial foundations.

"Everything non-POSIX" is a useful repository ownership rule, but it does not
explain the product's purpose to users. Yoke's promise should be a consistent
way for people and agents to discover, authorize, run, verify, and improve
capabilities across tools and machines.

The following are integration priorities, not claims that their constituent
mechanisms are absent:

1. **One capability contract.** Commands, scripts, skills, and agents should
   expose consistent information about inputs, outputs, prerequisites, effects,
   authority, verification, and provenance. Their differences must remain
   visible: deterministic execution and agent judgment provide different
   guarantees. Build on the existing registries and Command Atlas.
2. **One execution lifecycle.** Local and remote work should share status,
   cancellation, results, artifacts, and failure reporting. Recovery must
   distinguish work that never started, failed, or may have completed before
   retrying side effects. Reuse the existing execution and transport machinery.
3. **One improvement loop.** Discover → compose → run → verify → retain. Reuse
   existing capabilities first; when they are insufficient, shaping provides a
   verified, reversible extension. Connect discovery, execution, evidence,
   learning, and shaping into a dependable workflow.
4. **Evidence for complete journeys.** Demonstrate representative workflows
   across operating systems, including missing dependencies, interrupted runs,
   failed verification, and rollback. Measure dependable completion rather
   than the number of registered commands.

Sprint 653 addresses the execution priority through registered runner pools,
capability-based placement, and consistent local/remote behavior. At review
time the card was in backlog with 0/10 stories closed; this is planned work,
not delivered functionality. Read the live card with `bashy sprint show 653`;
sprint numbers are host-local, so its stable identity is
`9df162a8-6713-594e-b658-a9d7fc8d1938`. The committed
[runner design story](todo/dd119b50aa15-r0-design-one-runner-registry-and-one-way-to-say-r.md)
records the existing machinery to reuse.

## Recommended emphasis

> bashy unifies the shell environment. Bash# unifies language composition.
> Yoke unifies tools and agents into verified workflows across your machines.

Invest first in coherence across the existing features. The strongest next
proof is a small set of workflows that complete reliably, recover clearly,
and retain verified improvements. A larger command catalog is secondary to
that outcome.

This is a documentation review based on repository inspection and the sprint
card, not a fresh runtime, security, or cross-platform qualification run.
