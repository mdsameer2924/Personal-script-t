#!/bin/bash
set -euo pipefail

# --- Embedded Module: package_script.sh ---
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
  sudo "$PKG_MANAGER" install "$package" -y || "$PKG_MANAGER" install "$package" -y
}

updte() {
  sudo "$PKG_MANAGER" update || "$PKG_MANAGER" update
}

try_manual() {
  local tool=$1
  echo "try to install manually look  below command just paste into terminal!"
  echo "sudo $PKG_MANAGER install $tool" || echo "$PKG_MANAGER install $tool"
}

# --- Main Entrypoint: main.sh ---
<<Comment
Start working now 
Comment

RESET="\033[0m"

# Modules
log_ok() {
  local GREEN="\033[92m"
  echo -e "${GREEN}[ OK ]${RESET} $1"
}
log_info() {
  local CYAN="\033[96m"
  echo -e "${CYAN}[INFO]${RESET} $1"
}
log_warn() {
  local YELLOW="\033[93m"
  echo -e "${YELLOW}[WARN]${RESET} $1"
}
log_err() {
  local RED="\033[91m"
  echo -e "${RED}[FAIL]${RESET} $1"
}

check_tool_installation() {
  local tool="$1"
  if ! which "$tool" >/dev/null 2>&1; then
    log_info "$tool is Not installed. wait it's installing..."
    if Ins "$tool" >/dev/null 2>&1; then
      log_ok "$tool successfully installed"
    else
      log_err "failed to install"
      try_manual "$tool"
    fi
  else
    log_info "found ${tool}: installation skip!"
  fi
}

update_system() {
  log_info "wait system is updating..."
  sudo apt update -y >/dev/null 2>&1 || pkg update -y >/dev/null 2>&1 || sudo dnf update -y >/dev/null 2>&1
  log_ok "sucessfully udpate now resume further process..."
}

check_tool_installation "cmatrix"
