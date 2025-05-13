<!--
SPDX-FileCopyrightText: 2023-2025 Daniel Wolf <nephatrine@gmail.com>
SPDX-License-Identifier: ISC
-->

# Remark42 Comment Engine

[![NephCode](https://img.shields.io/static/v1?label=Git&message=NephCode&color=teal)](https://code.nephatrine.net/NephNET/docker-remark42-ce)
[![GitHub](https://img.shields.io/static/v1?label=Git&message=GitHub&color=teal)](https://github.com/nephatrine/docker-remark42-ce)
[![Registry](https://img.shields.io/static/v1?label=OCI&message=NephCode&color=blue)](https://code.nephatrine.net/NephNET/-/packages/container/remark42-ce/latest)
[![DockerHub](https://img.shields.io/static/v1?label=OCI&message=DockerHub&color=blue)](https://hub.docker.com/repository/docker/nephatrine/remark42-ce/general)
[![unRAID](https://img.shields.io/static/v1?label=unRAID&message=template&color=orange)](https://code.nephatrine.net/NephNET/unraid-containers)

This is an Alpine-based container hosting the Remark42 comment engine. This is
not super useful by itself, but can be called into from other containerized web
applications to add a comments system or "guestbook" to static HTML pages, post
templates, and the like.

To secure this service, we suggest a separate reverse proxy server, such as
[nephatrine/nginx-ssl](https://hub.docker.com/repository/docker/nephatrine/nginx-ssl/general).

## Supported Tags

- `remark42-ce:1.14.0`: Remark42 1.14.0

## Software

- [Alpine Linux](https://alpinelinux.org/)
- [Skarnet S6](https://skarnet.org/software/s6/)
- [s6-overlay](https://github.com/just-containers/s6-overlay)
- [Remark42](https://remark42.com/)

## Configuration

There are some important configuration files you need to be aware of and
potentially customize.

- `/mnt/config/etc/remark42-config`

This is a bash script that will be sourced by the startup routine to include
additional tweaks or setup you would like to perform. Modifications to these
files will require a service restart to pull in the changes made.

You can place any additional web files here and they will be served, if present.
It will require a service restart to pull in new or updated files, however.

- `/mnt/config/www/remark42/*`

### Container Variables

- `TZ`: Time Zone (i.e. `America/New_York`)
- `PUID`: Mounted File Owner User ID
- `PGID`: Mounted File Owner Group ID
- `REMARK_URL`: Remark42 External URL
- `SITE`: Remark42 Site ID

## Testing

### docker-compose

```yaml
services:
  remark42-ce:
    image: nephatrine/remark42-ce:latest
    container_name: remark42-ce
    environment:
      TZ: America/New_York
      PUID: 1000
      PGID: 1000
      REMARK_URL: http://127.0.0.1:8080
      SITE: remark
    ports:
      - "8080:8080/tcp"
    volumes:
      - /mnt/containers/remark42-ce:/mnt/config
```

### docker run

```bash
docker run --rm -ti code.nephatrine.net/nephnet/remark42-ce:latest /bin/bash
```
