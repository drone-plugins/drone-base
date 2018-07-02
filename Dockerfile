# escape=`
FROM microsoft/nanoserver:10.0.14393.1593

LABEL maintainer="Drone.IO Community <drone-dev@googlegroups.com>" `
  org.label-schema.name="Drone Base" `
  org.label-schema.vendor="Drone.IO Community" `
  org.label-schema.schema-version="1.0"

SHELL ["powershell", "-Command", "$ErrorActionPreference = 'Stop'; $ProgressPreference = 'SilentlyContinue';"]
