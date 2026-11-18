# Sprint 655 plan: one app, unified command contract (MVP)

Sprint 655 (`31ee6639-a559-5fea-9e71-a7ca52cdea91`). Operator-reviewed scope,
2026-11-18. The sprint card and its stories stay authoritative; this file
records the plan and the decisions behind it.

## Meaning of "one app"

Bashy is one coherent app for users and agents: commands, registered tools and
apps (`bashy app`) are its parts, and a web UI is one view of what the CLI can
do. "One app" is a **contract** about observable behavior, never a requirement
on how anything is implemented inside. Third parties register their own
commands and apps through the existing extension points (`commands add`,
`app add`, `adapter add`, shaped apps).

Rod, not fish: bashy provides the contract and the tools to check against it.
The user or agent decides what to do with the result, including the stability
tier (`experimental → preview → supported`, declared by hand as in the atlas).

## Scope (KISS)

### S0: the contract (`4b633be22c28`)

`yoke/docs/command-contract.md`, short and normative, borrowing existing
standards:

- syntax: POSIX XBD 12.2 utility guidelines, plus `--help` and `--version`;
- common options as `pkg/adapt` already declares them (`--json --fields --null
  --dry-run --no-input --explain`) with their existing rules;
- one versioned result envelope (`schema_version`, `status`, `data`, `error`,
  `hints`); existing hint/recommend records become kinds of it;
- exit codes 0 / 1 / 2 (usage or declared-unsupported option) / 126 / 127, and
  6 = yield as in Bash#;
- effects metadata aligned with the atlas axes;
- apps: every UI action has an equivalent CLI command (UI → CLI parity);
- conformance is optional: commands and apps register as today (none conform
  yet); one may be made to conform, for example by shaping it.

Plus a small reference package in yoke (envelope type, exit-code constants)
next to `pkg/adapt`, so commands adopt the contract by import. The contract is
also published where shaping agents look things up (a `bashy` skill doc or kb
page), so "conform to the command contract" is an ordinary shaping wish.

Done when the operator accepts the doc.

### S1: minimum checker (`244c0d674df7`)

One small command that checks one command or app against the contract and
reports by name: conform / adapted / declared-unsupported / FAIL.

- A Bash# skill-script registered with `commands add` (Go only where a script
  cannot do the job), so it is itself shapeable.
- `shape verify` can include it when the user or agent asks. Not on by default;
  it never blocks registration or activation.

Done when: it runs on one featured command and on one app and reports gaps by
name; one shaping wish ("conform to the command contract") on the Hello World
app yields a candidate the checker passes; existing shaping tests stay green.

## Deferred to the backlog (unchanged, not cancelled)

S2 claims ledger, S3 MCP projection, S4 forge family, S5 other provider
families, S6 app family, S7 claim consolidation, S8 location-transparency
spike. Each can pick up the contract and checker once they exist. No baseline
run over the featured commands in this sprint.

Moved to the build/release work (sprint 575 owner): the Makefile removal story
`5bc29f7f` and the `make` → `bashy dag` fallthrough story `d9bf47e9`.

## Decisions

- Maturity tiers reuse the atlas vocabulary; stable/beta meant the same tiers.
- No new refusals: the only built-in refusal remains `commands add` refusing to
  shadow a command bashy ships.
- Stories close on their own criteria plus no regression in formerly green yoke
  and shaping tests.
