#!/bin/zsh
# Builds the signed Mac App Store package of Toolbox Studio (build/appstore/export).
# With --upload it also sends the build to App Store Connect (TestFlight and review),
# using the Apple ID signed in to Xcode (Settings > Accounts).
# Raise CURRENT_PROJECT_VERSION in AppStore/project.yml before every new upload.
set -euo pipefail
cd "$(dirname "$0")/.."

xcodegen generate --spec AppStore/project.yml >/dev/null

ARCHIVE=build/appstore/Toolbox.xcarchive
rm -rf "$ARCHIVE" build/appstore/export
mkdir -p build/appstore

xcodebuild archive -project AppStore/ToolboxAppStore.xcodeproj -scheme Toolbox -configuration Release \
  -destination 'generic/platform=macOS' -archivePath "$ARCHIVE" -allowProvisioningUpdates | grep -E "error:|ARCHIVE"

OPTIONS=AppStore/ExportOptions.plist
if [[ "${1:-}" == "--upload" ]]; then
  OPTIONS=$(mktemp -t toolbox-export).plist
  sed 's#<string>export</string>#<string>upload</string>#' AppStore/ExportOptions.plist > "$OPTIONS"
fi

xcodebuild -exportArchive -archivePath "$ARCHIVE" -exportOptionsPlist "$OPTIONS" \
  -exportPath build/appstore/export -allowProvisioningUpdates | grep -E "error|EXPORT|Upload"
echo "Package: $PWD/build/appstore/export"
