# drone-base

[![Build Status](http://beta.drone.io/api/badges/drone-plugins/drone-base/status.svg)](http://beta.drone.io/drone-plugins/drone-base)
[![Join the discussion at https://www.reddit.com/r/droneci/](https://img.shields.io/badge/reddit-forum-orange.svg)](https://www.reddit.com/r/droneci/)
[![Drone questions at https://stackoverflow.com](https://img.shields.io/badge/drone-stackoverflow-orange.svg)](https://stackoverflow.com/questions/tagged/drone.io)
[![](https://images.microbadger.com/badges/image/plugins/base.svg)](https://microbadger.com/images/plugins/base "Get your own image badge on microbadger.com")

This repository is used to build the base images used by our plugins. It just adds a general `/etc/ssl/certs/ca-certificates.crt` and `/etc/mime.types` to a scratch image.

## Docker

Build the Docker image with the following command:

```
docker build \
  --label org.label-schema.build-date=$(date -u +"%Y-%m-%dT%H:%M:%SZ") \
  --label org.label-schema.vcs-ref=$(git rev-parse --short HEAD) \
  -t plugins/base:multiarch .
```
