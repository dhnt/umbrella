---
id: 59b70382e93a
kind: bug
title: 'agent-bench harness: launch agy 1.5 in isolated arms (keychain auth, first-run onboarding, folder trust)'
seq: 549
status: todo
priority: p1
labels:
    - agents
created: 2026-11-19T21:22:57.458516Z
sprint: 674
sprint_id: e07a7b3a-e0a8-51df-b09e-53a5adb7fe3e
sprint_title: 'agent-bench: port the agy harness to agy 1.5 (Gemini 4 Carbon steer eval)'
---

Goal: a quick steer eval of Gemini 4 Carbon (agy-gemini4-carbon) before entrusting agy with sprint management. Today every agy run in agent-bench fails at launch ('chat: agy-gemini4-carbon exited before its instruction was delivered', LAUNCH FAILED, not scored, no quota spent). The harness (agent-bench DAG.md 'run' + scripts/arm_home.py) was built for agy 1.3; the dev host has agy 1.5.12.

Root causes measured 2026-11-19 (zero-quota repros):
1. AUTH — agy 1.5 keeps its sign-in in the macOS login keychain, located via $HOME/Library/Keychains (no longer .gemini/antigravity-cli/antigravity-oauth-token). Changing HOME alone makes 'agy models' say 'Please sign in'; GEMINI_CLI_HOME alone is fine. A copied keychain stays locked. FIXED (uncommitted): opt-in BENCH_AGY_KEYCHAIN=1 in arm_home.py links Library/Keychains to the operator keychain after _no_links_out and records it in arm.json 'exceptions'; 15 arm_home unittest tests pass. No password needed.
2. ONBOARDING — in a fresh arm HOME agy shows first-run onboarding (Choose your color scheme -> Terms/Privacy -> Done); the instruction lands on the menu. jetski_state.pbtxt (seeded) has post_onboarding steps but no theme; seeding .gemini/antigravity-cli/settings.json, history.jsonl, presence did not help; Library/Application Support/antigravity holds only credential-user-scope. OPEN: find where agy 1.5 records onboarding completion and seed it (or a documented flag/env).
3. FOLDER TRUST — even in the real HOME a new workspace shows 'Yes, I trust this folder / No, exit'. The tool seed has trust_preseed: none. OPEN: preseed trust for the arm workspace (likely trustedWorkspaces in .gemini/antigravity-cli/settings.json; Claude's preseed is scripts/trust_preseed.py) — opt-in and recorded like (1).

Repro (no prompt, no quota): BENCH_AGY_KEYCHAIN=1 python3 scripts/arm_home.py prepare --arm-dir $(mktemp -d /tmp/bench-arm.XXXXXX) --tool agy --binary ~/.local/bin/agy, then run 'agy --dangerously-skip-permissions --model gemini-4-carbon-high' under that env in a pty from a fresh /tmp/bench-ws.* dir and read the screen. Launch log evidence: bashy chat session logs under the run's 1.launchN.arm/.bashy/sessions/logs.

Acceptance: see sprint 674 card. Then (operator decision) Carbon steer eval one run at a time, reported before continuing; anchors scored 2 per steer task. Do not touch the operator's real ~/.gemini or keychain contents; keep every exception opt-in.
