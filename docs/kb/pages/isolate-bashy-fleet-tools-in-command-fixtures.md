---
id: 01a1d2b2-170d-766c-8968-e51b23dec0e4
seq: 5
form: page
type: gotcha
title: Isolate Bashy fleet tools in command fixtures
description: 'WHEN a test or scratch bootstrap imports a tool with bashy tool add: BASHY_HOME alone does not isolate the fleet tool registry. Set BASHY_FLEET_DIR and BASHY_TOOLS_DIR to scratch directories, clear BASHY_TOOLS_PATH, and keep BASHY_COMMANDS_DIR isolated too. A stray invalid HTTP tool record can make unrelated service provider selection fail.'
status: candidate
source:
    tool: codex-gpt6-sol-z
    episode: ep-24d8ca1bca7137ac
    parent_episode: ep-09abc2249dbaeef7
created: "2026-11-13T02:17:29Z"
---
