#!/usr/bin/env bash
# no-phone-home.sh DIR — static scrub for hidden outbound calls in an app
# source tree (Sprint 631 "just for me" apps). It reports every telemetry or
# analytics SDK, crash reporter, update check, vendor OTel endpoint and remote
# font or CDN reference it finds. Exit 0 = no hits; 1 = hits to remove or
# explain; 2 = usage or scan error.
#
# The scan uses the system grep, not whatever `grep` the calling shell
# resolves (an agent shell's built-in grep may lack \b and used to make this
# report a false "clean"). NO_PHONE_HOME_GREP=/path/to/grep overrides it
# (logged). A self-test proves the grep handles \b before scanning, and any
# grep error (exit >= 2) is a scan error, never "clean".
#
# Each hit must be removed, disabled by default, or explained in the story
# evidence. A clean static scan does not replace the runtime check (run the
# app with outbound traffic logged or blocked).
set -euo pipefail

dir=${1:-}
[[ -n $dir && -d $dir ]] || { echo "usage: $0 DIR" >&2; exit 2; }

# SDK/package names and endpoints, matched case-insensitively.
patterns=(
  '\bposthog' 'segment\.(io|com)|analytics-node|@segment/' '\bsentry\b' '\bplausible'
  'google-analytics|googletagmanager|gtag\(|ga\(.create' 'mixpanel' 'amplitude'
  '\bdatadog|dd-trace' 'newrelic' 'bugsnag' '\brollbar' 'logrocket' 'hotjar'
  'fullstory' '\bheap(analytics)?\.io' '\bintercom\b' 'launchdarkly' 'statsig'
  'honeycomb\.io' 'api\.github\.com/repos/[^"'\'' ]+/releases'
  'update[-_ ]?check|check[-_ ]?for[-_ ]?update|latest[-_ ]?version'
  'telemetry' 'otlp[^"'\'' ]*(\.com|\.io)' 'fonts\.(googleapis|gstatic)\.com'
  'cdn\.jsdelivr\.net|unpkg\.com|cdnjs\.cloudflare\.com'
)
re=$(IFS='|'; echo "${patterns[*]}")

excludes=(--exclude-dir=.git --exclude-dir=node_modules --exclude-dir=vendor
  --exclude-dir=dist --exclude-dir=build --exclude-dir=.next --exclude-dir=coverage
  --exclude='*.lock' --exclude='*-lock.json' --exclude='*-lock.yaml' --exclude='*.map'
  --exclude='*.min.js' --exclude='go.sum' --exclude='*.txt' --exclude='*.svg' --exclude='*.png' --exclude='*.md')

grep_bin=${NO_PHONE_HOME_GREP:-}
if [[ -n $grep_bin ]]; then
  echo "no-phone-home: using NO_PHONE_HOME_GREP=$grep_bin" >&2
else
  for g in /usr/bin/grep /bin/grep; do [[ -x $g ]] && { grep_bin=$g; break; }; done
fi
[[ -n $grep_bin && -x $grep_bin ]] || { echo "no-phone-home: no system grep found (set NO_PHONE_HOME_GREP)" >&2; exit 2; }

# Self-test: a known \b pattern must hit, or the scan would be silently empty.
if ! printf 'x posthog.init()\n' | "$grep_bin" -qiE '\bposthog'; then
  echo "no-phone-home: $grep_bin failed the \\b self-test; refusing to report clean" >&2
  exit 2
fi

rc=0
hits=$("$grep_bin" -rniE "${excludes[@]}" -- "$re" "$dir") || rc=$?
if (( rc > 1 )); then
  echo "no-phone-home: scan error (grep exit $rc) in $dir" >&2
  exit 2
fi
if [[ -z $hits ]]; then
  echo "no-phone-home: clean ($dir)"
  exit 0
fi
printf '%s\n' "$hits"
echo "no-phone-home: $(printf '%s\n' "$hits" | wc -l | tr -d ' ') hit(s) in $dir — remove, default off, or explain each" >&2
exit 1
