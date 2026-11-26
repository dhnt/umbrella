# Sprint 726: the loop on a second test app, with an agent in every role

*2026-11-26 · conductor: claude-fable5.2-s726 · protocol: `sprint-726-protocol.md` (with amendment 1) on top of `spec2src-protocol-v2.md` · test app: bashy `examples/desk/notepad`, a notes server with one page.*

`form` and `notepad` are test apps. The question is about the method that is
meant to draft and build the specs of every bashy app, not about these two.

## Answer (narrow)

The method works with an agent in every role, on a second and different
app (a service with a fixed port, file conversion and revisions). One agent
wrote the spec from the app in one session; an agent of another vendor wrote
the hidden cases from that spec in one session; an agent of a third vendor
rebuilt the app from the spec 3 times out of 3, each build passing every
visible and hidden check and the lifecycle test. The conductor wrote no spec,
no case and no source.

The sprint's own bar, two vendors' builders at 2 of 3 or better, was **not
met**: the second vendor's builders did not reach it (1 of 3 at one tier; the
next tier delivered nothing in its one completed run). By operator ruling a
problem with that vendor is reported and the sprint is closed without
further runs.

| Stage | Who did it | Gate | Result |
|---|---|---|---|
| App to spec | `muse-wonder`, one session, 40 minutes, from kb runbook `shapeware-spec-from-app` | lint on the folder and the spec release; 3 certification runs; mutation | clean; PASS, none noisy; 124 of 124 mutants killed |
| Lifecycle end-to-end test | the conductor, a small rework of the form script; no model | controls | the reference passes 3 of 3; an empty folder fails; one broken step fails alone |
| Hidden cases and grader | `claude-opus5.5`, one session, 35 minutes, from kb runbook `spec-to-source-drill` part A | controls through the grader | reference 3 of 3 (177 of 177 checks, lifecycle PASS); empty workspace fails every layer |
| Spec to source | `codex-gpt6.1-terra` | behaviour and lifecycle, both PASS | **3 of 3** |
| Spec to source | `opencode-glm-5.3-flash` | the same | 1 of 3 |
| Spec to source | `opencode-glm-5.3` (step up, amendment 1) | the same | not measured: 0 of 1, stopped |

## Every build run

| Binding | Run | Session | Behaviour (of 177) | Lifecycle | Classification |
|---|---|---|---|---|---|
| `claude-sonnet5.5` | smoke | 410 s | PASS, 177 | PASS | not scored |
| `codex-gpt6.1-terra` | 1 | 328 s | PASS, 177 | PASS | |
| `codex-gpt6.1-terra` | 2 | 359 s | PASS, 177 | PASS | |
| `codex-gpt6.1-terra` | 3 | 368 s | PASS, 177 | PASS | |
| `opencode-glm-5.3-flash` | 1 | 1,240 s | FAIL, 160 | FAIL (`test`) | builder, with a spec weakness behind it (finding 3) |
| `opencode-glm-5.3-flash` | 2 | 1,501 s | PASS, 177 | PASS | |
| `opencode-glm-5.3-flash` | 3 | 747 s | FAIL, nothing delivered | not run | builder (finding 5) |
| `opencode-glm-5.3` | 1 | 641 s | FAIL, nothing delivered | not run | builder (finding 5) |
| `opencode-glm-5.3` | 2 | stopped at 16 minutes | not measured | | stopped by the conductor at the close |
| `opencode-glm-5.3` | 3 | not started | | | |

The 177 checks are 36 steps of the visible contract, 137 steps of 27 hidden
cases, and the page checks. Digests of the hidden set, the grader files, the
contract, the lifecycle and the judge binary are in the protocol. The three
`codex` builds are one Python file each with a launcher and `build.sh`; the
smoke build is Go. All use the converter the contract's Venue section allows.

## Findings

1. **An agent can write a certifiable spec from an app in one session, from
   the runbook.** 37 assertions from real runs, a lifecycle as part of the
   spec, three known issues and three open questions for the owner. The
   conductor's gate re-ran everything from the committed branch and changed
   nothing.
2. **An agent of another vendor can write the hidden cases, and reading the
   spec that closely finds defects.** The judge found four places where the
   reference does not follow rules its own contract states (`--format` is
   ignored; content sniffing is broader than stated; the first write after an
   empty `add` is `r2`, not `r1`; one `features.yaml` acceptance line fails).
   No assertion covered any of them: the lint is static, and certification
   only runs the assertions that exist. **A rule with no assertion is
   unverified.**
3. **The judge compares output in two ways, and the spec did not say so.**
   Output of a command that carries `--json` is compared structurally; any
   other output is compared as text, JSON from `curl` included. One build
   refused and accepted the right fields but printed the API's JSON with
   spaces and another key order, and failed 17 checks on that alone. Three of
   them were visible, so the builder could have seen it; the spec still
   demanded a byte format it never stated.
4. **A service app needs things the form example never forced:** a place for
   `stop` when the program has none (a launcher), a way for the contract to
   start its server, a scope for `stop`, per-case servers, ports and data
   folders for hidden cases, and a build step before grading. Both role
   agents had to decide these alone.
5. **"Nothing delivered" is a pattern of one tool and vendor.** Twice, at two
   tiers, the session read the spec, checked the converter, spent six to nine
   minutes in one thinking step and ended its turn with no file written. The
   logs show no refusal by the provider. The cause is not established; a
   guess is that the thinking step uses up the turn's output budget.
6. **The lifecycle test did its job and has one defect.** Every passing
   build passed all ten lines. Its `installed` check matches JSON as text,
   the same mistake as finding 3; it changed no verdict.
7. **Time differs by a factor of four** between the builder that passed 3 of
   3 (about 6 minutes) and the one that passed once (21 to 25 of the 30
   minutes allowed).

## The runbooks, tested by use

The two role agents listed every point where a runbook left them guessing or
was wrong: seven for `shapeware-spec-from-app`, ten for part A of
`spec-to-source-drill` (both lists are on stories `7512c17bc9d5` and
`f232758ae073`). The wording that is certain is now in the pages (umbrella
kb, and bashy `kb/defaults` `a5edf39a` for the two that ship): service apps,
the two ways of judging output, the reference command of a wrapped app, the
page fallback, mutants that survive because of the command's shape, binary
fixtures, both lifecycle files under the lint, the state model, per-case
state, build before grading, the lifecycle phase, and "do not deliver while
a visible assertion fails". `shapeware-source-from-spec` stays a candidate:
the task does not name it and no builder was seen using it.

What needs a decision, a judge change or a lint rule is collected in Sprint
734 (story `def02641e735`): twelve generic items and nine that concern
notepad only. Operator ruling: collect more before another round.

## For Sprint 730 (issues become spec changes)

- Assertions for a new feature or a bug fix are added as in spec creation:
  visible ones with the spec change, hidden ones afterwards by another agent.
- For a bug fix the reference rule is the reverse of today's: the new
  assertion fails on the old reference and passes on the fixed one.
- Open: who wins when contract and reference disagree, and which hidden
  cases stay or are rewritten when the spec version changes.

## Bands recorded

In bashy `examples/desk/notepad/SKILL.md` (`a5edf39a`), as bounds by binding
with the date. Registry bands of these bindings are still seeded, so no level
is claimed.

## Limits

- One more app, n = 3 per binding, one vendor's builder passing.
- One author session and one judge session: nothing is known about how often
  an agent writes a sound spec or a sound hidden set.
- The author and the judge had the conductor's mechanics notes (where to
  work, how to reach the test host) besides the runbooks.
- The smoke binding and the judge are of the same vendor as the conductor.
- No owner review of the spec, by ruling; the author's open questions and
  the four reference defects are undecided.
- The lease of this sprint went stale during every long wait and was
  retaken; nothing was lost.
