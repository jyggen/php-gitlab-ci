#!/usr/bin/env bash
set -Eeuo pipefail

declare -A images=(
  [5.5]='php:5.5-alpine'
	[5.6]='php:5.6-alpine'
  [7.0]='php:7.0-alpine'
	[7.1]='php:7.1-alpine'
	[7.1-dev]='phpdaily/php:7.1-dev'
	[7.2]='php:7.2-alpine'
	[7.2-dev]='phpdaily/php:7.2-dev'
	[7.3]='php:7.3-alpine'
	[7.3-dev]='phpdaily/php:7.3-dev'
	[7.4-dev]='phpdaily/php:7.4-dev'
	[8.0-dev]='phpdaily/php:8.0-dev'
)

generated_warning() {
	cat <<-EOH
		#
		# NOTE: THIS DOCKERFILE IS GENERATED VIA "update.sh"
		#
		# PLEASE DO NOT EDIT IT DIRECTLY.
		#

	EOH
}

baseDockerfile="Dockerfile.template"
readlinkCmd="readlink"

if command -v greadlink >/dev/null 2>&1; then
	readlinkCmd="greadlink"
fi

sedCmd="sed"

if command -v gsed >/dev/null 2>&1; then
	sedCmd="gsed"
fi

cd $(dirname $("$readlinkCmd" -f "$BASH_SOURCE"))

for version in "${!images[@]}"; do
	baseImage="${images[$version]}"
	majorVersion="${version%%.*}"
	minorVersion="${version#$majorVersion.}"
	minorVersion="${minorVersion%-dev}"

	echo "Generating php/$version/Dockerfile from $baseDockerfile"

  mkdir -p "php/$version"
	{ generated_warning; cat "$baseDockerfile"; } > "php/$version/Dockerfile"

	$sedCmd -ri \
		-e 's!%%BASE_IMAGE%%!'"$baseImage"'!' \
		-e 's!%%PHP_VERSION%%!'"$version"'!' \
		"php/$version/Dockerfile"

	# the alpine version 5.3 is running does not have libzip-dev.
	if [ "$majorVersion" = '5' -a "$minorVersion" -lt '6' ]; then
		$sedCmd -ri \
			-e 's/ libzip-dev//g' \
			"php/$version/Dockerfile"
	fi

	# pcov only supports 7.1 and later, and PEAR/PECL is (currently) non-functioning on 8.0-dev.
	if [ "$majorVersion" -lt '7' ] || [ "$majorVersion" -gt '7' ] || [ "$majorVersion" = '7' -a "$minorVersion" -lt '1' ]; then
		$sedCmd -ri \
			-e '/&& apk add --no-cache --virtual .build-deps/d' \
			-e '/&& pecl install pcov-1.0.0/d' \
			-e '/&& apk del .build-deps/d' \
			-e '/&& docker-php-ext-enable pcov/d' \
			"php/$version/Dockerfile"
	fi

	# mcrypt is unavailable in 7.2 and later.
	if [ "$majorVersion" -gt '7' ] || [ "$majorVersion" = '7' -a "$minorVersion" -gt '1' ]; then
		$sedCmd -ri \
			-e 's/ libmcrypt-dev//g' \
			-e 's/ mcrypt//g' \
			"php/$version/Dockerfile"
	fi
done
