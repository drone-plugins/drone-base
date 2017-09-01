FROM alpine:3.6
MAINTAINER Drone.IO Community <drone-dev@googlegroups.com>

ENV GODEBUG=netdns=go

RUN apk add -U --no-cache ca-certificates mailcap

LABEL org.label-schema.version=amd64
LABEL org.label-schema.vcs-url="https://github.com/drone-plugins/drone-base.git"
LABEL org.label-schema.name="Drone Base"
LABEL org.label-schema.vendor="Drone.IO Community"
LABEL org.label-schema.schema-version="1.0"
