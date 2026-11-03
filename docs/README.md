# Umbrella docs — catalog

One entry per doc with its abstract. `INDEX.md` is the one-line index.
Stories live in `docs/todo/` (the committed repo store `bashy todo --repo`
reads and writes; a story carries its sprint as `sprint_id`).

- **`build.md`** — How the umbrella builds: no `go.work`, no root Makefile;
  hydrate submodules once, then build/test each subproject from its own
  root; the flat sibling-replace convention and its gotchas (nested `yoke`
  externals, TTY-bound tests, foreign suites never run natively).
