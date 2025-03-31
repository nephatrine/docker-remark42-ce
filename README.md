<!--
SPDX-FileCopyrightText: 2023 - 2025 Daniel Wolf <nephatrine@gmail.com>

SPDX-License-Identifier: ISC
-->

[Git](https://code.nephatrine.net/NephNET/docker-remark42-ce/src/branch/master) |
[Docker](https://hub.docker.com/r/nephatrine/remark42-ce/) |
[unRAID](https://code.nephatrine.net/NephNET/unraid-containers)

# Remark42 Comment Engine

This docker image contains a Remark42 server to self-host your own comments.

The `latest` tag points to version `1.14.0` and this is the only image actively
being updated. There are tags for older versions, but these may no longer be
using the latest Alpine version and packages.

To secure this service, we suggest a separate reverse proxy server, such as an
[NGINX](https://nginx.com/) container.

## Docker-Compose

This is an example docker-compose file:

```yaml
services:
  remark42:
    image: nephatrine/remark42-ce:latest
    container_name: remark42
    environment:
      TZ: America/New_York
      PUID: 1000
      PGID: 1000
      REMARK_URL: http://127.0.0.1:8080
      SITE: remark
    ports:
      - "8080:8080/tcp"
    volumes:
      - /mnt/containers/remark42:/mnt/config
```

## Server Configuration

There are some important configuration files you need to be aware of and
potentially customize.

- `/mnt/config/etc/remark42-config`
- `/mnt/config/www/remark42/*`

Modifications to these files will require a service restart to pull in the
changes made.
