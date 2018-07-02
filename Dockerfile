# escape=`
# The nanoserver:1709 container does not come with powershell installed on it
# so the powershell image should be used when requiring any commands to be run
# to add to the image contents
FROM microsoft/powershell:nanoserver

LABEL maintainer="Drone.IO Community <drone-dev@googlegroups.com>" `
  org.label-schema.name="Drone Base" `
  org.label-schema.vendor="Drone.IO Community" `
  org.label-schema.schema-version="1.0"

# In the powershell container pwsh is the name of the command
SHELL ["pwsh", "-Command", "$ErrorActionPreference = 'Stop'; $ProgressPreference = 'SilentlyContinue';"]
