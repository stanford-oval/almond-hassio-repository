#!/bin/bash

: ${TEST:=1}
: ${ARCHS:="armv7 aarch64 amd64"}

args=""
if [ ${TEST} -eq 1 ]; then
	args="--test"
else
	echo "$DOCKER_PASSWORD" | docker login -u "$DOCKER_USERNAME" --password-stdin
fi

if [ -n "$1" ] && [ -d "$1" ]; then
	cd ${1}
else
	echo "error: $1 doesn't exist"
fi

set -ex
echo "Running in $(pwd)"

for arch in ${ARCHS}; do
	docker run --rm --name hassio-builder --privileged -i \
		-v "$(pwd)":/data \
		-v ~/.docker:/root/.docker \
		-v /var/run/docker.sock:/var/run/docker.sock:ro \
		homeassistant/${arch}-builder \
		-t /data \
		--${arch} \
		-i almond-hassio-addon-{arch} \
		${args} \
		--no-latest
done
