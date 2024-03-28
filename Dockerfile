FROM docker.io/rclone/rclone:1.66.0 AS rclone
FROM docker.io/kopia/kopia:20240327.0.124953 AS kopia
FROM docker.io/restic/restic:0.16.4 AS restic
FROM docker.io/alpine:20240315 AS downloader
ARG  TARGETARCH
WORKDIR /tmp
RUN  wget https://github.com/go-task/task/releases/download/v3.35.1/task_linux_${TARGETARCH}.tar.gz && \
     tar zxvf task_linux_${TARGETARCH}.tar.gz

FROM docker.io/alpine:20240315 AS base
LABEL org.opencontainers.image.title "Hosting tools"
LABEL org.opencontainers.image.description "MariaDB client, Imagemagick, Rsync, WebP, XZ, Restic, Kopia, Rclone, Task and Just"
LABEL org.opencontainers.image.authors "githubcdr"
LABEL org.opencontainers.image.source "http://github.com/githubcdr/docker-hosting-tools"
LABEL org.opencontainers.image.licenses "MIT"
LABEL org.opencontainers.image.vendor "githubcdr"

RUN  apk add --update --no-cache libwebp-tools imagemagick git xz ca-certificates mariadb-client wget curl openssh-client rsync just
COPY --from=downloader /tmp/task /usr/local/bin/
COPY --from=rclone /usr/local/bin/rclone /usr/local/bin/
COPY --from=restic /usr/bin/restic /usr/local/bin/
COPY --from=kopia /bin/kopia /usr/local/bin/
