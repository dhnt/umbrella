# Sprint 627 M2b-song: live OSS render attempt

Story `0d2e5664b05e`. **Blocked; no song artifact.** All live checks were on
the claimed Windows test host. The claim is released after this attempt. No
model weights were downloaded, no default Podman machine or WSL configuration
was changed, and no AWS or dev-host model work was used.

## Venue and staged inputs

Native Windows was checked first: `bashy.exe` exists, but `uv`, `ffmpeg`, and
`git` were absent from the native command lookup, and the native song cache was
empty. Its C: volume had 861,126,758,400 bytes free. The existing WSL checkout
already has the pinned ACE-Step 1.5 source at
`ca1e85fe9430179831e6bc6be790c332190a3866`, a complete `uv` environment,
and the staged model directory. WSL was used to reuse those bytes and that
environment; native AMD inference for this rod is unverified. WSL had
210,874,240 KiB free before the attempt, above the rod's 25 GiB preflight.

The four principal checkpoint files were freshly SHA-256 checked on the host
against `docs/sprint-627-m2b-weights-evidence.md`:

| Relative file in `song-acestep/models/Ace-Step1.5` | SHA-256 |
|---|---|
| `Qwen3-Embedding-0.6B/model.safetensors` | `0437e45c94563b09e13cb7a64478fc406947a93cb34a7e05870fc8dcd48e23fd` |
| `acestep-5Hz-lm-1.7B/model.safetensors` | `f161689da73e5ecefa28ff780d51c2d92a00f056d021d7933c779ed5c6cd7db8` |
| `acestep-v15-turbo/model.safetensors` | `3f6e0797fad420a39bd33979eb6e840e30989e34a3794e843d23b60ec6e422d7` |
| `vae/diffusion_pytorch_model.safetensors` | `da17edb604c40deaf09e9b24974e590d1ca83a374070e5d0884cfa4bed9a99b0` |

## Bounded invocation and blockers

The previous M2b probe's `bashy-svc-v1` envelope, preserved on the host, was:

```json
{"cost_class":"oss","elapsed":51,"outcome":"error","outputs":[],"provider":"song-acestep","role":"song","route":"oss","schema_version":"bashy-svc-v1","text":""}
```

Its stderr says the rod provisioned the checkout and environment, then stopped
because no ACE-Step server was listening at the expected local URL. This is
**prior-run evidence**, not a new successful render.

For this story, a bounded `bashy song --route oss --json` invocation was made
with Hugging Face and Transformers offline flags and the staged cache path. It
exited 127 in 1 second with `bashy: song: command not found`, before dispatching
the rod; therefore it emitted no new `bashy-svc-v1` envelope. The isolated
command registry needs to be restored before a further front-door attempt.
Free disk afterward was 210,874,252 KiB (filesystem accounting noise; no
weight transfer). Available WSL memory before invocation was 31,499,448 KiB.
No model process launched, so a render peak memory measurement is unavailable;
the artifact checksum is **none** because no artifact exists.

The pinned ACE-Step environment has PyTorch `2.10.0+cu128` and reports no GPU
on this AMD host. The separate ROCm environment from M3 reports PyTorch
`2.9.1+rocm7.2.1` but currently reports no GPU; `rocminfo` fails at
`hsa_init`. This differs from M3's earlier successful GPU tensor check. The
host GPU venue must be recovered and the ACE-Step server started with a usable
backend while binding its model directory to the already staged files, with
offline flags enforced. A subsequent direct SSH probe failed because the host
access elevation cookie expired. The conductor was asked to refresh it and
investigate GPU availability. No runtime increase is requested: this attempt
did not reach inference or demonstrate a runtime need.
