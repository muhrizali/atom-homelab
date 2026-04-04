#!/usr/bin/bash

# Full system upgrade
sudo dnf upgrade

# To enable "Free" repository
sudo dnf install https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm

# To enable "Nonfree" repository
sudo dnf install https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm

# Upgrade again to refresh repositories
sudo dnf upgrade
