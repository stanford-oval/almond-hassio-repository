#!/bin/bash

set -e
set -x

: ${image_ns:="$(echo ${IMAGE_NAME} | cut -d'/' -f1-2)"}
: ${etag:=""}

archs="armv7 aarch64 amd64"
for arch in ${archs}; do
	docker push ${image_ns}/almond-hassio-addon-${arch}${etag}
done
