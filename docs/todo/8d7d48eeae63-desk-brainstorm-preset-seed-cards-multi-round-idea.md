---
id: 8d7d48eeae63
kind: enhancement
title: 'desk brainstorm: preset seed cards, multi-round ideation/voting, round history back/forth, card filtering, and cross-session carry-forward'
seq: 40
status: todo
priority: p1
labels:
    - desk
    - brainstorm
created: 2026-11-07T22:26:45.464739Z
sprint: 589
sprint_id: 154c840a-9158-552f-9a27-d6e500d339cb
sprint_title: Competition media & Desk tools — PDF and video production fixes
---

Enhance bashy/examples/brainstorm (server/main.go, desk.go, cli.go, index.html) to support iterative multi-round brainstorming sessions:
1. Preset / predefined cards: allow seeding a session (via CLI/API add/set or UI) with predefined example cards or cards imported from a previous saved session (optionally preserving or resetting prior vote counts), visible to participants from the start.
2. Iterative multi-round workflow: replace the one-way write -> discuss -> vote -> closed lock-in with repeatable rounds (Round 1..N) where the facilitator can start a new round and either (a) open card writing to add additional cards alongside carried-over cards or (b) skip directly to a new voting round (e.g., runoff vote with a fresh per-round vote budget).
3. Filtering & shortlisting between rounds: let the facilitator (via UI and CLI/API) filter and select which cards advance to the next round by manual selection, minimum votes / top-N votes, column, author/tag, or search field, archiving unselected cards in the previous round history.
4. Round history recording & back/forth navigation: record a snapshot of each round (cards, votes, filter criteria, and shortlist) in the session record, and provide Prev / Next round controls (plus round selector in the UI and `--round N` on `show`/`export` CLI/API) so participants and facilitators can browse back and forth through earlier and later rounds, and facilitators can step back/re-open a round if needed.
5. Save & restart across sessions: support saving full multi-round history and seeding or restarting a new session from any round of an exported JSON/Markdown file or an existing saved session in sessions/<name>.json.
