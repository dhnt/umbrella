# Shapeware spec v0: layout and structure (draft)

Status: **draft for operator review** (Sprint 712, story b35b89620f88, 2026-11-25). Plan only: no product code changed. Validated with scratch walkthroughs on the dev box (§15).

Shapeware is software that ships as Bash# source together with its specs, skill and known issues, and that agents finish or fix in use (the reverse SDLC; record: `docs/sprint-712-shapeware-exploration-2026-11-25.md`). This spec defines what a shapeware release **is on disk**: precise enough that a low-end model can create, check and use one.

It rests on D3, D7, D10 and D12–D17 (record §3). Three rules govern everything else:
- **Superset (D15).** A shapeware folder is a superset of an Agent Skill folder. Every shapeware release is a valid Agent Skill that any skills loader (Claude Code, a claude.ai upload, the Skills API, `bashy skill add`) takes unchanged, ignoring what it does not know.
- **Defaults (D16).** Only `SKILL.md` is required. Every other part is optional, and a missing part takes the default in §11.
- **Self-describing (D17).** `SKILL.md` tells any agent that the folder is shapeware and how to run it the right way, with no extra advertisement (§4.3).

No new formats (D7): Markdown, YAML, Bash#, semantic HTML/CSS and JSON only.

## 1. Where the folder lives: one layout for the repo and the skill

The shapeware folder is wherever its `SKILL.md` is. The Agent Skills format does not require any subdirectory: `scripts/`, `references/` and `assets/` are conventions, and an agent loads whatever `SKILL.md` links to. That lets one layout serve as both the repo and the skill:

- **Skill directories are named by meaning, and repos use the same meanings.** `scripts/` holds executables, `assets/` static files, and `references/` longer docs (a repo's `docs/` serves the same role; `SKILL.md` may link `docs/…` instead).
- **The repo root can be the skill folder.** Add `SKILL.md` at the root and link the repo's existing `scripts/`, `assets/` and `docs/`. Nothing moves. The skill `name` equals the repo directory name.
- **The shapeware parts have default paths** (`features.yaml`, `checks/acceptance.bsh`, `assets/ui/`, `contract.bsh`). A repo that already uses one of these names for something else points to another path with a `metadata` path key (§3: `features`, `checks`, `ui`). Tools and agents resolve every path through those keys, then the defaults.
- **Zero-touch alternative:** a self-contained subfolder at the usual skills location (`skills/<name>/`, or the repo's existing one such as `.claude/skills/<name>/`), whose scripts reach the repo root with `git rev-parse --show-toplevel`. Use it when the root must not change at all.
- Uploading a whole repo as one skill (claude.ai, the Skills API) may exceed size limits. `bashy skill export` of a trimmed folder is the route there; trimming is not in the MVP.

## 2. Layout

```
<name>/                     a valid Agent Skill; one release (D14)
  SKILL.md                  required. Frontmatter + "Type: shapeware" line + the standard
                            run block + usage steps + "## Known issues"
  scripts/<name>.bsh        [skill std dir] the script face (Bash#)
  assets/ui/                [skill std dir] restricted semantic HTML/CSS pages, JSON data
  references/shapeware.md   [skill std dir] the bundled agent card (offline rules)
  references/               [skill std dir] any longer docs
  features.yaml             [shapeware] the feature list
  checks/acceptance.bsh     [shapeware; existing bashy name] PASS/FAIL/TBD lines
  contract.bsh              [shapeware; existing bashy name] the effect cap
  shaped.json               [shapeware; existing bashy name] trusted-core server + wishes
```

- The standard skill directories are used where they fit.
- The existing bashy names (`checks/`, `contract.bsh`, `shaped.json`) stay, because `bashy shape` and its verifier already use them.
- A single `.bsh` holding all its faces (`~~~skill`, `~~~feature`, `~~~ui`) remains an authoring form for tiny apps. Projecting it into the folder is not in the MVP.

## 3. Frontmatter

Only the standard keys appear at the top level:

| Key | Notes |
|---|---|
| `name` | Required. At most 64 characters, `[a-z0-9-]`, no reserved words, equal to the folder name |
| `description` | Required. At most 1,024 characters, what and when, no XML tags |
| `license` | Optional |
| `compatibility` | Optional. Declare the bashy runtime here |
| `allowed-tools` | Optional |
| `metadata` | Optional. **All shapeware keys go here, as string values** |

The shapeware keys under `metadata`:

| Key | Meaning |
|---|---|
| `type: shapeware` | Declares the folder as shapeware (D17). Without it the folder is a plain skill. |
| `shapeware: "0"` | The spec version. A reader accepts the same major and ignores unknown keys. |
| `version: "X.Y.Z"` | The app release (semver, the same as the git tag). |
| `min-band` | The band floor for field building (D12). Values wait for Q12 (band numbering). |
| `requires`, `check-tests` | Existing bashy keys (see `form.bsh`). |
| `features`, `checks`, `ui` | Path overrides, relative to the folder, for a repo whose layout already uses the default names (§1). Defaults: `features.yaml`, `checks/acceptance.bsh`, `assets/ui/`. |

The release class is **never stored**; it is computed (§12). Critical feature ids live only in `features.yaml`.

Note on `type`: bashy's skill parser already reads a **top-level** `type` key (`yoke/pkg/skills/skill.go`). The open skill format does not allow one, so shapeware uses `metadata.type`. Reconciling the two is follow-on F4 in §16.

## 4. SKILL.md body

### 4.1 Order
1. The title.
2. `Type: shapeware (v0)`.
3. The standard run block (§4.3).
4. The usage steps.
5. `## Known issues`.

The body stays under about 5k tokens. Longer material goes in `references/`.

### 4.2 Known issues (D3: in the body)
Known issues are a symptom → action lookup, one entry per issue, and each line can be grepped:

```
- KI-<n> [open|workaround|fixed|expired] <symptom> → <action>
  cause: proven|suspected <what is known>
  bounds: <when the workaround stops applying>
  forbidden: <workarounds that must not be used>
  expires: <date | next release>
  todo: <todo id | none>
```

Ids are stable across versions. A `fixed` entry needs a passing acceptance example. An entry past its expiry is `expired`: reopen it and escalate.

### 4.3 The standard run block (verbatim; only `<name>` and the paths change)
The canonical text is the hello example in Appendix A (`SKILL.md`, lines "Type: shapeware (v0)" through step 7). It does four things:
- It tells any agent what the folder is.
- It links the bundled card, `references/shapeware.md`, which works offline and in the no-network API sandbox.
- It gives numbered steps: runtime check, run, known issues first, show, check, build (with the band floor, the installed-copy rule and a sibling `<folder>.work/` copy), and report.
- It encodes the rules a generic agent would otherwise break: run under bashy (so the effect cap applies), look up known issues before improvising, never retry blindly, never edit in place, never field-build a critical feature, and treat checks as the only evidence.

## 5. features.yaml

A YAML list. Feature ids are stable across versions.

```yaml
- id: greet-lang                 # required, stable
  status: tbd                    # tbd | verified   (default tbd)
  intent: A user can ask for the greeting in their own language.
  acceptance:                    # "command => expected output" lines
    - hello greet Ada --lang es => ¡Hola, Ada!
  critical: false                # default false; true = never tbd, never field-built
  band: <floor>                  # optional; raises the app min-band for this feature
```

A feature's floor is the higher of `metadata.min-band` and its own `band`. UI acceptance by label and role is not in the MVP.

## 6. Checks contract

`checks/acceptance.bsh`:
- prints one line per acceptance example: `PASS|FAIL|TBD <feature-id> <example>`
- a `verified` feature that does not pass prints FAIL; a `tbd` one prints TBD
- exits 1 on any FAIL, otherwise 0
- reads the examples from `features.yaml` (data-driven), so a copy of the folder tests itself
- is run as `bashy --bashsharp checks/acceptance.bsh` (a record install drops the executable bit, §14)

## 7. contract.bsh (the effect cap)

As inspected (§14):
- The shaping verifier takes the union of the `@effects(...)`/`@guard` atoms in the tree's `.bsh`, `.bash` and `.md` files. `contract.bsh` is the conventional place for them; the file name has no special meaning.
- A base with no cap **cannot be verified**: "an uncapped run proves nothing". So field building through `bashy shape` needs a cap.
- A candidate can never raise the base's cap.
- When a shaped app serves an API, a unit that declares no effects runs at read+write.

## 8. UI assets

- `assets/ui/*.html|*.css` are restricted semantic HTML/CSS (D7): no page JS. They are opened directly in a browser or served by the kit.
- `assets/ui/*.json` holds data, such as form definitions.
- Not in the MVP: the `bashy-ui-v1` envelope (Q4) and the exact allowlist (Q2).

## 9. Trusted core

Critical features ship as prebuilt binaries named in `shaped.json` (`server.main` plus a pinned digest). The skill references and verifies the core and never replaces it. Signing and provenance are not in the MVP (follow-on).

## 10. Versions and upgrades

**Four independent versions:**

| Version | Where | Rule |
|---|---|---|
| Spec | `metadata.shapeware` | Same major is readable; unknown keys are ignored |
| App release | git tag = `metadata.version` | Semver. One release, one tag |
| Local variant | `X.Y.Z+shaped.<sha>` | Never a new upstream version |
| Known-issue feed (later) | each entry names the version range it affects | Fast channel; not in the MVP |

**Semver meaning:**
- major: a feature id is removed or renamed, or an acceptance example or data shape changes meaning
- minor: a feature is added, or one moves from tbd to verified
- patch: a known issue is added, worked around or fixed, or docs change

The release class is reported beside the version, never encoded in it.

**Upgrade** (it maps onto the existing `bashy shape` machinery; no new mechanism):
1. A new release appears as an incoming tag, semver-greater than the installed one (`Service.Incoming`).
2. For each local variant: if its feature is now `verified` upstream, drop the variant. Otherwise adopt the release. Adopt fast-forwards when it can, and otherwise does a 3-way merge. On a conflict it parks the variant in `refs/shaping/<slug>/review/…` and leaves the live version unchanged; redo the variant from the feature spec rather than repairing it.
3. Run acceptance. Keep the result only on no FAIL. A local workaround retires when its known issue is `fixed` upstream.
4. Undo returns to the last known good version.

Feature and known-issue ids are the join key between versions. The trusted core changes only with a new upstream release. Not in the MVP: background upgrades, the feed, and user-data migration.

## 11. Defaults (D16)

| Missing | Default |
|---|---|
| `metadata.type` | A plain skill. A shapeware-aware agent may apply all the defaults below. A published release must declare it. |
| `metadata.shapeware` | The current spec version (v0) |
| `metadata.version` | The release git tag, else `0.0.0+<commit>`, else `0.0.0+unversioned` |
| `metadata.min-band`, a feature's `band` | The lowest band: any agent may build a non-critical feature. The checks and the critical rule are the guardrails; an app that wants a higher floor declares one. |
| An agent's own band | The band its operator registered (`bashy agent list`), else the lowest |
| `features.yaml` | No feature claims |
| A feature's `status` | `tbd` |
| A feature's `critical` | `false` |
| A feature's `acceptance` | None, so the feature stays `tbd` |
| `## Known issues` | None |
| A known issue's `status` | `open` |
| A known issue's `cause` | `suspected` |
| A known issue's `expires` | Review at the next release |
| `checks/` | Nothing to run. Declared features stay `tbd` |
| An effect cap | No field building through `bashy shape` (the verifier refuses). Normal running is unaffected |
| `shaped.json` | No trusted core, no wishes |
| `metadata.features` / `checks` / `ui` | `features.yaml` / `checks/acceptance.bsh` / `assets/ui/` |
| `<sha>` in `X.Y.Z+shaped.<sha>` | The git short commit of the change, else the first 7 hex digits of the SHA-256 of the diff |
| `assets/ui/` | No UI face |

## 12. Release class (computed)

The class is computed from `features.yaml` (statuses after defaults), the check lines and the open or workaround known issues. The first match wins:

1. any FAIL line → **blocked**
2. a critical feature that is not verified, or that has an open or workaround known issue → **blocked**
3. no features → **verified (no feature claims)**
4. no verified feature → **requirements release**
5. any tbd → **verified with tbd**
6. any open or workaround known issue → **verified with known issues**
7. otherwise → **verified**

The shapeware skill carries the computation as a short script (Appendix B, `release-class.bsh`). There is no new verb.

## 13. Enabling an existing repo

Any repo can be run by any agent with three additions and no moves:
1. **`SKILL.md` at the root** (§1), with the type line and the standard run block. Its steps name the repo's real run and test commands and link its existing `scripts/`, `assets/` and `docs/`. Everything else is optional (§11): a `features.yaml` can start with the backlog's wanted features as `tbd`, and `checks/acceptance.bsh` can wrap the repo's existing tests. Use the `metadata` path keys where the default names are taken. (Zero-touch alternative: the same files in `skills/<name>/`.)
2. **Discovery.** `bashy skill export <name> --repo` already writes `.agents/skills/` (the vendor-neutral location) and `.claude/skills/` when `.claude` exists. Agents with no skill loader get one line in the files they already read (`AGENTS.md`, `CLAUDE.md`, `README`): "This repo is shapeware: read `SKILL.md` first."
3. **Lint.** Run `lint.bsh` (Appendix B).

A shapeware skill-script that drafts step 1 from a repo (detecting the build and test commands) is a follow-on. Wide detection is not in the MVP.

## 14. What was inspected (2026-11-25)

- `bashy/examples/desk/form/` (`form.bsh` skill face and `metadata` keys, `contract.bsh`, `shaped.json`, `checks/`) and `bashy/examples/shaping/hello-world/`.
- bashy `CLAUDE.md` §Skills (`SKILL.md` is canonical; the record is the wire form).
- yoke, the code behind `bashy shape` and `bashy skill`:
  - **Effect cap:** `pkg/shape/verify/contract.go` (union of `@effects`), `verify.go` (an empty cap is refused; a candidate cannot escalate), `pkg/webconsole/shaped.go` (runtime default read+write).
  - **Skill record:** `pkg/skills/skill.go` parses `name`, `description`, `type`, `compatibility` and `metadata` (as string scalars) and keeps other keys. `record.go`: the record carries every file byte for byte, the record schema itself is strict, and there is no version field. `cli.go`: the name is checked for path safety only, not the skill-format rules. `install.go`: the install directory follows the frontmatter name, `name` and `description` are required, files are written 0644 and symlinks are skipped.
  - **Shaping:** `pkg/shape/service.go` (candidates as directories with a `BaseRev`; approve refuses on a moved base), `pkg/src/activate.go` (`refs/shaping/<slug>/line|named|review`), `restore_sealed.go` and `history.go` (undo to LastKnownGood), `offer.go` (`adopt` merges: fast-forward or 3-way, with a review ref on conflict), `promotion.go` (incoming semver tags).
- Agent Skills format (Anthropic docs, 2026-11-25): the required `name`/`description` rules, the body budget, links one level deep, and runtime differences (the API sandbox has no network).

## 15. Validation (dev box, scratch folders, no product change)

| Check | Result |
|---|---|
| Hello rewritten in the layout (Appendix A); acceptance | 2 PASS, 1 TBD, exit 0 |
| Release class | `verified with tbd`, version 0.1.0 |
| Lint (Appendix B) on hello | all PASS (format, name, description, metadata strings, type line, run block, links and paths) |
| Lint negative case (bad name, numeric metadata) | 3 FAIL, as intended |
| Superset (c): `bashy skill add`, then export `--yaml`, then re-add (isolated HOME) | installed copy and round trip byte-identical |
| Superset (d): plain skill `bashy/skills/bashy` | class `verified (no feature claims)`, version `0.0.0+<commit>`. The lint **fails its frontmatter**: the description holds an unquoted `: `, so it is not strict YAML (finding F1) |
| Upgrade leg: v0.1.0 + local variant (3 PASS), then upstream v0.2.0 | variant dropped (feature verified upstream); v0.2.0 3 PASS, class `verified`; undo to v0.1.0 restores English |
| Unaware agent, run 1 (fresh agent, no shapeware context, only the folder) | Followed `SKILL.md` exactly: runtime check, run, KI-1 matched, checks; **refused to build** because the v0 text defaulted a missing `min-band` to "do not build". It reported five gaps, all fixed in the text above: the step 6 vs rule 6 conflict, `band` vs `min-band`, "your band" undefined, `bashy shape` needing a registered app, and "installed copy" undefined |
| Unaware agent, run 2 (fixed text, fresh agent) | **Built the feature correctly.** Runtime check, run, KI-1, checks (TBD). Band floor: none set, so allowed. `bashy app list`: not registered, so it used the sibling-copy route. It copied to `hello.work/`, added the `es` case, and the copy's checks showed 3 PASS. Only after the PASS did it set `greet-lang` verified, KI-1 fixed and the version `0.1.0+shaped.<sha>`; the installed copy was untouched; it reported the change. Residual points: which `bashy agent list` row is the agent; the `<sha>` when the folder is not a git repo (now in §11); whether a PASS permits record updates (the card's rule 4 now says so explicitly, below) |
| Superset (b): listing in a Claude Code skill root | not run as a separate session; covered by the format lint and the unaware runs |

## 16. Findings and follow-ons (none are 712 work)

| # | Finding | Proposed follow-on |
|---|---|---|
| F1 | `bashy/skills/bashy/SKILL.md` frontmatter is not strict YAML (an unquoted `: ` in `description`); strict skill validators may reject it | bashy todo: quote the description (p3) |
| F2 | bashy skill admission checks only path safety, not the skill-format name rules, and does not require the name to match the folder | Fold into the shapeware lint as a bashy skill-script; whether `bashy skill add` should warn is an operator call |
| F3 | A record install writes files 0644 | Spec rule: always run `bashy --bashsharp <file>`. No change needed |
| F4 | bashy reads a top-level `type`; the open format puts extras under `metadata` | bashy: also read `metadata.type` (small) |
| F5 | `bashy shape` needs a registered app; a plain folder uses the sibling-copy route | The pilot (9643d77f) tests registration of a shapeware folder |
| F6 | Q12 band numbering is still open; the defaults use "lowest band" | Operator decision (Phase 3) |

Not in the MVP: projecting the single `.bsh` into the folder, UI acceptance by role, the `bashy-ui-v1` envelope, signing, the known-issue feed, background upgrades, data migration, and a repo-enable generator.

## Appendix A: the hello example in the v0 layout (as validated)

### hello/SKILL.md

````markdown
---
name: hello
description: Greet someone by name, optionally in their language. Use when asked to say hello or to try a minimal shapeware app.
compatibility: Runs with bashy (pure-Go Bash 5.3 + Bash#); without bashy the steps are guidance only.
metadata:
  type: shapeware
  shapeware: "0"
  version: "0.1.0"
  requires: "has=bashy"
  check-tests: "bashy --bashsharp checks/acceptance.bsh"
---
# hello

Type: shapeware (v0)

## How to run this shapeware app
This skill is an app. It ships source, feature specs, checks and known issues,
and agents may finish or fix it in use. Full rules:
[references/shapeware.md](references/shapeware.md).

1. Check the runtime: run `bashy --version`. Without bashy, read the steps
   and scripts only, and ask the user before installing anything.
2. Run: `bashy --bashsharp scripts/hello.bsh <verb> …` (or `bashy hello …`
   once it is registered). This honours the effect cap in `contract.bsh`.
3. On any failure, stop. Find the symptom under "Known issues" and do the
   listed action. Not listed? Report it (step 7). Never retry blindly.
4. Show: open `assets/ui/card.html` in a browser (plain HTML, no server).
5. Check: `bashy --bashsharp checks/acceptance.bsh`. Read only the
   PASS / FAIL / TBD lines.
6. Build a missing feature (`status: tbd` in `features.yaml`) only when the
   user asks, never when it is `critical: true`, and only if your band meets
   its floor (see the card; unknown band or no floor set: lowest band).
   This folder is the installed copy: never edit it. Copy the whole folder to
   a sibling `<folder>.work/`, change the copy, and run the copy's own
   `checks/acceptance.bsh`. Keep the change only when its lines say PASS,
   then offer it (report, or `bashy shape` if the app is registered).
7. Report: what you ran, the check lines, and the feature or known-issue id.

## Use
- `hello greet [NAME]` prints `Hello, NAME!` (NAME defaults to World).
- `hello greet NAME --lang CODE` greets in another language: feature
  `greet-lang`, status tbd (see `features.yaml`).

## Known issues
- KI-1 [workaround] `--lang` is ignored and the greeting stays English →
  the feature is tbd; build it (step 6) or report it. Do not translate by hand.
  cause: proven (greet-lang not built in 0.1.0)
  bounds: until greet-lang is verified
  forbidden: editing scripts/hello.bsh in place
  expires: next release
  todo: none
````

### hello/references/shapeware.md

````markdown
# Shapeware v0: the agent card

A shapeware app is an Agent Skill that is also an app: it ships its source,
feature specs, checks and known issues, and agents finish or fix it in use.

## Files
- `SKILL.md`: how to use it, plus "Known issues". Frontmatter
  `metadata.type: shapeware`. Only this file is required.
- `scripts/`: what machines run (Bash#, run with `bashy --bashsharp`).
- `features.yaml`: features with `id`, `status` (tbd | verified), `intent`,
  `acceptance` (`command => expected output`), `critical`, `band`.
- `checks/acceptance.bsh`: prints `PASS|FAIL|TBD <feature-id> <example>`;
  exit 1 on any FAIL.
- `contract.bsh`: the effect cap (`@effects("read,...")`).
- `assets/ui/`: plain semantic HTML/CSS pages and JSON data. No page JS.
- `shaped.json`: optional prebuilt server (the trusted core) and wishes.
- Missing files mean: no features, no known issues, nothing to check.
- Paths: `metadata.features`, `metadata.checks` and `metadata.ui` override the
  default paths above (used when the app is a whole repo).

## Statuses
- Feature: `tbd` (specified, not built), `verified` (its checks pass).
  Missing status means `tbd`.
- Known issue: `open`, `workaround`, `fixed`, `expired`.
- Release class (computed, never written by hand):
  all tbd = requirements release; some tbd = verified with tbd;
  a workaround or open issue = verified with known issues; else verified.

## Rules
1. Known issues first: match the symptom, do the listed action.
2. Never retry until green. Stop, find the cause within your budget,
   or record a known issue and report.
3. Never edit the installed copy (the folder you were given). Copy the whole
   folder to a sibling `<folder>.work/` and change the copy; its own checks
   test it. Registered apps (`bashy app add --type shaped`) use `bashy shape`
   instead: wish, verify, approve; undo returns the previous version.
4. Only a passing check makes a feature `verified` or an issue `fixed`.
   After a PASS, update the copy's own records: `features.yaml` status, the
   known issue's status, and `metadata.version` as `VERSION+shaped.<sha>`
   (git short commit, else 7 hex of the SHA-256 of the diff). Then offer
   the copy: report it; the user or owner decides whether to adopt it.
5. Never build or change a feature marked `critical: true`.
6. Band floor: the app may set `metadata.min-band`; a feature may raise it
   with `band:`. The floor for a feature is the higher of the two. Missing
   both: the lowest band, so any agent may build it. Your band is the one
   your operator registered for you (`bashy agent list`); unknown means the
   lowest band. Below the floor: do not build; report the request.
7. Versions: `metadata.version` is the release (semver). A local change is
   `VERSION+shaped.<sha>`, never a new release. On upgrade, drop local
   changes whose feature is now verified; re-apply the rest as shaped
   candidates and keep them only if checks pass.
````

### hello/features.yaml

````yaml
# hello feature list (shapeware v0). Ids are stable across versions.
- id: greet
  status: verified
  intent: Anyone running hello sees a friendly greeting.
  acceptance:
    - hello greet => Hello, World!
    - hello greet Ada => Hello, Ada!
- id: greet-lang
  status: tbd
  intent: A user can ask for the greeting in their own language.
  acceptance:
    - hello greet Ada --lang es => ¡Hola, Ada!
````

### hello/scripts/hello.bsh

````bash
#!/usr/bin/env -S bashy --bashsharp
# hello: the script face of the hello shapeware app.
greet() {
  local name=${1:-World} lang=en
  [[ ${2:-} == --lang ]] && lang=${3:-en}
  case $lang in
    *) echo "Hello, $name!" ;;
  esac
}
case "${1:-}" in
  greet) greet "${2:-}" "${3:-}" "${4:-}" ;;
  *) echo "usage: hello greet [NAME] [--lang CODE]" >&2; exit 2 ;;
esac
````

### hello/checks/acceptance.bsh

````bash
# Acceptance for hello (shapeware v0 checks contract).
# Runs every acceptance example in features.yaml against scripts/hello.bsh.
# Prints one line per example: PASS|FAIL|TBD <feature-id> <example>.
# A verified feature that does not pass is FAIL; a tbd one is TBD.
# Exit status: 1 if any FAIL, else 0.
set -u
root=$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)
fail=0 id='' status=''
while IFS= read -r line; do
  case $line in
    '- id: '*) id=${line#- id: } ;;
    '  status: '*) status=${line#  status: } ;;
    '    - '*'=>'*)
      ex=${line#    - }
      cmd=${ex%% =>*}; want=${ex#*=> }
      read -r -a argv <<< "${cmd#hello }"
      got=$(bashy --bashsharp "$root/scripts/hello.bsh" "${argv[@]}" 2>/dev/null)
      if [[ $got == "$want" ]]; then echo "PASS $id $ex"
      elif [[ $status == tbd ]]; then echo "TBD $id $ex"
      else echo "FAIL $id $ex (got: ${got:-<error>})"; fail=1; fi ;;
  esac
done < "$root/features.yaml"
exit $fail
````

### hello/contract.bsh

````bash
# Shaping contract: the effect cap the checks run under. hello only reads.
@effects("read,exec")
````

### hello/assets/ui/card.html

````html
<!doctype html>
<html lang="en">
<head><meta charset="utf-8"><title>hello</title></head>
<body>
<main>
  <h1>Hello, World!</h1>
  <p>This page is the <strong>ui face</strong> of the hello shapeware app.</p>
</main>
</body>
</html>
````

## Appendix B: shapeware skill-scripts (drafts, as validated)

### lint.bsh

````bash
# shapeware lint (v0): is DIR a valid Agent Skill, and a well-formed shapeware app?
# Prints one line per check: PASS|FAIL <check> [detail]. Exit 1 on any FAIL.
set -u
dir=$(cd "${1:-.}" && pwd); fail=0
ok()  { echo "PASS $1"; }
bad() { echo "FAIL $1 ${2:-}"; fail=1; }
[[ -f $dir/SKILL.md ]] || { bad skill-md "no SKILL.md"; exit 1; }
fm=$(awk 'NR==1&&/^---$/{f=1;next} f&&/^---$/{exit} f' "$dir/SKILL.md" | lens -f yaml -t json 2>/dev/null)
[[ -n $fm ]] && ok frontmatter || { bad frontmatter "missing or not YAML"; exit 1; }
# Agent Skill rules
extra=$(jq -r 'keys[] | select(IN("name","description","license","compatibility","metadata","allowed-tools")|not)' <<<"$fm")
[[ -z $extra ]] && ok top-level-keys || bad top-level-keys "unknown: $(echo $extra)"
name=$(jq -r '.name // ""' <<<"$fm")
[[ $name =~ ^[a-z0-9]+(-[a-z0-9]+)*$ && ${#name} -le 64 ]] && ok name-format || bad name-format "'$name'"
[[ $name == "$(basename "$dir")" ]] && ok name-matches-dir || bad name-matches-dir "'$name' vs '$(basename "$dir")'"
[[ $name == *anthropic* || $name == *claude* ]] && bad name-reserved "$name" || ok name-reserved
desc=$(jq -r '.description // ""' <<<"$fm")
[[ -n $desc && ${#desc} -le 1024 && $desc != *'<'* ]] && ok description || bad description "empty, >1024 or has tags"
nonstr=$(jq -r '(.metadata // {}) | to_entries[] | select(.value|type!="string") | .key' <<<"$fm")
[[ -z $nonstr ]] && ok metadata-strings || bad metadata-strings "$(echo $nonstr)"
# Shapeware rules (only when declared; D16: otherwise a plain skill)
type=$(jq -r '.metadata.type // ""' <<<"$fm")
if [[ $type != shapeware ]]; then echo "INFO plain skill (no metadata.type: shapeware); shapeware defaults apply"; exit $fail; fi
body=$(awk 'NR==1&&/^---$/{f=1;next} f==1&&/^---$/{f=2;next} f==2' "$dir/SKILL.md")
grep -q '^Type: shapeware' <<<"$body" && ok type-line || bad type-line "body lacks 'Type: shapeware'"
grep -q '^## How to run this shapeware app' <<<"$body" && ok run-block || bad run-block "standard block missing"
while IFS= read -r link; do
  [[ $link == http* ]] && continue
  [[ -e $dir/$link ]] && ok "link $link" || bad "link $link" "does not resolve"
done < <(grep -o '\]([^)#]*)' <<<"$body" | sed 's/^](//; s/)$//')
while IFS= read -r p; do
  [[ -e $dir/$p ]] && ok "path $p" || bad "path $p" "named in the run block but missing"
done < <(grep -oE '(scripts|checks|assets|references)/[A-Za-z0-9._/<>-]+' <<<"$body" | grep -v '[<>]' | sort -u)
exit $fail
````

### release-class.bsh

````bash
# shapeware release class (v0): computed, never written by hand.
# Usage: release-class.bsh DIR   (runs DIR/checks/acceptance.bsh when present)
# Prints: class: <class> / version / counts / blockers, one per line.
set -u
dir=$(cd "${1:-.}" && pwd)
ver=$(awk 'NR==1&&/^---$/{f=1;next} f&&/^---$/{exit} f' "$dir/SKILL.md" | lens -f yaml -t json 2>/dev/null | jq -r '.metadata.version // ""')
# D16 default: the git tag, else 0.0.0+<commit>, else 0.0.0+unversioned
[[ -z $ver ]] && ver=$(git -C "$dir" describe --tags --exact-match 2>/dev/null || { c=$(git -C "$dir" rev-parse --short HEAD 2>/dev/null) && echo "0.0.0+$c"; } || echo "0.0.0+unversioned")
meta() { awk 'NR==1&&/^---$/{f=1;next} f&&/^---$/{exit} f' "$dir/SKILL.md" | lens -f yaml -t json 2>/dev/null | jq -r ".metadata.\"$1\" // \"$2\""; }
feat=$dir/$(meta features features.yaml); chk=$dir/$(meta checks checks/acceptance.bsh)
tbd=0 ver_ok=0 crit_bad='' 
if [[ -f $feat ]]; then
  # D16 defaults: status tbd, critical false
  while IFS=$'\t' read -r id status critical; do
    [[ $status == verified ]] && ver_ok=$((ver_ok+1)) || tbd=$((tbd+1))
    [[ $critical == true && $status != verified ]] && crit_bad+=" $id(not verified)"
  done < <(lens -f yaml -t json < "$feat" 2>/dev/null | jq -r '.[] | [.id, (.status // "tbd"), ((.critical // false)|tostring)] | @tsv')
fi
fails=0
[[ -f $chk ]] && fails=$(bashy --bashsharp "$chk" 2>/dev/null | grep -c '^FAIL' || true)
ki=$(grep -cE '^- KI-[0-9]+ \[(open|workaround)\]' "$dir/SKILL.md" || true)
crit_ki=''
[[ -f $feat ]] && crit_ki=$(lens -f yaml -t json < "$feat" 2>/dev/null 2>/dev/null | jq -r '.[] | select(.critical==true) | .id' | while read -r c; do grep -qE "^- KI-[0-9]+ \[(open|workaround)\].*\b$c\b" "$dir/SKILL.md" && echo "$c"; done)
if (( fails > 0 )); then class="blocked (FAIL lines: $fails)"
elif [[ -n $crit_bad || -n $crit_ki ]]; then class="blocked (critical:$crit_bad $crit_ki)"
elif (( ver_ok == 0 && tbd == 0 )); then class="verified (no feature claims)"
elif (( ver_ok == 0 )); then class="requirements release"
elif (( tbd > 0 )); then class="verified with tbd"
elif (( ki > 0 )); then class="verified with known issues"
else class=verified; fi
printf 'class: %s\nversion: %s\nfeatures: %d verified, %d tbd\nknown issues open/workaround: %d\n' "$class" "$ver" "$ver_ok" "$tbd" "$ki"
````

