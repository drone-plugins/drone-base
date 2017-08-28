# drone-base

[![Build Status](http://beta.drone.io/api/badges/drone-plugins/drone-base/status.svg)](http://beta.drone.io/drone-plugins/drone-base)
[![Join the chat at https://gitter.im/drone/drone](https://badges.gitter.im/Join%20Chat.svg)](https://gitter.im/drone/drone)
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
