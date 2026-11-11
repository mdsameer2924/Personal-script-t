#!/usr/bin/env bash
set -eou pipefail

Red="\033[91m"
Green="\033[92m"
Cyan="\033[96m"
Reset="\033[0m"

log_ok() {
  echo -e "${Green}[ OK ]${Reset} $1"
}
log_info() {
  echo -e "${Cyan}[INFO]${Reset} $1"
}
log_err() {
  echo -e "${Red}[FAIL]${Reset} $1"
}

# --- Detect Package Manager (matching your installer logic) ---
if command -v apt-get >/dev/null 2>&1; then
  PKG_MANAGER="apt"
elif command -v dnf >/dev/null 2>&1; then
  PKG_MANAGER="dnf"
elif command -v pacman >/dev/null 2>&1; then
  PKG_MANAGER="pacman"
elif command -v pkg >/dev/null 2>&1; then
  PKG_MANAGER="termux"
else
  PKG_MANAGER=""
fi

log_info "Starting cleanup and reversal of Neovim setup script..."

# 1. Remove Neovim binary placed in /usr/bin (for GNU/Linux)
if [[ -f /usr/bin/nvim ]]; then
  log_info "Removing Neovim binary from /usr/bin..."
  sudo rm -f /usr/bin/nvim
  log_ok "Neovim binary removed."
fi

# 2. Remove extracted /opt folder artifacts if they exist
if [[ -d /opt/nvim-linux-x86_64 ]]; then
  log_info "Removing extracted folder from /opt..."
  sudo rm -rf /opt/nvim-linux-x86_64
  log_ok "/opt/nvim-linux-x86_64 cleaned up."
fi

# 3. Remove Neovim configuration directory (~/.config/nvim)
if [[ -d ~/.config/nvim ]]; then
  log_info "Removing Neovim configuration directory (~/.config/nvim)..."
  rm -rf ~/.config/nvim
  log_ok "Neovim config removed."
fi

# 4. Remove downloaded archives and tarballs from the working directory
log_info "Cleaning up downloaded local archives and tarballs..."
rm -f nvim-linux-x86_64.tar.gz
rm -f nvim_setup.tar.gz
log_ok "Archives cleaned up."

# 5. Uninstall tools installed via package manager (git, fzf, nodejs, npm, neovim)
if [[ -n "$PKG_MANAGER" ]]; then
  log_info "Uninstalling packages installed by setup script via $PKG_MANAGER..."

  if [[ "$PKG_MANAGER" == "apt" ]]; then
    sudo apt purge git fzf nodejs npm neovim -y >/dev/null 2>&1 || true
    sudo apt autoremove -y >/dev/null 2>&1 || true
  elif [[ "$PKG_MANAGER" == "dnf" ]]; then
    sudo dnf remove git fzf nodejs npm neovim -y >/dev/null 2>&1 || true
  elif [[ "$PKG_MANAGER" == "pacman" ]]; then
    sudo pacman -R --noconfirm git fzf nodejs npm neovim >/dev/null 2>&1 || true
  elif [[ "$PKG_MANAGER" == "termux" ]]; then
    pkg uninstall git fzf nodejs npm neovim -y >/dev/null 2>&1 || true
  fi

  log_ok "Package manager cleanup completed."
else
  log_err "No supported package manager found to uninstall dependencies."
fi

log_ok "All setup effects have been completely reversed and cleaned up!"
