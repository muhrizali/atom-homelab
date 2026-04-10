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

**[Fedora Server](os/fedora/):** Fedora server is a powerful and flexible operating system backed by Red Hat. It proves to be the best choice available for self-hosting because of its latest technologies, sensible security defaults and a stable ecosystem. You can never go wrong choosing this OS whether you are beginner or a Linux veteran.

**[CachyOS](os/cachyos/):** At first, CachyOS seems to be one of the most unconventional choice for server operations but in my case (and other undocumented cases of people using it) it has proved itself to be a simple, blazing fast and bleeding edge operating system. Its an operating system based on the popular Arch Linux project and provides user-friendly defaults, deep hardware optimizations and easy security on top of it. Recommended only for people who want to experiment or for those who are well versed with Linux ecosystem.

## Essential Tools

After choosing and installing our operating system, we need to install some essential services which need to be running in our server (preferably) at all times.

**[SSH](services/):** For securely and remotely accessing our homelab server terminal CLI. It is a little convinient to operate your server computer from a remote PC (like laptop) than to always be present at the face of it.

**[Docker](services/):** For using and managing containerized applications and services. It makes setting up some of the most notoriously difficult applications seem like a breeze.

## Storage Pool

Now that you have remote access to your local homelab server, it is much easier to work with it from another computer through the `ssh` command. Also now would be a good time to think about and setup your storage for the server. We will be adding all our hard drives into the computer and pooling/grouping them to get a single large bucket of storage.

We will be carrying out this procedure by first wiping the hard drives attached to our system and then pooling them together through `mergerfs`.

**[Adding Drives](storage/README.md#setting-up-drives):** Installing, formatting and creating a new filesystem partition on our HDD drives for server use.

**[Pooling Drives](storage/README.md#setting-up-mergerfs):** Pooling our drives into a single large mounted volume as a folder.

## Container Applications

Now we can finally move on to the fun part of setting up our container self-hosted applications as docker container applications. We will be using docker and docker compose for running our applications. And we will be using compose YAML files for setting up the container before running them.

**[Container Applications](docker/):** List of some docker container applications that I like and their compose YAML files for straightforward configuration.
