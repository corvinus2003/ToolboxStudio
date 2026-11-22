# Toolbox Studio

**Wire up media tools like building blocks, on your Mac.** Drop in photos, videos, sound or PDFs, connect
tools with wires and watch every step update live. Press ⌘R and the finished files land in a folder.

![macOS 26+](https://img.shields.io/badge/macOS-26%2B-black?logo=apple)
![SwiftUI](https://img.shields.io/badge/SwiftUI-native-orange?logo=swift&logoColor=white)
![License: MIT](https://img.shields.io/badge/license-MIT-blue)
![Mac App Store: in review](https://img.shields.io/badge/Mac%20App%20Store-in%20review-0D96F6)

![Toolbox Studio: a photo dithered with a sunset palette and redrawn as ASCII art, with the live preview in the inspector](AppStore/screenshots/1-photo.png)

## How it came about

Toolbox Studio came from an idea by my friend Cojo ([MinuneIonel](https://github.com/MinuneIonel) on GitHub).
It started under the name **Toolbox Pro Max** and was written from scratch as a native SwiftUI app for the Mac.

C++ olympiads and contests, the trenches, are what let me build software this way now, without writing
the code myself. Toolbox Studio was made with
[Claude Code](https://claude.com/claude-code), Anthropic's AI coding agent. I decided what it should do,
made the design decisions, followed and checked the code, tested it on my Mac and published it, including
the Mac App Store submission. Claude wrote the code. Before each release a built-in self-test runs every
node on sample photos, video, sound and PDFs.

On 20 November 2026 the app went to Apple for review. It comes in two editions, built from the same code
in this repository:

| | **Toolbox Studio Unboxed** (this page) | **Toolbox Studio** (Mac App Store) |
| --- | --- | --- |
| Price | Free and open source | Free |
| Install | Download the DMG, allow it once in System Settings | One click from the App Store, updates on their own |
| Signed by | Ad hoc (no paid certificate) | Apple, after App Review |
| Downloads from YouTube & co. | Yes, with the Download node | No, the App Store doesn't allow it |
| Runs on | Apple Silicon, macOS 26 | Apple Silicon and Intel, macOS 26 |
| Everything else | Same nodes, same canvas, same results | Same nodes, same canvas, same results |

**Unboxed** because it lives outside the App Store's sandbox, which is what lets it download from the web.
The App Store link goes here as soon as Apple approves it. Until then you can try the App Store edition through [TestFlight](https://testflight.apple.com/join/rqpNUcHA) (the link opens once Apple approves the beta build).

## Download

Get `Toolbox-Studio-Unboxed-0.2.0.dmg` from [Releases](../../releases).

- **Needs** a Mac with Apple Silicon (M1 or newer) and **macOS 26 Tahoe** or newer.
- This build isn't signed with a paid certificate, so macOS asks once. Drag Toolbox Studio Unboxed into
  Applications and open it. When macOS says it can't check the app, open
  **System Settings → Privacy & Security**, scroll down and click **Open Anyway**.
  (Prefer no warnings at all? Toolbox Studio from the App Store installs normally.)
- Coming from Toolbox Pro Max 0.1? Your saved graph carries over. You can delete the old app afterwards.

## What it can do

| | Nodes |
| --- | --- |
| **Inputs** | Image, Several Images (files or a folder), Video, Audio, PDF, Text, Download (YouTube, Vimeo, SoundCloud… via yt-dlp) |
| **Image** | Resize, Crop, Rotate & Flip, Adjust, Dither (retro palettes), ASCII Art, Lift Subject (removes the background, on device) |
| **Video** | Trim Video, Grab Frame. Every Image node also works on a video, frame by frame |
| **Audio** | Extract Audio, Trim Audio, Fade, Normalize, Mix to Mono |
| **PDF** | Merge, Pick Pages, Watermark, Page Numbers, Images to PDF, PDF to Images |
| **Text** | Read Text (on-device text recognition for photos and scanned PDFs), ASCII to Text |
| **Export** | Image (JPEG, HEIC, PNG, TIFF), Video (H.264, HEVC, ProRes 422, GIF, or no re-encode), Audio (M4A, Apple Lossless, WAV, AIFF), PDF (optional password, compression), Text |

Also: 10 ready-made workflows (8 in Toolbox Studio, without the two YouTube ones), undo and redo, autosave,
light and dark mode.

## Private by design

Everything runs on your Mac. No account, no analytics, no tracking. Toolbox Studio doesn't touch the
network at all; Toolbox Studio Unboxed only does when you use the Download node.
[Privacy policy](docs/privacy.md).

## About the size

The disk image is **2.3 MB**. Toolbox Studio only runs on recent Macs and uses what macOS already ships
(Core Image, AVFoundation, Vision and PDFKit), so it doesn't need to bundle its own browser engine or ffmpeg.

## What's tested, and what isn't

Tested, on one Mac (Apple Silicon, macOS 26):
- A built-in self-test runs every node on generated media (photo, video, sound, PDF) and writes each export
  format: 25 chains, all passing. It includes a real YouTube download, video and sound-only.
- By hand: building graphs, connecting and moving nodes, zoom, live previews, the inspector, Render.
- The App Store edition in its sandbox: opening dropped files, saving to Downloads, reopening a saved graph
  after a restart.

Not tested yet: Intel Macs (the App Store build includes Intel code, but no Intel Mac has run it), other
people's Macs, very long or very large files, and a wide range of real-world formats.

## Known limitations

- No WebP, AVIF or MP3 export, no webcam input, no Romanian diacritics tool.
- YouTube downloads go up to 1080p H.264. VP9/AV1-only formats aren't used.
- The first accurate text recognition after each launch takes about 25 seconds while macOS loads its
  model. Live previews use the fast model in the meantime.
- GIF export stops at 900 frames.
- Unboxed has no automatic updates yet: Help → Check for Updates opens the releases page.
- The Download node fetches yt-dlp from its GitHub releases the first time, checks it against the published
  SHA-256 and refreshes it weekly. Only download things you have the right to.

## Build from source

Needs Xcode 26 or newer.

```sh
./scripts/build-app.sh   # → build/Toolbox Studio Unboxed.app and build/Toolbox-Studio-Unboxed-<version>.dmg
swift run                # quick run from source (no icon)
```

Self-test, which makes sample media, runs every node and writes the results:

```sh
.build/debug/ToolboxProMax --selftest /tmp/tpm-test
.build/debug/ToolboxProMax --selftest /tmp/tpm-test --download "https://www.youtube.com/watch?v=jNQXAC9IVRw"
```

The App Store edition is an Xcode project generated from `AppStore/project.yml`. It compiles the same sources
with an `APPSTORE` flag that switches on the sandbox and leaves the Download node out.
See [AppStore/README.md](AppStore/README.md).

## How it fits together

- `Model/Catalog.swift` defines every node: its ports, its settings and what it does.
- `Engine/` does the processing (`ImageOps`, `Dither`, `ASCII`, `VisionOps`, `VideoOps`, `AudioOps`, `PDFOps`, `Downloader`).
- `Engine/Evaluator.swift` runs the graph and caches each node's result by a fingerprint of its settings and
  everything upstream, so moving a slider only recomputes what comes after it.
- Image effects are closures `(CIImage, scale) -> CIImage`. They're applied once to a still, or plugged into an
  `AVVideoComposition` for video. `scale` keeps pixel-sized effects identical between preview and render.
- YouTube serves picture and sound as separate fragmented MP4s whose timestamps AVFoundation reads at twice
  their length. Normally ffmpeg fixes that up. Here they're joined without re-encoding, and the picture's
  timing is recomputed from its frame count.
- `App/Edition.swift` holds the one switch between the two editions.

## License

[MIT](LICENSE): use it, change it, share it, just keep the copyright notice.
yt-dlp, which the Download node fetches on first use, is a separate project under its own license (Unlicense).
