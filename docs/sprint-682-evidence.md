# Sprint 682 evidence

Wire-level evidence for the closure of Sprint 682 (consumer-shaping example
apps). Hosts by role only. Plan: `sprint-682-master-execution-plan.md`.
Story record of truth: C4 `8e5204e127c4` in the bashy story store.

## Accepted stories (11-21, 11-23)

| Story | Delivery | Verified by |
|---|---|---|
| C1 viewer and chart shaped | bashy `a156c7a4`, `acb83615` | conductor rerun 11-21 |
| C1b `app show --runtime` | yoke `299a502d`, bashy `acb83615` | conductor rerun 11-21 |
| C2 session shaped | bashy `29537381` | conductor rerun 11-21 |
| C3 genie.examples, whiteboard path | bashy `6f41b85f` | conductor rerun 11-21 |
| keychain | yoke `97fd8985`, bashy `9af6b6ba` | conductor rerun 11-21 |
| C4b C4 fixes landed | yoke `be872cc5`, bashy `0605b1ec` (framing, Node 18/ws helper `93fed833`, bounded screenshot) | conductor 11-23: both on main, inside the pins |
| C4c Genie receiver half | ycode `5323b1b` (cherry-pick of `40b5066`), bashy pin `b6394ca6` | package tests green 11-23 |

The kb runbook "Enable an app for consumer shaping" passed its independent
walkthrough on the gate host on 11-21 (hello-world, production Genie, two
paired Chrome sessions; manifest SHA-256 on the sprint thread).

## C4 gate-host preflight, 2026-11-23 (conductor): RED, no paid row started

Venue: the Windows gate host's WSL distro, lane 1 (claimed and released).

- Candidate: bashy `66a4bb89` cloned and built on the host with `GOWORK=off`
  (module pins yoke `4bafb600`, ycode `61f6782`); binary SHA-256
  `e573388dcdb70f2d6f53d24d9f33c720dfed992111080e90b942988767f0e5f6`.
- Disposable installation per the hello-world matrix: isolated HOME,
  BASHY_HOME, fleet catalog, private PATH wrapper; five apps registered with
  their shipped `register.sh` (`bashy app list`: chart, form, notepad,
  session, viewer ready).
- Model route (operator decision: Amazon Bedrock): the account has access to
  `zai.glm-5` only (Claude and GPT model ids return "not available for this
  account"). Route registered as an OpenAI-compatible model behind bashy's
  built-in genie; smoke `SMOKE-OK`; a tool-call probe returned a structured
  `tool_calls` envelope. Shaping agent and provenance: `genie:bedrock-glm5-e2e`.
- Console: LAN-bound, pairing mode, `--shape-agent genie:bedrock-glm5-e2e`.
  Readiness: `/login` 200. Anonymous `/` and `/form/`: 403.
- Members: two synthetic device principals (`device:m_alice`,
  `device:m_bob`) paired through single-use tickets redeemed in separate
  headless Chrome profiles; each profile holds the console session cookie;
  `bashy app devices` lists both. `shape status form --user device:m_alice`
  answers with the baseline revision.
- `e2e-agent.sh --dry-run`: all eight prompts render; wishes match the
  shipped manifests.
- RED at matrix step 1 (form as member A): the console served the
  self-healing incident page. Incident `kind: server, status: 500`:

```
shaped app form: server build failed for revision 55bfd58f:
go build ./server: exit status 1
server/main.go:29:2: desk-chart@v0.0.0: replacement directory ../chart does not exist
server/cli.go:19:2:  desk-kit@v0.0.0:   replacement directory ../kit does not exist
```

- Root cause (product, recorded on the story and as umbrella bug todo
  "Console cannot build any desk example app as a shaped member instance"):
  `buildServer` extracts the app's committed tree alone and builds there;
  the five apps' `go.mod` replace sibling directories. Not a regression (the
  code is identical at the 11-21 yoke pin); the 11-21 preflight read the
  same incident page as success. `TestDeskToolsShipShapedServer` builds in
  place and never exercises this path.
- Spend: two route smokes plus the console's automatic repair attempts on
  the form incident (one `repair` candidate created). The approved paid
  matrix was not started; the approval is intact.
- State: console stopped, headless browsers stopped, installation retained
  on the host for resumption.

## Not covered

board, whiteboard, table: operator pre-install rows, outside the approval;
recorded as SKIP by design.
