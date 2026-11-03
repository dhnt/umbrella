#!/usr/bin/env bash
# Inert mount-policy control. No uutils source or test code executes here.
set -euo pipefail
out=${RUNNER_TEMP:?}/uutils-mount-diagnostic
mkdir -p "$out"
# Exact base digest retained by the failed original uutils image preparation.
image=rust:1-bookworm@sha256:9181b56c2a21ab1d5e73cffe04fc762426d30aa7fac3c91141dd033f49a7fc8b
docker pull "$image" > "$out/pull.log" 2>&1
docker image inspect "$image" > "$out/image.json"
name=
cleanup() { if [ -n "$name" ]; then docker rm -f "$name" >/dev/null 2>&1 || true; fi; }
trap cleanup EXIT
trap 'exit 130' INT
trap 'exit 143' TERM
trap 'exit 129' HUP
for mode in original explicit-exec; do
  options=rw,nosuid,nodev,size=8g,mode=1777
  if [ "$mode" = explicit-exec ]; then options=$options,exec; fi
  name=baseline-uutils-mount-${GITHUB_RUN_ID:?}-$mode
  # Original nonroot/network/read-only/capability/memory/PID/tmpfs conditions.
  # The second control changes only /work exec, not any actual suite invocation.
  set +e
  timeout -k 5s 60s docker run --rm --name "$name" --network=none \
    --memory 3g --memory-swap 3g --pids-limit 512 --user "$(id -u):$(id -g)" \
    --read-only --cap-drop=ALL --security-opt=no-new-privileges \
    --tmpfs "/work:$options" --tmpfs /tmp:rw,nosuid,nodev,size=256m,mode=1777 \
    "$image" /bin/sh -c '
      grep " /work " /proc/self/mountinfo
      cp /usr/bin/true /work/probe
      stat -c "%a %u:%g %n" /work/probe
      /work/probe
      rc=$?
      printf "probe_exit=%s\n" "$rc"
      exit "$rc"
    ' > "$out/$mode.log" 2>&1
  rc=$?
  set -e
  printf '%s\t%s\n' "$mode" "$rc" >> "$out/results.tsv"
  cleanup
  name=
done
printf '%s\n' 'Diagnostic only: neither control executes a foreign suite or supplies baseline acceptance.' > "$out/scope.txt"
