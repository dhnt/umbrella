# Product marks

One family of squares and circles for the dhnt products, selected in Sprint 622
(story L1) from the concept board in [`concepts/`](concepts/).
The **Shape** action keeps its own Flow mark ([design archive](https://github.com/qiangli/bashy/blob/main/docs/software-shaping-design/README.md)).

| Mark | Product | Shape |
|---|---|---|
| ![cloudbox](cloudbox/cloudbox-48.png) | **cloudbox**, the master | A square held in a circle |
| ![satellite](satellite/satellite-48.png) | **satellite** | The cloudbox square on a 45° orbit, with a violet body at the orbit's upper end |
| ![outpost](outpost/outpost-48.png) | **outpost** | A small outlined square and a larger violet tile stacked up the 45° diagonal |
| ![bashy](bashy/bashy-48.png) | **bashy** | Four squares in a circle like an app grid; the top-right one, turned and violet, is the app you shaped |

## Rules

- **One axis.** Every mark mirrors onto itself across the 45° line from bottom-left to top-right.
- **One square.** The main square is 24 units on the 64-unit grid in cloudbox, satellite and outpost.
- **Shape before color.** Each mark is recognizable at 16 px in one color, and violet (`#6D4AFF`, dark `#9C85FF`) is only an extra cue. Cloudbox and satellite differ by shape, so they can be told apart in a browser tab.
- **Hand-drawn geometry.** The SVGs are written by hand; the PNGs are derived from them.

## Files (per mark)

| File | Use |
|---|---|
| `NAME.svg` | Color, for light surfaces |
| `NAME-dark.svg` | Color, for dark surfaces |
| `NAME-mono.svg` | One color, black on white |
| `NAME-icon.svg` | App icon: the mark on a white rounded tile |
| `NAME-{16,32,48,180,192,512}.png` | App icon rasters (180 is the Apple touch icon, 192 and 512 are for web manifests) |
| `favicon.ico` | 16, 32 and 48 px icons in one file |
| `SHA256SUMS` | `shasum -a 256 -c SHA256SUMS` |

PNGs are rendered from `NAME-icon.svg` at 1024 px by headless Chrome, then downsampled with Catmull-Rom.
