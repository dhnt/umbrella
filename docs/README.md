# Umbrella docs — catalog

One entry per doc with its abstract. `INDEX.md` is the one-line index.
Stories live in `docs/todo/` (the committed repo store `bashy todo --repo`
reads and writes; a story carries its sprint as `sprint_id`).

- **`build.md`** — Hydrate the public submodules and build with the root
  `go.work` or independently with `GOWORK=off`. Covers the pinned Go toolchain,
  nested dependencies, TTY-bound tests and remote test execution.
- **`validation.md`** — Run the public validation workflow against exact
  candidate commits. Describes native platforms, standalone and workspace
  dependencies, full shell and language suites, evidence artifacts and
  coverage limits. Licensed certification remains a separate private gate.
