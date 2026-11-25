# Sprint 712 master execution plan (operator-approved 2026-11-25)


## Context

Sprint 712 (fccece26, epic software-shaping) is a **plan-only** spike. It is in backlog and unclaimed, with one story: b35b89620f88 (#744). It asks whether software should ship as shapeable Bash# source plus specs, skills and known issues, and be finished or fixed in the field by runtime agents (the "reverse SDLC"). The 11-25 session explored this and recorded decisions D1–D14, four experiments, the `shapeware` skill draft v0 and 13 open questions. Its handoff (`docs/handoff-sprint-712-shapeware-spec.md`, 8a798fedb) names the next step: **define the shapeware spec layout and structure**. Nothing has been committed against 712 since then.

## Review: where 712 stands against its own acceptance

| Story acceptance item | State |
|---|---|
| Written plan: definitions, options, recommendation, risks/dissent, non-goals | Partial. The definitions and the skill draft exist. There is **no explicit recommendation, no risk review and no dissent (status quo)**. |
| Lifecycle map | Effectively done: the hello-world walkthrough (record §4.2). It needs to be lifted into the plan as the map. |
| Three schemas: field session, known issue + runtime instruction, artifact manifest | Partial. Each exists only as prose in the skill draft. **This is the handoff's "spec layout" task.** |
| Three tabletop cases: (i) #3230 timing, (ii) a shaping app used for real, (iii) a skill/spec with no new binary | (ii) and (iii) are partly covered by hello and the pilot design. **(i) #3230 has not been simulated.** |
| Comparison with the current build/release process | Missing. |
| Follow-on sprint/story split with priorities and owners; what stays frozen | Missing. Today there are only loose todos: 9643d77f and four bugs. |
| No product code | Held. |

Review findings:
1. **D3 and D14 conflict.** D3 puts known issues "in the `.bsh` body", but D14 makes the release a skill folder with known issues in `SKILL.md`. Reconcile it this way: `SKILL.md` *is* the body in the folder form, and the single `.bsh` is an authoring convenience that projects into the folder.
2. **Feature list placement.** An in-body `~~~feature` fence needs a runner (finding 2), and only one alias is allowed per language per file (finding 1). Put the list in a `features.yaml` file instead: standard YAML, with no engine change.
3. **Q12 (band numbering) blocks `min-band`.** It must be settled before the spec names band values.
4. **Q3 (built-in text fences) is an `sh` engine change**, and the engine is frozen. Recommend staying with runners; no request.
5. The sprint is unclaimed and has no continuity record. Take it and checkpoint per step (memory: review before start; handoff mechanics).

## Master execution plan

### Phase 0: start (the conductor, me)
- Record D17 (the standard self-describing preamble in every `SKILL.md`, plus the bundled `references/shapeware.md`).
- Record D16 (missing parts take defaults; any plain skill is shapeware with defaults) next to D15.
- Record the operator's superset rule as D15 on story b35b89620f88 and in the record §3. Correct D14's wording to match: from "a skill folder" to "a superset of an Agent Skill folder; every shapeware release is a valid skill". Save it to memory as well.
- `ListAgents`, `bashy weave list`, `bashy claim list`, `bashy inbox`: check for peers on 712 and shaping.
- Fetch the umbrella and bashy (docs only, so no pin bump is needed). `bashy sprint take 712`, then a first `sprint checkpoint`.

### Phase 1: the shapeware spec v0 (the handoff task; one doc)
New: `docs/shapeware-spec-v0.md` in the umbrella (plus its abstract in `docs/README.md` and a line in `docs/INDEX.md`).

**Governing rule (operator, 11-25; record it as D15): a shapeware app folder is a superset of an Anthropic Agent Skill folder.**
- **Every shapeware folder is a valid Agent Skill.** Any skills loader (Claude Code, claude.ai upload, the Skills API, `bashy skill add`) loads it unchanged and gets usable instructions. It ignores what it does not know.
- **Missing parts take defaults (operator, 11-25; record it as D16).** Only `SKILL.md` is required, as in a skill. Every shapeware part is optional, and when it is missing the spec's documented default applies. A **published** shapeware release declares its type (D17). A folder without the declaration is a plain skill, which a shapeware-aware agent may still treat as shapeware with all defaults.
- Shapeware adds things only where the skill format already allows extras: entries under frontmatter `metadata`, and extra files and directories. It never adds new top-level frontmatter keys or changes the meaning of standard ones.

Skill-format constraints to honour (checked in the Agent Skills docs, 11-25):
- `SKILL.md` must have `name` and `description`.
  - `name`: at most 64 characters; lowercase letters, digits and hyphens; no reserved words; it equals the folder name.
  - `description`: at most 1,024 characters, saying what the skill does and when to use it; no XML tags.
- The body stays small (under about 5k tokens).
- Other files load only when `SKILL.md` links to them, one level deep.
- Scripts run, and only their output enters context. That fits D13: the reasoning goes in scripts.
- Runtimes differ. The API sandbox has no network and no package installs, and bashy is not present there. So the bashy dependency is declared in the open spec's optional `compatibility` field (or the existing `metadata.requires: "has=bashy"`), and the folder still reads as guidance without bashy.

**`SKILL.md` teaches any agent (operator, 11-25; record it as D17): (1) that this is `type: shapeware`, and (2) how to run shapeware the right way, with no extra advertisement and no prior knowledge of shapeware.**
- **(1) The type is declared twice, once for machines and once for readers:**
  - In the frontmatter, `metadata.type: "shapeware"` and `metadata.shapeware: "0"` (the spec version). It goes under `metadata` because the open skill spec allows only `name`, `description`, `license`, `compatibility`, `metadata` and `allowed-tools` at the top level, and a strict validator such as `skills-ref` or a Skills API upload may reject a top-level `type:`. Phase 1 confirms this with the validator; if top-level `type` turns out to be accepted everywhere, the spec may use it.
  - In the body, the first line under the title reads `Type: shapeware (v0)`. Agents read the body, and they may never see the frontmatter `metadata`.
- **(2) Run it the right way:** one standard block, placed right after the title, as fixed text from the spec (the same words in every app; only `<name>` and the paths change). It is written for the low end (D13): numbered imperative steps with exact commands.
- **It works offline.** It links to a bundled `references/shapeware.md`, a one-page agent card (the condensed `shapeware` skill rules, versioned with the spec). The public spec URL is a secondary link, under github.com/shapeware once the Q9 sanity check clears. So it works in the no-network API sandbox too.
- **It gives a path with bashy and one without:**

```markdown
Type: shapeware (v0)

## How to run this shapeware app
This skill is an app. It ships source, feature specs, checks and known issues,
and agents may finish or fix it in use. Full rules:
[references/shapeware.md](references/shapeware.md).

1. Check the runtime: run `bashy --version`. Without bashy, read the steps
   and scripts only, and ask the user before installing anything.
2. Run: `bashy --bashsharp scripts/<name>.bsh <verb> …` (or `bashy <name> …`
   once it is registered). This honours the effect cap in `contract.bsh`.
3. On any failure, stop. Find the symptom under "Known issues" and do the
   listed action. Not listed? Report it (step 7). Never retry blindly.
4. Show: open `assets/ui/<page>.html` in a browser (plain HTML, no server).
5. Check: `bashy --bashsharp checks/acceptance.bsh`. Read only the
   PASS / FAIL / TBD lines.
6. Build a missing feature (`status: tbd` in `features.yaml`): only if the
   user asks for it, never for `critical: true`, and never by editing the
   installed copy. Use `bashy shape wish "<feature id>"`, or work on a copy.
   Keep the change only when its check lines say PASS.
7. Report: what you ran, the check lines, and the feature or known-issue id.
```
- **"The right way" means the rules a generic agent would otherwise break:** use bashy as the runtime (so the effect caps apply), look up known issues before improvising, never retry until green, never edit in place, never field-build a critical feature, and treat checks as the only evidence. The longer rules (band floor, release class, upgrades) stay in `references/shapeware.md`, out of the body budget.
- **Lint (Phase 1 superset check):**
  - `metadata.type` is present and the body line `Type: shapeware` is present, and the two agree.
  - The block is present and matches the spec version's text.
  - Its links resolve inside the folder. With no block, the folder is still shapeware with defaults (D16), but agents that know nothing of shapeware get no guidance. So a published release must carry the block.
- Cost: about 200 tokens, within the body budget.

**Defaults table (part of the spec; the rule is to take the existing default where bashy already has one, else the safe or no-claim value):**

| Missing | Default |
|---|---|
| `metadata.type` | A plain skill. A shapeware-aware agent may apply all the defaults below; a published release must declare it. |
| `metadata.shapeware` | The current spec version (v0). |
| `metadata.min-band` | The lowest field-building band. The exact value waits for Q12; until then the default is "no field building of tbd features", which is the safe choice. |
| `features.yaml` | No declared features. The class is computed over an empty list and reported as "verified (no feature claims)", with nothing tbd and nothing critical. |
| A feature's `status` | `tbd`. Only a passing acceptance run can make a feature `verified`. |
| A feature's `critical` | `false`. |
| A feature's `band` | The app's `min-band`. |
| A feature's `acceptance` | None. The feature cannot be `verified`, so it stays `tbd`. |
| `## Known issues` | None. |
| A known issue's `status` | `open`. |
| A known issue's `cause` | `suspected`. |
| A known issue's `expires` | Review at the next release. |
| `checks/` | Nothing to run. Declared features without checks stay `tbd`. |
| `contract.bsh` | bashy's existing default effect cap. Inspect `bashy src pr verify` and `bashy shape` during Phase 1 and record it; if bashy has none, `read` only. |
| `metadata.version` | Taken from the release's git tag. With no tag, `0.0.0+<commit>`. |
| `shaped.json` | No server (no trusted core) and no genie examples. |
| `assets/ui/` | No UI face. The skill and script faces only. |

The recommended structure settles the 7 handoff questions in order (only `SKILL.md` is required; everything else is optional, with the defaults above):

```
<name>/                     valid Agent Skill; one release (D14)
  SKILL.md                  [skill] name, description, (license, compatibility),
                            metadata: {type: shapeware, shapeware: "0", version, min-band, requires, check-tests} (string values)
                            body: "Type: shapeware" line + standard "How to run" block (D17) + short imperative steps + "## Known issues" (D3, D13),
                            with links to features.yaml / checks / assets
  scripts/<name>.bsh        [skill std dir] the script face (may embed ~~~skill; it must match SKILL.md)
  assets/ui/                [skill std dir] restricted *.html/*.css, *.json data (optional)
  references/shapeware.md   [skill std dir] bundled one-page agent card (target of the preamble link)
  references/               [skill std dir] optional longer docs
  features.yaml             [shapeware extra] feature list, linked from SKILL.md
  checks/acceptance.bsh     [shapeware extra; existing bashy name] PASS|FAIL|TBD lines
  contract.bsh              [shapeware extra; existing] @effects cap
  shaped.json               [shapeware extra; existing, optional] server (trusted core) + genie
```
1. **Layout:** as above. The standard skill directories are used wherever they fit (`scripts/`, `assets/`, `references/`). The existing bashy names (`checks/`, `contract.bsh`, `shaped.json`) stay as extra entries, because `bashy src pr verify` and `bashy shape` already expect them. The single `.bsh` with faces stays an authoring form for tiny apps; projecting it into the folder is not in the MVP.
2. **Frontmatter:** only the standard keys at the top level. All shapeware keys go under `metadata` as string values: `shapeware: "0"` (the marker and spec version), `min-band` (once Q12 is settled), plus the existing `requires` and `check-tests`. The release class is **never stored**; it is computed (D10). Critical ids live only in `features.yaml`, as the single source.
3. **`features.yaml`:** `id`, `status` (tbd|verified), `intent`, `acceptance` (`cmd => expected` lines, as proven in hello; UI acceptance by label/role is not in the MVP), `critical`, `band`.
4. **Known issue** (in the `SKILL.md` list): `KI-n [status] symptom → action`, then indented `cause: proven|suspected …`, `bounds:`, `forbidden:`, `expires:`, `todo:`. Each line must be greppable by a script.
5. **Checks contract:** `checks/acceptance.bsh` prints `PASS|FAIL|TBD <feature-id> <example>` and exits non-zero on any FAIL. The release class = f(features.yaml, the KI statuses, the check lines). The rules are in the spec, and the shapeware skill carries a short script that computes it (the rod; no new verb).
6. **UI assets:** `assets/ui/` holds restricted HTML/CSS and JSON data. The envelope reference waits for Q4 (`bashy-ui-v1`) and is marked "not in MVP".
7. **Trusted core:** `shaped.json` `server.main` plus a pinned digest. Signing and provenance are marked "not in MVP" and become a follow-on.
8. **Versions and upgrades** (the operator asked how to handle them; this is the recommendation, which reuses git tags, `bashy shape` and the skill record):
   - **Four independent versions:**
     - (a) The spec format: `metadata.shapeware`. A reader accepts the same major and ignores unknown `metadata` keys, which follows from the superset rule.
     - (b) The app release: a semver git tag, mirrored in `metadata.version` (a string, standard in the open skill spec). "One release, one tag."
     - (c) A local shaped variant: the base version plus a local suffix, `1.2.0+shaped.<sha>`, kept on a `shaped/local` branch. It is never a new upstream version.
     - (d) The known-issue feed (the fast channel, later): each entry names the app version range it affects.
   - **Semver meaning for shapeware:**
     - major: a feature id is removed or renamed, or an acceptance example changes meaning
     - minor: a feature is added, or one moves from tbd to verified
     - patch: a known issue is added, worked around or fixed, or docs change

     The release class is computed and reported beside the version, never encoded in it.
   - **Feature and known-issue ids are stable across versions.** They are the join key for an upgrade.
   - **Upgrade = rebase the local variants onto the new release, through the shaping lifecycle:**
     1. Install the new release beside the current one (the current one stays as the undo point).
     2. For each local variant: if its feature is now `verified` upstream, drop the variant. Otherwise re-apply it as a `bashy shape` candidate, run acceptance, then approve. If it conflicts, redo it from the feature spec rather than repairing it.
     3. A local workaround is retired when its known issue is `fixed` upstream.
     4. Any FAIL keeps the old release live; undo is the previous tag.
   - **The trusted core** (critical features) is pinned by digest in `shaped.json`. It changes only with a new upstream release, never through an upgrade-time field change.
   - **Not in the MVP:** automatic or background upgrades, the feed, and migrating user data. Data shapes live in `assets/ui/*.json`, and changing one is a major version.
   - Inspect before deciding: whether the bashy skill record and `bashy skill add` already carry or check a version, `bashy update` (the binary channel; unchanged), and how `bashy shape` stores and undoes variants.

   The hello walkthrough already exercised this path (v0.1.0 → shaped/local → v0.2.0). Phase 1 adds an upgrade leg: v0.1.0 with a local variant, then v0.2.0 makes that feature verified, so the variant is dropped, and acceptance shows 3 PASS.

Inspect, and record the inspection in the doc: `bashy/examples/desk/form/{form.bsh,contract.bsh,shaped.json,checks/}`, `bashy/examples/shaping/hello-world/`, `bashy/examples/desk/kit/contracttest`, `sh/syntax/bashpp_{nodes,embed}.go`, and bashy `CLAUDE.md` §Skills (SKILL.md canonical; the record form for the wire).

Validate by rewriting hello (record Appendix A) into the layout, in the scratchpad only. Then on the dev box: `bashy skill add` the folder, run `checks/acceptance.bsh` (2 PASS + 1 TBD expected), and compute the class ("verified with tbd"). Run no ollama and no browser. Put the rewritten folder in the spec as an appendix.
**Superset check** (the same folder, unchanged):
- (a) It passes a skill-format lint: the frontmatter keys, the `name` rules, the `description` length, `name` matching the folder name, and string `metadata` values. Use the open `skills-ref validate` if it is available; otherwise a short script in the shapeware skill.
- (b) A Claude Code session that has it in a scratch project's `.claude/skills/` (not the user's home skills dir) lists it and can follow `SKILL.md`.
- (c) `bashy skill add` and `export --yaml` round-trip it losslessly.
- (d) The reverse direction: an existing plain skill, unchanged, is treated as shapeware with all defaults. Use `bashy/skills/bashy` read-only: the class computes as "verified (no feature claims)" and no rule errors.

### Phase 2: complete the story's plan deliverable (one doc)
New: `docs/sprint-712-recommendation.md`. It reuses the record rather than re-deriving it:
- The lifecycle map, lifted from the hello walkthrough.
- The three schemas: the manifest (= spec v0), the known issue (= spec §4), and the field-session record (a minimal `bashy shape` wish/candidate/verify/approve trail plus the outcome class).
- Tabletop (i) #3230: written as KI-1-style data with a budget and a classification. (ii) is hello field shaping. (iii) is the form pilot design (9643d77f).
- A comparison with the current train/freeze/no-HUAT process, and the **status quo as dissent**.
- Risks: safety, security (field code and the critical core), determinism, support, cost (Q8).
- **What stays conventionally frozen:** the `sh` engine, the release train (76eac0ea), critical features and the trusted core, and the gates (86/86, POSIX).
- Recommendation: **pilot** (go for the narrow pilot; no-go for scale until Section D trust exists).
- The follow-on split (below).

Commits are docs only, in the umbrella, with a pathspec. Trailers: `Sprint: #712`, `Story: #744`, `Story-ID: b35b89620f88`. Check `git diff --cached` first.

### Phase 3: operator review, then close
- One review form covering the spec v0 and the recommendation, plus decisions on Q1 (skill v1, and where it ships), Q2 (the HTML allowlist, or defer), Q3 (runners, no engine change), Q4 (defer the envelope), Q6 (the known-issue todo status) and Q12 (band numbering).
- Record the answers on b35b89620f88 and the 712 thread. Close the story and end 712 (one story, one goal).

### Phase 4: proposed follow-ons (filed only after operator approval, each reviewed before start)

| Pri | Follow-on | Contents | Owner | Venue |
|---|---|---|---|---|
| P1 | Sprint: shapeware pilot on form | 64ef2626 (prerequisite fix, root cause known) → 9643d77f cases 1+2, laid out per spec v0 | agy worker; I review and gate | gate host for browser acceptance |
| P1 | Story: known-issue todo state | `bashy todo` status for known/workaround/expires; move #3230 into it | bashy worker | unit tests |
| P2 | Sprint: low-end eval pack | Q13 + Q11 in agent-bench (task pack, scoring); sets the band floor | worker | gate host (bashy ollama) |
| P2 | Story: `bashy-ui-v1` envelope + restricted-HTML profile | Q4 + Q2; extend kit/contracttest | worker | unit tests |
| P3 | Backlog | signed KI feed and field network (Q6b/Q7), cost model (Q8), MCP elicitation (Q5), trademark sanity check (Q9) | — | — |

The unrelated bugs 9ab67520, c28b0669 and f571c624 stay independent todos; they are not shapeware scope.

## Non-goals in 712
No product code, no engine change, no new verbs or formats, no release-train change, no ollama or browser runs on the dev box.

## Verification
- Phase 1, unaware agent:
  - A fresh Claude Code session in a scratch project gets only the hello folder and no shapeware context. From the preamble alone it runs the app, shows the card page, runs the checks, and builds the tbd feature on a copy until it passes.
  - Record its tool calls. The same task goes into the P2 low-end pack for a small local model on the gate host, never on the dev box.
- Phase 1, upgrade leg: v0.1.0 plus a local variant, upgraded to v0.2.0. The variant is dropped because the feature is verified upstream, acceptance passes, and undo to v0.1.0 restores the old behaviour.
- Phase 1, superset: the hello folder passes the skill-format lint, loads as a plain skill in a scratch Claude Code project, and round-trips through `bashy skill add` and `export`.
- Phase 1: the dev-box walkthrough of the rewritten hello folder gives 2 PASS / 1 TBD and the class "verified with tbd". A low-end model can follow the spec, which is checked later by the P2 pack, not here.
- Phase 2: every story-acceptance row in the table above maps to a section of the recommendation doc.
- `script/scrub-gate.sh` passes at pre-commit, and the `commit-msg` trailer hook passes.
- `bashy sprint show 712` shows the goal checked and the story closed after the operator review.
