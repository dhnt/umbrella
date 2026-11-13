# Sprint 627 M2b-transcribe: live OSS SRT

Story `9e5df5c4e139`. **Works:** the `transcribe-whisperx` rod produced one
476-byte SRT from the existing speech fixture through the service door on the
claimed Windows test host. The artifact remains in the host's isolated M2b
work area as `transcribe-story-203/transcript.srt`; no audio or weights are
committed. The claim was released after the run.

## Venue and preflight

Native Windows `bashy.exe` was checked first. Its PATH had neither `uv` nor
`ffmpeg`, and its WhisperX environment and checkpoint were not staged. These
dependencies could be installed, but doing so would provision a second Torch
stack and require copying the 3.09 GB staged checkpoint. The existing WSL
environment had WhisperX 3.8.6, `uv`, `ffmpeg`, and the M2b-w checkpoint, so
this CPU render reused it. No WSL configuration, default Podman machine, AWS
resource, or dev-host model was used. Host access used the direct mesh/LAN SSH
form. Native C: had 864,570,040,320 bytes free. The WSL cache volume had
189,547,456 KiB free at initial preflight, above the rod's 10 GiB threshold.

The staged `faster-whisper-large-v3/model.bin` was rechecked against M2b-w:
3,087,284,237 bytes, SHA-256
`69f74147e3334731bc3a76048724833325d2ec74642fb52620eda87352e3d4f1`.
The input fixture was 538,014 bytes, SHA-256
`a4bf9becd046d7aedb6d05b6e12347a6294a44f74d263089c636fb0a2b1e6561`.

## Render

The isolated command registry contained `transcribe-whisperx`. `bashy providers
select transcribe --provider transcribe-whisperx --route oss --json` selected
it. The service door then dispatched the selected rod with a v1 request for
English SRT. The rod's new `TRANSCRIBE_WHISPERX_MODEL` binding pointed at the
verified local directory and set WhisperX's `--model_cache_only True`;
`TRANSCRIBE_WHISPERX_NO_ALIGN=1` avoided an unstaged alignment model. Hugging
Face, Transformers, and Datasets offline flags were set. The run log showed
local Pyannote VAD and transcription, with no download markers.

The service door returned exit 0 in **27.02 s** wall time; its envelope
reported 26 s. `/usr/bin/time -v` recorded **4,048,260 KiB** maximum resident
memory (3.86 GiB). WSL free disk was 189,547,428 KiB immediately before and
189,547,388 KiB after dispatch, a 40 KiB decrease. The SRT has two cues,
covering 00:00:00,031–00:00:28,921 and 00:00:30,001–00:00:32,262, and
transcribes all ten spoken fixture sentences. With alignment disabled, cue
boundaries reflect Whisper segments rather than word alignment.

```json
{
  "cost_class": "oss",
  "elapsed": 26,
  "outcome": "success",
  "outputs": [{"media_type": "application/x-subrip", "path": "<Windows test host M2b work area>/transcript.srt"}],
  "provider": "transcribe-whisperx",
  "role": "transcribe",
  "route": "oss",
  "schema_version": "bashy-svc-v1",
  "text": "M2b transcribe fixture"
}
```

The door's temporary output was copied to the isolated host work area and
rechecked there. Artifact SHA-256:
`b35c497964b0cb3e878d9f97c926d606ff7f25a06df1ef0c02f620708551e860`.

## Verification limit

The live render verified the local-model binding and the v1 envelope. The
focused Go rod suite could not build in this workspace: the sibling yoke pin
lacks `fleet.NewSuperadminCmd`, which bashy currently imports. This is the
known stale-sibling build condition from the M2b-image run, not a WhisperX
failure. `git diff --check` and the public scrub gate passed for this delivery.
