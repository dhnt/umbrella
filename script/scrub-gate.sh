#!/usr/bin/env bash
# Public-repo scrub gate (pre-commit, fail-closed).
#
# Everything in this repository is public. This gate refuses a commit whose
# STAGED text names a credential, an address, a home-directory path, or a
# private pattern. Two pattern sources:
#
#   1. built-in shapes below — tokens, private IPs, home paths, creds-in-URL;
#   2. .scrub-patterns.local (gitignored, one extended regex per line) — the
#      machine names and OS logins of YOUR hosts. Never commit that file.
#
# Usage: script/scrub-gate.sh            # staged files (the hook)
#        script/scrub-gate.sh --all      # every tracked file (CI, audits)
#        SCRUB_ALLOW=1 git commit …      # bypass — record why in the commit
set -euo pipefail

root=$(git rev-parse --show-toplevel)
cd "$root"

if [ "${SCRUB_ALLOW:-}" = "1" ]; then
  echo "scrub-gate: bypassed by SCRUB_ALLOW=1" >&2
  exit 0
fi

mode=${1:-staged}
files=()
if [ "$mode" = "--all" ]; then
  mapfile -t files < <(git ls-files)
else
  mapfile -t files < <(git diff --cached --name-only --diff-filter=ACMR)
fi
[ ${#files[@]} -eq 0 ] && exit 0

# Submodule gitlinks and binaries are not text to scan.
text=()
for f in "${files[@]}"; do
  [ -f "$f" ] || continue
  case "$f" in *.png|*.jpg|*.jpeg|*.gif|*.pdf|*.zip|*.gz|*.woff|*.woff2|*.ico) continue;; esac
  text+=("$f")
done
[ ${#text[@]} -eq 0 ] && exit 0

builtin_patterns=(
  # credentials
  'gh[pousr]_[A-Za-z0-9]{20,}'
  'github_pat_[A-Za-z0-9_]{20,}'
  'sk-(ant-)?[A-Za-z0-9_-]{20,}'
  'xox[abpr]-[A-Za-z0-9-]{10,}'
  'AKIA[0-9A-Z]{16}'
  'SG\.[A-Za-z0-9_-]{20,}\.[A-Za-z0-9_-]{20,}'
  '-----BEGIN [A-Z ]*PRIVATE KEY-----'
  '[a-z][a-z0-9+.-]*://[^/:@[:space:]]+:[^/@[:space:]]{4,}@'
  # addresses: any IPv4 (loopback, 0.0.0.0 and the documentation ranges
  # are filtered back out below)
  '(^|[^0-9.])([0-9]{1,3}\.){3}[0-9]{1,3}([^0-9.]|$)'
  # home-directory paths carry a login
  '/Users/[A-Za-z0-9._-]+/'
  '/home/[A-Za-z0-9._-]+/'
  '[A-Za-z]:\\\\Users\\\\[A-Za-z0-9._-]+'
)

local_patterns=()
if [ -f .scrub-patterns.local ]; then
  while IFS= read -r line; do
    case "$line" in ''|'#'*) continue;; esac
    local_patterns+=("$line")
  done < .scrub-patterns.local
fi

# IPv4 values that are not an address of anything: loopback, unspecified,
# the RFC 5737 documentation ranges, and version-looking dotted quads.
ip_allow='(^|[^0-9.])(127\.[0-9]+\.[0-9]+\.[0-9]+|0\.0\.0\.0|192\.0\.2\.[0-9]+|198\.51\.100\.[0-9]+|203\.0\.113\.[0-9]+)([^0-9.]|$)'

fail=0
for p in "${builtin_patterns[@]}" "${local_patterns[@]}"; do
  # POSIX ERE only: BSD grep (stock macOS) has no -P.
  if hits=$(grep -nE -- "$p" "${text[@]}" 2>/dev/null); then
    case "$p" in *'[0-9]{1,3}'*) hits=$(printf '%s\n' "$hits" | grep -vE -- "$ip_allow" || true);; esac
    [ -z "$hits" ] && continue
    fail=1
    echo "scrub-gate: pattern /$p/" >&2
    printf '%s\n' "$hits" | sed -E 's/(gh[pousr]_|github_pat_|sk-|xox[abpr]-|AKIA|SG\.)[A-Za-z0-9._-]+/\1<redacted>/g' | head -20 >&2
  fi
done

if [ "$fail" -ne 0 ]; then
  cat >&2 <<'MSG'
scrub-gate: REFUSED — this repository is public. Describe hosts by role,
drop the address/login/credential, or add a placeholder. (SCRUB_ALLOW=1 to
bypass; say why in the commit message.)
MSG
  exit 1
fi
