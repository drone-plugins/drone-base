FROM alpine:3.7 as alpine
RUN apk add --no-cache ca-certificates mailcap

FROM scratch

ENV GODEBUG=netdns=go

COPY --from=alpine /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/
COPY --from=alpine /etc/mime.types /etc/

LABEL maintainer="Drone.IO Community <drone-dev@googlegroups.com>" \
  org.label-schema.name="Drone Base" \
  org.label-schema.vendor="Drone.IO Community" \
  org.label-schema.schema-version="1.0"
