# Sprint 627 M2b-image: live draft render preflight

Story `c8204201fdd2`. **Works:** one image generate and one image edit rendered
through `bashy image --route oss --json` on the claimed Windows test host.
Initial preflight found an incomplete model; the conductor authorized a
one-time fetch of **only** the missing files from the pinned FLUX revision
(`mb:13665`). Both renders then ran with offline Hub and Transformers flags
against that local snapshot. No model or image bytes are committed here.

| Check | Result |
|---|---|
| Host claim | Held for all remote checks and renders; released after artifact verification |
| Native C: free space | 887,724,060,672 bytes before inference |
| WSL cache volume free space | 197,588,208 KiB (read-only fallback inventory) |
| Native `bashy.exe` | Present |
| Native `uv` and Python | Absent; no native inference environment exists |
| Staged FLUX.2 klein-4B checkpoint | 7,751,105,712 bytes; SHA-256 `ec3d4e733a771f61c052fb4856c48b336c55eaf2c65487c2a1faeb9bbda7a343`, matching M2b-w |
| Other FLUX.2 files at initial preflight | None; missing components staged once afterward |
| Generate (`bashy image --route oss --json`) | Success, 268.97 s, peak RSS 17,620,160 KiB, SHA-256 `19620eb54e7a3c48863c11a97b547d13bb1cd61932ef863816a1cc62eb6e2e59` |
| Edit (`bashy image --role image.edit --route oss --json`) | Success, 158.01 s, peak RSS 17,618,536 KiB, SHA-256 `f782f5966a9dab3d928e2f7c795abfbd83312bfa0953f8ae38f40e20692a33a6` |
| `bashy-svc-v1` live envelopes | Both `outcome=success`, `cost_class=oss`, provider `image-klein`; see below |

The [pinned FLUX.2 klein-4B model tree](https://huggingface.co/black-forest-labs/FLUX.2-klein-4B/tree/e7b7dc27f91deacad38e78976d1f2b499d76a294)
contains 23.7 GB of files, including both a 7.75 GB single-file checkpoint
and separate Diffusers components (`text_encoder`, `tokenizer`, `vae`,
`scheduler`, `transformer`, and `model_index.json`). M2b-w staged only its
7.75 GB
single-file checkpoint. The remaining pipeline components were not present in
the native model directory. The optional partial Qwen cache is a different
model and cannot complete this FLUX snapshot. The existing checkpoint was not
downloaded or copied again. The separately packaged Diffusers transformer has
a different SHA-256 from that single-file checkpoint; the live pipeline loaded
the separate transformer, while the M2b-w single-file checkpoint remained
staged and unused for inference.

## Missing components staged once

All files below were fetched directly into the native `image-klein` cache from
revision `e7b7dc27f91deacad38e78976d1f2b499d76a294`. The transfer script
refused an existing file with a mismatched size or hash, used a resumable
`.part` file for new transfers, and verified the final byte count and SHA-256
before moving each file into place. It did not fetch Qwen or the already staged
single-file FLUX checkpoint.

| Relative model path | Bytes | SHA-256 | Transfer wall time |
|---|---:|---|---:|
| `text_encoder/model-00001-of-00002.safetensors` | 4,967,215,360 | `8c0506e7f4936fa7e26183a4fd8da4e2bdbc5990ba64ae441f965d51228f36ea` | 76.75 s |
| `text_encoder/model-00002-of-00002.safetensors` | 3,077,766,632 | `82f2bd839378541b0557bfabaf37c7d3d637071fdcb73302dedd7cf61162ce07` | 46.79 s |
| `transformer/diffusion_pytorch_model.safetensors` | 7,751,109,744 | `9f29f9edcfdae452a653ffb51a534ca4decd389952c225724ff3b94042612a6e` | checked on host |
| `vae/diffusion_pytorch_model.safetensors` | 168,120,878 | `ca70d2202afe6415bdbcb8793ba8cd99fd159cfe6192381504d6c4d3036e0f04` | 3.13 s |

The other required files were verified on the native host after rendering:

| Relative model path | Bytes | SHA-256 |
|---|---:|---|
| `LICENSE.md` | 9,584 | `ca02bc51900ab07789d1b70283329e7137f5af98f5161c23a1c81fc38a4af1fe` |
| `model_index.json` | 446 | `51a76cb1cf3ed37423a1128c79c22faee8e6fbe7f5aaeb737f0a258930dbaac0` |
| `scheduler/scheduler_config.json` | 486 | `067afb012cef64553a763447d1efd93daeffcc0123ca7e25b09f8de20b90762e` |
| `text_encoder/config.json` | 1,536 | `214b4c29a0d975e9fddf9994a5673f22cb2c4c5750352f9227c2c3251ebeab40` |
| `text_encoder/generation_config.json` | 214 | `4347b1aeed2b2b78bc059920a0b7f5fec71482e1344952b76d7665d638d71f13` |
| `text_encoder/model.safetensors.index.json` | 32,855 | `06b3d5319b6d76d1a4a2433419180016cfd54ed62d086a5e6567a809f8c82634` |
| `tokenizer/added_tokens.json` | 707 | `c0284b582e14987fbd3d5a2cb2bd139084371ed9acbae488829a1c900833c680` |
| `tokenizer/chat_template.jinja` | 4,168 | `a55ee1b1660128b7098723e0abcd92caa0788061051c62d51cbe87d9cf1974d8` |
| `tokenizer/merges.txt` | 1,671,853 | `8831e4f1a044471340f7c0a83d7bd71306a5b867e95fd870f74d0c5308a904d5` |
| `tokenizer/special_tokens_map.json` | 613 | `76862e765266b85aa9459767e33cbaf13970f327a0e88d1c65846c2ddd3a1ecd` |
| `tokenizer/tokenizer.json` | 11,422,654 | `aeb13307a71acd8fe81861d94ad54ab689df773318809eed3cbe794b4492dae4` |
| `tokenizer/tokenizer_config.json` | 5,404 | `443bfa629eb16387a12edbf92a76f6a6f10b2af3b53d87ba1550adfcf45f7fa0` |
| `tokenizer/vocab.json` | 2,776,833 | `ca10d7e9fb3ed18575dd1e277a2579c16d108e32f27439684afa0e10b1440910` |
| `transformer/config.json` | 541 | `09733c74a3da6d17dd0a0472a091a8950c7c6935889c32c16cc800ede05029de` |
| `vae/config.json` | 821 | `0d6dfb69ae95a5e2ac9836284bbb63d8b38ce67b25ba2dff380752b2a10ab948` |

Native C: free
space was 887,648,608,256 bytes at this transfer's preflight and
871,592,071,168 bytes afterward. The first two measured large-file rates were
64.7 MB/s and 65.8 MB/s respectively.

The new `image-klein` rod lives beside `image-qwen`, but is the only image rod
registered by defaults so `bashy image --route oss` selects the draft model.
Qwen remains an optional explicit registration. The light rod binds a local
snapshot and forces Hugging Face and Transformers offline. It refuses an
incomplete snapshot before installing packages. Its service-door generate and
edit paths are covered by fixture tests in addition to these live renders.
Native inference was checked first. WSL was used for GPU rendering: native
Python and `uv` are absent and native Windows ROCm remains unverified. The WSL
runtime read the native model cache through the mounted C: volume, with no
second weight copy or fetch. The existing ROCm PyTorch environment was copied
to a separate image rod environment and updated to diffusers `0.43.0`,
Transformers `5.22.2` and Hugging Face Hub `2.4.0`. PyTorch
`2.9.1+rocm7.2.1` saw the AMD GPU. The isolated command registry received
`bashy-defaults apply` plus the `image-klein` registration before the calls.
No WSL configuration, default Podman machine, AWS resource or dev-host model
was touched.

## Live render evidence

The live requests explicitly selected `--provider image-klein` because the
host's older source pin still registered Qwen. The new defaults register only
the light image rod. Both requests used seed `436`/`437` and 512×512 PNG
output. The generate prompt depicted an original fictional singer on a
blue-lit stage; the edit request used the generated PNG as input and asked for
warm amber lighting.
The PNGs were reopened and verified after rendering. The generated file is
249,901 bytes; the edited file is 269,432 bytes. The outputs remain in the
host-local M2b image work area.

| Role | Wall time | Peak process RSS | SHA-256 |
|---|---:|---:|---|
| `image.generate` | 268.97 s | 17,620,160 KiB | `19620eb54e7a3c48863c11a97b547d13bb1cd61932ef863816a1cc62eb6e2e59` |
| `image.edit` | 158.01 s | 17,618,536 KiB | `f782f5966a9dab3d928e2f7c795abfbd83312bfa0953f8ae38f40e20692a33a6` |

WSL cache-volume free space changed from 189,577,540 KiB before generation
to 189,547,816 KiB after edit. The service envelopes reported 268 s and
157 s respectively (rounded down from the external wall clock). Paths below
are redacted to the host-local work area.

```json
{"schema_version":"bashy-svc-v1","role":"image.generate","provider":"image-klein","route":"oss","outcome":"success","cost_class":"oss","elapsed":268,"outputs":[{"media_type":"image/png","path":"<Windows test host M2b image work area>/generated/image-01.png"}],"text":"oss draft via FLUX.2 klein-4B"}
{"schema_version":"bashy-svc-v1","role":"image.edit","provider":"image-klein","route":"oss","outcome":"success","cost_class":"oss","elapsed":157,"outputs":[{"media_type":"image/png","path":"<Windows test host M2b image work area>/edited/edit-01.png"}],"text":"oss draft via FLUX.2 klein-4B"}
```

## Verification scope

The `examples/oss-rods` and `examples/defaults` Go fixture suites passed with
the installed bashy binary selected through their test binary override. The
defaults fixture asserts that the optional Qwen rod is not registered, keeping
the unqualified oss image route unambiguous. The public scrub gate and
`git diff --check` passed. The source-built fixture test was also attempted;
it could not compile this workspace's bashy/yoke sibling combination because
`fleet.NewSuperadminCmd` is absent from the checked-out yoke sibling, though
it is present in bashy's pinned module dependency. That build mismatch is
separate from the live image render and is not reported as a passing gate.
