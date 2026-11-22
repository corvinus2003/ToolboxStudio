# Mac App Store edition

The same source code builds two editions:

| | Full edition (Unboxed) | App Store edition |
| --- | --- | --- |
| Built with | `scripts/build-app.sh` | this folder (Xcode project) |
| Download node (yt-dlp) | yes | no: the App Store doesn't allow downloading from YouTube or running downloaded programs |
| Sandbox | no | yes, with security-scoped bookmarks so saved graphs reopen their files |
| Bundle ID | `app.toolboxpromax` (kept from the old name) | `io.github.corvinus2003.toolbox` (can never change once published) |
| Name | Toolbox Studio Unboxed (was Toolbox Pro Max) | Toolbox Studio |
| Distributed | GitHub releases, free | Mac App Store |

The difference is the `APPSTORE` compilation flag (see `Sources/ToolboxProMax/App/Edition.swift`).
Nothing in this folder affects the full edition.

## Build

```sh
brew install xcodegen                         # once
xcodegen generate --spec AppStore/project.yml # creates AppStore/ToolboxAppStore.xcodeproj
open AppStore/ToolboxAppStore.xcodeproj
```

The display name is the `APP_DISPLAY_NAME` setting in `project.yml`; the version is `MARKETING_VERSION`.
Archive with the "Any Mac" destination to get a universal (Apple Silicon + Intel) build.

## Store page

- Texts to paste: [metadata/en-US.md](metadata/en-US.md)
- Screenshots (2880×1800, no alpha): [screenshots/](screenshots/), remade with `scripts/appstore-shots/`
- Privacy policy: [docs/privacy.md](../docs/privacy.md)

## Upload

```sh
scripts/appstore-upload.sh            # signed package in build/appstore/export
scripts/appstore-upload.sh --upload   # same, then upload to App Store Connect
```

Export manages the build number: it raises it past the last uploaded build on its own.

## App Store Connect

| | |
| --- | --- |
| App ID | 6837013838 |
| Status | 1.0 (1) waiting for review, submitted 2026-11-20 |
| TestFlight | internal group "Toolbox Studio Beta Test"; external group "Public Beta" (build 1 in Beta App Review) |
| TestFlight public link | https://testflight.apple.com/join/rqpNUcHA (opens once the beta build is approved) |
| Support / Marketing URL | https://github.com/corvinus2003/ToolboxStudio |

## Publishing checklist

In Xcode
- [x] Xcode ▸ Settings ▸ Accounts: signed in with the developer Apple ID
- [x] Team set (`DEVELOPMENT_TEAM` in `project.yml`)
- [x] Archive and upload (now `scripts/appstore-upload.sh --upload`)

In App Store Connect
- [x] New macOS app "Toolbox Studio", bundle ID `io.github.corvinus2003.toolbox`
- [x] Description, keywords, screenshots, support and marketing URL, privacy policy URL
- [x] App Privacy "Data Not Collected"; age rating
- [x] Build submitted for review (free)
- [x] TestFlight: test information, internal and external groups, public link
- [ ] If the app becomes paid: Paid Applications Agreement, banking and tax, DSA trader status, price
