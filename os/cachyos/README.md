## CachyOS Server

CachyOS is a performance-centric Arch Linux distribution designed to deliver a stable, efficient, and user-friendly computing environment. It offers the full power and flexibility of a rolling-release system, enhanced by advanced optimizations and a custom toolchain that streamlines the user experience for both new and experienced users.

CachyOS Linux is not meant to be used as a server but as regular daily driver operating system for users. But in my experience it has proved to as stable as any other Linux variant. It is still recommended to install CachyOS when you know your way around Linux.

**Tip:** Since we are installing CachyOS as a server OS, we can opt out of installing any desktop environment or GUI. When the installer prompts you to choose a desktop environment simply choose "No Desktop" (KDE Plasma should have been already selected as the default option).

[CachyOS Linux](https://fedoraproject.org/server/)

## Setting Up

**Initial Upgrade**

After installing the CachyOS and booting it up for the first, you should always upgrade the system packages:

```bash
# Upgrading through pacman
sudo pacman -Syu

# Upgrading through paru
paru -Syu
```

Reboot the system after the upgrade finishes.

**Adding Chaotic AUR Repositories**

Chaotic AUR is an AUR repository for Arch Linux users (Linux based on CachyOS) which automatically builds and compile some common and popular AUR packages.

To add the Chaotic AUR repositories for packages, we run the following commands:

```bash
# Retreiving primary for keyring and mirror list
sudo pacman-key --recv-key 3056513887B78AEB --keyserver hkp://keyserver.ubuntu.com:80
sudo pacman-key --lsign-key 3056513887B78AEB

# Installing chaotic-keyring and chaotic-mirrorlist
sudo pacman -U 'https://cdn-mirror.chaotic.cx/chaotic-aur/chaotic-keyring.pkg.tar.zst'
sudo pacman -U 'https://cdn-mirror.chaotic.cx/chaotic-aur/chaotic-mirrorlist.pkg.tar.zst'
```

Then we append the following to the end of the file /etc/pacman.conf:

```
[chaotic-aur]
Include = /etc/pacman.d/chaotic-mirrorlist
```

Now run the full system update to sync the repositories and mirrorlist:

```bash
sudo pacman -Syu
# paru -Syu
```

The first time we attempt to install packages from these repositories, the dnf utility prompts you to confirm the signature of the repositories. Confirm it.

## Package Management Commands

`pacman` is the default software package manager that installs, updates, and removes packages on CachyOS (and hence Arch Linux) from official Arch repositories. There is also `paru` which manages both `pacman` and AUR packages. I mostly use `paru` as it provides some additional convinient commands over `pacman`.

Some essential `dnf` package management commands are:

```bash
# To install packages
paru -Sy vlc rclone

# To upgrade all packages
paru -Syu

# To remove packages
paru -Rnc vlc rclone

# To remove packages no longer required by any packages
paru -c
```
