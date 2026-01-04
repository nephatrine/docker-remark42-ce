# SPDX-FileCopyrightText: 2023-2025 Daniel Wolf <nephatrine@gmail.com>
# SPDX-License-Identifier: ISC

# hadolint ignore=DL3007
FROM code.nephatrine.net/nephnet/nxb-golang:latest AS builder

ARG REMARK42_VERSION=v1.15.0
RUN git -C /root clone -b "$REMARK42_VERSION" --single-branch --depth=1 https://github.com/umputun/remark42.git

WORKDIR /root/remark42/frontend
RUN npm i -g pnpm@8 && pnpm i
WORKDIR /root/remark42/frontend/apps/remark42
RUN pnpm build
WORKDIR /root/remark42/backend
RUN go build -o remark42 -ldflags "-X main.revision=${REMARK42_VERSION} -s -w" ./app

# hadolint ignore=DL3007
FROM code.nephatrine.net/nephnet/alpine-s6:latest
LABEL maintainer="Daniel Wolf <nephatrine@gmail.com>"

COPY --from=builder /root/remark42/backend/remark42 /usr/bin/
COPY --from=builder /root/remark42/backend/scripts/backup.sh /usr/local/bin/backup-r42
COPY --from=builder /root/remark42/backend/scripts/restore.sh /usr/local/bin/restore-r42
COPY --from=builder /root/remark42/backend/scripts/import.sh /usr/local/bin/import-r42
COPY --from=builder /root/remark42/frontend/apps/remark42/public/ /var/www/remark42/

RUN sed -i 's~/srv/remark42~/usr/bin/remark42~g' /usr/local/bin/*r42 && chmod -R +x /usr/local/bin/*r42

COPY override /
EXPOSE 8080/tcp
