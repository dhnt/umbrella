# Sprint 738 report: contained subscription agents

*2026-11-27 · manager claude-fable5.2 (seat taken over from claude-opus5.5 the same day) · 10 of 10 stories closed.*

## Result

`bashy genie --contained [-m BINDING|BAND] [--dir DIR] "TASK"` runs genie inside a file sandbox with a subscription model served by the host's model door. No vendor credential enters the sandbox; the only secret inside is a run token that can reach only the chosen binding or band, for 30 minutes or 200 requests, and is revoked when the run ends.

Final heads: yoke `e43c1967`, bashy `b872d444`. Both were fast-forwarded onto `main` from the branch the gate ran on.

## What each story delivered

| Story | Delivered | Author | Review |
|---|---|---|---|
| C1 spike | go/no-go: go (closed before this manager took the seat) | claude-opus5.5 | — |
| C2a, G1, duplicate a36b302f | closed before this manager took the seat | claude-opus5.5 | — |
| **C2** run sessions | `bashy llm session open\|close\|list\|forward`: a per-run token scoped to bindings or a band, an expiry and a request cap, on the run's own owner-only unix socket; yoke `pkg/cligw/run_session*.go` | codex-gpt6.2-sol | manager |
| **G2** needs-login | a signed-out vendor CLI is reported as `needs_login` (401, not retryable) with the vendor's one-time sign-in step; the breaker is not tripped; the owner is told once per episode; serving resumes after sign-in | muse-wonder | manager, one fix round |
| **C3** file confinement | `bashy contain --net deny --dir DIR [--socket] [--ro] [--env] [--loopback PORT]`: macOS Seatbelt profile (reads denied by default, home unreadable, keychain services denied, one named loopback port), Linux bashy image (no network, read-only root, capabilities dropped, exact environment), Windows exit 125 | claude-opus5.5 | codex-gpt6-sol, two rounds |
| **C4** the verb | `bashy genie --contained`: opens the session, starts the sandbox, forwards the socket in process on the one permitted port, prints genie's answer, writes the run record, closes the session on every exit path | codex-gpt6.2-astra | manager, one fix round |
| **C5** e2e | `tests/contained-genie-e2e`: a fake door on a unix socket, the real sandbox and the real launcher; 20 checks in four legs | agy-gemini4-hydrogen | manager, on the gate lane |
| **C6** acceptance | the Sprint 737 folder-alone task through the verb on the dev box: claude-opus5.5 (42 s) and muse-wonder (70 s), each 4 of 4 | manager | — |

## What review and the gate found

The first code review of C3 (a different vendor than its author) found four blockers, all fixed and confirmed closed in round 2: the macOS profile allowed every read outside the home; every host loopback port was reachable; the home to deny came from `$HOME`; an empty `--dir` fell back to the unconfined mode.

Running the pieces together on the gate lane found what unit tests could not. Each is fixed on `main`, in its own commit:

1. The Linux image ran as its default user and could not enter the caller's folder.
2. `bashy llm session forward` cannot run inside the sandbox: `llm` is built on first use from the user's cache, which the sandbox does not have. The launcher now forwards in process.
3. A candidate bashy tested in the released image met the image's older bashy. The confined run now honours `BASHY_CONTAIN_BASHY`, as an image call already did.
4. The genie bundle's adapter is interpreted Go source and needs a Go toolchain; the sandbox cannot provision one. The host's provisioned toolchain is mounted read-only.
5. Inside the sandbox `bashy` did not resolve by name (dev box drill).
6. A binding that shares its name with a model (`muse-wonder`) was refused at session open (dev box drill).

## Evidence

- Gate lane (Linux, official image, claimed), candidate bashy `b872d444` with yoke `e43c1967`: builds for Linux, macOS and Windows; `go vet`; `go test ./internal/agentos -run 'Contain|Genie|SrcPins'`; the harness's own unit tests (9); the e2e **twice, PASS, 20 of 20 checks, 29 s and 27 s**. Raw logs are kept privately with the manager.
- Full `go test ./internal/agentos` on the lane (run on `2fbc5ad9`, two commits before the final head): five failures. Four fail identically on `main` `37833eb8` on the same lane and are not caused by this sprint (todo `570d50d0`). The fifth was ours (the new command doc missing from an exact name list) and is fixed in `b872d444`. The full package was not rerun after that fix; the doc and skill tests were.
- yoke: `go test ./pkg/cligw ./pkg/broker` green on the final head.
- Dev box (C6): transcripts, run records and the work folders are kept privately with the manager. A SIGTERM to a running contained genie removed every sandbox process and closed the run session (exit 130).

## Limits a user will meet

- **No network inside.** A step that clones or downloads from a remote fails. For C6 the implementation repository was placed under the work folder and the folder's address pointed at it.
- **Windows** refuses (exit 125): no backend.
- **macOS** has no network namespace: the one permitted loopback port is a port on the host's loopback.
- The sandbox reads the host's Go toolchain (read-only), because genie's adapter needs it.

## Not done, recorded

- Todos filed: `570d50d0` (four unit tests red on main), `1e7e2a1d` (a caller abort trips the breaker; a hung vendor turn has no deadline; one claude turn hung for 8 minutes in the drill and passed on retry), `bbbb3b54` (the first-use adapter and its source checkout are not refreshed when the binary changes), `bc0e918b` (supplementary groups in the image backend).
- G2's owner notice is posted to the board addressed to the OS login name; unit-tested, not observed live (that needs a signed-out vendor CLI).
- GLM took no part: one binding failed its probe (launch flag drift), and an unattended review with the other was refused by the launch guard this sprint is about. Neither was overridden.
- `bashy mod drift` still reports ycode, outpost and bashsharp behind yoke. They were behind before the sprint and are not consumers of this change.

## How the sprint ran

Five stories were dispatched at once to four vendors against written command-line contracts (plan section 11). All five came back within 25 minutes; two review rounds and seven gate-lane runs followed. From taking the seat to both `main` branches: about two hours.

## Addendum, same day: the four red unit tests

Todo `570d50d0` is closed (bashy `7a30ca7a`, `e8b5032d`). One was a product defect: two script changes had not been regenerated into the copies built into the binary. Three were a test defect: the make-hint tests read the hint switch from the environment, and the gate lanes run with hints off. With both fixes the full `go test ./internal/agentos` is green on the gate lane (bashy `e8b5032d`), which is also the first full-package run after the Sprint 738 merge.
