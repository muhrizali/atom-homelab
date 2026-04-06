## Introduction

This project is about re-purposing and turning any old computer/laptop into a usable and efficient Linux server for various useful network and media consumption services. Initially I have started this project for the purpose of learning but over time it has become one of the things that I enjoy mantaining and improving.

I have taken inspiration from various YouTube channels without whom this project would have been impossible:
- [Hardware Haven](https://youtu.be/72D3MvPk3Xs)
- [Jeff Geerling](https://www.youtube.com/@JeffGeerling)
- [NetworkChuck](https://www.youtube.com/@NetworkChuck)

<!-- ## Contents -->
<!-- - [Entry](Link) -->

## Operating System

We will be primarily using Linux for the main operating system for maximum throughput of the hardware and also for hardware longevity. The best options for OS that I have used over the years for personal homelab servers are Fedora and CachyOS (controversial take).

**[Fedora Server](os/fedora/README.md):** Fedora server is a powerful and flexible operating system backed by Red Hat. It proves to be the best choice available for self-hosting because of its latest technologies, sensible security defaults and a stable ecosystem. You can never go wrong choosing this OS whether you are beginner or a Linux veteran.

**[CachyOS](os/cachyos/README.md):** At first, CachyOS seems to be one of the most unconventional choice for server operations but in my case (and other undocumented cases of people using it) it has proved itself to be a simple, blazing fast and bleeding edge operating system. Its an operating system based on the popular Arch Linux project and provides user-friendly defaults, deep hardware optimizations and easy security on top of it. Recommended only for people who want to experiment or for those who are well versed with Linux ecosystem.

## Essential Services

After choosing and installing our operating system, we need to install some essential services which need to be running in our server (preferably) at all times. This includes Secure Shell `ssh` for remote access to server terminal CLI and `docker` for using and managing containerized applications.

**Setting Up SSH**

Since `ssh` is such a widely used service, it is found in all of the Linux distributions, but installing it might be a little different depending on the package manager you are using. The `ssh` service itself is provided by the `openssh` package:

```bash
# Fedora
sudo dnf install openssh
```
  
```bash
# CachyOS/Arch
sudo pacman -Sy openssh
```

After installing the `openssh` we need to enable the service so that it keeps running at all times:

```bash
# Starting up the SSH service and enabling it
# so that it starts up at the system bootup.
sudo systemctl enable --now sshd

# Check the status of service
sudo systemctl status sshd
```

Fedora server and the CachyOS distributions are protected by network firewall which deliberately blocks some of your network ports from outside access for security purposes. To access our server from local network, we need to open the port reponsible for SSH (the port 22) on respective firewall software:

```bash
# Fedora uses firewall-cmd for firewall
sudo firewall-cmd --permanent --add-service=ssh
# then reload the firewall to apply changes
sudo firewall-cmd --reload
```
  
```bash
# CachyOS uses ufw for firewall
sudo ufw allow ssh # or sudo ufw allow 22
```

Now we can access our local homelab server from another device in our local network:

```bash
# To access user 'atomic' on server with IP '192.168.1.3'
ssh atomic@192.168.1.3

# It prompts the user for confirmation of fingerprint; type "yes"
# and then type your password for the server user to enter.
```

**Setting Up Docker**

Docker is a containerization platform, a tool and a manager for using and managing containerized applications. In simple words, it solves the problem of distributing software/services by isolating all the dependencies of an application into an isolated and reproducible environment so that there won't be a situation where a user experiences difficulty setting up the same application that others claim that "it runs on their machines".

```bash
# Fedora
# Adding docker repos
sudo dnf config-manager addrepo --from-repofile https://download.docker.com/linux/fedora/docker-ce.repo

# Installing docker and related packages
sudo dnf install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
```

```bash
# CachyOS/Arch
sudo pacman -Sy docker docker-compose
```

Finally, after installation of all `docker` related packages, we need to enable the service so that it starts running as soon as the system boots up:

```bash
# Starting and enabling docker service
sudo systemctl enable --now docker
```

**Basic Service Management**

We will be working with many other services apart from `ssh` and `docker`, so it might be useful to know some basic commands for managing various Linux services:

```bash
# Starting a service
sudo systemctl start [service]

# Stopping a service
sudo systemctl stop [service]

# Enabling a service so it always starts at bootup
sudo systemctl enable [service]

# Disabling a service so it doesn't start at bootup
sudo systemctl disable [service]

# Enable and start the service at the same time
sudo systemctl enable --now [service]

# Disable and stop the service at the same time
sudo systemctl disable --now [service]
```

## Storage Pool

Now that you have remote access to your local homelab server, it is much easier to work with it from another computer through the `ssh` command. Also now would be a good time to think about and setup your storage for the server. We will be adding all our hard drives into the computer and pooling/grouping them to get a big bucket of storage.

We will be carrying out this procedure by first wiping the hard drives attached to our system and then pooling them together through `mergerfs`.

**Setting Up Drives**

After attaching the hard drives to your server, it is recommended to format them to a common filesystem. We can go without formatting but its a good thing that all hard drives have the same filesystem (would also be better if all of the drives are the same manufacture model).

The best filesystems I have used in the past that works great for our purposes are `btrfs`, `ext4` and `xfs`. You can search about these filesystems on your own and decide what works best for you. I will be using `btrfs` for my use case.

Personally I refrain from touching hard drives through terminal CLI (from the  fear I will mess some things up) and always use some GUI for the task:

1. After adding your hard drives, boot into a live environment of a Linux distribution. I would recommend you use "Linux Mint" or "CachyOS" USB live environment.
2. Install partitions manager utility called `gparted` in your live environment (or skip if already present).
3. Open `gparted`, select your first drive from the options on the top-right and do the following: delete all the existing partitions by formatting the current drive (backup if the data is important), create a new single partition on the drive, choose `btrfs` as the new filesystem and then apply all the changes.
4. Repeat the above steps for each of the drive you will be using in your server. After applying all the changes, reboot into the server OS.

**Setting Up MergerFS**

The `mergerfs` is a featureful union filesystem that pools multiple independent drives or directories into a single unified mount point, making them appear as one large volume.

The `mergerfs` utility can be installed through the following commands:

```bash
# Fedora
# Downloading RPM package file
wget -o mergerfs-release.rpm https://github.com/trapexit/mergerfs/releases/download/2.41.1/mergerfs-2.41.1-1.fc43.x86_64.rpm
# Installing RPM package
sudo dnf install ./mergerfs-release.rpm
```

```bash
# CachyOS
# Simply installing through package manager
sudo pacman -Sy mergerfs
# or paru -Sy mergerfs
```

Now that we have our hard drives and `mergerfs` installed we can mount and combine them into one large volume.

**Mounting Drives**

We will be using the UUID of our hard drives to mount them as UUID always correctly identifies the hard drives even if the order in the motherboard changes. To find the UUIDs of our hard drives we run the following commands:

```bash
# Listing all drives with their UUIDs
# HDDs will be displayed in the form "sd*"
# and SSDs will displayed like "nvme0n1p*"
lsblk -f

# Store these UUIDs somewhere, we will needing it later
# Example UUID: 15bc327d-467e-47c1-be56-d4539a8c9b18
```

Creating folders for hard drives and the storage pool to be mounted:

```bash
# Mount folders for 3 HDDs in my case
sudo mkdir -p /mnt/data1 /mnt/data2 /mnt/data3

# Mount folder for storage pool
sudo mkdir -p /mnt/storage
```

Now we will add our drives in the `/etc/fstab` file which is responsible for making our mount points permanent by mounting all the storage/filesystem devices on bootup. Open the file with your favorite text editor (like `sudo helix /etc/fstab`) and append the following lines (requires root access):

```bash
# Append at the end of /etc/fstab file:

# HDD DATA DRIVES:

# HDD 1
UUID="63f74c83-dd83-4685-bfaf-02a2fec3a8f3" /mnt/data1 btrfs  defaults 0 0
# HDD 2
UUID="97e1cbbf-5777-430d-a4ee-37cc5512a468" /mnt/data2 btrfs  defaults 0 0
# HDD 3
UUID="db316557-9617-459c-9445-593159e1097a" /mnt/data3 btrfs  defaults 0 0

# MergerFS POOL OF DRIVES:
/mnt/data* /mnt/storage mergerfs cache.files=off,category.create=pfrd,func.getattr=newest,dropcacheonclose=false,minfreespace=500G 0 0

```

Save the file and quit the text editor. We can test our drives and storage pool by running `sudo mount -a` which mounts all the filesystems mentioned in `/etc/fstab`. Go into the `/mnt/storage` folder; this is the storage pool that we will be using/referencing for any storage purposes (not the individual `/mnt/data*` entries).

If the program runs without any errors then we are good to go and simply reboot our system (HDDs will automatically be mounted at the startup).

It might also be necessary to change the permissions of everything inside the storage pool. (Also, I always symlink the storage pool into my home directory just for easy navigation):

```bash
# Changing permissions
sudo chown -R atomic /mnt/storage

# Symlinking storage pool into home folder
sudo ln -s /mnt/storage /home/atomic/store
```

