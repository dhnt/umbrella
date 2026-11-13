# Sprint 634 master execution plan — film follow-ups: local, recorded translation and text stages; subtitle font fix

Status: approved by the operator 2026-11-13; sprint started under the
conductor `claude-fable5.1-s634`. Carried from Sprint 627 M8
(`docs/sprint-627-m8-drafts-evidence.md`).

## Outcome

Every text stage of a `bashy film` draft is produced by a recorded provider,
local by default, so a draft can be fully local and its provenance is
auditable. The bilingual subtitle burn-in renders the Latin line in a Latin
font.

Stories (bashy `docs/todo/`, sprint uuid `f57b15f7-34b1-5edb-80df-fa3588507b7c`):

| Story | Priority | Title |
|---|---|---|
| `aad065039174` | p1 | film: local, recorded translate stage (route=oss default) for bilingual subtitles |
| `759ea0f92839` | p2 | film: optional local text-drafting stage (lyrics / storyboard prose) with recorded provider |
| `eeaeb68a3260` | p2 | media subs: English line rendered in the CJK font has uneven letter spacing |

## State at start

- The film pipeline already records every door call in `stages.jsonl` and
  `manifest.json` (provider, route, cost_class, elapsed). A translate stage
  drops into that mechanism. Today the translation lines come from the
  storyboard with no stage record (the M8 finding).
- The font bug is in the burned banners, not the `.ass` track: the soft track
  already uses IBM Plex Mono for the primary style, but `burn_cues` renders
  both lines of a cue with one `agg` call in the CJK family.
- The Windows test host is the draft venue (native first). Whether native
  ollama and a Qwen3 model are staged there is checked in step 3; the operator
  approved installing them if missing.

## Steps

1. **Seat.** Fast-forward the bashy checkout to origin main, set this plan as
   the spec, start the sprint, checkpoint, post the plan on the board.
2. **`eeaeb68a` font fix** (conductor, first: every later spot frame depends
   on it). In `examples/media/media.bsh` render line one of a burned banner
   in the Latin font and only line two in the CJK font; keep the pinned
   font-cache path. Fixture test on the banner path; verify with a spot frame
   and the media gate.
3. **`aad065039174` translate stage** (claude clone worker). One new oss rod in
   `examples/oss-rods` serving the `translate` role over native ollama with a
   pinned Qwen3 tag. `--doctor --json` checks the registered ollama command
   and the staged model; a render never pulls. Input: the timing cue list;
   output: cues on identical timestamps; line count checked in the rod and
   again in film. `film.bsh` gains a translate stage between timing and
   assembly (route oss default, `--route-translate`/`--provider-translate`
   like the other roles); lock and final reuse the locked translation; a
   count mismatch fails loudly, never a silent single-language fallback.
   Storyboard-supplied lines stay allowed only as an explicit `manual` route
   recorded as such (the escape hatch). Fixture rod gains a translate case;
   tests cover the recorded stage and the mismatch failure. One live run on
   the Windows test host producing EN+ZH subs with the stage recorded, zero
   spend.
4. **`759ea0f92839` text drafting** (non-claude vendor worker, after step 3
   lands: it reuses the same rod with a `text` role). One verb that drafts
   lyrics, shot prose and image prompts into the storyboard and records the
   provider in a stage file. Fixture test plus one live local run.
5. **Closure.** Targeted film and media tests plus the media gate on the dev
   box; live evidence from the Windows host; bashy pin bump into the
   umbrella; `script/sync.sh --check`; accept each story on its own criteria;
   checkpoint; kb retro.

## Rules

- Windows native first; WSL only with a recorded reason.
- Free local drafts only; no spend, no `--yes`.
- Every guard has an explicit, logged escape hatch.
- Targeted tests in implementation; the full suites are a later QA pass.
- Do not sweep other agents' work into commits; notify the owner.
- Hosts by role only in every committed file.

## Venue

Dev box for fixture tests and the media gate. The Windows test host for live
local runs, claimed with `bashy claim` before use and released after; it is
shared with the Sprint 627 M8 work, so wait for its release.
