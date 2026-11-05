# Umbrella docs — catalog

One entry per doc with its abstract. `INDEX.md` is the one-line index.

- **`plan-s568-master-execution.md`** — Sprint 568's operator-agreed design scope, six-story sequence and acceptance matrix for ordinary human/agent membership, service-specific accounts, and bidirectional routing between application conversations and local MB, Meet and sprint sessions. Preserves direct human use of bashy and existing local workflows; implementation follows separately.
Stories live in `docs/todo/` (the committed repo store `bashy todo --repo`
reads and writes; a story carries its sprint as `sprint_id`).

- **`build.md`** — How the umbrella builds: no `go.work`, no root Makefile;
  hydrate submodules once, then build/test each subproject from its own
  root; the flat sibling-replace convention and its gotchas (nested `yoke`
  externals, TTY-bound tests, foreign suites never run natively).

- **`plan-s571-posix-certification-readiness.md`** — Seven-story follow-up to S561: reconcile exact residual identities, obtain and apply VSC rulings, review nine current-journal manual decisions, verify resulting repairs and prepare an independently reviewed certification dossier. Keeps raw results and approved dispositions separate, with explicit evidence reuse and authorization boundaries.
