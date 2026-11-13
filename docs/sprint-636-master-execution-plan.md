# Sprint 636 master execution plan — bashy apps UI: landing section order + Flow mark on the Shape button

Status: filed 2026-11-13 from an operator request; planning-only, not
started. Sprint uuid `3a22a674-3f50-586e-914a-4be22f7e6de5`, epic
`software-shaping`.

## Outcome

The bashy apps landing page lists **Apps** right under **Recent**, with
**Cloud** and **Neighborhood** below it, and the top-right **Shape** button
shows the Software Shaping Flow mark (two stacked S curves) drawn from one
hand-authored SVG.

Stories (umbrella `docs/todo/`):

| Story | Priority | Title |
|---|---|---|
| `f397d1cd72f6` | p1 | Landing page: move Apps up under Recent (Cloud and Neighborhood below) |
| `b642b1161a60` | p1 | Shape button: hand-authored Flow mark (double-decked S) in genie and the Shape page |

## State at start

- Both surfaces live in yoke `pkg/webconsole/artifact/`: the launcher is
  `app.js` (`renderHome` appends Overview, Favorites, Recent, Cloud,
  Neighborhood, then Apps; `SECTIONS` drives the Settings toggles in the
  same order) and the Shape button is the genie component `genie.js`,
  injected top-right on every shaped page by `genie.go`.
- yoke `ec5bebe4` (2026-11-09) already swapped the genie sparkle for a
  polyline traced from the PNG masters in bashy
  `docs/software-shaping-design/monochrome/`. That commit is inside bashy's
  current yoke pin and the installed dev-box binary. The archive holds no
  SVG master; the story authors one and uses it everywhere the mark appears.
- The operator's same-day request to drop the **Tutor** tile (renamed
  **Session**) was host config, not code: `bashy app rm tutor` on the dev
  box; recorded on the sprint thread.

## Steps

1. **Seat.** Fast-forward yoke to origin main, start the sprint, checkpoint.
2. **`f397d1cd` section order** in `app.js`: Apps after Recent; mirror in
   `SECTIONS`; one asset test asserting the append order.
3. **`b642b116` Flow mark**: hand-author `flow.svg` (24 grid, cubic paths,
   `currentColor`), wire into `genie.js` and `shape.html`, add it to the
   design archive with `SHA256SUMS`; compare against `flow-256.png` and at
   18px in both themes.
4. **Deliver.** yoke `go test ./pkg/webconsole`; push yoke; `bashy mod sync`
   + commit in bashy; umbrella pin bump; `make install` on the dev box and a
   browser smoke of the landing order and the button.

## Rules

- Coding session, not QA: targeted webconsole tests only; no full suites.
- Commits carry `Sprint:` / `Story:` / `Story-ID:` trailers; submodule
  edits are committed inside yoke and bashy, then pinned at the root.
- If the operator meant a newer asset than the Flow mark, it is attached to
  `b642b116` before any drawing starts.
