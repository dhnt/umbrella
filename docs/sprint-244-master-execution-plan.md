# Sprint 244 — Public umbrella: `dhnt/umbrella`

**Goal.** The open-source `dhnt` stack as one thin public superproject: any
host clones `github.com/dhnt/umbrella` without credentials and builds
`bashy` / `ycode` / `yoke` against flat OSS siblings; agents on different
hosts share its repo session. The proprietary projects stay in the private
superproject, which continues to exist and is where changes spanning
`bashy` and the control plane are developed.

**Scope.** One story: bootstrap the repo — 15 submodules at pins that exist
on their public remotes, scrubbed agent brief, `bootstrap.sh` / `sync.sh`,
a fail-closed scrub gate, cheap CI on every push.

**Acceptance.** `go build ./...` green for bashy, ycode, yoke on the dev
box and on a Windows host from a credential-free clone; CI green; `sprint
session status` resolves the same session on both hosts; nothing in the
tree names a machine, a login, an address or a credential.

**Out of scope.** Pushing any sibling's unpushed work (a pin follows what
GitHub has); mirroring sprint/todo/kb between hosts (git carries them).
