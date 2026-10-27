#!/bin/zsh
set -euo pipefail
cd "$(dirname "$0")"
app="$PWD/build/WDYM.app"
mkdir -p "$app/Contents/MacOS" "$app/Contents/Resources"
xcrun swiftc -parse-as-library -target arm64-apple-macos26.0 -O \
  Sources/Core.swift Sources/WDYM.swift \
  -framework AppKit -framework SwiftUI -framework FoundationModels \
  -o "$app/Contents/MacOS/WDYM"
cp Assets/AppIcon.icns "$app/Contents/Resources/AppIcon.icns"
cat > "$app/Contents/Info.plist" <<'PLIST'
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0"><dict>
<key>CFBundleExecutable</key><string>WDYM</string>
<key>CFBundleIdentifier</key><string>dev.leechenghsiu.wdym</string>
<key>CFBundleDevelopmentRegion</key><string>en</string>
<key>CFBundleLocalizations</key><array><string>en</string></array>
<key>CFBundleName</key><string>wdym</string>
<key>CFBundleDisplayName</key><string>wdym?</string>
<key>CFBundlePackageType</key><string>APPL</string>
<key>CFBundleIconFile</key><string>AppIcon</string>
<key>CFBundleVersion</key><string>8</string>
<key>CFBundleShortVersionString</key><string>0.1.0</string>
<key>LSMinimumSystemVersion</key><string>26.0</string>
<key>LSUIElement</key><true/>
<key>NSPrincipalClass</key><string>NSApplication</string>
<key>NSHighResolutionCapable</key><true/>
</dict></plist>
PLIST
codesign --force --sign - "$app" > /dev/null 2>&1
echo "$app"
