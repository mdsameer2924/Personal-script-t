#!/bin/bash
source ./setup.sh
if command -v apt-get >/dev/null 2>&1; then
  PKG_MANAGER="apt"
  INSTALL_CMD="sudo apt update && sudo apt install -y"
elif command -v dnf >/dev/null 2>&1; then
  PKG_MANAGER="dnf"
  INSTALL_CMD="sudo dnf install -y"
elif command -v pacman >/dev/null 2>&1; then
  PKG_MANAGER="pacman"
  INSTALL_CMD="sudo pacman -S --noconfirm"
elif command -v pkg >/dev/null 2>&1; then
  PKG_MANAGER="termux"
  INSTALL_CMD="pkg install -y"
else
  echo "Error: No supported package manager found (apt, dnf, pacman, pkg)." >&2
  exit 1
fi
Ins() {
  local package="$1"
  sudo "$PKG_MANAGER" install "$package" || "$PKG_MANAGER" install "$package"
}

updte() {
  sudo "$PKG_MANAGER" update || "$PKG_MANAGER" update
}

try_manual() {
  local tool=$1
  echo "try to install manually look  below command just paste into terminal!"
  echo "sudo $PKG_MANAGER install $tool" || echo "$PKG_MANAGER install $tool"
}
