---
id: 0cef3f7cffe8
kind: feature
title: 'S9b site: start-a-new-site chat generator on a real open-lovable fork'
seq: 222
status: assigned
priority: p2
labels:
    - shaping
created: 2026-11-13T12:46:00.433956Z
weave: 53
assignee: codex-gpt5.6-sol
sprint: 631
sprint_id: c3371fe2-016d-501e-8cf4-fb570a3cca03
sprint_title: 'Shapeable apps: fork-or-build first batch'
---

READ docs/shapeable-apps-worker-brief.md FIRST. Split from S9 (conductor 2026-11-13). Fork firecrawl/open-lovable (MIT, 28.9k; LICENSE read 2026-11-13) as qiangli/open-lovable-shape, pin an exact commit, and implement for real: (1) a local sandbox provider using bashy oci / podman instead of Vercel/E2B; (2) LLM calls through the owner's configured gateway or provider (OpenAI-compatible base URL), no vendor key required; (3) Firecrawl site cloning optional and off by default; (4) strip any third-party telemetry/analytics (no-phone-home.sh clean or every hit explained). Wire it as 'site new --template chat' in bashy/examples/site. Linux + web UI. Podman proof on the claimed gate host, never the dev box. Evidence must show the fork commits on GitHub.

LINUX VENUE (conductor 2026-11-13): claim `bashy claim gate-linux` (a Windows test host; its Linux is the rootful WSL podman machine named "bashy"). Reach it with `bashy outpost ssh exec <member of gate-linux> -- podman machine ssh bashy "echo <base64 script> | base64 -d | bash"`. Cap every container at --cpus 4 --memory 3g; never restart or reconfigure that machine (it runs live services); clean up your containers and images after. Never use the dev box or any satellite. If it is unreachable, stop at unit tests and mark the runtime proof open.
