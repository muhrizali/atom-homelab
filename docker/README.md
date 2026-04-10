## Docker Applications

Now comes the actual fun part of installing and setting up your self-hosted web applications/services via the docker platform. Most of the sources of the configuration files provided here are docker compose files that I have taken from the amazing folks at LinuxServer or from their official recommended docker setup.

<!-- **[LinuxServer](https://www.linuxserver.io/):** -->

<!-- A popular group of maintainers who build and maintain the largest collection of easy-to-use and streamlined docker images. You can check out more of their images I haven't used here on their website! -->

**Common Containers Workflow**

All the following docker containers follows the same workflow for initializing and running them. This allows us to have uniform configuration files and also allows easy maintainence.

1. Create a `docker` folder at your preferred location for storing all the docker container YAML files. Create another folder inside for the container you are going to be working with. For example, create folder `navidrome` inside `docker` for container `navidrome`.
2. Inside the container folder, create an empty text file `docker-compose.yml` with your favorite text editor. Paste the corresponding docker compose configuration shown below and save it.
3. Open the terminal and change to the container folder consisting of `docker-compose.yml` file and run the command `sudo docker compose up -d`. The command initializes and creates the container, and start it in the background.

**Storing Containers Configuration**

Docker container applications runs as an isolated and self-contained unit which is independent of the host environment (the OS running the docker program). This way we can only allow docker containers certain paths (for configuration data) without giving them full access to entire system.

I have found it best to use the standard `~/.config` Linux home directory for storing the container data. The containers will store their data in their respective directory (corresponding to their application name) inside `.config`.

```bash
# Create directory if not present (highly unlikely)
mkdir -p ~/.config

# Example: Config data directory for "navidrome" container
mkdir -p ~/.config/navidrome
```

## Pihole: Network-wide Ad-blocking & DNS Sinkhole System

Pihole is easily the most fascinating application in this list. It allows you to protect your home network from malicious websites and trackers to keep you safe while you are surfing the internet. It acts as a fine grained filter layer on top of your network for blocking advertisements and also acts as a DNS resolver (and sinkhole) for all your devices.

**Docker Compoese YAML**

```yaml
# More info at https://github.com/pi-hole/docker-pi-hole/ and https://docs.pi-hole.net/
---
services:
  pihole:
    container_name: pihole
    image: pihole/pihole:latest
    ports:
      # DNS Ports
      - "53:53/tcp"
      - "53:53/udp"
      # Default HTTP Port
      - "80:80/tcp"
      # Default HTTPs Port. FTL will generate a self-signed certificate
      - "443:443/tcp"
      # Uncomment the line below if you are using Pi-hole as your DHCP server
      - "67:67/udp"
      # Uncomment the line below if you are using Pi-hole as your NTP server
      # - "123:123/udp"
    environment:
      # Set the appropriate timezone for your location (https://en.wikipedia.org/wiki/List_of_tz_database_time_zones), e.g:
      TZ: 'Asia/Kolkata'
      # Set a password to access the web interface. Not setting one will result in a random password being assigned
      FTLCONF_webserver_api_password: 'your_web_ui_password'
      # If using Docker's default `bridge` network setting the dns listening mode should be set to 'ALL'
      FTLCONF_dns_listeningMode: 'ALL'
    # Volumes store your data between container upgrades
    volumes:
      # For persisting Pi-hole's databases and common configuration file
      - '/home/atomic/.config/pihole:/etc/pihole'
      # Uncomment the below if you have custom dnsmasq config files that you want to persist. Not needed for most starting fresh with Pi-hole v6. If you're upgrading from v5 you and have used this directory before, you should keep it enabled for the first v6 container start to allow for a complete migration. It can be removed afterwards. Needs environment variable FTLCONF_misc_etc_dnsmasq_d: 'true'
      #- './etc-dnsmasq.d:/etc/dnsmasq.d'
    cap_add:
      # See https://docs.pi-hole.net/docker/#note-on-capabilities
      # Required if you are using Pi-hole as your DHCP server, else not needed
      - NET_ADMIN
      # Required if you are using Pi-hole as your NTP client to be able to set the host's system time
      - SYS_TIME
      # Optional, if Pi-hole should get some more processing time
      - SYS_NICE
    restart: unless-stopped
```

## TODO - Syncthing: Data Syncing System

## Navidrome: Self-hosted Music Collections & Server

The first docker application we will be talking about is my favourite and also something that is close to my heart. Navidrome is a self-hosted music server solution which is like your own Spotify server. I found this amazing application when I was searching for a music solution that grants me full control over my music and ownership.

Personally I was very happy when I had set it up for myself and got it working with the client app [Symfonium](https://symfonium.app/) on my phone. Navidrome uses Subsonic API (the standard music streaming API) for backend and works with a large number of Subsonic clients (the list can be found on their website: [Apps](https://www.navidrome.org/apps/)).

**Docker Compose YAML**

```yaml
---
services:
  navidrome:
    image: deluan/navidrome:latest
    container_name: navidrome
    user: 1000:1000 # should be owner of volumes
    ports:
      - "4533:4533"
    restart: unless-stopped
    environment:
      ND_ENABLETRANSCODINGCONFIG: true
      # Optional: put your config options customization here. Examples:
      # ND_LOGLEVEL: debug
    volumes:
      # Change the volume paths according to your user and home directory
      - "/home/atomic/.config/navidrome:/data" # configurations
      - "/home/atomic/Storage/COLLECTIONS/music/Music:/music" # music library
```

## Sonarr & Radarr: Movies & TV Shows Managers

Sonarr and Radarr are kind of like essential applications for people who have considerable amount of movie and shows collections and wants to manage them efficiently. From tracking all the movies/shows you have and don't have in your storage to scraping and downloading their metadata for various external applications, these applications can do everything in between.

Radarr is for managing your movie collections while Sonarr is for TV shows.

**Radarr Docker Compose YAML**

```yaml
---
services:
  radarr:
    image: lscr.io/linuxserver/radarr:latest
    container_name: radarr
    environment:
      - PUID=1000
      - PGID=1000
      - TZ=Etc/UTC
    volumes:
      - /home/atomic/.config/radarr:/config
      - /home/atomic/Storage/COLLECTIONS/media:/media
    ports:
      - 7878:7878
    restart: unless-stopped
```

**Sonarr Docker Compose YAML**

```yaml
---
services:
  sonarr:
    image: lscr.io/linuxserver/sonarr:latest
    container_name: sonarr
    environment:
      - PUID=1000
      - PGID=1000
      - TZ=Etc/UTC
    volumes:
      - /home/atomic/.config/sonarr:/config
      - /home/atomic/Storage/COLLECTIONS/media:/media
    ports:
      - 8989:8989
    restart: unless-stopped
```

## Jellyfin: Self-hosted Media Server

Jellyfin is like your personal media streaming and server solution which you have complete control over. You point Jellyfin to your media collections like movies and TV shows and it scans and presents them in a beautiful interface (like Netflix) with all necessary metadata and posters. It also allows you to share your media libraries with your friends and family members.

**Docker Compose YAML**

```yaml
---
services:
  jellyfin:
    image: lscr.io/linuxserver/jellyfin:latest
    container_name: jellyfin
    environment:
      - PUID=1000
      - PGID=1000
      - TZ=Etc/UTC
      - JELLYFIN_PublishedServerUrl=http://192.168.1.3 #optional
    volumes:
      - /home/atomic/.config/jellyfin:/config
      - /home/atomic/Storage/COLLECTIONS/media:/data/media
    ports:
      - 8096:8096
      - 8920:8920 #optional
      - 7359:7359/udp #optional
      - 1900:1900/udp #optional
    restart: unless-stopped
```

## Immich: Self-Hosted Photo & Video Management Solution

Immich is your personal self-hosted photo and video collections manager like Google Photos. It can even identify faces in your photos to categorise and catalogue them using machine learning.

**Docker Compose YAML**

```yaml
#
# WARNING: To install Immich, follow our guide: https://docs.immich.app/install/docker-compose
#
# Make sure to use the docker-compose.yml of the current release:
#
# https://github.com/immich-app/immich/releases/latest/download/docker-compose.yml
#
# The compose file on main may not be compatible with the latest release.

name: immich

services:
  immich-server:
    container_name: immich_server
    image: ghcr.io/immich-app/immich-server:${IMMICH_VERSION:-release}
    # extends:
    #   file: hwaccel.transcoding.yml
    #   service: cpu # set to one of [nvenc, quicksync, rkmpp, vaapi, vaapi-wsl] for accelerated transcoding
    volumes:
      # Do not edit the next line. If you want to change the media storage location on your system, edit the value of UPLOAD_LOCATION in the .env file
      - ${UPLOAD_LOCATION}:/data
      - /etc/localtime:/etc/localtime:ro
    env_file:
      - .env
    ports:
      - '2283:2283'
    depends_on:
      - redis
      - database
    restart: always
    healthcheck:
      disable: false

  immich-machine-learning:
    container_name: immich_machine_learning
    # For hardware acceleration, add one of -[armnn, cuda, rocm, openvino, rknn] to the image tag.
    # Example tag: ${IMMICH_VERSION:-release}-cuda
    image: ghcr.io/immich-app/immich-machine-learning:${IMMICH_VERSION:-release}
    # extends: # uncomment this section for hardware acceleration - see https://docs.immich.app/features/ml-hardware-acceleration
    #   file: hwaccel.ml.yml
    #   service: cpu # set to one of [armnn, cuda, rocm, openvino, openvino-wsl, rknn] for accelerated inference - use the `-wsl` version for WSL2 where applicable
    volumes:
      - model-cache:/cache
    env_file:
      - .env
    restart: always
    healthcheck:
      disable: false

  redis:
    container_name: immich_redis
    image: docker.io/valkey/valkey:9@sha256:3eeb09785cd61ec8e3be35f8804c8892080f3ca21934d628abc24ee4ed1698f6
    healthcheck:
      test: redis-cli ping || exit 1
    restart: always

  database:
    container_name: immich_postgres
    image: ghcr.io/immich-app/postgres:14-vectorchord0.4.3-pgvectors0.2.0@sha256:bcf63357191b76a916ae5eb93464d65c07511da41e3bf7a8416db519b40b1c23
    environment:
      POSTGRES_PASSWORD: ${DB_PASSWORD}
      POSTGRES_USER: ${DB_USERNAME}
      POSTGRES_DB: ${DB_DATABASE_NAME}
      POSTGRES_INITDB_ARGS: '--data-checksums'
      # Uncomment the DB_STORAGE_TYPE: 'HDD' var if your database isn't stored on SSDs
      # DB_STORAGE_TYPE: 'HDD'
    volumes:
      # Do not edit the next line. If you want to change the database storage location on your system, edit the value of DB_DATA_LOCATION in the .env file
      - ${DB_DATA_LOCATION}:/var/lib/postgresql/data
    shm_size: 128mb
    restart: always
    healthcheck:
      disable: false

volumes:
  model-cache:
```

**Extra `.env` File Needed**
```env
# You can find documentation for all the supported env variables at https://docs.immich.app/install/environment-variables

# The location where your uploaded files are stored
UPLOAD_LOCATION=/home/atomic/Storage/COLLECTIONS/photos/Photos

# The location where your database files are stored. Network shares are not supported for the database
DB_DATA_LOCATION=/home/atomic/.config/immich/database

# To set a timezone, uncomment the next line and change Etc/UTC to a TZ identifier from this list: https://en.wikipedia.org/wiki/List_of_tz_database_time_zones#List
# TZ=Etc/UTC

# The Immich version to use. You can pin this to a specific version like "v2.1.0"
IMMICH_VERSION=v2

# Connection secret for postgres. You should change it to a random password
# Please use only the characters `A-Za-z0-9`, without special characters or spaces
DB_PASSWORD=postgres

# The values below this line do not need to be changed
###################################################################################
DB_USERNAME=postgres
DB_DATABASE_NAME=immich
```

