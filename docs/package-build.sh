#!/usr/bin/env bash
# git kolide/launcher
# make deps
# make all
# make package-builder

$GOPATH/src/github.com/kolide/launcher/build/package-builder make \
  --hostname=fleet.{somedomain.io}:8081 \
  --enroll_secret={some enroll secret}

# $GOPATH/src/github.com/kolide/launcher/build/package-builder make \
#   --hostname=localhost:2024 \
#   --enroll_secret={some enroll secret} \
#   --insecure
#  --autoupdate \
#  --update_channel=nightly \
#  --cert_pins=5dc4d2318f1ffabb80d94ad67a6f05ab9f77591ffc131498ed03eef3b5075281
