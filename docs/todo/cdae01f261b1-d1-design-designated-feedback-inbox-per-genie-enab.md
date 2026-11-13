---
id: cdae01f261b1
kind: spike
title: 'D1 design: designated feedback inbox per genie-enabled command: other agents report failures in real time, humans file wishes on the web UI, agent-driven agents yield reports; refine consumes them'
seq: 255
status: todo
priority: p1
labels:
    - agentic
created: 2026-11-13T19:35:09.577193Z
sprint: 633
sprint_id: 9e1f8ffa-529b-5c1a-8633-138b7615dc97
sprint_title: 'agentic <command>: self-improving skill-scripts as the calling agent''s muscle memory'
---

Operator 2026-11-13: design the support for designated issue/inbox messages so other agents can report and give feedback in real time; the same channel carries software-shaping requests from humans on the web UI and reports from agents driven by another agent. Design doc deliverable (docs/agentic-command-skill-scripts-design.md section 5, then bashy/docs with S6), reusing surfaces that exist: (1) every forged CMD.bsh is also registered as a shaped app (bashy app add CMD --type shaped, source = the overlay dir), so bashy shape wish CMD REQUEST --evidence --expected --reproduction and the console's wish form are the human/web entry, bashy shape incident CMD MESSAGE --kind script is the automated failure entry, shape suggest shows pending ones, approve/undo gate the saved versions (the micro-shaping loop becomes an ordinary shaping lifecycle); (2) real-time agent reports go on the notification bus topic agentic.CMD (bashy bus publish --topic agentic.CMD, forge run watches with bus watch --drain before refine) with a structured report line (who, argv scrubbed, exit, stderr tail, host role, version); (3) a forge-run failure in a yield (exit 6) already carries the report to the driving agent, which may forward it with agentic-forge report CMD --from AGENT ...; (4) status for the human goes to bashy inbox human send --topic agentic --ref <overlay path>; (5) refine's prompt reads the inbox: open incidents + wishes + bus reports + graph pitfalls, and closes what the new version fixed (incident resolved, wish fulfilled) with evidence. Open points to decide in the doc: identity of reporters across hosts, dedup of the same failure from many agents, rate limits so a loop cannot flood refine, and which reports need human approval before a version is accepted (MCP elicitation when fronted by bashy mcp serve). No code in this story.
