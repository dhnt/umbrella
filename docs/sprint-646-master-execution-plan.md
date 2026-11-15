# Sprint 646 master execution plan

- **Design of record:** `docs/vendor-chat-gateway-mvp.md`. It includes the task wire contract, which is the seam
  that lets the gateway work and the outpost work run in parallel.
- **Manager:** `claude-opus5.5-s646`. The manager triages, assigns, reviews, merges and gates. Workers do the
  delivery.
- **Fleet:** claude, codex, muse and agy, matched to each story's difficulty. All are flat-then-metered.

## Triage and dependencies

```
wave 1 (independent, parallel)        wave 2 (after its inputs merge)          QA pass
G1 OAuth AS (cloudbox) ─────────────► G3 dynamic router + sync (cloudbox) ──┐
O1 conduct directives (yoke) ───────► G2 /mcp + pull route (cloudbox) ──────┤
O0 bashy-mcp outpost app (bashy) ───► (G3)                                   ├─► E1 fleet-mirror e2e
O2 worker adapter + creds (yoke) ───► O3 digest-bound approval (yoke/bashy) ─┤   (operator-authorized)
C1 client guides + Muse pack (docs)                                         ─┘
```

- G2 needs G1's bearer validation and O1's directive consumer. It is held for wave 2 for two reasons: it edits the
  same Cloudbox route tables and token entity as G1, and starting it earlier would serialize the merges anyway.
- O3 needs O1's `approve` directive and O2's worker states.
- C1 depends only on the design doc.

## Assignments

| Story | Repo (code) | Band | Agent | Why this agent |
|---|---|---|---|---|
| G1 dc83eeefc0c8 | cloudbox | 5 | claude-opus5.5 | Security-critical OAuth 2.1 work (PKCE, DCR, refresh rotation); the strongest reasoning model |
| O1 834feb47a654 | yoke (weave) | 4 | codex-gpt6-sol | Contained Go state machine in the weave conductor; codex's strength |
| O0 e072ee4f8551 | bashy (+ outpost app registration) | 4 | codex-gpt6-astra | Mechanical wiring of the existing `bashy mcp serve`; a second codex binding, so no double-booking |
| O2 d007d138f153 | yoke (agentlaunch, fleet baseline) | 4 | muse-spark1.3 | Cross-vendor adapter YAML, including its own Muse Code binding |
| C1 6f2d02f6be96 | umbrella docs | 3 | agy-gemini3.8-flash | Documentation; Gemini-native context for the Google guide |
| G2 75a0b939d7d7 | cloudbox | 4 | codex-gpt6-sol (after O1) | It wrote the directive consumer, so it already holds the wire contract |
| G3 eb2712b67992 | cloudbox | 5 | claude-opus5.5 (after G1) | Same Cloudbox token and route area as G1 |
| O3 7adb439e2c96 | yoke ask, bashy | 4 | muse-spark1.3 (after O2) or codex-gpt6-astra | Whichever is free first |
| E1 a0a72ad338de | fleet-mirror venue | — | Manager, in the QA pass | Needs operator authorization for live vendor sign-ins; not dispatched in this coding session |

## Rules for every worker

These rules are also in each story's note.
- Work only in the weave workspace. Never touch the shared checkouts.
- Run unit tests only on the packages you change (`GOWORK=off go test ./<pkg>/...`). No full suites; QA comes later.
- Commit trailers: `Sprint: #646`, `Story`, `Story-ID`, and `Agent: <your agent name>`.
- Cloudbox stories: never quote Cloudbox internals in public repositories.
- Credentials:
  - Use the documented vendor headless credentials only. Never fall back to an API key.
  - Never read or print a credential value.

## Merge and gate

- Merge with the S632 recipe: salvage the workspace commit, then cherry-pick it in a detached worktree off the
  default branch.
- Before every push, re-run the story's own tests and fetch and rebase, because other sessions push concurrently.
- Bump the pin with `git update-index --cacheinfo`.
- Accept a story when its own criteria pass. The full gate is deferred to the QA pass (E1).
