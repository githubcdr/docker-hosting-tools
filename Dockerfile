FROM rclone/rclone:1.61.1 AS rclone
FROM kopia/kopia:20230311.0.62805 AS kopia
FROM alpine:20230208 AS base
RUN  apk add --update --no-cache libwebp-tools imagemagick git xz ca-certificates restic mariadb-client wget curl openssh-client rsync
COPY --from=rclone /usr/local/bin/rclone /usr/local/bin/rclone
COPY --from=kopia /bin/kopia /usr/local/bin/kopia
