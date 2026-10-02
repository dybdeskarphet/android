#!/data/data/com.termux/files/usr/bin/sh
set -eu

if command -v fish >/dev/null 2>&1; then
    FISH_BIN="$(command -v fish)"
    echo "==> Setting default Termux shell to fish ($FISH_BIN)..."
    chsh -s fish || echo "$FISH_BIN" > "$HOME/.termux/shell"
fi
