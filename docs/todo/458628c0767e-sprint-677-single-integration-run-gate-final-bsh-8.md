---
id: 458628c0767e
kind: task
title: 'Sprint 677 single integration run: gate.final + bsh 86/86 + 3-OS dispatch e2e'
seq: 611
status: assigned
priority: p0
created: 2026-11-21T16:08:15.84969Z
weave: 140
assignee: agy-gemini4-carbon
sprint: 677
sprint_id: 334e4662-d75c-5c5f-8671-7b62ea882de1
sprint_title: Fast build, small core binary, and shapeable Yoke CLI modularization
---

Sprint 677 integration run, LEG 1 RERUN in the NEW official image. Prior attempt (run #131) went red ONLY on the toolchain wall: image rc.37/go1.27.2 vs productgo go1.27.4 (evidence: docs/sprint-677-integration-evidence.md, umbrella 91094fa80 - APPEND leg-1 rerun results to that same doc; 7/8 dag test targets passed even then).

NOW: bashy e5ea93a8, image localhost/bashy-build:v1.0.0-rc.40-go1.27.4-1171628e07d3 (image.lock rolled; verify the lock values in your checkout before running). Umbrella f0efc9335.

METHOD (proven, copy exactly): gate host lane 1 (8 CPU/7 GB; manager holds lane lease), workdir /root/lanes/lane1/s677-integration (reuse run #131 staging if present), attached foreground: bashy oci run --rm --init --cpus 8 --memory 7g -e BASHY_BUILD_RUN=1 -e GOFLAGS=-p=8 --entrypoint /usr/bin/dash <rc.40 image> -c '<commands>'. Stage bashy@e5ea93a8; record image id, sha, mod drift FIRST.

RUN bashy/.bashy/gate.final lines in order: bashy dag build; bashy dag test; bashy dag test-bash-gate. Commit evidence to docs/sprint-677-integration-evidence.md after EACH line (first commit <15 min: setup+image+drift). Exact exit codes, wall times, pass/fail counts, failing names verbatim. Root cause before any fix; NO code fixes in this story - record and continue. Trailers + Agent yourself. Role names only for hosts.
