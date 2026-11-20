# Sprint 681 — vendor session commands on live sessions (plan)

Planner: the conductor. Operator, 2026-11-20:
- The manager should drive a controlled agent's own session commands (reset,
  exit, resume, rename, …) without exiting and restarting it.
- Declare them in config, as `/plan` already is, so a supervisor or manager can
  detect them and use them.

## Gap (inspected 2026-11-20, yoke main)

- **Already exists:** tool YAML `commands:` (`pkg/fleet/types.go` `ToolCommand`):
  - a canonical name, the vendor `slash:` spelling, a mode (print/tui/http) and
    a `quit:` line;
  - `/plan`, `/review` and `/video` use it, and cligw routes `slash=` by it;
  - `CanonicalToolCommands` (`pkg/fleet/toolcommand.go`) already lists `exit`,
    `resume`, `compact`, `status` and `init`.
- **Missing:**
  1. no seed declares any of those session commands;
  2. `clear` and `rename` are not in the vocabulary;
  3. `tui` mode always starts a NEW session (`toolcmd/tui.go` → `chat.Start`)
     and cannot target a live one;
  4. `bashy chat steer` ignores the declarations, and `Session.Quit`
     hardcodes `/quit`.

## Story L1 — declared session commands on a live session

1. **Vocabulary.** Add `clear` and `rename` to `CanonicalToolCommands`, and
   mirror them in docs/tool-commands-design.md.
2. **Seeds.** In `pkg/fleet/baseline/tools/{claude,agy,muse,codex}.yaml`,
   declare `clear`, `exit`, `resume`, `rename`, `compact` and `status` with
   `mode: tui`, in each vendor's own spelling.
   - **Measure each spelling** against the installed vendor CLI version, and
     cite it in a `# MEASURED <date> (<tool> <version>)` comment, as the seeds
     already do. Sources: the vendor's help or slash menu, or its docs.
   - A command a vendor lacks is left undeclared. **Never guess.**
   - If measuring would need a live session, ask the conductor first (see 6).
3. **Verb `bashy chat command <session> <name> [args...]`.**
   - Resolve the session's tool from the room card.
   - Look up the declared command and render `{args}`.
   - Wait for readiness, as steer delivery already does.
   - Send the slash line verbatim. NO inbox prepend or queued-steer merging
     may alter it.
   - Wait until the session is ready again (bounded).
   - Record a `command` event on the room timeline (name, rendered line, actor).
   - An undeclared name, or a session whose tool declares nothing, exits 2 and
     lists the declared names.
   - `--json` returns an envelope.
4. **Discovery.** `bashy chat sessions --json` includes each live session's
   declared command names, so a manager or supervisor can detect them.
5. **Quit.** `Session.Quit` uses the declared `exit` line when there is one,
   and falls back to `/quit`.
6. **Tests.**
   - Unit tests against the existing fake tui session:
     - lookup and rendering;
     - the verbatim send, with a queued inbox item present that must not be
       prepended;
     - the refusal and its listing;
     - the timeline event;
     - the sessions JSON field;
     - the Quit fallback.
   - **Live smoke test:** run only by the conductor on an idle session, never
     on a session mid-story.

## Non-goals

- New service verbs or cligw routing changes.
- ACP sessions (no TUI: their protocol already has its own shutdown).
- Changing `/plan` or the other existing commands.

## Delivery

- **Worker:** agy (`agy-gemini4-carbon`). It takes this story after it finishes
  Sprint 576 9ac774dd, and the rest of the 576 queue waits.
- **Rules:** same brief rules: its own worktree, root cause/design note first,
  targeted tests only on the dev box, no push.
- **Conductor:** reviews, re-runs the tests, merges into yoke, and bumps bashy's
  yoke pin when batched.
- **Release:** none authorized.
