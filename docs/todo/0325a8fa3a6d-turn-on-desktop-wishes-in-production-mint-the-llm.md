---
id: 0325a8fa3a6d
kind: task
title: 'Turn on desktop wishes in production: mint the llm:chat token from an owner session, then add the four DESKTOP_WISH_* keys to the live master spec'
seq: 379
status: todo
priority: p1
labels:
    - vendor-gateway
created: 2026-11-16T04:31:50.409835Z
---

The operator approved this on 2026-11-15, relayed by Sprint 641 and confirmed in Sprint 646.

Blocked: no agent-held credential holds llm:chat (neither the host's paired token nor DHNT_OWNER_TOKEN), and tokens only attenuate, so the token must be minted from the operator's signed-in owner session.

Steps:
1. Name it desktop-wish-master, scope llm:chat only, TTL 365d, stored in the vault as DESKTOP_WISH_TOKEN.
2. Check that /v1/models with that token is non-empty. If it is empty, set nothing and tell Sprint 641.
3. Pick the smallest instruct model of 7-8B or larger.
4. Add to the LIVE spec (doctl apps update; never deploy.yml, see cloudbox todo cdb68ec8):
   - DESKTOP_WISH_URL=https://ai.dhnt.io/v1/chat/completions
   - DESKTOP_WISH_TOKEN as a SECRET
   - DESKTOP_WISH_MODEL
   - DESKTOP_WISH_DAILY_LIMIT=20
5. After deploy, check that GET /api/v1/desktop/allowance returns available:true and limit 20.
6. Report the key names and model name to Sprint 641.
