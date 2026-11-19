---
id: fdf86c785022
kind: feature
title: 'kimi seed: wire model selection so kimi:<model> bindings work'
seq: 542
status: todo
priority: p2
labels:
    - agents
created: 2026-11-19T18:31:15.320263Z
---

Follow-up from Sprint 671 T5/T6. The kimi seed (yoke baseline tools/kimi.yaml) launches 'kimi -m {model}', but -m takes a kimi config.toml ALIAS and the seed writes no config (no setup/state_dir like zcode and dsh). So no kimi:<model> agent binding can be verified, and Sprint 671 seeded kimi-k3.1-pro only through opencode and ycode. Also check integration.detect (~/.kimi) against the current install root (~/.kimi-code). Shape: a setup snippet writing a private config with the bound model alias, an offline seed test, then kimi-kimi-k3.1-pro.
