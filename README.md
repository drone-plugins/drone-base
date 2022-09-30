# drone-base

[![Build Status](http://harness.drone.io/api/badges/drone-plugins/drone-base/status.svg)](http://harness.drone.io/drone-plugins/drone-base)
[![Slack](https://img.shields.io/badge/slack-drone-orange.svg?logo=slack)](https://join.slack.com/t/harnesscommunity/shared_invite/zt-y4hdqh7p-RVuEQyIl5Hcx4Ck8VCvzBw)
[![Join the discussion at https://community.harness.io](https://img.shields.io/badge/discourse-forum-orange.svg)](https://community.harness.io)
[![Drone questions at https://stackoverflow.com](https://img.shields.io/badge/drone-stackoverflow-orange.svg)](https://stackoverflow.com/questions/tagged/drone.io)

This repository is used to build the base images for our plugins. On Linux it just adds a general `/etc/ssl/certs/ca-certificates.crt` and `/etc/mime.types` to an Alpine or a Scratch image depending on the tag. On Windows it targets the Nano Server that corresponds with the version of Windows in use.

## Docker

Build the Docker images with the following commands:

```
docker build \
  --label org.label-schema.build-date=$(date -u +"%Y-%m-%dT%H:%M:%SZ") \
  --label org.label-schema.vcs-ref=$(git rev-parse --short HEAD) \
  --file docker/Dockerfile.linux.multiarch \
  --tag plugins/base:multiarch .

docker build \
  --label org.label-schema.build-date=$(date -u +"%Y-%m-%dT%H:%M:%SZ") \
  --label org.label-schema.vcs-ref=$(git rev-parse --short HEAD) \
  --file docker/Dockerfile.linux.amd64 \
  --tag plugins/base:linux-amd64 .

docker build \
  --label org.label-schema.build-date=$(date -u +"%Y-%m-%dT%H:%M:%SZ") \
  --label org.label-schema.vcs-ref=$(git rev-parse --short HEAD) \
  --file docker/Dockerfile.linux.arm64 \
  --tag plugins/base:linux-arm64 .

docker build \
  --label org.label-schema.build-date=$(date -u +"%Y-%m-%dT%H:%M:%SZ") \
  --label org.label-schema.vcs-ref=$(git rev-parse --short HEAD) \
  --file docker/Dockerfile.windows.1809.amd64 \
  --tag plugins/base:windows-1809-amd64 .

docker build \
  --label org.label-schema.build-date=$(date -u +"%Y-%m-%dT%H:%M:%SZ") \
  --label org.label-schema.vcs-ref=$(git rev-parse --short HEAD) \
  --file docker/Dockerfile.windows.ltsc2022.amd64 \
  --tag plugins/base:windows-ltsc2022-amd64 .
```
