---
id: bbbb3b54a44e
kind: bug
title: 'bashy thin core: the first-use adapter and its source checkout are not refreshed when the bashy binary changes'
seq: 856
status: todo
priority: p2
created: 2026-11-28T00:51:44.45467Z
---

Found 2026-11-27 in the Sprint 738 drill with a private BASHY_HOME and BASHY_ADAPTER_CACHE. After replacing the bashy binary with a newer build, 'bashy llm' kept using the adapter built from the earlier source checkout under BASHY_HOME/src/bashy (it stayed at the first commit fetched), so a fix in the pinned yoke did not reach the running door until the checkout was moved by hand and the cached adapter removed. With the real home (an older src/bashy) and an empty adapter cache the build failed with 'go: go.mod file not found'. Expected: the adapter is keyed to the binary's own source pin and rebuilt when it changes. Root cause not yet identified.
