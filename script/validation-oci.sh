#!/usr/bin/env bash
# Translate the existing conformance runners' Podman CLI subset to Docker.
set -euo pipefail
if [ "${1:-}" = image ] && [ "${2:-}" = exists ]; then
  shift 2
  exec docker image inspect "$@" >/dev/null
fi
if [ "${1:-}" = build ]; then
  shift
  explicit_file=0
  for arg in "$@"; do
    case "$arg" in -f|--file|--file=*|-f?*) explicit_file=1 ;; esac
  done
  context=${!#}
  if [ "$explicit_file" = 0 ] && [ -f "$context/Containerfile" ]; then
    docker build --file "$context/Containerfile" "$@"
  else
    docker build "$@"
  fi
  # build-conformance-image.sh filters for the classic builder success line.
  # BuildKit omits it; emit only after Docker itself succeeds (set -e).
  echo 'Successfully built conformance image'
  exit 0
fi
exec docker "$@"
