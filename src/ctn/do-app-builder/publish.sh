#!/usr/bin/env sh
#
# This script is sourced by Make

echo "Logging in to ghcr.io"

$BUILDAH login ghcr.io -u "$GHCR_USERNAME" -p "$GHCR_ACCESS_TOKEN"

for prefix in "${IMAGE_URI_PREFIXES[@]}" ; do

	publishUri="${prefix}/${IMAGE_NAME}:${CANONICAL_IMAGE_TAG}"

	echo "Publishing image ${publishUri}"

	$BUILDAH push --quiet "${IMAGE_NAME}" "$publishUri"

	# TODO: Check if current commit is branch HEAD
	# if it is push :latest
	$BUILDAH push --quiet "${IMAGE_NAME}" \
	 "${prefix}/${IMAGE_NAME}:latest"

done
