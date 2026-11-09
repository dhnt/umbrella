# Research: xonsh features for the Bash# Python fence

Status: research only. No sprint, no story, no implementation commitment.

Question: which features of [xonsh](https://github.com/xonsh/xonsh) (reviewed
at 0.25.0, commit `b3c9e1e`, BSD-2-Clause) should the Bash# fenced Python
island (`~~~python` in `sh/polyglot`) adopt? Rule applied: where Bash# is
already equal or superior, nothing is proposed.

## The two designs in one paragraph each

**xonsh** is a Python superset shell. Every line is Python or a subprocess,
decided by a parse-then-name-lookup heuristic (`xonsh/execer.py`,
`xonsh/parsers/ast.py` `CtxAwareTransformer`). Commands are called from
Python through `$()` (captured str), `!()` (a `CommandPipeline` object),
`$[]`/`![]` (uncaptured), and `@()` (Python values splatted into argv). Python
functions become commands as *callable aliases*. The environment is a typed
dict (`$PATH` is a list). It is not POSIX and cannot run bash scripts.

**Bash#** is Bash 5.3 plus declared foreign modules. A `~~~python [as NAME]`
fence at column one declares functions only (imports, literal constants,
plain `def`; classes/async/decorators rejected before execution). Each module
runs in one persistent CPython worker over a Go-owned NDJSON protocol
(`sh/polyglot/polyglot.go`). Functions are callable two ways: typed
(`answer := py.add(20, 22)`, scalar annotations → typed wrapper, others →
`(any, error)`) and as a command word (`py.add 20 22`), using xonsh's own
return convention (`int` → status, `str` → stdout, `(out, err, rc)` tuple,
`SystemExit`, `KeyboardInterrupt` → 130). Non-scalar values come back as
opaque handles with attribute access and iteration (`iter_open`/`iter_next`);
shell functions can be passed into Python as callbacks; stdin is streamed via
a callback-backed reader. Reference: `sh/docs/bashpp-polyglot-fences.md`.

## Where Bash# is already equal or superior — adopt nothing

| xonsh feature | Why nothing is needed |
|---|---|
| Python/subprocess mode detection | The fence is an explicit boundary. xonsh's heuristic is its biggest gotcha (a variable named `ls` changes a line's meaning). Bash# has no ambiguity. |
| Callable aliases (Python function as a command) | Already done: command-form calls with argv, streamed stdin, and the xonsh return convention (`command_status` in the worker cites xonsh's `parse_proxy_return`). |
| Mixing Python callables in pipes | `cmd \| py.fn \| wc` already works through the command form; Bash# keeps OS pipes for everything else, while xonsh routes alias pipes through Python proxy threads. |
| `@()` Python values into argv | Typed calls pass values directly without string round-trips; `$(py.fn)` and `:=` cover the shell side. |
| `$()` / `!()` / `$[]` / `![]` from the shell side | Bash already has `$( )`, `$?`, `PIPESTATUS`, `set -e/-o pipefail`, plus Bash# typed `:=` and `(value, error)` returns. |
| Typed environment (`$PATH` as list, ensurers) | Bash# declarations are typed; inside Python, `os.environ` is the idiomatic interface. A second typed env model would duplicate both. |
| Path literals `p""`, regex/glob backticks | Shell globbing, `find`, and in-fence `pathlib`/`glob`/`re` cover these. Backtick literals collide with Classic command substitution. |
| Macros (`f!()`, `with!`), `@!()` | Language-level feature with no fence analogue; heredocs cover raw-text passing. |
| `source-bash` / foreign-shell import | bashy *is* bash. |
| Events, xontribs, history backends, Python completers | Shell-level REPL extensibility, not fence scope. bashy has its own hook/skill/registry surfaces. |
| POSIX compatibility, startup cost | xonsh has neither; Bash# runs POSIX/bash unchanged and starts a Python worker only when a fence is called. |

## Where xonsh does better — candidates to take in

### 1. Process spawns from fenced code go through bashy (high value, all fence languages)

xonsh: `p = !(git status --porcelain)` gives an object with `returncode`,
`out`, `err`, `lines`, iteration, and truthiness (rc == 0)
(`xonsh/procs/pipelines.py`). Because xonsh is the Python process, every
command it runs goes through the shell.

Bash# today: data flows shell → Python only. The way back is passing a shell
function in as a callback. Fenced code that spawns a process (`subprocess`,
`child_process`, `exec.Command`, `std::process::Command`, `system()`,
`Process.Start`) calls the OS directly. That bypasses bashy: no bashy
builtins or coreutils, no command registry, no gates, and on Windows no
POSIX commands. Fenced code is an escape hatch from the shell's guardrails.

**Decision: bashy is the shell for every process a fence spawns.** bashy's
commands are full pure-Go drop-in replacements (`git` has both a Go and an
external variant, selected by bashy). Rerouting is the point: fenced code runs
under the same command surface, registry and gates as the script around it.

**Mechanism: rewrite the argv; don't emulate a process.** The worker's spawn
seam replaces the command with bashy as a real child process:

```
Popen(["ls", "-l"])        →  Popen([BASHY, <gated exec entry>, "ls", "-l"])
os.system("ls | wc -l")    →  BASHY -c "ls | wc -l"
```

The child is a real OS process, so pid, pipes, `wait`/`poll`, signals,
`pass_fds`, `cwd` and `env` keep their native semantics in every language.
No virtual `Popen` is needed. bashy resolves the name through its builtins,
coreutils, registered commands and gates; a registered external is executed
by bashy, under the same gates. The child does not see the caller's shell
functions or unexported variables. That is acceptable for commands; the
explicit helper below covers the caller-context case. Whether `bashy -c
'"$@"'` is the gated entry or bashy needs a dedicated exec mode is an open
design point for the story.

**Build on the existing job-control seam.** Bash# already manages fence
workers as job members, and the spawn routing extends that mechanism rather
than adding a new one:

- Interpreter → worker protocol ops `job_join` / `job_leave`
  (`sh/polyglot/process_group.go`), implemented in the Python, Rust, C# and
  PowerShell workers. The worker moves itself into the shell job's process
  group (`setpgid`). The TypeScript/JavaScript worker does not implement
  them yet.
- Job lifecycle in the interpreter: `sh/interp/bashpp_stream_group.go`
  (ordered reservation, join, leave, close-on-unproven-cleanup).
- Real-child substrate: `sh/interp/bashpp_process_cmd.go` `bashPPStartCmd`
  (own process group, group kill, kill-after-reap guard, exec budget check).

Because a rewritten spawn is a real bashy child of a worker that has joined
the job's process group, it inherits that group. Foreground/background,
signals, Ctrl-C and cancellation group-kill then reach fenced
grandchildren the same way they reach ordinary pipeline stages. The spawn
seam adds the same protocol pattern: the worker reports or requests a spawn
(op TBD) so the interpreter can apply the registration rule and record the
child, rather than each worker re-implementing the policy. The TS/JS worker
gains `job_join`/`job_leave` as part of its story.

**Registration rule.** A command spawned from fenced code must resolve to a
bashy command: built-in, coreutils, or registered with `bashy commands add`.
An unregistered command is refused with a diagnostic naming the command and
the registration step; it does not fall through to a raw `execve`.

**Hook per fence language.** The seam differs; the bashy side is shared.

| Fence language | Spawn seam | Coverage |
|---|---|---|
| Python | worker patches `subprocess.Popen`, `os.system`/`popen`, `os.exec*`/`spawn*`/`posix_spawn`, `asyncio` subprocess at start | all stdlib spawns |
| TypeScript / JavaScript | worker patches `child_process` (`spawn`, `exec`, `execFile`, `fork`, sync variants) at start | all Node spawns |
| PowerShell | worker routes native-command invocation and `Start-Process` | needs design |
| Go, Rust, C, C++, C# | worker `PATH` begins with a shim directory of bashy links; `SHELL` and `ComSpec` point to bashy | bare names and shell-string calls |
| all | — | absolute paths, raw `fork`/`execve`, `ctypes`/native extensions escape any in-process hook |

So in-process routing gives the same gates by default, not containment. The
fence doc already states the process boundary is not a security sandbox;
non-bypassable enforcement remains the sandbox tier (`bashy oci`) or an
exec-level control.

**Explicit helper (second slice).** For fenced code that needs the caller's
shell context (functions, unexported variables), a `run(argv)` request over
the existing callback channel executes in the caller's interpreter and
returns a result object: `rc`, `out`, `err`, `lines`, `__bool__` meaning
rc == 0, and `check()` raising on failure. Default is **no raise**: xonsh's
raise-by-default changed between releases and broke scripts
(`docs/error_handling.rst`). The callback host side is shared Go
(`sh/polyglot/polyglot.go`, `$callback` encoding); the Python and Rust
workers already decode callbacks, so each language needs only a client stub.

### 2. Per-call environment for the worker (correctness gap)

xonsh: Python and commands see the same live environment.

Bash# today: the worker's environment is fixed at launch
(`Python.configure`: `cmd.Env = p.Environment.Env`). The call request
carries cwd but not env. So:

```bash
py.show_region             # starts worker
export AWS_REGION=eu-west-1
py.show_region             # still sees the launch-time value
```

Proposal: send the exported-variable delta with each call (the call already
carries cwd). The worker applies it to `os.environ` for the call's duration
and restores it afterwards. This matches what a child process would see, so
Bash# semantics stay intact. No typed env model is needed (see table).

### 3. Output decoders on capture (low value, optional)

xonsh: `$(@json curl …)`, `@lines`, `@jsonl`, `@yaml`. These are output
decorators that turn command stdout into Python values.

Relevant only once candidate 1 exists: give the result object
`.json()`/`.lines` accessors. The shell side already has `jq`/`lens` and
does not need this.

## Explicitly not recommended

- **Mode detection / Python-as-shell-syntax.** This is the opposite of the
  fence's design and xonsh's main weakness.
- **Raise-on-failure as a default** for anything. Keep bash's `set -e`
  semantics.
- **Threaded alias execution with interactive-command prediction**
  (`@thread`/`@unthread`, `$[]` for editors). xonsh needs this because
  everything runs in one Python process. The Bash# worker is a separate
  process with its own stdio, so it has no such problem.
- **Relaxing fence content rules** (classes, decorators, top-level
  statements). xonsh offers no lesson here. This is a separate decision
  about Bash# initialization semantics.

## Summary

Bash# already matches or beats xonsh on the shell→Python direction, and it
has already adopted xonsh's callable-alias return convention. The real gaps
are in the fence→shell direction:

1. **Every process a fence spawns goes through bashy** (agreed direction,
   all fence languages). The worker rewrites the argv so a real bashy child
   process runs the command. Spawned commands must be bashy built-ins or
   registered commands; unregistered ones are refused. A `run()` helper for
   caller-context execution follows as a second slice.
2. **Per-call environment propagation.** The worker environment is fixed at
   launch today; this is a correctness fix.

Everything else is either already present or deliberately rejected.
Implementation is tracked as a sprint; this doc stays the research record.
