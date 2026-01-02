#!/usr/bin/env bash
set -e

APPIMAGE="ContextokenizeX.AppImage"

echo "== ContextokenizeX installer =="

# --- check AppImage exists ---
if [[ ! -f "$APPIMAGE" ]]; then
    echo "[ERROR] $APPIMAGE not found in current directory"
    exit 1
fi

# --- make executable ---
if [[ ! -x "$APPIMAGE" ]]; then
    echo "[INFO] Making $APPIMAGE executable"
    chmod +x "./$APPIMAGE"
fi

# --- check FUSE ---
echo "[INFO] Checking FUSE support..."
if ! command -v fusermount >/dev/null 2>&1 && ! command -v fusermount3 >/dev/null 2>&1; then
    echo "[WARN] FUSE not found"
    echo "       Required to run AppImage"
    echo
    echo "Ubuntu 22.04+:"
    echo "  sudo apt install fuse"
    echo "  or"
    echo "  sudo apt install libfuse2"
    echo
    echo "Fallback (no FUSE):"
    echo "  ./$APPIMAGE --appimage-extract"
    echo "  ./squashfs-root/usr/bin/ContextokenizeX"
else
    echo "[OK] FUSE available"
fi

# --- check OpenGL ---
echo "[INFO] Checking OpenGL (libOpenGL.so.0)..."
if ! ldconfig -p 2>/dev/null | grep -q "libOpenGL.so.0"; then
    echo "[WARN] libOpenGL.so.0 not found"
    echo
    echo "Ubuntu 24.04:"
    echo "  sudo apt install libgl1-mesa-dev"
    echo "  or"
    echo "  sudo apt install libgl1-mesa-dri libegl1 libglx-mesa0"
else
    echo "[OK] OpenGL libraries found"
fi

# --- launch ---
echo
echo "[INFO] Launching ContextokenizeX..."
echo "       If you see display issues, try:"
echo "       ./$APPIMAGE --platform xcb"
echo

"./$APPIMAGE" || {
    echo
    echo "[WARN] Failed to launch normally"
    echo "Trying X11 fallback (--platform xcb)..."
    "./$APPIMAGE" --platform xcb
}
