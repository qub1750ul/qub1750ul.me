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
RUN dnf -y install make

# Switch to user 'podman' to enable nested containers
USER podman

# Mount build context over container VFS. Then do actual build work.
ADD . projectRoot
RUN make -C projectRoot build/hugo/

# DigitalOcean's cloud automation system searches for files to publish into the
# container file system. As the previous build step wrote files on a bind mount
# that ISN'T part of container's fs, we create a clean layer and copy these in
# a predefined location on it.
FROM scratch AS final
ADD build /mnt/projectRoot/build
