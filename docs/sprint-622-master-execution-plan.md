# Sprint 622 master execution plan: Software Shaping one theme

Sprint 622 `03e47ab4-d1a0-5152-97e2-eee6dcb08395`, epic `software-shaping`. Planned 2026-11-12. Backlog, unclaimed; manager to be decided. Story cards in `docs/todo/` are authoritative.

| Story | ID |
|---|---|
| D1 definition | `e22ab49578aa` |
| R1 bashy README | `61bc4d6416a8` |
| R2 Bash# | `3f93cfd6a16a` |
| R3 yoke | `7077b21508c5` |
| B1 qiangli/bash | `fa411741730b` |
| R4 umbrella + outpost | `cc5fc9162d98` |
| L1 product marks | `5a3c262770b1` |

`qiangli/bash` was created empty and public on 2026-11-12 with operator approval; B1 fills it.


## Context

Software shaping is already bashy's headline (founder decision 2026-11-09), but only the bashy README says so.

- yoke, Bash# (`bashsharp/bashsharp`), the Bash# tour, outpost and the umbrella README never mention it, even though bashy credits Yoke as "the shaping harness". The engine is in `yoke/pkg/shape`.
- No canonical definition exists. The meaning is spread across `bashy/docs/shape-contract.md` (implementation contract), `bashy/docs/overview.md` §Software Shaping (user view), `bashy/docs/agentic-block-shaping.md` (boundary) and the design archive `bashy/docs/software-shaping-design/` (mark and badge wording).
- The POSIX shell and userland (`qiangli/sh` and `qiangli/coreutils`) have no single public face. `sh/README.md` is still the upstream mvdan text.

The goal is one theme across bashy → outpost → satellite → cloudbox: **software shaping is the product, and everything else is why shaping is safe.** This sprint is docs and positioning only. It adds no product code and authorizes no release.

Operator decisions (2026-11-12):
- qiangli/bash = a thin superproject with sh and coreutils as submodules plus READMEs. No new Go code.
- It is standalone and is **not** mounted in the dhnt umbrella, because the 18-module list and `script/sync.sh` stay unchanged. The umbrella only links to it.
- The sprint manager will be decided later. The card is created unclaimed in `backlog`.

Constraints that apply:
- Claim only what ships. "Every number names its corpus" (`bashsharp/docs/claims.md`).
- **No POSIX certification is claimed anywhere.** The operator's phrase "posix certed" becomes "built for POSIX.1-2016 certification; not yet certified", with the cited S561 evidence and S571 readiness (CLAUDE.md: no certification claim or v1.0.0 before official certification).
- Keep the bashy README's agent-bootstrap parts byte-stable: the front matter, *For agents*, and the dag targets.
- Everything is public and scrubbed. cloudbox internals are never quoted; refer to it only as "the hosted control plane / satellite" through the public wire protocol.
- Leave Sprint 621 (shaping TDD) untouched. This sprint only links to it as the "verify" mechanism.

## Draft definition: what software shaping is (D1 turns this into the canonical doc)

**One line:** *Software shaping lets anyone tell an agent, in plain words, how a running tool should work, and get their own verified, reversible version, while everyone else keeps theirs.*

**The loop:** wish → candidate → verify → preview → approve (for me) → undo / restore → promote (local → team → upstream).

**Guidelines (the rules a shapeable thing obeys):**
1. **Yours, not everyone's.** Activation is scoped to a principal (web), a host (cli) or a host service. Other users and hosts are untouched.
2. **Judged, never trusted.** A model's output is a candidate. Ordinary commands and checks decide; approval re-runs verification, and a cached verdict is never authority. TDD adds red-on-base and green-on-candidate (S621).
3. **Always a way back.** Every activation is versioned; undo is one step and restore goes to any revision.
4. **Invariant core.** The certified/86-of-86 shell and the signed core never change by shaping. Only registered apps, tools, configs and skill-scripts do.
5. **Contracts, not prose.** Surfaces (routes, flags, args, JSON keys) evolve expand-then-contract, and effects never silently escalate.
6. **Rod, not fish.** Small `bashy shape … --json` verbs with exit codes 0/3/1, composed by Bash# skill-scripts that are themselves shapeable.
7. **UI→CLI parity.** Every web action has a CLI verb on the same entities with the same permissions.
8. **Provenance.** Each wish is a todo (`origin: shape`). Commits carry `Shape:` and `Shaped-By:`, and evidence is attached.

**Technologies (what makes it possible, mapped to repos):**

| Layer | Role in shaping | Repo |
|---|---|---|
| Classic: pure-Go Bash 5.3 + POSIX userland | The invariant, measured foundation that the same script runs on (every OS) | qiangli/bash = sh + coreutils |
| Bash# | The shaping language: script = skill, contracts (`@require/@ensure/@guard`), `agentic {}` judged by commands | bashsharp |
| Yoke | The shaping engine: `pkg/shape` lifecycle, verify, evidence, webconsole, weave isolation | yoke |
| bashy | The one binary: `bashy shape` CLI, web console `/shape/<app>/`, dag gates | bashy |
| outpost | Brings shaping to your own hosts and apps behind one door | outpost |
| satellite / cloudbox | Shares shaped versions with a circle or team: owner/member, promotion target | hosted (public wire only) |

**Features (shipped vs in progress, with each claim tied to evidence):**
- Shipped: the CLI lifecycle and promotion rod (rc.27+), the web console trial, the hello-world example, and per-principal web activation.
- In progress: cross-OS validation (S579), shaping TDD (S621), shaping dogfood and session slots (S617/618), and a free-workspace shaping host (S615).

**Shapeable badge criteria:** "Shapeable with Bashy" (design archive wording) means the app is registered, has declared checks, has a scoped activation, and has undo. The badge is a checklist and is never awarded by self-description.

## Sprint (created at execution start, not in plan mode)

`bashy sprint add "Software Shaping one theme: definition, READMEs, qiangli/bash" --json` (epic `software-shaping`) creates the card in `backlog`, unclaimed. The manager is TBD. Stories are added with `bashy todo add … --sprint <N>`. The master plan goes to `docs/sprint-<N>-master-execution-plan.md` with lines in `docs/INDEX.md` and `docs/README.md`. Commits carry the `Sprint:` / `Story:` / `Story-ID:` trailers.

### Stories, waves and planned workers (spread across vendors)

| Wave | Story | Scope (files) | Planned worker |
|---|---|---|---|
| 1 | **D1 Define software shaping.** The canonical doc, built from the draft above, reconciled with the shape-contract, overview and agentic-block docs; each feature has a shipped/in-progress tag and evidence link | new `bashy/docs/software-shaping.md`; links from `bashy/docs/INDEX.md`, `overview.md` | claude-opus5.5 (design-heavy) |
| 2 | **R1 bashy README + overview.** Reconcile with D1: the tagline points to the definition, and "what makes shaping safe" maps to the guidelines. Bootstrap sections stay byte-stable | `bashy/README.md` (top half only), `bashy/docs/overview.md` | claude-sonnet5.5 |
| 2 | **R2 Bash# as the shaping language.** One section on why Bash# is how shapes are written (script = skill, contracts judge models, `.bsh` + JSON hook is shapeable) | `bashsharp/README.md`, `bashsharp-tour/README.md` (Relationship section) | codex-gpt6-sol |
| 2 | **R3 Yoke as the shaping engine.** Rewrite the headline: the agentic userland *and* the shaping engine (`pkg/shape`, verify, evidence, webconsole); keep the certification-status note | `yoke/README.md` | opencode-glm-5.3 |
| 2 | **B1 qiangli/bash.** Create a public repo `qiangli/bash` (operator confirms before creation, since it is outward-facing) with submodules `sh` and `coreutils`, a README (pure-Go GNU Bash 5.3 + POSIX.1-2016 userland, one binary on every OS, built for certification but not certified, an evidence table, how bashy consumes it, the 86/86 gate pointer), and an MIT LICENSE for the superproject (submodules keep BSD-3 / MIT). Also prepend a short fork section to `sh/README.md`, keeping the upstream text below it, and add a "part of qiangli/bash" line to `coreutils/README.md` | new repo; `sh/README.md`, `coreutils/README.md` | muse-spark1.3 (READMEs); the manager creates the repo |
| 3 | **R4 One theme across the door.** Add one shaping line plus a link to D1 in the umbrella README (and a link to qiangli/bash) and the outpost README. Satellite and cloudbox positioning goes to the private docs repo, not here | `README.md`, `outpost/README.md`, umbrella `docs/INDEX.md` | agy-gemini3.8-flash |

| 2→3 | **L1 Product marks (logo / icon / favicon) for cloudbox/satellite, outpost, bashy.** One geometric family built from squares and circles. The operator chooses from a concept board, the same way S564 H6 chose the shaping "B Flow" mark. **Concepts:** cloudbox = a square inside a circle. **satellite = a clearly distinct variant of the cloudbox mark**, so a person can tell at a glance (16 px included) whether they are on the master or on a satellite. The board shows 3–4 options: an orbit dot or small ring arc on the circle; the square rotated 45° inside the circle; a smaller inner square with a second concentric ring; or the circle broken into an orbit ellipse. Shape alone must make the difference, with color as an extra cue only. outpost = two small slanted, stacked squares (still being worked out: offset, angle, gap, filled vs outline; the board shows 3–4 variants). bashy = four squares in a circle, app-grid style, where the top-right square differs (variants: rotated 45°, the shaping-violet `#6D4AFF` accent, outlined, or smaller/offset, which hints "the one you shaped"). The shaping B Flow mark stays the *action/badge* ("Shape this app"); these are *product* marks and must sit next to it without clashing. **Deliverables per mark:** hand-authored SVG master (pure geometry, no generated raster as the source), monochrome + screen-color versions on light/dark, PNG 16/32/48/180/192/512, `favicon.ico` (16/32/48), and a `SHA256SUMS`. **Legibility gate:** each mark must be recognizable at 16 px and in one color, and color alone never carries meaning. **Flow:** board → operator picks → finalize → wire favicons into the shipped web surfaces (bashy web console, outpost admin UI). The cloudbox/satellite wiring happens in the private repo and is out of scope here. | public family + bashy/outpost assets: new `docs/brand/` in the umbrella (concept board, family README) and `bashy/docs/brand/`, `outpost/docs/brand/`; the favicon wiring goes in each repo's existing static-asset path; cloudbox/satellite masters are copied to the private repo | claude-opus5.5 (design + SVG); favicon wiring → codex-gpt6-sol |

Composition note (rod, not fish): no new verbs. Every README points to the existing `bashy shape … --json` verbs and the D1 doc. **Shaping hook:** D1's "Shapeable" checklist is the extension point that later sprints (S621 TDD, S617 dogfood) cite, and no code is added here.

Submodule mechanics: commit and push inside each subproject, then bump the umbrella pins (`sync: bump bashy + yoke + bashsharp + … pins (S<N> one theme)`). Never `git add -A` at the root. Check `bashy weave list` before committing in a shared checkout.

## Open decisions (flag at sprint start)
1. **Portal name drift:** the outpost README says `ai.dhnt.io` and the umbrella says `tessaro.sh`. R4 aligns them to whichever you confirm.
2. **L1 selections:** the concept board stops for your pick (outpost shape, and the bashy top-right square variant) before finalizing. You also pick which satellite variant of the cloudbox mark to use (decided: the satellite gets its own visible variant).
3. **Repo creation:** `gh repo create qiangli/bash --public` happens only after your explicit go-ahead at execution.

## Verification
- `script/scrub-gate.sh` passes on every commit (it runs as the pre-commit hook, fail-closed).
- Claims audit: every number in the changed READMEs names its corpus and links its evidence. Grep confirms no "certified" claim: `grep -rn -i "certif" ` over the changed files shows only "not certified / readiness" wording.
- bashy README stays executable as a skill: `bashy dag -f bashy/README.md --list` lists the same targets as before, and a diff confirms the front matter and *For agents* through `help` are unchanged.
- Link check on the changed Markdown (relative links resolve; the qiangli/bash submodule URLs resolve after creation): `git clone --recurse-submodules` of qiangli/bash succeeds on a clean dir.
- Cross-read: each README's shaping sentence matches D1's one-liner verbatim, and the reviewer checks all six READMEs against D1.
- L1: render every PNG and favicon at 16 px and 32 px, in light and dark, and check them side by side with the B Flow mark. Run a blind distinguishability check: someone shown the cloudbox and satellite favicons at 16 px in a browser tab strip must tell them apart in monochrome. `sha256sum -c SHA256SUMS` passes. The favicon is served by the bashy web console and the outpost admin UI (a local smoke test: fetch `/favicon.ico` and match its hash).
- Docs-only sprint, apart from the L1 favicon wiring: no product gates are run (coding sessions are not QA).
