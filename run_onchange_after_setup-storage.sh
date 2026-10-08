#!/data/data/com.termux/files/usr/bin/sh
set -eu

# Only execute on Android/Termux
if ! command -v termux-setup-storage >/dev/null 2>&1; then
  exit 0
fi

# If neither ~/storage nor ~/sd exists, invoke termux-setup-storage
if [ ! -e "$HOME/storage" ] && [ ! -e "$HOME/sd" ]; then
  echo "==> Requesting Android storage permission via termux-setup-storage..."
  termux-setup-storage
  # Wait up to 5 seconds for storage directory creation
  for i in 1 2 3 4 5; do
    [ -e "$HOME/storage" ] && break
    sleep 1
  done
fi

# Rename ~/storage to ~/sd if it is a real directory created by termux-setup-storage
if [ -d "$HOME/storage" ] && [ ! -L "$HOME/storage" ]; then
  if [ ! -e "$HOME/sd" ]; then
    echo "==> Renaming ~/storage to ~/sd..."
    mv "$HOME/storage" "$HOME/sd"
  fi
  # Maintain ~/storage as a symlink to ~/sd for backwards compatibility
  ln -sfn "$HOME/sd" "$HOME/storage"
fi

# Resolve shared storage directory
SHARED_DIR=""
if [ -d "$HOME/sd/shared" ]; then
  SHARED_DIR="$HOME/sd/shared"
elif [ -d "/sdcard" ]; then
  SHARED_DIR="/sdcard"
  [ ! -e "$HOME/sd" ] && ln -sfn /sdcard "$HOME/sd"
fi

if [ -n "$SHARED_DIR" ]; then
  # Ensure target directories exist on shared storage
  mkdir -p "$SHARED_DIR/Documents"
  mkdir -p "$SHARED_DIR/Pictures/Wallpapers"
  mkdir -p "$SHARED_DIR/Backups"
  mkdir -p "$SHARED_DIR/DCIM/Camera"

  # Create convenient short symlinks in $HOME
  ln -sfn "$SHARED_DIR/Documents" "$HOME/doc"
  ln -sfn "$SHARED_DIR/Pictures" "$HOME/img"
  ln -sfn "$SHARED_DIR/Backups" "$HOME/bak"
  ln -sfn "$SHARED_DIR/DCIM/Camera" "$HOME/dcim"

  # Screenshot directory (DCIM/Screenshots or Pictures/Screenshots)
  if [ -d "$SHARED_DIR/Pictures/Screenshots" ]; then
    ln -sfn "$SHARED_DIR/Pictures/Screenshots" "$HOME/ss"
  elif [ -d "$SHARED_DIR/DCIM/Screenshots" ]; then
    ln -sfn "$SHARED_DIR/DCIM/Screenshots" "$HOME/ss"
  else
    mkdir -p "$SHARED_DIR/DCIM/Screenshots"
    ln -sfn "$SHARED_DIR/DCIM/Screenshots" "$HOME/ss"
  fi
fi

# Ensure wallpaper script is accessible globally in $PREFIX/bin
if [ -d "${PREFIX:-/data/data/com.termux/files/usr}/bin" ]; then
  ln -sfn "$HOME/.local/bin/wallpaper" "${PREFIX:-/data/data/com.termux/files/usr}/bin/wallpaper"
fi
