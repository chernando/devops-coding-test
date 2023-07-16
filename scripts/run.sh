#!/bin/sh

set -e

cd "$(dirname "$0")/.."

if test -f target/maven-archiver/pom.properties; then
	echo "▶️  Started at… $(date "+%H:%M:%S")"
	. target/maven-archiver/pom.properties

	docker run \
		-p 8443:8443 \
		--interactive \
		--tty \
		--rm \
		example/$artifactId:$version
	echo "⏹  Stopped at… $(date "+%H:%M:%S")"

else
	echo "🛑  You need to use 'scripts/build.sh' first"
	exit 1
fi
