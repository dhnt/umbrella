# Sprint 712 exploration record (2026-11-25): shapeware, the SDLC for the agent era

Status: **exploration, not final.** The operator will revisit and finalize after this session.

- Sprint: 712 (fccece26), story b35b89620f88.
- The story holds the question, the operator review, the decisions and the `shapeware` skill draft (v0, with the release spectrum and critical features).
- This document keeps the full discussion, the experiments and their sources, so the work can be resumed without the session.

## How to resume

1. Read story b35b89620f88: the thesis, the decisions and the skill draft.
2. Read §3 Decisions and §6 Open questions below.
3. Use the pilot todo bashy `9643d77f` (two cases plus addenda a–d) for the first hands-on work. Treat the experiments in §4 as prior evidence, not acceptance.

## 1. How the discussion went

1. **Review of the sprint notes.** I first read 712 as a delivery sprint and proposed cutting it down. The operator corrected me: 712 explores where software shaping must head, given the recurring field issues of 11-24/25:
   - #3230: a first-navigation timing abort
   - D1: an embedded adapter that cannot build on a fresh HOME
   - H6: an environment-variable binding that the fakes masked

   All three passed the sandbox e2e with fakes and failed somewhere real. Under the no-HUAT rule, every user's daily session is where this class of failure is found.
2. **Operator form review.** All 7 points agreed, and the operator added the **reverse-SDLC thesis**:
   - Features ship as Bash# source plus specs and skill-scripts, including UI as a spec.
   - Hard bugs are documented in Bash# skills so runtime agents handle them: "fix then use", not "fix then ship".
   - Features not yet built ship as TBD specs that agents implement on the fly.
   - Acceptance happens in the field, after automated tests with fake users.
3. **Name.** "shapeware" for the new layer: hardware → firmware → software → shapeware (Bash#). The GitHub org `shapeware` was created the same day.
   - It is a **category word** (like firmware or middleware), not a brand, and is not to be registered. The brands stay dhnt, bashy and Tessaro.
   - Prior art: Shapeware Corporation (1992–95) became Visio. Before public use, confirm that its old USPTO filings are dead.
   - Rejected: liveware (already means people), wetware (brains and biology), liquidware (existing vendor), clayware and plasticware (ordinary words), specware (Kestrel's formal-methods tool). fluidware was the softness-scale alternative.
4. **Anatomy of a shapeware feature.** `bashy/examples/desk/form` already ships most of it:
   - `form.bsh`: the skill face and the executable in one body
   - `contract.bsh`: an effects cap
   - `checks/`: acceptance
   - `shaped.json`: genie wishes
   - a prebuilt Go server: the trusted core

   Missing: a known-issue block and TBD features, both inside the same body.
5. **UI as a face.** Bash# already has the HTML `<video>` analogue. The `ui` tag needed no change to Bash#; any language tag works with a runner.
   - Inline: `~~~ui as NAME !RUNNER … ~~~`
   - By reference: `embed ui "./FILE" as NAME !RUNNER`

   UI is the human face of the coin: the script is for machines, the skill for agents, and the UI for eyes (later audio for ears).
6. **CLI ↔ serve contract.** The desk kit routes are already the de facto standard:
   - `POST /api/action` with a `{"action":VERB,…}` body
   - `GET /api/state`
   - `GET /api/export`
   - `GET /api/events`

   They are covered by the existing kit contract test. Name it `bashy-ui-v1`.
7. **Hello-world SDLC walkthrough** (§4.2): spec → build → test → release → deploy → field shaping → undo → upstream, on a scratch repo.
8. **Mesh with the web, don't replace it.** The companion-file model: an existing web app keeps its HTML and gains a `.bsh` beside it, like `.d.ts` beside `.js`. Other patterns are future input:
   - a view override fence
   - a `<bashy-face>` web component
   - the wire as the integration point for any framework
   - the Shape button reading the companion
9. **HTML is one representation.** A UI spec defines how content is presented to the human senses (visual, audio). The two-sense experiment (§4.3) showed that an invented YAML presentation vocabulary falls short at once.
10. **No reinventing the wheel (operator).**
    - The UI spec is a **restricted profile of semantic HTML/CSS**: like Bash# relative to bash, it keeps the host ecosystem working, though it is a subset where Bash# is a superset.
    - Semantic HTML plus CSS (`@media speech`) already defines salience, order, grouping, summary/detail, state and speech pacing.
    - **Not either/or (operator):** the converter path stays beside restricted HTML.
    - The spec can bundle any well-known language, in parts: md, html, css, json/yaml, ts.
11. **The glue is a skill.** The classic SDLC adapted for agents comes down to rules, the `shapeware` skill draft. It has no new tools.
12. **Iterative releases (operator).** A release can be anything from user requirements only to a fully built app (the release spectrum), with critical features always verified and prebuilt.
13. **Band level (operator).** Agent capability becomes critical too: the band ladder's "a band is a floor" rule applies to field building, so shipped apps keep a consistent look and feel (D12).
14. **QA for the reverse SDLC (operator).** Shaping only works if skills and scripts work for low-end models, preferably local through `bashy ollama`. The skill draft gains "Write for the low end" (D13).
15. **Back to skills (operator).** Shapeware returns to where Agent Skills started: every new shapeware release can be a skill. Shapeware is a skill with a contract (D14).

## 2. The model in one page

- **Artifact:** one `.bsh` body (or an app plus a companion `.bsh`) with faces in standard languages:
  - script: Bash#
  - skill: Markdown, plus Known issues
  - features: YAML (id, status, intent, acceptance, `critical`)
  - ui: restricted HTML/CSS, JSON/YAML for data, TS for logic
- **Delivery channels:**
  - train-frozen code
  - a signed known-issue data feed (symptom signatures, workarounds, hints)
  - local shaped variants

  Opt-in installations form a network: field fixes reach users with the same symptom and return upstream as reproduction tests.
- **Field shaping loop** (was "HUAT"): the user's agent is the tester and first responder.
  - Root-cause discipline applies in the field.
  - Effort is bounded by a budget.
  - Each outcome is classified.
  - Retrying until green is never allowed.
- **Statuses:**
  - feature: `tbd`, `verified`
  - known issue: `open`, `workaround`, `fixed`, `expired`
  - release class, computed: requirements release, verified with tbd, verified with known issues, verified
- **Critical features** (auth, payments, sandbox, destructive or irreversible, regulated): never `tbd`, never field-built, and they block the release while a known issue is open.
- **UI rendering, two paths that meet in the same restricted HTML:**
  - direct: the restricted HTML is served as-is, and audio walks the semantic page with speech CSS
  - converter: `lens -f bsh -t md` plus the kit/render `feature`/`ui` renderers, for data faces, raw views and non-browser representations (Markdown/PDF, terminal, MCP elicitation, audio)
- **Rendering is not running:** a view never executes runners.
- **Packaging:** a release is a skill folder with shapeware metadata; there is no new format (D14).
- **Low-end QA:** skills and scripts must work for small local models (`bashy ollama`); evaluated with a fixed task pack on the gate host.
- **Band floor:** field building needs an agent at or above the app's or feature's minimum band; otherwise route up or don't build.
- **Safety:** field changes go through `bashy shape` (wish → candidate → verify → preview → approve → undo), never by editing deployed source.

## 3. Decisions (operator, 2026-11-25)

| # | Decision |
|---|---|
| D1 | All 7 review points agreed; the reverse-SDLC thesis recorded; KISS/MVP (the rod, not a framework) |
| D2 | Name: shapeware; GitHub org taken; category word, no trademark registration |
| D3 | Known issues are written inside the `.bsh` body, not in a separate file |
| D4 | The form pilot is 712's case (iii), run as follow-on todo `9643d77f` (712 itself stays plan-only) |
| D5 | UI is a face; JSON/YAML/HTML are the default "fish"; a standard CLI↔serve format is needed now (`bashy-ui-v1`) |
| D6 | The pilot adds case 2: a companion `.bsh` on an existing web app (`examples/shaping/hello-world`) |
| D7 | No reinventing the wheel: the UI spec is restricted semantic HTML/CSS; a spec may bundle md/html/css/json/yaml/ts |
| D8 | The converter stays: restricted HTML and the converter, not either/or |
| D9 | The glue is a skill (the `shapeware` skill draft), recorded on 712 |
| D10 | Release spectrum (requirements … traditional) and critical features added to the skill |
| D11 | Revisit and finalize after this session |
| D12 | Band floor: the app declares a minimum agent band for field building (`min-band`; per-feature `band:` may raise it), so shipped shapeware keeps a consistent look, feel and quality. Below the floor: route to the cheapest qualified agent (own fleet or pooled), else don't build. Consistency = constraints + checks + band floor together. Critical features are never field-built at any band. |
| D13 | QA for the reverse SDLC: skills and scripts are the thing under test and must work for low-end models, preferably local through `bashy ollama`. Reasoning goes into scripts with structured output; the skill is short imperative steps, symptom → action known issues and PASS/FAIL/TBD acceptance. A fixed task pack runs on the gate host (never the dev box), and a drop in low-end success is a regression. The same pack on larger models sets the band floor. |
| D14 | Packaging: a shapeware release is a skill folder (`SKILL.md` + `scripts/*.bsh` + UI assets + `checks/` and the feature list + frontmatter `metadata:` for release class, `min-band` and critical); "shapeware is a skill with a contract". It uses existing skill channels, with no new format. A plain skill does not give trust (signing, effect caps, provenance), the prebuilt trusted core, or the shaping lifecycle; shapeware still requires them. Refined by D15: a superset of an Agent Skill folder. |
| D15 | Superset (operator, plan session): a shapeware app folder is a superset of an Anthropic Agent Skill folder. Every shapeware release is a valid Agent Skill, which any skills loader (Claude Code, claude.ai upload, the Skills API, `bashy skill add`) takes unchanged and ignores what it does not know. Shapeware adds things only as frontmatter `metadata` entries (string values) and extra files; it uses the standard `scripts/`, `assets/` and `references/` directories where they fit. |
| D16 | Defaults (operator): when part of the spec is missing, documented defaults apply. Only `SKILL.md` is required; every shapeware part is optional, and the defaults are the safe or no-claim values (for example, a feature defaults to `tbd`, `critical` defaults to `false`, and with no features there are no feature claims). |
| D17 | Self-describing (operator): `SKILL.md` teaches any agent, including agents that know nothing of shapeware, (1) the type, as `metadata.type: shapeware` plus a body line `Type: shapeware (v0)`, and (2) how to run shapeware the right way, in a fixed standard block that links a bundled `references/shapeware.md`. So with no extra advertisement, any current agent can run, check, show and build the app. |
| D18 | Layout and repos (operator, spec session): one layout serves both the repo and the skill. The skill directory names (`scripts/`, `assets/`, `references/`) are defaults whose meanings repos already use; the shapeware parts have default paths with `metadata` path keys for repos where those names are taken; the repo root can be the skill folder, with `skills/<name>/` as the zero-touch alternative. So any repo is potential shapeware: one root `SKILL.md` makes it actual. Spec: `docs/shapeware-spec-v0.md`. |

## 4. Experiments and evidence

All ran on the dev box with the installed bashy and scratch files only. No product code changed.

### 4.1 UI fence validation
- **Inline:** a Bash# script with `~~~ui as intake !form_ui` (a JSON form definition) produced a live loopback form through a shell-function runner adapter over `form.bsh`.
- **By reference:** `embed ui "./contact.json" as contact !form_ui` resolved the same way (`BASHPP_FENCE_TYPE=ui`).
- **Gaps:**
  - The adapter is needed because `form` expects `add --def FILE` (todo `64ef2626`).
  - The fence materializes as `fence.ui`, and `form` picks its format by extension, so `bashy-ui-v1` should detect the format from the content.

### 4.2 Hello-world SDLC walkthrough
The source is in Appendix A: `hello.bsh` with four faces, plus `checks/acceptance.bsh`.

| Stage | What happened |
|---|---|
| Spec | `greet` verified; `greet-lang` tbd (`hello greet Ada --lang es` should give `¡Hola, Ada!`) |
| Build | project the faces (`--skill`, `--feature`); nothing to compile |
| Test | acceptance: 2 PASS, 1 TBD; verified must pass, tbd is reported, not failed |
| Release | tag `v0.1.0`, class "verified with tbd", notes generated from the feature statuses |
| Deploy | `bashy commands add hello` + `bashy skill add`; `bashy hello greet Ada` works; `bashy skill show hello` gives the guide |
| UI | `hello card Ada` showed the greeting as a desk viewer page |
| Field | Spanish requested, still TBD; the runtime agent implemented it on a `shaped/local` branch; acceptance 3/3; known issue KI-1 (viewer discovery) recorded in the body |
| Undo | switching back to the release restored the old behaviour |
| Upstream | fast-forward merge, tag `v0.2.0` |

Findings:
1. **One alias per language per file**, so all specs go in one `~~~feature` list.
2. **A fence without a runner must be a language Bash# already knows**, so `feature`/`ui` need runners or built-in registration.
3. **Face projection is hand-rolled** in each script (`form.bsh`, `hello.bsh`) and should use the parser.
4. **KI-1:** the viewer could not be discovered when it had been started by hand. The workaround was to set `VIEWER_ADDR`/`VIEWER_DATA`.
5. **No approve step.** The deployed command pointed at the working tree, so a field edit went live with no approval. The real path is the `bashy shape` lifecycle.

### 4.3 Two-sense experiment
Run by a delegated agent; the spec and mapping are in Appendix B.
- **Result:** one spec gave a visual page (primary → heading, secondary → paragraph) and an audio file (macOS `say -o`, 4.4 s, emphasis and a pause).
- **Gaps in the invented YAML vocabulary:**
  - `size` has no audio meaning
  - order was only a renderer convention
  - only one emphasis level
  - the speaking rate was hard-coded
  - "pause 500 ms" was ambiguous: it measured about 0.3 s, because `say` replaces the natural gap rather than adding to it
  - the `{{name}}` placeholder had no binding in the spec

  Semantic HTML plus CSS already defines each of these, which led to D7.

### 4.4 Which languages Bash# accepts as fences
Tested with the installed bashy:
- `js` is accepted.
- `ts` is accepted **and type-checked**: a bad body failed with "Cannot find name 'hello'".
- `md`, `markdown`, `html`, `css`, `json`, `yaml` and `jsonschema` are rejected ("unsupported language") unless a runner is given.

Options:
1. Use runners now (`~~~html as view !ui`); no engine change.
2. Later, make them built-in text fences like `~~~skill`/`~~~dockerfile`. That is an `sh` engine change, which is frozen to bug fixes only, so it needs operator approval.

## 5. Filed and changed during the session

| Item | Where |
|---|---|
| Story b35b89620f88: operator review, decisions, the `shapeware` skill draft (v0 + spectrum + critical) | umbrella `docs/todo` (ca4be8b17, c0748b78d, b80b2c30c, 765992bb6) |
| Pilot `9643d77f` (p2 spike): case 1 form, case 2 web-app companion, addenda a–d | bashy `docs/todo` (de99eaa0 … bd47b043) |
| `64ef2626` (p2 bug): the form registration declares positionals but no flags, so every flag is rejected (`examples/desk/form/register.sh`; `chart` has the same pattern) | bashy |
| `9ab67520` (p3 bug): `bashy serve --help` takes `--help` as the socket path and starts the server (`internal/agentos/agentos.go`, `case "serve"`) | bashy |
| `c28b0669` (p3 bug): a registered command can point into a deleted weave workspace (the stale `notepad` on the dev box: wrong path, old verb set) | bashy |
| `f571c624` (p3 bug): the copy sheet would not copy a field a second time; root cause not yet identified | yoke |
| GitHub org `shapeware` (empty) | GitHub |

## 6. Open questions for finalization

1. Accept the `shapeware` skill (story b35b89620f88) as v1? Where does it ship: an embedded skill face plus a kb runbook?
2. The restricted-HTML profile: the exact element/attribute allowlist and which CSS properties are allowed; how much the kit's bluemonday policy and CSP already cover.
3. Built-in text fences for md/html/css/json/yaml: request the `sh` engine change, or stay with runners?
4. `bashy-ui-v1`: the document envelope (content schema + presentation) and the wire, written down in the form README and covered by the kit contract test.
5. MCP elicitation as a UI representation: none exists in bashy/yoke today.
6. The known-issue lifecycle: the `bashy todo` status for "known, worked around, tracked until expiry" (#3230 is the first case), and the signed known-issue feed.
7. The field network: how opt-in installations share signatures and workarounds, and how field fixes return upstream.
8. Cost model: who pays the tokens for TBD features built at first use, and the budgets for field root-causing.
9. The trademark sanity check on the 1992–95 Shapeware filings before public use of the word.
10. Pilot owner and venue: browser-driving acceptance runs on the gate host, never the dev box.
11. A **shapeware certificate pack** in agent-bench: can an agent implement a tbd UI feature within the restricted profile and kit tokens, and pass acceptance, within a budget? This would be the measured gate behind `min-band`.
12. **Reconcile the band numbering** before shapeware declares bands:
    - `bashy/docs/band-ladder.md` has L1 QA, L2 coding, L3 conductor, L4 steward.
    - `bashy sprint assign --band` takes 3–5.
    - The 2026-11-20 operator ruling uses L4 for managing a sprint and L5 for managing managers.
13. **Low-end evaluation pack:**
    - which small local models are the target
    - the task pack contents and scoring
    - where it lives (agent-bench)
    - the gate-host venue
    - whether skill and script changes must pass it before release

## Appendix A: hello-world walkthrough source (v0.2.0)

### hello.bsh

````bash
#!/usr/bin/env -S bashy --bashsharp
# hello: a shapeware Hello World. One Bash# body, four faces:
# script (machines), skill (agents), ui (human eyes), feature specs (acceptance).

~~~skill as guide
---
name: hello
description: Greet someone, as text or as a page for human eyes. Use when asked to say hello.
---
# hello
- `hello greet [NAME]` prints `Hello, NAME!` (NAME defaults to World).
- `hello card [NAME]` shows the greeting as a page in the desk viewer and prints its URL.
- `hello features` lists the feature specs and their status (verified / tbd).

## Known issues
- KI-1 (workaround active, expires on fix): `hello card` fails with
  "cannot discover viewer" when the viewer server was started by hand, not
  from the console. Workaround: set VIEWER_ADDR and VIEWER_DATA from the
  running viewer process (`ps` shows --addr/--dir). Do not retry blindly.
~~~

# The feature runner: answers questions about the specs in the feature face.
feature_spec() {
  case "$1" in
    methods) printf '%s\n' '{"name":"status"}' '{"name":"examples"}' ;;
    status) awk '/^- id:/{id=$3} /^  status:/{print id"\t"$2}' "$2" ;;
    examples) awk -v want="${3:-}" '/^- id:/{id=$3} /=>/{ if (want=="" || want==id) { sub(/^ +/,""); print id"\t"$0 } }' "$2" ;;
  esac
}

~~~feature as features !feature_spec
- id: greet
  status: verified
  intent: Anyone running hello sees a friendly greeting.
  acceptance:
    hello greet       => Hello, World!
    hello greet Ada   => Hello, Ada!
- id: greet-lang
  status: verified
  intent: A user can ask for the greeting in their own language.
  acceptance:
    hello greet Ada --lang es   => ¡Hola, Ada!
~~~

# The ui runner: renders the ui face with the desk viewer (the default "fish").
viewer_ui() {
  case "$1" in
    methods) printf '%s\n' '{"name":"show","effect":"world"}' ;;
    show)
      local name=${3:-World} md="$2.md"
      sed "s/{{name}}/$name/g" "$2" > "$md"
      bashy viewer add "hello-$(date +%s)" -f "$md" 2>/dev/null | head -1 ;;
  esac
}

~~~ui as card !viewer_ui
# Hello, {{name}}!

This greeting is the **ui face** of `hello.bsh`: one Bash# body that is also a
script for machines and a skill for agents.
~~~

greet() {
  local name=${1:-World} lang=en
  [[ ${2:-} == --lang ]] && lang=${3:-en}
  case $lang in
    es) echo "¡Hola, $name!" ;;
    *)  echo "Hello, $name!" ;;
  esac
}

case "${1:-}" in
  --skill|--ui|--feature)
    face=${1#--}; copying=false
    while IFS= read -r line; do
      if [[ $line == "~~~$face as "* ]]; then copying=true; continue; fi
      if [[ $copying == true && $line == '~~~' ]]; then break; fi
      if [[ $copying == true ]]; then printf '%s\n' "$line"; fi
    done < "${BASH_SOURCE[0]}" ;;
  greet) greet "${2:-}" "${3:-}" "${4:-}" ;;
  card) u := card.show("${2:-World}"); echo "$u" ;;
  features) st := features.status(); echo "$st" ;;
  *) echo "usage: hello greet|card|features [NAME]" >&2; exit 2 ;;
esac
````

### checks/acceptance.bsh

````bash
# Acceptance: run every feature spec's examples against hello.bsh.
# verified features must pass; tbd features are reported, not failed.
set -u
h="bashy --bashsharp ${HELLO_BSH:-./hello.bsh}"
fail=0
check() { # status cmd... => expected
  local status=$1 want=$2; shift 2
  local got; got=$($h "$@" 2>/dev/null)
  if [ "$got" = "$want" ]; then echo "PASS [$status] hello $* => $got"
  elif [ "$status" = tbd ]; then echo "TBD  [$status] hello $* (got: ${got:-<error>})"
  else echo "FAIL [$status] hello $* => $got (want $want)"; fail=1; fi
}
check verified 'Hello, World!' greet
check verified 'Hello, Ada!' greet Ada
check verified '¡Hola, Ada!' greet Ada --lang es
exit $fail
````

## Appendix B: two-sense experiment

### card.yaml (the spec)

````yaml
content:
  greeting: "Hello, {{name}}!"
  note: "This greeting is the ui face of hello.bsh."
present:
  greeting: {salience: primary}
  note:     {salience: secondary, after: greeting}
  visual:
    greeting: {size: xl}
  audio:
    greeting: {pause_after: 500ms}
````

### Text sent to say (audio rendering)

````text
[[emph +]]Hello, Ada![[emph -]] [[slnc 500]] [[rate 160]]This greeting is the ui face of hello.bsh.

````

### Mapping

| intent term | visual (render-visual -> Markdown -> desk viewer) | audio (render-audio -> `say -o` AIFF) |
|---|---|---|
| salience: primary | heading (level from size; default `##`) | spoken first, `[[emph +]]...[[emph -]]` |
| salience: secondary | plain paragraph | normal emphasis, `[[rate 160]]` (slightly slower) |
| after: X | placed below X in document order | spoken after X in time order |
| visual.size: xl | `#` (h1) | ignored (visual-only) |
| audio.pause_after: 500ms | ignored (audio-only) | `[[slnc 500]]` after the item |

## Appendix C: operator review answers (verbatim)
The operator's answers to the 2026-11-25 review form, copied word for word, including the original wording and typos. Each heading summarizes the reviewer's point; the full points are in §1 and on story b35b89620f88.

**0. Premise (field issues found in daily use; design the loop on purpose)**

- Choice: agree

````text
paradigm shift. instead of ask user testing pre release, users "test" and use during working sessions, shape/fix it if error found with the well designed software shaping feature including but not limited to comment/instructions in bash# skill-script format that would help runtime agent to perform the same impelementation/but fixing process/life cycle during traditional uat tests
````

**1. Start from failure classes, not pillars**

- Choice: agree

````text
again. rod/not fish, rod is more important as it is impossible to enumerate all possible cases on the field.
````

**2. Drop the name HUAT from section A**

- Choice: field shaping loop

````text
regarding huat, I just wanted to stress in the traditional testing metodologhy . most likely it will be agent no longer human for bashy software shaping enabled apps.
````

**3. Three delivery channels at different speeds**

- Choice: agree

````text
and also layered. the IT industry has gone through these cycles. now a new one. we should coin a new word for it. that is:
hardware: machine code
firmware: aseembly langguage
software: c/c++.... bash
X-ware: bash#
liveware, shapeware, liquidware... recommendations
````

**4. Root-cause discipline in the field**

- Choice: agree

````text
we had same problem during development time. so the effort should always be bounded by budget/time or other creteria. and solution/resolution classified. e.g verfied (default) there a feature is shipped but with bugs idendify so the runtime agent where the feature stands and take from there when needed all should be using the same common unified language bash# skill/script.
````

**5. Feed field fixes back to everyone (N:N)**

- Choice: agree

````text
good idea. all bashy opt-in  installations become a network/matrix that could benefit each other no traditional software applications could match
````

**6. Explicit known-issue state; #3230 as the test case**

- Choice: new explicit known-issue state (reopen #3230 into it)

````text
again rod/not fish. philosophy
````

**7. Keep section D and plan-only acceptance**

- Choice: agree

**Next step**

- Choice: record agreed points on story b35b89620f88 + sprint 712 thread

**Anything missing from the paradigm?**

````text
many of the traditional SDLC problems could be solved easily in a reverse order with the support software shaping feature. here are my thoughts for your information:
1) feature: traditionally, it is compiled into binary after long testing cycles and yet hard to meet the varying requirements of end users. new paradigm: ship in source code (bash#), the users requirement in specs written in bash# skill-script. we should explore more for this topic as especially important to UI applications. why ship in js/html/css/typescript? why not in spec/skill since all entry level LLM  agents could easily handle a spec and show the ui?
2) bug - hard to catch and only happen on certain dictions. instead of fixing them, document in bash# skill so agents could easily handle them without having to "fix" it - same way if found, by the agents during development. fix then use (instead of fix then ship)
3) mvp - not designed feature have to be done and some may bloat the release most of users donot need - ship as spec or simply (TBD - not implemeneted with instructions/specs to run agents which could implement on the fly)
4) e2e uat - cumbersome, slow, requiring human users - just ship after auto/fake user tests, let the real users acceptance happen on the field. failed? fine, runtime agent take care of it/fix it so long the errors are expected and sufficient instructions/specs for the agent to handle it.
5) many other cases, we could "reverse" the sdlc processes. all of the above "software shaping" could provide the machinery to help the runtime agents in the field after applcation release.  
````
