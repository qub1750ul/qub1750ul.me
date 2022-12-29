# DigitalOcean App Platform build script
#
# This Container-file creates a containerized environment in which the project
# build system can run.
# Note that the build system spawns containers in turn, so it is necessary to
# prepare environment for nested containerization.

# The podman base container is special: it allows container nesting OOTB.
# Ref: https://www.redhat.com/sysadmin/podman-inside-container
FROM quay.io/containers/podman:v4.3.1 AS builder

# Install missing dependencies
RUN dnf -y install make git

# Switch to user 'podman' to enable nested containers
USER podman

# Copy sources into the container. Then start the build.
ADD --chown=podman . /mnt/projectRoot/
RUN make -C /mnt/projectRoot build/hugo/
