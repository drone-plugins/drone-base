# drone-base

[![Build Status](http://cloud.drone.io/api/badges/drone-plugins/drone-base/status.svg)](http://cloud.drone.io/drone-plugins/drone-base)
[![Gitter chat](https://badges.gitter.im/drone/drone.png)](https://gitter.im/drone/drone)
[![Join the discussion at https://discourse.drone.io](https://img.shields.io/badge/discourse-forum-orange.svg)](https://discourse.drone.io)
[![Drone questions at https://stackoverflow.com](https://img.shields.io/badge/drone-stackoverflow-orange.svg)](https://stackoverflow.com/questions/tagged/drone.io)
[![](https://images.microbadger.com/badges/image/plugins/base.svg)](https://microbadger.com/images/plugins/base "Get your own image badge on microbadger.com")

This repository is used to build the base images for our plugins. It just adds a general `/etc/ssl/certs/ca-certificates.crt` and `/etc/mime.types` to an Alpine or a Scratch image depending on the tag.
