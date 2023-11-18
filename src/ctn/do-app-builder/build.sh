#!/usr/bin/env bash

# THIS SCRIPT IS SOURCED BY MAKE

# DigitalOcean App Platform build container
#
# This script creates a containerized environment in which the project
# build process is guaranteed to run smoothly.
# Note that the build system spawns containers, so it is necessary to enable
# nested containerization for this to work.

#------------------------------------------------------------------------------
# BUILD PARAMETERS
#------------------------------------------------------------------------------

# The podman base container is special: it allows container nesting OOTB.
# Ref: https://www.redhat.com/sysadmin/podman-inside-container
declare -r baseImage=docker://quay.io/containers/podman:v4.7.0

declare -ra packages=(make git)

#------------------------------------------------------------------------------
# BUILD SCRIPT
#------------------------------------------------------------------------------

shopt -s lastpipe

declare -a layers=()
declare -n wctn=layers[${#layers[@]}]

echo "Starting build for image $IMAGE_NAME"

$BUILDAH from "$baseImage" | mapfile -t -O "${#layers[@]}" layers

# Install missing packages
$BUILDAH run "$wctn" -- dnf -y install "${packages[@]}"

#------------------------------------------------------------------------------
# CONFIGURATION SCRIPT
#------------------------------------------------------------------------------

# Switch to user _podman_ to enable nested containers
$BUILDAH config --user podman "$wctn"

# Start build by default
$BUILDAH config --cmd "make hugo.build" "$wctn"

$BUILDAH commit "$wctn" "$IMAGE_NAME"
