#!/usr/bin/env bash
source ./system_package.sh
<<Comment
Start working now 
Comment

set -eou pipefail

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
  local install_app="$2"
  if ! which "$tool" >/dev/null 2>&1; then
    log_info "$tool is Not installed. wait it's installing..."
    "$install_app" ## here use as a flag while calling which is eg: get_git get_nevim etc
  else
    log_info "found ${tool}: installation skip!"
  fi
}

update_system() {
  log_info "wait system is updating..."
  sudo apt update -y >/dev/null 2>&1 || pkg update -y >/dev/null 2>&1 || sudo dnf update -y >/dev/null 2>&1
  log_ok "sucessfully udpate now resume further process..."
}

get_git() {
  if Ins "sl" >/dev/null 2>&1; then
    log_ok "sl successfully installed"
  else
    log_err "failed to install"
    try_manual "sl"
  fi
}

check_tool_installation "sl" "get_git"
