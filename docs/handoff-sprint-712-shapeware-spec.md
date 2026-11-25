# Handoff: Sprint 712 shapeware, next step is the spec layout and structure

Written 2026-11-25 at the end of the exploration session. Status: exploration recorded, nothing finalized. The next session **defines the shapeware spec: the folder layout and the structure of each part.**

## Start here (read in this order)

1. Story b35b89620f88 (umbrella `docs/todo/b35b89620f88-…md`). It holds the question, the operator review, the decisions and the **`shapeware` skill draft** (v0, with sections for the release spectrum, critical features, band floor, low-end QA and packaging).
2. `docs/sprint-712-shapeware-exploration-2026-11-25.md`. It holds:
   - the full discussion (15 steps)
   - the one-page model
   - decisions D1–D14
   - the experiments and their findings
   - 13 open questions
   - Appendix A, the hello-world source: a worked four-face example
   - Appendix B, the two-sense spec
   - Appendix C, the operator's answers verbatim
3. `bashy sprint show 712`. The thread has a comment for each step.

## Where things stand

- Sprint 712 is in **backlog**, plan-only, unclaimed. Its one story is b35b89620f88, which stays plan-only: no product code under it.
- Pilot: bashy todo `9643d77f` (p2 spike, no sprint, no owner).
  - Case 1: `form`, with an in-body known issue, a TBD spec and a `~~~ui` fence.
  - Case 2: a companion `.bsh` on `examples/shaping/hello-world`.
  - Addenda a–d: the UI face, `bashy-ui-v1`, the raw view, and "restricted HTML and the converter, not either/or".
- Bugs found in the session:

  | Todo | Priority | Bug |
  |---|---|---|
  | bashy `64ef2626` | p2 | the form registration rejects all flags |
  | bashy `9ab67520` | p3 | `serve --help` starts the server |
  | bashy `c28b0669` | p3 | registrations can point into deleted weave workspaces |
  | yoke `f571c624` | p3 | the copy sheet will not copy a field twice; root cause unknown |

- Name: **shapeware** (category word, not registered). The GitHub org `shapeware` exists and is empty.
- Nothing is running or installed from the session. The desk items, the `hello` command and skill, and the notepad server are all cleaned up.

## The next task: define the shapeware spec (layout and structure)

Goal: a written spec of what a shapeware release **is** on disk. It should be precise enough that a low-end local model can create, check and use one. Settle structure only; no implementation in this step.

**Settled inputs (do not reopen):**
- D14: a release is a **skill folder**. "Shapeware is a skill with a contract." There is no new package format.
- D7/D8: no reinventing the wheel. Every part uses a standard language (Markdown, Bash#, YAML/JSON, restricted HTML/CSS, TS). Restricted HTML and the converter coexist.
- D3: known issues are written in-body (in `SKILL.md`).
- D10: the release class is **computed** from feature statuses and known issues (requirements release / verified with tbd / verified with known issues / verified). `critical: true` features are never tbd.
- D12: `min-band` (app level), with an optional per-feature `band:`.
- D13: everything must be usable by low-end local models (short imperative steps, structured output, PASS/FAIL/TBD acceptance).

**Reuse these existing conventions; inspect the code before deciding:**
- `SKILL.md` frontmatter (`name`, `description`, `metadata:`). See `bashy/examples/desk/form/form.bsh` for `metadata: requires / step-porota / check-tests` and the `~~~skill as guide` face.
- `contract.bsh` (`@effects(...)`), `checks/*.bsh`, and `shaped.json` (`server`, `genie.examples`). See `bashy/examples/desk/form/` and `bashy/examples/shaping/hello-world/`.
- The desk kit wire, to be named `bashy-ui-v1`: `POST /api/action`, `GET /api/state`, `GET /api/export`, `GET /api/events`, plus `kit/contracttest`. See `bashy/examples/desk/kit/`.
- Bash# fences: `~~~LANG as ALIAS !RUNNER` and `embed LANG "FILE" as ALIAS !RUNNER` (`sh/syntax/bashpp_nodes.go`, `bashpp_embed.go`).
  - Only one alias is allowed per language per file.
  - md/html/css/json/yaml need a runner today.
- `bashy skill add/export` and the skill record (`bashy/CLAUDE.md` §Skills).

**Structure questions to settle, in this order:**
1. **Folder layout:** which files are required and which optional (`SKILL.md`, `scripts/`, `checks/`, `contract.bsh`, UI assets, `shaped.json`?). Decide whether the faces live in-body (one `.bsh`, as in the hello example) or as separate files, or allow both.
2. **Frontmatter `metadata:` keys:** the shapeware version, `min-band`, critical-feature ids, the computed release class (or never stored, always computed?), and requirements.
3. **The feature list schema:** `id`, `status`, `intent`, `acceptance` (format of the examples), `critical`, `band`. Decide where it lives (a `~~~feature` block or a `features.yaml`).
4. **The known-issue schema** inside `SKILL.md`: symptom, cause (proven/suspected), workaround and its bounds, forbidden workarounds, status, expiry, link to a todo. Keep it a symptom → action lookup.
5. **The `checks/` contract:** how acceptance is invoked and its PASS/FAIL/TBD output lines; how the release class is computed from them.
6. **UI assets:** where restricted HTML/CSS lives, how the `bashy-ui-v1` envelope refers to it, and how JSON data (form definitions) is placed.
7. **The trusted-core reference:** how a skill points at and verifies prebuilt binaries for critical features.

Deliver: one spec doc (draft), checked against the hello example rewritten into the settled layout. Validate it with a dev-box walkthrough only (no ollama or browser runs on the dev box).

## Rules for the next session

- **KISS/MVP, rod not fish:** define the smallest structure that holds. Record gaps as "not in the MVP" rather than adding parts.
- **Inspect the existing code before proposing a structure**, and record what was inspected.
- 712 stays plan-only. Product changes go to follow-on todos and need operator approval; the `sh` engine is frozen to bug fixes only.
- **Venues:** low-end model evaluation and any browser-driving acceptance run on the gate host, never the dev box.
- **Public repo:** no host names, home paths, addresses or credentials in anything committed.
- **Commits:**
  - Commit with a pathspec.
  - Use the 712 provenance trailers (Sprint #712, Story #744, Story-ID b35b89620f88), or `Adhoc:` for work no sprint owns.
  - Check `git diff --cached` first, because other agents share the index.

## Remaining open questions (from the record, §6)

Most relevant to the spec step: 1 (accept the skill as v1, and where it ships), 2 (the restricted-HTML allowlist), 3 (built-in text fences vs runners), 4 (the `bashy-ui-v1` envelope), 6 (the known-issue status in `bashy todo`), and 12 (reconcile the band numbering before using `min-band`).

Later: 5 (MCP elicitation), 7 (the field network), 8 (the cost model), 9 (the trademark sanity check), 10 (pilot owner and venue), 11 (the shapeware certificate pack), 13 (the low-end evaluation pack).
