# Sprint 688 — Show worker status and watch changes

Revised 2026-11-25. Sprint ID `b6d0bf82-bf8a-5ba7-bbab-90b24be56deb`.

| Part | Story | What the operator can do |
|---|---|---|
| A. Fetch and show | `6254c3c64248` | Ask once what a worker is doing and whether a limit is affecting it. See available session state, quota or reset time, and usage or spend. Unavailable readings are identified. |
| B. Watch and diff | `db7b7f8c51ee` | Follow the same information for a chosen duration and optionally see only what changed. A watch ends when the duration expires. |

```sh
bashy sprint worker-status
bashy sprint worker-status --watch 30s --diff
```

The command shows local sessions and cached account readings. Watch mode prints an initial snapshot. With `--diff`, it then prints only changes through the deadline. Add `--json` for a JSON snapshot or newline-delimited watch events.

## What already works

- `bashy chat sessions --json` lists live sessions, their tasks and tools. The response inspected on November 25 identified the sessions but did not report whether a worker was waiting for input or rate-limited.
- `bashy sprint monitor 688` showed account and resource readings with partial or unknown values. Its JSON response reported that the workload inventory exceeded its input limit. `bashy llm usage --since 1h --json` also returned its per-principal report.
- `bashy sprint monitor 688 --watch --duration 1s --json` emitted an initial snapshot and exited. The existing watch detects changed summaries and can emit heartbeats. Part B covers showing which worker or account value changed. Demonstrate it with a change and an unchanged observation.

## Disposition of the original stories

| Original story | Decision |
|---|---|
| Session state (`6254c3c64248`) | Retain the status question in A. Automatic wakeups are outside the MVP. |
| Usage and watermark alerts (`49cd45d94248`) | A uses available usage readings. Keep alerting and automated responses in the standalone backlog item. |
| Exhaustion handoff (`26bbbf019492`) | Defer automatic handoff. A and B let the operator see the condition. |
| Message-board history performance (`80e91377127f`) | Keep the reported performance bug open for separate investigation. |
| MCP test process leak (`309381beda57`) | Keep the cleanup bug open for separate investigation. |
| Point-based budgets (`e868c8201747`) | Defer the budget and band experiment. |

The earlier research and proposals, including the quota-exhaustion design cited by older stories, remain in the [November 21 plan](https://github.com/dhnt/umbrella/blob/0d92f29f6d2838b99fdd78e87c290aa271227914/docs/sprint-688-master-execution-plan.md).

## Delivery evidence

- The routed one-shot command read 15 live worker rows and 12 account pools. It showed 34 available and 121 unavailable quota, usage, or spend readings.
- The routed 16-second change-only watch reported one live worker task change, stayed silent on unchanged polls, and exited in 16.12 seconds.
- The standalone sprint adapter tests and build passed on the self-hosted Linux gate. The integrated adapter source tree matches the tested tree.
