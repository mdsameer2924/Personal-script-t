#!/usr/bin/env bash

<<bootstrap
this script for setup which work on setup environment and ready for 
preqeusites for crypt key 
bootstrap

set -eou pipefail ## exception handling

Red="\033[91m"
Green="\033[92m"
Cyan="\033[96m"
Yellow="\033[93m"
Reset="\033[0m"

## module for logging
log_err() {
  echo -e "${Red}[FAIL]${Reset} $1"
}

log_ok() {
  echo -e "${Green}[ OK ]${Reset} $1"
}

log_info() {
  echo -e "${Cyan}[ .. ]${Reset} $1"
}

log_warn() {
  echo "${Yellow}[WARN]${Reset} $1"
}
prepare() {
  log_warn "$1"
  sleep 0.5
  echo "....."
  sleep 0.5
  echo "....."
  log_info "$2"

}

setup_bin_path() {
  mkdir -p ~/bin
  echo 'export PATH="$HOME/bin:$PATH"' >>~/.bashrc
  source ~/.bashrc
  log_ok "User bin path successfully setup!."
}
log_info "Checking Internet Connection..."
sleep 0.5
echo "....."
sleep 0.8
echo "....."
if ! ping -c 1 -W 2 www.google.com >/dev/null 2>&1; then
  log_err "Please connect to internet then try again!"
  exit 1
else
  log_ok "Internet connection found"
fi

# before learn anything start update system
log_info "System is updating wait"
if sudo apt update 2>/dev/null || pkg update 2>/dev/null || sudo dnf update 2>/dev/null; then
  log_ok "system updated now it's time to install depedency"
else
  log_err "Error something wrong please fix your package manager apt"
fi

if ! which git >/dev/null 2>&1; then
  prepare "git is not installed" "wait for while it's installing"
  sudo apt install git -y >/dev/null 2>&1 || pkg install git -y >/dev/null 2>&1 || sudo dnf install git -y >/dev/null 2>&1
  log_ok "git installation complete"
else
  log_info "git found installed"
fi

if ! which python3 >/dev/null 2>&1; then
  prepare "python is not installed" "python is installing wait..."
  sudo apt install python3 -y >/dev/null 2>&1 || pkg install python3 -y /dev/null 2>&1 || sudo dnf install python3 -y >/dev/null 2>&1
  log_ok "python installation complete"
else
  log_info "python found installed"
fi

if ! which gocryptfs >/dev/null 2>&1; then
  if sudo apt install gocryptfs -y >/dev/null 2>&1 || pkg install gocryptfs -y >/dev/null 2>&1 || sudo dnf install gocryptfs -y >/dev/null 2>&1; then
    echo "utiliies done no log_error"
  else
    log_err "utiliies failed to install"
    echo "try sudo apy/dnf/pkg  install gocryptfs"
  fi
fi

if ! cat ~/.bashrc | grep -i 'export PATH="$HOME/bin:$PATH"' >/dev/null; then
  log_info "wait user bin path setting up"
  setup_bin_path
else
  log_info "no need to setup use bin path it's already setup"
fi

if ! which go >/dev/null 2>&1; then
  prepare "go is not installed" "wait for it's installation"
  sudo apt install golang -y >/dev/null 2>&1 || pkg install golang -y >/dev/null 2>&1 || sudo dnf install golang -y >/dev/null 2>&1
  log_ok "installation completed!"
else
  log_info "already installed go no setup required"
fi
if ! which tle >/dev/null 2>&1; then
  while True; do
    if go install github.com/drand/tlock/cmd/tle@latest; then
      log_ok "Tle encrption tool isntalled"
      break
    else
      sudo apt install build-essential -y || sudo dnf groupinstall "Development Tools" -y
      break
    fi
  done

else
  log_info "skip already installed"
fi
