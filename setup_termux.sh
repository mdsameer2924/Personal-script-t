#!/bin/bash
set -e
echo "setup: username@localhost view"
echo "remember it's won't change your original username and hostname just replace text"
read -p "enter replacement for username: " name
read -p "enter replacement for localhost: " locs

## Ubuntu terminal color pallette
mkdir -p ~/.termux
cat <<'EOF' >~/.termux/colors.properties
background=#300A24
foreground=#FFFFFF
cursor=#FFFFFF

color0=#2E3436
color1=#CC0000
color2=#4E9A06
color3=#C4A000
color4=#3465A4
color5=#75507B
color6=#06989A
color7=#D3D7CF

color8=#555753
color9=#EF2929
color10=#8AE234
color11=#FCE94F
color12=#729FCF
color13=#AD7FA8
color14=#34E2E2
color15=#EEEEEC
EOF
## Setup user@localhost custom
## install ubuntu font
pkg install -y curl unzip
curl -L "https://github.com/canonical/Ubuntu-Sans-Mono-fonts/releases/download/v1.100/Ubuntu-Sans-Mono-fonts-v1.100.zip" -o ~/ubuntu-font.zip
unzip -j ~/ubuntu-font.zip "*/ttf/UbuntuSansMono-Regular.ttf" -d ~/.termux/
mv ~/.termux/UbuntuSansMono-Regular.ttf ~/.termux/font.ttf
rm ~/ubuntu-font.zip

# Remove previous custom prompt configuration
sed -i '/# Custom Ubuntu-style Termux prompt/,$d' ~/.bashrc

# Custom Ubuntu-style Termux prompt
echo "PS1='\[\e[1;32m\]${name}@${locs}\[\e[0m\]:\[\e[1;34m\]\w\[\e[0m\]\$ '" >>~/.bashrc
## restart termux
termux-reload-settings
