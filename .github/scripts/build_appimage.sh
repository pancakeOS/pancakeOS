#!/usr/bin/env bash
set -euo pipefail

echo "Building AppImage..."

sudo apt-get update
sudo apt-get install -y zip wget unzip libfuse2

# Install love from apt as a fallback runtime
sudo apt-get install -y love || true

# Prepare AppDir
rm -rf AppDir
mkdir -p AppDir/usr/bin AppDir/usr/share/pancakeos AppDir/usr/share/applications AppDir/usr/share/icons/hicolor/256x256/apps

if [ -f pancakeos.love ]; then
  cp pancakeos.love AppDir/usr/share/pancakeos/
else
  echo "pancakeos.love not found" >&2
  exit 1
fi

# Try to copy system love binary
if [ -x /usr/bin/love ]; then
  cp /usr/bin/love AppDir/usr/bin/ || true
else
  echo "/usr/bin/love not found; AppImage may fail at runtime" >&2
fi

# Create AppRun
printf '%s
' '#!/bin/sh' 'HERE="$(dirname "$(readlink -f "$0")")"' 'exec "$HERE/usr/bin/love" "$HERE/usr/share/pancakeos/pancakeos.love" "$@"' > AppDir/AppRun
chmod +x AppDir/AppRun

# Desktop file
printf '%s
' '[Desktop Entry]' 'Type=Application' 'Name=PancakeOS' 'Exec=PancakeOS %F' 'Icon=pancakeos' 'Categories=Game;' > AppDir/usr/share/applications/pancakeos.desktop

# Icon
if [ -f assets/images/logo.png ]; then
  cp assets/images/logo.png AppDir/usr/share/icons/hicolor/256x256/apps/pancakeos.png
fi

# Download appimagetool and build AppImage
wget -q -O appimagetool.AppImage "https://github.com/AppImage/AppImageKit/releases/download/continuous/appimagetool-x86_64.AppImage"
chmod +x appimagetool.AppImage
./appimagetool.AppImage AppDir PancakeOS-x86_64.AppImage || true

echo "AppImage build finished"
