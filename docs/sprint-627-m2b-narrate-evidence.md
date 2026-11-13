# Sprint 627 M2b-narrate: live OSS render

Story `b268cd0048de`. **Works:** `bashy narrate --route oss --json` produced
one Chatterbox narration WAV on the claimed Windows test host. The artifact
remains in the isolated host work area as `narrate-story-202/out/narration.wav`;
no audio or model bytes are committed here. The host claim was released after
the run.

## Venue and staged input

Native Windows was checked first: `bashy.exe` was present and C: had
863,683,723,264 bytes free, but native uv and ffmpeg were absent, and the
`python.exe` on PATH was only the Windows Store alias. More decisively, native
GPU PyTorch remains unverified, while the WSL rod environment and staged
Chatterbox weights had already rendered a prior probe. WSL was chosen to reuse
those inputs without installing a second toolchain or copying weights. No WSL
configuration, default Podman machine, AWS resource or dev-host model was used.

The WSL volume had 189,547,640 KiB free at render preflight, above the rod's
12 GiB minimum. The staged `s3gen.pt` and `t3_cfg.pt` checksums were rechecked
against `sprint-627-m2b-weights-evidence.md`:

| File | SHA-256 |
|---|---|
| `chatterbox/s3gen.pt` | `9b9ff07e60b20c136e2b1b3d7563a24604e8d2c4c267888d1ee929dd0151d2a3` |
| `chatterbox/t3_cfg.pt` | `0b2dd5439fe7e94f379561419847a45bf2c79d0e8ea751c6bbe947ce337789cc` |

Kokoro's staged checkpoint and default voice were also rechecked and matched
their recorded hashes. An isolated `BASHY_COMMANDS_DIR` registered the `narrate`
door and `narrate-local` rod. `HSA_ENABLE_DXG_DETECTION=1` was set, as were
Hugging Face, Transformers, ModelScope, uv and pip offline controls. The rod
environment has CUDA-only PyTorch `2.6.0+cu124`, so this successful render ran
on CPU. The host-local pinned ROCm wheel is tagged `cp312`; the existing rod
environment is Python 3.11, so it cannot be installed into that environment.
The captured render stderr showed no model transfer. The prior completed probe
had already populated the model cache, and this run reused it offline.

## Result

Request: `text="Welcome to opening night. The story begins now."`,
`voice="chatterbox"`, `seed=436`. The front door returned this
`bashy-svc-v1` envelope (host path abbreviated for publication):

```json
{
  "cost_class": "oss",
  "elapsed": 27,
  "outcome": "success",
  "outputs": [{"media_type": "audio/wav", "path": "<host M2b work area>/narrate-story-202/out/narration.wav"}],
  "provider": "narrate-local",
  "role": "narrate",
  "route": "oss",
  "schema_version": "bashy-svc-v1",
  "text": "M2b narration clip"
}
```

`/usr/bin/time -v` measured **27.63 s wall time**, **7,106,664 KiB maximum
resident set size** for the timed command, and exit status 0. Free
WSL disk changed from 189,547,640 to 189,547,492 KiB (148 KiB less).
`ffprobe` confirmed PCM 16-bit mono at 24 kHz, duration **2.420833 s**. The
WAV is **116,278 bytes**, SHA-256
`d981cf8a22d3aa1e848033dccf8dfbfc96ece45e202fe9309961c6a01e978d7e`.

The first front-door attempt in this run returned `unavailable` because the
isolated command record lacked its role and provider fields. Adding
`exec.3=narrate` to the door and `provides.0=narrate`, `route=oss` to the rod
resolved it; the successful invocation above is the fresh retry. The host
work area retains the request, envelope, time report, disk snapshots and WAV.
