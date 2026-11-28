---
id: 28ac6f5b2e7b
kind: bug
title: 'bashy form on the dev box refuses every flag (unknown flag --def): registered record predates the 11-25 fix'
seq: 853
status: done
priority: p2
labels:
    - form
created: 2026-11-28T00:47:21.688505Z
closed: 2026-11-28T00:47:38.569714Z
---

Observed 2026-11-27 on the dev box: bashy form ask --def F and bashy form --help fail with 'bashy: form: unknown flag --def' / '--help', and 'too many positional arguments: got 5, want 2' behind a -- separator. The command body run directly (bashy --bashsharp <form.bsh> ask --def F) works.

Root cause (classified: environment, a stale host record; not a product defect). The host's registered record (the user command ring, commands/form.yaml, written 2026-11-22) still carries args.positionals (verb enum, id) and no args.flags, so the shell binds that schema and rejects every flag before the body runs. The product fix already exists: bashy 06dfd56c (2026-11-25, story 64ef2626b13e) removed args from examples/desk/form/register.sh so the record is an untyped pass-through. The record on this host was never re-registered after that fix. The exec path in the record is current; only args is stale. chart is not registered on this host; notepad and viewer records were not affected by that fix.

Fix: drop args from the host record (what the current register.sh writes). No product change. Verify: bashy form --help prints help; bashy form list works; a form ask --def round trip creates a form.

Not done here (product gap, not in MVP): nothing tells a host that a registered example record is older than its register script; a re-register after a desk example changes is manual.

Fixed 2026-11-27 on the dev box: bashy commands set form --set args= removed the args block from the host record; a diff against the saved copy shows only that block removed. Verified through the registered verb: bashy form --help prints help, bashy form list lists the forms, and bashy form ask --def F created a form (probe form-2c3d464acf1b; left pending because its owner key was not kept, so close refused it). bashy commands verify form: ok.
