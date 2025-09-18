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
# Try to copy system love binary; if not available bundle official Love2D runtime
if [ -x /usr/bin/love ]; then
  cp /usr/bin/love AppDir/usr/bin/ || true
else
  echo "/usr/bin/love not found; bundling Love2D runtime into AppDir" >&2
  # Download official Love2D Linux runtime (x86_64) and extract
  LOVEDIR=love-runtime
  rm -rf "$LOVEDIR" && mkdir -p "$LOVEDIR"
  wget -q -O love.tgz "https://github.com/love2d/love/releases/download/11.5/love-11.5-x86_64.tar.gz"
  tar xzf love.tgz -C "$LOVEDIR" --strip-components=1
  # Place libs and binary under AppDir/usr
  mkdir -p AppDir/usr/lib AppDir/usr/bin
  cp -r "$LOVEDIR"/* AppDir/usr/lib/ || true
  # The extracted runtime typically contains a 'love' binary at usr/bin/love or similar
  if [ -f AppDir/usr/lib/usr/bin/love ]; then
    cp AppDir/usr/lib/usr/bin/love AppDir/usr/bin/love
  elif [ -f AppDir/usr/lib/bin/love ]; then
    cp AppDir/usr/lib/bin/love AppDir/usr/bin/love
  else
    echo "Bundled love binary not found in runtime archive" >&2
  fi
  # Create a wrapper that sets LD_LIBRARY_PATH to bundled libs
  printf '%s
' '#!/bin/sh' 'HERE="$(dirname "$(readlink -f "$0")")"' 'export LD_LIBRARY_PATH="$HERE/../lib:$LD_LIBRARY_PATH"' 'exec "$HERE/love" "$@"' > AppDir/usr/bin/love-wrapper
  chmod +x AppDir/usr/bin/love-wrapper
  # Ensure AppRun will call the wrapper instead of system love
  mv AppDir/usr/bin/love-wrapper AppDir/usr/bin/love || true
fi

# Create AppRun
printf '%s
' '#!/bin/sh' 'HERE="$(dirname "$(readlink -f "$0")")"' 'exec "$HERE/usr/bin/love" "$HERE/usr/share/pancakeos/pancakeos.love" "$@"' > AppDir/AppRun
chmod +x AppDir/AppRun

# Desktop file (create both the standard applications path and a top-level .desktop file AppImage expects)
printf '%s
' '[Desktop Entry]' 'Type=Application' 'Name=PancakeOS' 'Exec=AppRun %F' 'Icon=pancakeos' 'Categories=Game;' > AppDir/usr/share/applications/pancakeos.desktop
cp AppDir/usr/share/applications/pancakeos.desktop AppDir/pancakeos.desktop

# Icon
if [ -f assets/images/logo.png ]; then
  cp assets/images/logo.png AppDir/usr/share/icons/hicolor/256x256/apps/pancakeos.png
  # also copy a top-level icon AppImage can discover
  cp assets/images/logo.png AppDir/pancakeos.png
fi

# Download appimagetool and build AppImage
wget -q -O appimagetool.AppImage "https://github.com/AppImage/AppImageKit/releases/download/continuous/appimagetool-x86_64.AppImage"
chmod +x appimagetool.AppImage
# Try running appimagetool normally first, capture output; fall back to extract-and-run
set +e
echo "Running appimagetool (normal mode)..."
./appimagetool.AppImage AppDir PancakeOS-x86_64.AppImage 2>&1 | tee appimagetool.log
RET=$?
if [ $RET -ne 0 ]; then
  echo "appimagetool normal run failed with exit code $RET, trying extract-and-run fallback..."
  ./appimagetool.AppImage --appimage-extract-and-run AppDir PancakeOS-x86_64.AppImage 2>&1 | tee -a appimagetool.log
  RET2=$?
  if [ $RET2 -ne 0 ]; then
    echo "appimagetool extract-and-run also failed (exit $RET2). See appimagetool.log:" >&2
    tail -n 200 appimagetool.log >&2 || true
    exit $RET2
  fi
fi
set -e

echo "AppImage build finished"
