# drone-base

[![Build status](https://ci.appveyor.com/api/projects/status/ai796elpx06lc06j/branch/windows?svg=true)](https://ci.appveyor.com/project/tboerger/drone-base/branch/windows)
[![Join the discussion at https://www.reddit.com/r/droneci/](https://img.shields.io/badge/reddit-forum-orange.svg)](https://www.reddit.com/r/droneci/)
[![Drone questions at https://stackoverflow.com](https://img.shields.io/badge/drone-stackoverflow-orange.svg)](https://stackoverflow.com/questions/tagged/drone.io)
[![](https://images.microbadger.com/badges/image/plugins/base.svg)](https://microbadger.com/images/plugins/base "Get your own image badge on microbadger.com")

This repository is used to build the base images used by our plugins. It just defines oure base Windows image to make version updates much easier.

## Docker

Build the Docker image with the following command:

```
docker build \
  --label org.label-schema.build-date=$(date -u +"%Y-%m-%dT%H:%M:%SZ") \
  --label org.label-schema.vcs-ref=$(git rev-parse --short HEAD) \
  -t plugins/base:windows .
```
