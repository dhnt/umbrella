---
id: ab9cbdd6f838
kind: feature
title: 'F3b The unattended guard and the activation policy on the wish path: shape wish --source, off switch, decision log, auto-activate'
seq: 816
status: done
priority: p0
labels:
    - shapeware
created: 2026-11-26T23:49:36.66533Z
assignee: claude-fable5.2
sprint: 730
sprint_id: 84e490e9-6cc4-55f2-befb-36c1ba042c5b
sprint_title: 'Field shaping loop: runtime errors and issue feeds drive the existing shaping workflow unattended'
closed: 2026-11-27T01:12:44.372436Z
closed_by: claude-opus5.5
---

Delivery rules (conductor 2026-11-26): same as F1-F3. Base: yoke origin/main 2b10346c or later, bashy origin/main with s730-int merged (9e516af8 or later). Branch s730-<id> in each submodule; conductor merges. Trailers Sprint/Story/Story-ID/Agent: <your agent name>. Targeted unit tests only. KISS.

Why: F3 put the off switch and decision log on console incident repair only. A feed or a scheduled agent enters through `shape wish`, which today ignores both, and stops at verified, while the operator's policy (2026-11-26) is one rule for every unattended source: verified -> auto-activate with the existing rollback, owner notified, can undo.

Scope:
1. yoke pkg/shape: when Wish.Source.Kind is feed or schedule (unattended): refuse with a clear error when state.AutoEnabled(home) is false, and log a refusal; log a trigger when the candidate begins; log the verdict when it completes (same state.LogAuto, Source=kind, Ref=source ref, App). shape Approve logs an activation line when the candidate's Source is unattended. Human and empty sources: no change.
2. bashy `shape wish --source KIND:REF` (local mode; refused with --remote) sets Wish.Source; KIND validated by shape.Source.Validate.
3. bashy examples/shape-feed/shape-feed.bsh --apply: stop before filing anything when `bashy shape auto status` says off; call `shape wish APP --todo ID --source feed:ID --json`, then `bashy shape approve APP CANDIDATE` when the candidate verified (approve verifies again and activates). When wish or approve fails, set the todo to status known with a workaround text naming what was tried and the error, and continue with the next item. Keep the embedded copy under internal/agentos/adapterembed/examples/shape-feed in sync.
Tests: yoke unit tests for refusal when off, trigger/verdict/activation lines, no logging for human wishes; shape-feed test with a fake bashy (SHAPE_FEED_BASHY_BIN) proving off -> nothing filed, verified -> approve called, failure -> todo known.
