#!/usr/bin/env bash
# gate-lane.sh: make a Linux gate-host lane a correct venue for unit tests,
# and check that it is one.
#
#   script/gate-lane.sh setup BASHY_CHECKOUT   install the lane tools (once per host, idempotent)
#   script/gate-lane.sh check                  preflight: exit 0 only when the venue is right
#   script/gate-lane.sh run CMD ARGS...        run CMD in the venue (environment + no controlling terminal)
#   . script/gate-lane.sh env                  export the venue environment into this shell
#
# Why each piece exists (root causes recorded 2026-11-24 in
# docs/sprint-684-685-master-execution-plan.md, step 0):
#   - base Go must equal the toolchain every go.mod names; an older base
#     auto-switches for itself but hands child `go` processes a mismatched
#     GOROOT ("compile: version ... does not match go tool version");
#   - desk apps require the shared kit/chart modules at versions served only
#     by bashy's local Go module proxy, so the proxy must be published and
#     GOPROXY must name it; publishing needs a bashy that has `mod proxy`;
#   - tests that assert headless behaviour fail when the remote session has
#     a controlling terminal, so commands run under setsid.
#
# Workspace-mode suites (for example bashsharp's, which build sibling
# binaries) still need an umbrella checkout with submodules; this script does
# not create one.
if [ "${BASH_SOURCE[0]}" = "$0" ]; then set -euo pipefail; fi

GATE_GO_VERSION=${GATE_GO_VERSION:-1.27.4}
GATE_ROOT=${GATE_ROOT:-$HOME/lanes}
GATE_BIN=$GATE_ROOT/bin
GATE_GO_ROOT=$GATE_ROOT/go/$GATE_GO_VERSION
GATE_PROXY=${BASHY_GOMOD_PROXY:-${BASHY_HOME:-$HOME/.bashy}/gomod-proxy}

gate_env() {
	export PATH="$GATE_BIN:$GATE_GO_ROOT/bin:${PATH}"
	export GOTOOLCHAIN=local
	export BASHY_HINTS=off
	export BASHY_GOMOD_PROXY="$GATE_PROXY"
	export GOPROXY="file://$GATE_PROXY,https://proxy.golang.org,direct"
	export GONOSUMDB="github.com/qiangli/bashy/examples"
}

gate_setup() {
	local src=${1:?setup needs a bashy checkout at the commit to build the runner from}
	mkdir -p "$GATE_BIN" "$GATE_ROOT/go"
	if [ ! -x "$GATE_GO_ROOT/bin/go" ]; then
		local arch
		case "$(uname -m)" in x86_64) arch=amd64 ;; aarch64 | arm64) arch=arm64 ;; *) echo "gate-lane: unsupported machine $(uname -m)" >&2; return 1 ;; esac
		local cached="$HOME/go/pkg/mod/golang.org/toolchain@v0.0.1-go$GATE_GO_VERSION.linux-$arch"
		rm -rf "$GATE_GO_ROOT.tmp"
		if [ -x "$cached/bin/go" ]; then
			cp -r "$cached" "$GATE_GO_ROOT.tmp"
			chmod -R u+w "$GATE_GO_ROOT.tmp"
		else
			mkdir -p "$GATE_GO_ROOT.tmp"
			curl -fsSL "https://go.dev/dl/go$GATE_GO_VERSION.linux-$arch.tar.gz" | tar -xz -C "$GATE_GO_ROOT.tmp" --strip-components=1
		fi
		mv "$GATE_GO_ROOT.tmp" "$GATE_GO_ROOT"
	fi
	gate_env
	(cd "$src" && GOWORK=off go build -o "$GATE_BIN/bashy.new" ./cmd/bashy && mv "$GATE_BIN/bashy.new" "$GATE_BIN/bashy")
	git -C "$src" rev-parse HEAD >"$GATE_BIN/bashy.commit"
	(
		# shellcheck disable=SC1091
		BASHY_BIN="$GATE_BIN/bashy" . "$src/examples/desk/register-modules.sh"
	)
	install -m 0755 "$0" "$GATE_BIN/gate-lane"
	# Make the host default the same toolchain, so a command run outside
	# this script does not fall back to an older base. The old link target
	# is kept on disk and recorded.
	local link
	for link in /usr/local/bin/go /usr/local/bin/gofmt; do
		if [ -L "$link" ] && [ -w "$(dirname "$link")" ]; then
			readlink "$link" >>"$GATE_ROOT/go/previous-default.txt"
			ln -sfn "$GATE_GO_ROOT/bin/$(basename "$link")" "$link"
		fi
	done
	gate_check
}

gate_check() {
	gate_env
	local bad=0
	fail() { echo "gate-lane: FAIL $*" >&2; bad=1; }
	[ "$(cd / && go env GOVERSION 2>/dev/null)" = "go$GATE_GO_VERSION" ] || fail "base Go is $(cd / && go env GOVERSION 2>/dev/null), want go$GATE_GO_VERSION"
	[ "$(command -v bashy)" = "$GATE_BIN/bashy" ] || fail "bashy on PATH is $(command -v bashy), want $GATE_BIN/bashy"
	bashy mod proxy status --dir "$GATE_PROXY" >/dev/null 2>&1 || fail "bashy has no working 'mod proxy'"
	for m in kit chart; do
		ls "$GATE_PROXY/github.com/qiangli/bashy/examples/desk/$m/@v/"*.zip >/dev/null 2>&1 || fail "desk $m is not published in $GATE_PROXY"
	done
	command -v setsid >/dev/null || fail "setsid is missing"
	command -v python3 >/dev/null || fail "python3 is missing"
	if setsid -w sh -c ': </dev/tty' 2>/dev/null; then fail "a controlling terminal is visible under setsid"; fi
	[ "$bad" = 0 ] || return 1
	echo "gate-lane: ok (go$GATE_GO_VERSION, bashy $(cut -c1-9 "$GATE_BIN/bashy.commit" 2>/dev/null), proxy $GATE_PROXY)"
}

case "${1:-}" in
setup) shift; gate_setup "$@" ;;
check) gate_check ;;
run) shift; gate_check >/dev/null; exec setsid -w "$@" ;;
env) gate_env ;;
*) echo "usage: $0 setup BASHY_CHECKOUT | check | run CMD ARGS... | . $0 env" >&2; exit 2 ;;
esac
