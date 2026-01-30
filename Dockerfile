FROM docker.io/rclone/rclone:1.73.0 AS rclone
FROM docker.io/kopia/kopia:0.22.3 AS kopia
FROM docker.io/restic/restic:0.18.1 AS restic
FROM ghcr.io/rustic-rs/rustic:v0.10.3 AS rustic
FROM cgr.dev/chainguard/wolfi-base

LABEL org.opencontainers.image.title="Hosting tools"
LABEL org.opencontainers.image.description="MariaDB client, Imagemagick, Rsync, WebP, XZ, Restic, Kopia, Rclone, Task and Just"
LABEL org.opencontainers.image.authors="githubcdr"
LABEL org.opencontainers.image.source="http://github.com/githubcdr/docker-hosting-tools"
LABEL org.opencontainers.image.licenses="MIT"
LABEL org.opencontainers.image.vendor="githubcdr"

# libwebp-tools imagemagick git xz ca-certificates mariadb-client wget curl openssh-client rsync just
RUN  apk add --update --no-cache task just libwebp-tools wget curl jq yq xz mariadb-client openssh-client mc rsync grype regclient croc

COPY --from=rclone /usr/local/bin/rclone /usr/local/bin/
COPY --from=kopia /bin/kopia /usr/local/bin/
COPY --from=restic /usr/bin/restic /usr/local/bin/
COPY --from=rustic /rustic /usr/local/bin/

RUN echo "=== Verifying installed binaries ===" && \
    # Backup/sync tools
    rclone version && echo "✓ rclone" && \
    kopia --version && echo "✓ kopia" && \
    restic version && echo "✓ restic" && \
    rustic --version && echo "✓ rustic" && \
    # Task runners
    task --version && echo "✓ task" && \
    just --version && echo "✓ just" && \
    # Image tools
    cwebp -version && echo "✓ cwebp (libwebp-tools)" && \
    # Network tools
    wget --version | head -n1 && echo "✓ wget" && \
    curl --version | head -n1 && echo "✓ curl" && \
    # Data tools
    jq --version && echo "✓ jq" && \
    yq --version && echo "✓ yq" && \
    # Compression tools
    xz --version && echo "✓ xz" && \
    # Database tools
    mariadb --version && echo "✓ mariadb" && \
    # Transfer tools
    rsync --version | head -n1 && echo "✓ rsync" && \
    ssh -V 2>&1 | head -n1 && echo "✓ ssh (openssh-client)" && \
    # File manager
    mc --version && echo "✓ mc" && \
    # Security/Registry tools
    grype version && echo "✓ grype" && \
    regctl version && echo "✓ regctl (regclient)" && \
    croc --version && echo "✓ croc" && \
    echo "=== All binaries verified successfully ==="
