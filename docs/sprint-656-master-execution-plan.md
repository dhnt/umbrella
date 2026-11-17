# Sprint 656 — rc.37 QA venue: gate-host OTel env leak + macOS QA host ssh auth

Primary goal: the rc.37 native tier smoke can run unattended and with clean
command output on all three QA lanes.

Background: on 2026-11-17, while the `v1.0.0-rc.37` tier kit was being staged,
two venue problems showed up:

- Every command that outpost ssh runs on the gate host prints the OTel SDK
  error `parse url "127.0.0.1:31416"`. That host runs the linux lane in WSL. The
  same symptom on the first Windows QA host on 11-15 came from a user-level
  registry variable that the outpost daemon inherited (outpost todo
  `c84bb044`). Tier probes that parse command output break on these lines.
- outpost ssh to the macOS QA host asks for a password and has no TTY to read
  it from, so the darwin lane cannot run unattended.

## Rules

- Root cause before any fix (`CLAUDE.md`). Name the source, check the venue,
  and record the cause on the story.
- A venue problem is fixed in the venue, never in product code. bashy and
  outpost source stays frozen until rc.37 is promoted.
- Public text names hosts by role only. Do not touch the gate host's default
  podman or the gate image.

## Stories

| Story | Priority | Kind | Fix lives in |
|---|---|---|---|
| `43d7f0b2` gate host OTel env source | p1 | venue | host env + daemon restart |
| `b93cd467` macOS QA host ssh auth | p1 | venue | host auth config or the tier kit |
| `89a3f6f8` SDK diagnostics off the user's stderr | p2 | product | bashy, after rc.37 is promoted |

## Acceptance

1. The cause of each venue story is recorded, with evidence of where the value
   or the auth path comes from.
2. On the gate host, `outpost ssh … -- <native shell>` and the WSL root route
   print zero stray stderr lines.
3. The tier kit's darwin `remote()` route runs non-interactively.
4. The rc.37 tier smoke passes on linux, darwin and windows. That run is the
   gate for the venue stories.
5. `89a3f6f8` lands after promotion, with a regression test.
