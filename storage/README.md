
## Setting Up Drives

After attaching the hard drives to your server, it is recommended to format them to a common filesystem. We can go without formatting but its a good thing that all hard drives have the same filesystem (would also be better if all of the drives are the same manufacture model).

The best filesystems I have used in the past that works great for our purposes are `btrfs`, `ext4` and `xfs`. You can search about these filesystems on your own and decide what works best for you. I will be using `btrfs` for my use case.

Personally I refrain from touching hard drives through terminal CLI (from the  fear I will mess some things up) and always use some GUI for the task:

1. After adding your hard drives, boot into a live environment of a Linux distribution. I would recommend you use "Linux Mint" or "CachyOS" USB live environment.
2. Install partitions manager utility called `gparted` in your live environment (or skip if already present).
3. Open `gparted`, select your first drive from the options on the top-right and do the following: delete all the existing partitions by formatting the current drive (backup if the data is important), create a new single partition on the drive, choose `btrfs` as the new filesystem and then apply all the changes.
4. Repeat the above steps for each of the drive you will be using in your server. After applying all the changes, reboot into the server OS.

## Setting Up MergerFS

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

## Pooling Drives

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

