---
id: 0d0922b39875
kind: bug
title: 'Adapter resolution regression after 48d7c818: ''bashy dag: adapter yoke/dag/dag.bsh not found'' in test-bash-container-mode; Synergy DAG tests get ''go: downloading'' instead of a JSON envelope'
seq: 629
status: todo
priority: p0
labels:
    - bashy
    - adapter
    - release
    - gate
created: 2026-11-22T18:10:01.615071Z
sprint: 692
---

Gate rerun (umbrella bfd843f28, docs/sprint-677-integration-evidence.md second section) on frozen tip bebf3e8ca (bashy 1762e12c): (1) bashy dag test stops at test-bash-container-mode with 'bashy dag: adapter yoke/dag/dag.bsh not found' - this target PASSED in the first run at bashy 9dd37bb2; the only adapter-path change between the tips is 48d7c818 (adapter_dispatch.go: adapterScriptPath normalization, embeddedAdapterBuildsGo -> adapterSourceFetch (src.Fetch of the release-pinned bashy source) before materializeEmbeddedAdapter; skillhelp 10 min deadline). (2) TestSynergyDAGCheckAndList / TestSynergyDAGBoundedFixture / TestSynergyDAGRejectsEmptyImplementation: dag --json returns empty stdout, stderr 'go: downloading github.com/qiangli/coreutils ... github.com/qiangli/yoke v0.0.0-20261121163358-be872cc5a395 ...' (the yoke/dag adapter cold-builds inside the test with bashy/yoke/go.mod's yoke pin be872cc5 and a tmp module cache); not comparable with run 1 (package timed out there) so possibly pre-existing since the dag adapter conversion. ROOT CAUSE FIRST for each on the gate-host lane 3 (claim it; lane 2 is free too) in the official image: reproduce test-bash-container-mode at bashy 1762e12c vs 9dd37bb2 (bisect = 48d7c818 yes/no), with BASHY_ADAPTER_DEBUG=1 to see which resolution branch returns empty (src.Home empty in the container? fetch error path? writeEmbeddedCacheFile failing?). For the Synergy tests: decide whether a cold adapter build belongs inside these unit tests at all (warm the yoke/dag adapter once in TestMain like the ACP fix, with network, or point BASHY_ADAPTER_CACHE at a prebuilt dag) and whether 'go: downloading' must never reach the dispatcher's stderr during a --json call (the adapter template could run the build with -x off and stderr to the adapter log). Fix where the cause lives; keep 48d7c818's Windows behaviour (its e2e passed). Also bump bashy/yoke/go.mod (the adapter folder module) yoke pin to 5f136516 if that is what the tests download. Verify: test-bash-container-mode and the three Synergy tests green in the official image on the lane (targeted). Owner codex-gpt6-astra, --repo . TEST RULE (operator 2026-11-22): root cause recorded on this story BEFORE the fix; build + smallest targeted tests only; the full rerun is the conductor's. Start on current origin main; Sprint/Story/Story-ID + Agent trailers; do not push; nohup + poll for anything long on the gate host; hosts by role only.
