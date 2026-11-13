# Shapeable app catalog

The first batch of shapeable apps, delivered in Sprint 631 (2026-11-13). Each one is a bashy custom command under `bashy/examples/`. None of them is part of the bashy core. Each wraps a pinned, permissively licensed fork or a small build of our own.

## The apps

| Command | Job | Base | License |
|---|---|---|---|
| `notes` | Personal notes | Fork `qiangli/memos-shape` of usememos/memos | MIT |
| `form` | Forms an agent defines and a person fills in | Our own build (`examples/desk/form`) | — |
| `clips` | Async screen and video clips | Our own build on bashy's cast, record and video tools | — |
| `site` | Company website with a web editor | Hugo (built-in fallback generator) plus Sveltia CMS, both vendored | Apache-2.0 / MIT |
| `site new --template chat` | Start a new site from a chat | Fork `qiangli/open-lovable-shape` of firecrawl/open-lovable | MIT |
| `board` | Kanban board | Fork `qiangli/kaneo-shape` of usekaneo/kaneo | MIT |
| `whiteboard` | Shared whiteboard | Fork `qiangli/excalidraw-shape` of excalidraw/excalidraw | MIT |
| `table` | Records grid with personal views | Fork `qiangli/grist-core-shape` of gristlabs/grist-core | Apache-2.0 |

The `files` app also changed. It is not a new app: the console and outpost files app now embeds the maintained File Browser through the fork `qiangli/filebrowser-quantum` (Apache-2.0), replacing the archived upstream.

## What every app has in common

- **Shapeable.** You ask for a change in plain words, an agent produces a candidate, and the candidate is verified and previewed before you approve it. An approved change is visible only to you and can be undone (`bashy/docs/software-shaping.md`).
- **Fork or build.** If a self-hostable project with a permissive license (LICENSE file read, no open-core code) and at least 1k stars exists, it is forked and pinned to an exact commit. Otherwise we build our own.
- **No hidden phone-home.** Third-party telemetry, analytics, update checks and CDN loads are removed or stubbed. Telemetry is bashy OTel that goes only to a store the owner configures; dhnt never collects it. The `script/no-phone-home.sh` gate fails closed.
- **Linux and the web UI** are supported for now.

## Still open (Sprint 632)

- **blog:** a blog and wiki variant of `site` with rich media. It is built but not merged; it will be folded into `site new --template blog` (saved on bashy branch `salvage/s10-blog-run58`).
- **board and whiteboard:** some crash-report and analytics code is inert rather than removed (S4b, S5b).
- **table and the chat site:** paired-browser preview checks run on the gate host (Q1).
- **Evaluation:** whether personal changes survive upstream upgrades (E1), data safety (E2), a business scenario compared with an AI coding agent plus SaaS configuration (E3), and a scorecard per app (E4).

Worker rules for every app: `docs/shapeable-apps-worker-brief.md`.
