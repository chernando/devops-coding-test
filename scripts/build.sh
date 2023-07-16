#!/bin/sh
#
set -e

cd "$(dirname "$0")/.."

echo "🏗  Build started at… $(date "+%H:%M:%S")"
./mvnw clean install

. target/maven-archiver/pom.properties
JAR_FILE=target/$artifactId-$version.jar
echo "🐳  Build docker for $JAR_FILE at… $(date "+%H:%M:%S")"

if test -f "$JAR_FILE"; then

	docker build \
		--file scripts/Dockerfile \
		--tag $artifactId:$version \
		--build-arg jar_file=$JAR_FILE \
		.

else
	echo "🛑  $JAR_FILE not found"
	exit 1
fi

echo "✅  All done! $(date "+%H:%M:%S")"
