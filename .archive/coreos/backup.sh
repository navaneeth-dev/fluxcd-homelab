#!/usr/bin/env bash
set -euo pipefail

export RESTIC_REPOSITORY="s3:s3.amazonaws.com/mybucket"
export RESTIC_PASSWORD=""
export AWS_ACCESS_KEY_ID=""
export AWS_SECRET_ACCESS_KEY=""

podman run --rm \
  -v /var/home/core/media:/data/media:ro,z \
  -v /var/home/core/config:/data/config:ro,z \
  -e RESTIC_REPOSITORY \
  -e RESTIC_PASSWORD \
  -e AWS_ACCESS_KEY_ID \
  -e AWS_SECRET_ACCESS_KEY \
  docker.io/restic/restic:latest backup /data