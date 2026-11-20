---
id: fdf86c785022
kind: feature
title: 'kimi seed: wire model selection so kimi:<model> bindings work'
seq: 542
status: todo
priority: p3
labels:
    - agents
created: 2026-11-19T18:31:15.320263Z
---

Follow-up from Sprint 671 T5/T6. The kimi seed (yoke baseline tools/kimi.yaml) launches 'kimi -m {model}', but -m takes a kimi config.toml ALIAS and the seed writes no config (no setup/state_dir like zcode and dsh). So no kimi:<model> agent binding can be verified, and Sprint 671 seeded kimi-k3.1-pro only through opencode and ycode. Also check integration.detect (~/.kimi) against the current install root (~/.kimi-code). Shape: a setup snippet writing a private config with the bound model alias, an offline seed test, then kimi-kimi-k3.1-pro.

Operator decision 2026-11-19: no Kimi membership/subscription for now — Kimi is not a manager candidate (public-data ranking 9th of 11; agent-bench docs/manager-ranking/findings-2026-11-19.md). Kimi stays reachable as a worker via opencode/ycode on the per-token API. Kimi Code is not signed in on the dev host (kimi provider list: no providers). If revisited: kimi login (membership), read the managed alias it creates (legacy kimi-cli used moonshot-ai/<model>), add a plans/ entry for the membership tier and a kimi-kimi-k3.1-pro binding billed against it.
