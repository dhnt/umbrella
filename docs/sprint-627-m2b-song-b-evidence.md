# Sprint 627 M2b-song-b: offline OSS rods

Story `e013898155eb`. The rod fix binds ACE-Step to the staged
`BASHY_OSS_CACHE/bashy/oss/song-acestep/models/Ace-Step1.5` snapshot. Its
`--serve` launcher validates the required files, verifies that the checkout's
`checkpoints` path resolves to that snapshot, selects the turbo DiT and leaves
the LM disabled by default. An explicit `SONG_ACESTEP_LM=1.7B` requires its
staged weight. Renders reject an unmanaged server. The other OSS rods use
staged local paths and offline Hub, Transformers, ModelScope, uv and pip
controls. The optional Qwen image rod follows the same rule.

## Hermetic gate

`OSS_RODS_BASHY_BIN=<installed bashy> GOWORK=off go -C
bashy/examples/oss-rods test -count=1 ./...` passed on the development host.
The fixture asserts offline environment flags for every rod, checks the
ACE-Step server's checkpoint binding and LM default, and places failing stubs
for fetch commands before testing absent weights. No fixture reaches a model
or network. A source build of the fixture binary is blocked by the existing
workspace yoke sibling (`fleet.NewSuperadminCmd` missing), so this run used
the installed bashy binary; the rod scripts and Go test code are the candidate.

## Windows test host render

The claimed Windows test host reused its existing WSL ACE-Step checkout,
ROCm Python environment and checksum-verified staged snapshot. No package or
weight download was run. The new `--serve` path started the API with
`ACESTEP_INIT_LLM=false`, `ACESTEP_CONFIG_PATH=acestep-v15-turbo`, a
checkout `checkpoints` link to the staged snapshot, and the offline controls.
One 10-second instrumental render succeeded through the rod and produced a
1,920,044-byte WAV (SHA-256
`1b71105b3f1f1ad312ffdf95975af97c9660027653afd5e795511c6519cc8f63`).
A second render captured the complete 152-line server log and produced a
1,920,044-byte WAV (SHA-256
`f177868951ebd3eea5a7b9ef5d8dbe443c9ea7d63037668071324d419ffd884b`).
Both artifacts remain in the isolated host work area.

The captured server log (SHA-256
`703271ad0aed366d48a13c5e4c0510e873ff1c131fb6b035d3aec8a900f1f61b`)
contains **zero active download markers**: no `Downloading`, `ModelScope`,
`fetching`, `snapshot_download`, or `transfer` line. ACE-Step did emit two
`[Model Download] ... already exists` status lines for the staged DiT and VAE;
these are existence checks, not transfers. It also recorded
`ACESTEP_INIT_LLM=false` overriding GPU auto-selection and reported LM lazy
loading disabled. The server was stopped and the host claim released.
