# umbrella — the open-source `dhnt` stack, one clone

A thin git superproject that mounts every open-source `dhnt` subproject as a
flat sibling submodule, so each project's `replace github.com/qiangli/<X> =>
../<X>` resolves and every project builds on its own — no `go.work`, no root
`Makefile`. Clone it anywhere, no credentials needed.

```bash
git clone https://github.com/dhnt/umbrella.git
cd umbrella && script/bootstrap.sh       # hydrates the submodules at their pins
cd bashy && go build ./...               # or any other subproject, from its root
```

**dhnt** (spoken *dahenito*) is a language + a system for turning the
computers you already own into one coherent, self-hostable, agent-operable
mesh. Build stack: **bash** (pure-Go foundation) → **weave** (git-isolated
workspace) → **p2p sphere / ollama sharding** → **k8s cluster**.

## What is here

| dir | what |
|---|---|
| `bashy/` | the product — pure-Go Bash 5.3 drop-in CLI with the agentic userland; consumes `sh` |
| `sh/` | the engine — `mvdan.cc/sh/v3` fork (+ the Bash# evaluator, lowering, polyglot) |
| `bashsharp/` | Bash# language front door: front · transpile · cmd (`github.com/bashsharp/bashsharp`) |
| `bashsharp-tests/` | Bash# conformance gate (Go-profile + POSIX-2016 suite) |
| `bashsharp-tour/` | the Bash# tour + install-matrix CI (repo `bashsharp/tour`) |
| `coreutils/` | the certified POSIX package (116 POSIX names ∪ GNU coreutils); stable |
| `yoke/` | agentic userland — everything non-POSIX; imports `coreutils`, never the reverse |
| `outpost/` | home-host agent (bridge); the peer side of the mesh |
| `ycode/` | local agentic dev tool |
| `readline/` `filebrowser/` `nadir/` `bonsai/` `gfy/` | forks and deps pinned as siblings |
| `appstore/` | DKS app catalog — Helm chart pointers |

The hosted control plane (`cloudbox`, the portal at `tessaro.sh`) and two
other proprietary projects are **not** in this repo. Nothing here needs them
to build. If you have access, clone them beside the others — the directories
are gitignored and resolve as siblings the same way.

## Working here

- `script/bootstrap.sh` — fresh clone: submodules + git hooks.
- `script/sync.sh` — pull every submodule's default branch, propagate
  `.sibling-pins`, stage the pin bumps.
- `script/scrub-gate.sh` — refuses a commit that names a machine, an OS
  login, an address or a credential. Everything in this repo is public.
- Agent brief: `CLAUDE.md` (`AGENTS.md` redirects to it).

## License

Each subproject carries its own license (all OSI-approved). The umbrella's
own files: MIT.
