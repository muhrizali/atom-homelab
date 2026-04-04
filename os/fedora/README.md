## Fedora Server

A polished Linux server operating system backed by Red Hat. It provides a flexible and powerful ecosystem with latest technologies, sensible security defaults and a stable environment.

[Fedora Server](https://fedoraproject.org/server/)

## Setting Up

**Initial Upgrade**

After installing the Fedora server and booting it up for the first, you should always upgrade the system packages:

```bash
sudo dnf upgrade
```
Reboot the system after the upgrade finishes.

**Adding RPM Fusion Repositories**

The RPM Fusion project is a community-maintained software repository providing common and popular additional packages that are not distributed by Fedora.

To add the RPM Fusion repositories for packages, we run the following commands:

```bash
# To enable "Free" repository
sudo dnf install https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm

# To enable "Nonfree" repository
sudo dnf install https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm
```

The first time we attempt to install packages from these repositories, the dnf utility prompts you to confirm the signature of the repositories. Confirm it.

## Package Management Commands

 DNF is a software package manager that installs, updates, and removes packages on Fedora. This method eliminates the need to manually install or update the package, and its dependencies, using the `rpm` command. DNF is now the default software package management tool in Fedora.

Some essential `dnf` package management commands are:

```bash
# To install packages
sudo dnf install vlc rclone

# To upgrade all packages
sudo dnf upgrade

# To remove packages
sudo dnf remove vlc rclone

# To remove packages no longer required by any packages
sudo dnf autoremove
```
