## Setting Up SSH

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

## Setting Up Docker

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

