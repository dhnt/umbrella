# Sprint 662 plan: shaping friction found by Sprint 655

Sprint 662 (`4a1de847-5d33-5688-abf3-1a3b7903d26d`), filed 2026-11-18 for
tracking; planning only until the operator releases it. The card and its
stories are authoritative.

Sprint 655 put the command contract and a minimum checker in place and proved
conformance can be opted into through shaping (Hello World, disposable
install). Most of the manual setup in that run was test isolation, which an
ordinary user on their own host does not need. Four things were real friction
for any user or agent:

| Story | Gap | Layer |
|-------|-----|-------|
| F1 `ce6fff80608e` (p1) | Contained shaping checks cannot reach registered commands, so the contract check must be copied into each app | yoke `pkg/shape/contain` or bashy packaging |
| F2 `73feb12c6472` (p2) | A new agent needs several steps (register, export, claim the seat) before shaping; keep accountability, make it one step | yoke/bashy agent identity |
| F3 `9a4a7b8b3933` (p2) | bashy git does not serve `-c NAME=VALUE` / `commit --allow-empty` | yoke `git` |
| F4 `18c955ac1146` (p2) | bashy jq lacks `--arg`, `--argjson`, `-s`, `-R`, `inputs` | yoke `cmds/jq` |

Order: priority first (F1, then F2-F4 independently). Each story fixes the
cause where it lives, keeps unsupported forms failing loudly with exit 2, and
closes on its own verification plus no regression in formerly green tests.

Not in this sprint (standalone todos): `16b92ae5` bashy's own commands vs the
contract, `88c77abb` the `sprint show` stall.
