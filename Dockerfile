FROM nephatrine/nxbuilder:alpine AS builder1

ARG REMARK42_VERSION=v1.12.1
RUN git -C /root clone -b "$REMARK42_VERSION" --single-branch --depth=1 https://github.com/umputun/remark42.git

RUN echo "====== COMPILE REMARK42 ======" \
 && cd /root/remark42/frontend \
 && npm i -g pnpm@7 && pnpm i \
 && cd apps/remark42 && pnpm build

FROM nephatrine/nxbuilder:golang AS builder2

ARG REMARK42_VERSION=v1.12.1
COPY --from=builder1 /root/remark42/ /root/remark42/

RUN echo "====== COMPILE REMARK42 ======" \
 && cd /root/remark42/backend \
 && go build -o remark42 -ldflags "-X main.revision=${REMARK42_VERSION} -s -w" ./app

FROM nephatrine/alpine-s6:latest
LABEL maintainer="Daniel Wolf <nephatrine@gmail.com>"

COPY --from=builder2 /root/remark42/backend/remark42 /usr/bin/
COPY --from=builder2 /root/remark42/backend/scripts/backup.sh /usr/local/bin/backup-r42
COPY --from=builder2 /root/remark42/backend/scripts/restore.sh /usr/local/bin/restore-r42
COPY --from=builder2 /root/remark42/backend/scripts/import.sh /usr/local/bin/import-r42
COPY --from=builder2 /root/remark42/frontend/apps/remark42/public/ /var/www/remark42/

RUN echo "====== FINISH SETUP ======" \
 && chmod -R +x /usr/local/bin/*r42 \
 && sed -i 's~/srv/remark42~/usr/bin/remark42~g' /usr/local/bin/*r42

COPY override /

EXPOSE 8080/tcp
