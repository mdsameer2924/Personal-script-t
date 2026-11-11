#!/bin/bash
set -euo pipefail

# --- Embedded Module: package_script.sh ---
if command -v apt-get >/dev/null 2>&1; then
  PKG_MANAGER="apt"
elif command -v dnf >/dev/null 2>&1; then
  PKG_MANAGER="dnf"
elif command -v pacman >/dev/null 2>&1; then
  PKG_MANAGER="pacman"
elif command -v pkg >/dev/null 2>&1; then
  PKG_MANAGER="termux"
else
  echo "Error: No supported package manager found (apt, dnf, pacman, pkg)." >&2
  exit 1
fi
Ins() {
  local tool=$@
  for i in $tool; do
    sudo "$PKG_MANAGER" install $i -y || "$PKG_MANAGER" install $i -y
  done
}

updte() {
  sudo "$PKG_MANAGER" update || "$PKG_MANAGER" update
}

try_manual() {
  local tool="$1"
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
log_info "Internet connection checking wait..."
echo "....:"
sleep 1
echo "....:"
if ping -c 1 -W 1 www.google.com >/dev/null 2>&1; then
  log_ok "internet connection found..."
  echo "now continue"
else
  exit 1
fi

tool_installation() {
  local tools="$@"
  for tool in $tools; do
    if ! which $tool >/dev/null 2>&1; then
      log_info "$tool is Not installed. wait it's installing..."
      if Ins $tool >/dev/null 2>&1; then
        log_ok "$tool successfully installed"
      else
        log_err "failed to install"
        try_manual $tool
      fi
    else
      log_info "found ${tool}: installation skip!"
    fi
  done
}
tool_installation "git" "wget" "curl" "fzf" "nodejs" "npm" "neovim"
## let's install neovim before fetch latest file
## <code tha yaha par >

## let's setup nvim now
log_info "wait nvim configuration..."
wget https://github.com/mdsameer2924/Personal-script-t/raw/refs/heads/main/neovim_setup/dist/nvim_setup.tar.gz
tar -xvzf nvim_setup.tar.gz
mv nvim ~/.config/nvim
log_ok "successfully all setup done"
rm nvim_setup.tar.gz
