#!/usr/bin/bash

# Full system upgrade
paru -Syu

# Retreiving primary for keyring and mirror list
sudo pacman-key --recv-key 3056513887B78AEB --keyserver hkp://keyserver.ubuntu.com:80
sudo pacman-key --lsign-key 3056513887B78AEB

# Installing chaotic-keyring and chaotic-mirrorlist
sudo pacman -U 'https://cdn-mirror.chaotic.cx/chaotic-aur/chaotic-keyring.pkg.tar.zst'
sudo pacman -U 'https://cdn-mirror.chaotic.cx/chaotic-aur/chaotic-mirrorlist.pkg.tar.zst'

# Appending repo config
sudo echo -e "[chaotic-aur]\nInclude = /etc/pacman.d/chaotic-mirrorlist" >> /etc/pacman.conf

# Upgrade again to refresh the repositories
paru -Syu
