---
id: 01a20809-995a-745d-b848-26bd5c22aea9
seq: 20
form: page
type: lesson
title: 'Social follow sessions: agent prepares the page, human clicks'
description: 'WHEN an agent must follow/subscribe/join many accounts on throttling sites (X, YouTube, LinkedIn, Reddit, Discord) through the operator''s logged-in Chrome (bashy browser --mode live): agent navigates a dedicated tab by --id and verifies state, human clicks; interleave platforms for natural pauses; skip already-done; detect dead accounts and limit toasts; SPA settle 6-8 s; shadow-DOM buttons by index; runner under bashy not macOS bash 3.2; setsid for detached runs.'
tags:
    - browser
    - live-mode
    - social
    - rate-limit
    - human-in-the-loop
status: candidate
evidence: 'Sprint 523 follow session 2026-11-23: ~130 X/YouTube/LinkedIn pages verified from the live page in 20 min after a scripted burst hit X''s follow limit; logs in the agent scratchpad; dhnt-docs docs/sprint-523/follow-list-*.md; yoke todo 278ade0f'
source:
    tool: claude
created: "2026-11-23T10:52:56Z"
---

# Social follow sessions: agent prepares the page, human clicks

WHEN an agent must perform many account-bound actions on sites that throttle
automation (follow on X, subscribe on YouTube, follow on LinkedIn, join on
Reddit or Discord) using the operator's own logged-in browser
(`bashy browser --mode live`).

## What worked

1. **Split the work: agent navigates and verifies, human clicks.** Open each
   target page in a dedicated tab, bring it forward (`tabs switch`), let the
   human press Follow/Subscribe/Accept, then read the button state back
   (`extract`) and move on the moment it flips. Human clicks are not what X
   throttles; scripted follow clicks every few seconds are. The hybrid run
   covered ~130 pages in 20 minutes with no limit hit.
2. **Interleave platforms instead of spacing one out.** A schedule that
   rotates X, YouTube, LinkedIn gives each site a natural pause between
   visits while the overall pace stays high. One queue, round-robin by
   platform, with a per-site minimum gap and a global minimum gap.
3. **Skip what is already done before clicking.** Read the state first
   ("Following", "Subscribed", "Following, click to unfollow", "Joined").
   Most of a long list was already followed; checking first saved the
   clicks and avoided unfollow toggles.
4. **Verify by reading the page, not by trusting the click.** Record each
   item as done only after the state changed. Keep a per-item log line;
   re-run from the log so an interrupted session resumes without repeats.
5. **Bring the rest of the plan into the same hour.** Joining communities,
   accepting Discord invites, enabling GitHub Discussions and drafting
   submission emails need no warm-up and fit between the follow waits. Only
   posting (Reddit project posts, Show HN) has rules that justify waiting.

## Gotchas

- **Address the working tab by `--id`, never by a URL substring.** A second
  tab on the same domain (the operator's LinkedIn feed) made every
  navigation "ambiguous" and the run reported fake misses for ten minutes.
  `tabs new URL` prints the id; keep it for the whole run.
- **Single-page apps need 6-8 s before reading state.** YouTube and
  LinkedIn keep the previous header while loading; reading at 3-4 s returns
  the old page.
- **Button text differs after the action.** YouTube: `Subscribe` becomes
  `Subscribed` with a notification aria-label. LinkedIn: `Follow X` becomes
  `Following, click to unfollow X` (comma, not space). X: `Follow @h`
  becomes `Following @h`. Match on the text inside the button, scoped to the
  profile header, not the first Follow on the page (feeds contain others).
- **Shadow DOM selectors do not click.** Reddit's join button is behind
  `>>>`; click by the index `extract` prints instead of a CSS selector.
- **LinkedIn person pages hide Follow under More** and show Connect or
  Message; the agent cannot read a state. Show the page for a fixed window
  and let the human decide.
- **Check for dead or suspended accounts** ("This account doesn't exist",
  "Account suspended", 404) and skip at once instead of waiting.
- **The macOS system bash is 3.2.** A runner using `declare -A` or
  `mapfile` dies on line one; run it under bashy (`#!/usr/bin/env bashy`).
- **Detached runners need `setsid nohup ... &`**; a plain background job
  dies when the agent's shell call returns.
- **Rate limits are silent to the CLI.** X's "limited, try again" toast and
  the missing Follow button look like a slow page. Grep the page text for
  limit phrases after each visit and stop the whole run on a hit; a product
  fix is tracked separately (yoke todo: surface 429 / limit text in the
  envelope and add per-host pacing).
- **Take `bashy claim chrome-browser` before touching the live browser and
  release it when pausing**, so other agents do not drive the same window.
- **The agent cannot click through CAPTCHAs, member-screening forms or file
  uploads** (Terminal Trove, Discord rules screens). Say so and hand the
  step to the human instead of waiting.

## Recipe

```bash
TABID=$(bashy browser --mode live --browser chrome tabs new https://example.com | grep -o '[0-9]\{6,\}')
B(){ bashy browser --mode live --browser chrome --id "$TABID" "$@"; }
while read -r plat target; do
  B navigate "$(url_for "$plat" "$target")"; B tabs switch; sleep 7
  state=$(read_state "$plat")           # extract + grep on the header button
  [[ $state == done ]] && { log "$plat $target already"; continue; }
  until [[ $(read_state "$plat") == done ]]; do sleep 2; done   # human clicks
  log "$plat $target done"
done < schedule.txt                       # lines interleaved: x … / yt … / li …
```
