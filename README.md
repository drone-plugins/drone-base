# drone-base

| OS | Build |
| --- | --- |
| Linux | [![Build Status](https://cloud.drone.io/api/badges/drone-plugins/drone-base/status.svg)](https://cloud.drone.io/drone-plugins/drone-base) [![](https://images.microbadger.com/badges/image/plugins/base.svg)](https://microbadger.com/images/plugins/base "Get your own image badge on microbadger.com") |
| Windows | [![Build Status](https://internal.cloud.drone.ci/api/badges/drone-plugins/drone-base/status.svg)](http://cloud.drone.io/drone-plugins/drone-base) [![](https://images.microbadger.com/badges/image/plugins/docker:windows-1809-amd64.svg)](https://microbadger.com/images/plugins/docker:windows-1809-amd64 "Get your own image badge on microbadger.com") |

[![Gitter chat](https://badges.gitter.im/drone/drone.png)](https://gitter.im/drone/drone)
[![Join the discussion at https://discourse.drone.io](https://img.shields.io/badge/discourse-forum-orange.svg)](https://discourse.drone.io)
[![Drone questions at https://stackoverflow.com](https://img.shields.io/badge/drone-stackoverflow-orange.svg)](https://stackoverflow.com/questions/tagged/drone.io)

This repository is used to build the base images for our plugins. On Linux it just adds a general `/etc/ssl/certs/ca-certificates.crt` and `/etc/mime.types` to an Alpine or a Scratch image depending on the tag. On Windows it targets the nanoserver that corresponds with the version of Windows in use.

## Docker

Build the Docker images with the following commands:

```
docker build \
  --label org.label-schema.build-date=$(date -u +"%Y-%m-%dT%H:%M:%SZ") \
  --label org.label-schema.vcs-ref=$(git rev-parse --short HEAD) \
  --file docker/Dockerfile.linux.multiarch
  --tag plugins/base:multiarch .

docker build \
  --label org.label-schema.build-date=$(date -u +"%Y-%m-%dT%H:%M:%SZ") \
  --label org.label-schema.vcs-ref=$(git rev-parse --short HEAD) \
  --file docker/Dockerfile.linux.amd64
  --tag plugins/base:linux-amd64 .

docker build \
  --label org.label-schema.build-date=$(date -u +"%Y-%m-%dT%H:%M:%SZ") \
  --label org.label-schema.vcs-ref=$(git rev-parse --short HEAD) \
  --file docker/Dockerfile.linux.arm64
  --tag plugins/base:linux-arm64 .

docker build \
  --label org.label-schema.build-date=$(date -u +"%Y-%m-%dT%H:%M:%SZ") \
  --label org.label-schema.vcs-ref=$(git rev-parse --short HEAD) \
  --file docker/Dockerfile.linux.arm
  --tag plugins/base:linux-arm .

docker build \
  --label org.label-schema.build-date=$(date -u +"%Y-%m-%dT%H:%M:%SZ") \
  --label org.label-schema.vcs-ref=$(git rev-parse --short HEAD) \
  --file docker/Dockerfile.windows.amd64
  --tag plugins/base:windows-amd64 .
```
