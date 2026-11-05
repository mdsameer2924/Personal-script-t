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

# if ! which cmatrix; then
# if sudo apt install
