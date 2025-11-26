FROM docker.io/rclone/rclone:1.72.0 AS rclone
FROM docker.io/kopia/kopia:0.22.2 AS kopia
FROM docker.io/restic/restic:0.18.1 AS restic
FROM ghcr.io/rustic-rs/rustic:v0.10.1 AS rustic
FROM cgr.dev/chainguard/wolfi-base

LABEL org.opencontainers.image.title="Hosting tools"
LABEL org.opencontainers.image.description="MariaDB client, Imagemagick, Rsync, WebP, XZ, Restic, Kopia, Rclone, Task and Just"
LABEL org.opencontainers.image.authors="githubcdr"
LABEL org.opencontainers.image.source="http://github.com/githubcdr/docker-hosting-tools"
LABEL org.opencontainers.image.licenses="MIT"
LABEL org.opencontainers.image.vendor="githubcdr"

# libwebp-tools imagemagick git xz ca-certificates mariadb-client wget curl openssh-client rsync just
RUN  apk add --update --no-cache task just libwebp-tools wget curl jq yq xz mariadb openssh-client mc rsync grype regclient croc

COPY --from=rclone /usr/local/bin/rclone /usr/local/bin/
COPY --from=kopia /bin/kopia /usr/local/bin/
COPY --from=restic /usr/bin/restic /usr/local/bin/
COPY --from=rustic /rustic /usr/local/bin/
