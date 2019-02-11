#!/usr/bin/env bash
set -Eeuo pipefail

readlinkCmd="readlink"

if command -v greadlink >/dev/null 2>&1; then
	readlinkCmd="greadlink"
fi

cd $(dirname $("$readlinkCmd" -f "$BASH_SOURCE"))

for imagePath in $(find ./php/* -maxdepth 0 -type d); do
	version="${imagePath##*/}"
	imageName="jyggen/php-gitlab-ci:$version"
	docker build --pull --compress --cache-from $imageName -t $imageName -f php/$version/Dockerfile .
	docker push $imageName
done
