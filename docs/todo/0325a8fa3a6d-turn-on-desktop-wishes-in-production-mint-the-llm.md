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

## 2026-11-18: interim route on AWS Bedrock (operator request)

The operator chose Bedrock for now instead of minting the pool's `llm:chat`
token. Nothing in the hub changes: it already speaks OpenAI chat completions
with a Bearer token, and Bedrock accepts both.

- Dedicated IAM user `dhnt-desktop-wish` (no console), managed policy
  `dhnt-desktop-wish-invoke`: Bedrock inference only, us-west-2 only.
- Bedrock API key on that user, 365-day expiry, stored in the vault as
  `DESKTOP_WISH_TOKEN`. The root session was used only for these steps and
  then logged out.
- Budget `desktop-wish-cap`: USD 10 a month for Bedrock, email alerts at 50%
  and 100%.
- Model: `qwen.qwen3-next-80b-a3b-instruct` (about 3B active). On the wish
  prompt it returned bare JSON for three ordinary wishes and a proper `error`
  for an out-of-schema one, about 0.6 s each. Rejected: `openai.gpt-oss-20b`
  (puts a `<reasoning>` block in the content), `mistral.ministral-3-8b-instruct`
  and `google.gemma-3-12b-it` (wrap the JSON in a code fence, which the strict
  decoder refuses).
- Keys for the live spec (not applied yet; the operator approves the live update):
  `DESKTOP_WISH_URL=https://bedrock-mantle.us-west-2.api.aws/v1/chat/completions`,
  `DESKTOP_WISH_TOKEN` (secret), `DESKTOP_WISH_MODEL=qwen.qwen3-next-80b-a3b-instruct`,
  `DESKTOP_WISH_DAILY_LIMIT=20`.
