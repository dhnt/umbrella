---
id: 2f7dbd4856d1
kind: spike
title: T5 Research the latest models for the official tool families
seq: 539
status: assigned
priority: p1
labels:
    - agents
created: 2026-11-19T17:49:45.988384Z
assignee: claude-opus5.5-s671
sprint: 671
sprint_id: 4e6b5dcd-e6c8-5949-864a-799d4e9a9b5e
sprint_title: 'Agentic tool support: official set + latest models'
---

Official set: ycode/genie, claude, codex, opencode, agy, muse, zcode, kimi, dsh. Verify at vendor sources the current model ids, context windows and prices. Record a sourced table on this story. No seed edits. Web search authorized by the operator 2026-11-19.

## Result (2026-11-19)

Tool-native id lists were read locally where the CLI publishes one (no model call): `agy models` and codex's `~/.codex/models_cache.json` (fetched 2026-11-19T18:12Z).

| Family / tool | Newest model | Id (where) | Context | Price $/MTok in/out | Seeded before? | Source |
|---|---|---|---|---|---|---|
| Anthropic (claude) | Claude Fable 5.2, 2026-11-09 | `claude-fable-5-2` (API) | 1M (press) | 8 / 40 | no (fable5.1) | anthropic.com/claude/fable |
| Anthropic | Opus 5.5, Sonnet 5.5 | `claude-opus-5-5`, `claude-sonnet-5-5`; agy: `claude-opus-5-5-high`, `claude-sonnet-5-5-high` | — | — | yes (agy bindings still 4.6, retired) | `agy models` |
| OpenAI (codex) | GPT-6.2 Sol (codex priority 1), GPT-6.2 Astra, 2026-11-17 | `gpt-6.2-sol`, `gpt-6.2-astra` | 1.05M | Sol 2 / 10; Astra 8 / 40 | no (gpt6) | developers.openai.com/api/docs/models; codex models_cache |
| OpenAI (codex) | GPT-6.1 Terra, 2026-10-26 | `gpt-6.1-terra` | 1.05M | 1 / 5 | no (gpt5.6-terra) | same |
| Google (agy) | Gemini 4 Carbon (11-10), Hydrogen (11-13), Neon (11-18), Argon | API `gemini-4-{carbon,hydrogen,neon,argon}`; agy `gemini-4-<tier>-{low,medium,high[,xhigh]}` | 1M | Neon 3 / 15; Hydrogen 1.5 / 7.5; Carbon 2 / 10 launch (4 / 20 from 12-01) | no (gemini3.8-flash) | blog.google introducing-gemini-4-neon, gemini-4-carbon; aistudio.google.com/docs/models; `agy models` |
| Moonshot (kimi, opencode, ycode) | Kimi K3.1 Pro, 2026-10 | `kimi-k3.1-pro` | 1,048,576 | 2 / 10 (third-party report; vendor table unpopulated) | no (kimi-k3) | platform.kimi.ai/docs/pricing/chat; morphllm.com/kimi-k3-1 |
| Z.ai (zcode, opencode, ycode) | GLM-5.3 (Aug 2026); GLM-5.5 unreleased as of 11-13 | `glm-5.3` | 1M | — | yes, current | models.litellm.ai/providers/zai; cellcog.ai glm-5-5-release-date |
| DeepSeek (dsh, ycode) | deepseek-flash = V4.1-Flash-1017; deepseek-v4-pro = V4-Pro-0813 | `deepseek-flash`, `deepseek-v4-pro` | 1M | flash 0.30 / 1.20; pro 1.32 / 3.96 | yes (v4-pro active, v4.1-flash retired) | releasebot.io/updates/deepseek; kucoin DeepSeek API news |
| Meta (muse) | Muse Spark 1.3, 2026-09-02 | `muse-spark-1.3` | 1,048,576 | — | yes, current | research.meta.ai introducing-muse-spark-1-3 |

Not adopted: GPT-6 Cyber (restricted access), Claude Mythos 5.2 (verified orgs only), Gemini 4 Argon (positioning not documented by the vendor), kimi-k3.1-pro-highspeed (not on the vendor page), gpt-reserve (no vendor description), GLM-5.3-FlashX-Legal (domain model).

Finding: the kimi tool passes `-m {model}` as a kimi config.toml ALIAS and its seed writes no config, so no kimi:<model> binding can be verified offline. Follow-up todo, not T6.
