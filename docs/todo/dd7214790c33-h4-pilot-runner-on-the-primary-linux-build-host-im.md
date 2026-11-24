---
id: dd7214790c33
kind: task
title: 'H4 pilot runner on the primary Linux build host: image, hosted entry, tunnel to the master, hosted-runner skill-script'
seq: 666
status: todo
priority: p1
labels:
    - bashy-hosting
    - infra
created: 2026-11-23T13:18:04.529734Z
sprint: 691
sprint_id: 2c1803fe-634b-51fb-818c-9ac8e2a5428c
sprint_title: Hosted bashy and the trove virtual drive for cloudbox users without a live outpost
---

Planned vendor: agy. Image from bashy/tools/bashy-build/Containerfile.base + release bashy + the google example registered; entry bashy mcp serve --transport http --hosted --listen 127.0.0.1:PORT; one handler per call (Knative/Fission later, per the research); tunnel to the master; written as examples/hosted-runner/ Bash# skill-script (build|start|stop|status, --json) so the pilot is reproducible; host taken with bashy claim and released after. Accept (MVP rescope 2026-11-24): image builds on the build host (never the dev box); a call signed by a fake master signer (test key, same per-call identity format as H1) reaches the runner over the tunnel and returns a bashy result, with scratch removed after; the live gateway call answering route: hosted is a release-train item (Sprint 699 goal hosted-route-t1), not this story; pilot allocation per the research note referenced from story 3211. Depends on H1 and H2; the H3 master ticket gates only the train item. Spec: docs/sprint-691-master-execution-plan.md
