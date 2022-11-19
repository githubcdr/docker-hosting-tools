FROM rclone/rclone:1.60.0 AS rclone
FROM kopia/kopia:20221119.0.104130 AS kopia
FROM alpine:20221110 AS base
RUN  apk add --update --no-cache libwebp-tools imagemagick git xz ca-certificates restic mariadb-client wget curl openssh-client rsync
COPY --from=rclone /usr/local/bin/rclone /usr/local/bin/rclone
COPY --from=kopia /bin/kopia /usr/local/bin/kopia
