# Notes

These are my edited notes. I tried to annotate my mental processing as I was going through the challenge.

## Previous considerations

I have no experience using:

- Spring Boot projects,

- Maven,

- GitHub Actions.

The last time I touched Java was around 2010. So I might have committed some obvious errors for someone with real experience.

I only used ChatGPT to scaffold the README file.

## Establishing hard restrictions

In order to resolve the challenge, I established that:

- no changes outside the scripts folder,

- no upgrade dependencies or tools.

The scenario is to support an existing developer team and try not to change their current environment.

## First steps

I identified `pom.xml` as Maven dependency file and `mvnw` as a wrapper of the former.

I tried `mvnm clean install` but failed. Something was missing. Later I realized what was.

So I tried to use a pure Docker builder for the project and ensure it was in working condition:

```shel
docker run -it --rm --name my-maven-project -v “$(pwd)”:/usr/src/mymaven -w /usr/src/mymaven maven:3.8.6-jdk-11 mvn clean install
```

I chose Maven 3.8.6 as it was the last listed for JDK 11.

It worked correctly, generating a JAR file inside target folder:

```shell
java -jar target/demo-0.0.1-SNAPSHOT.jar

http http://localhost:8443/
HTTP/1.1 200
Connection: keep-alive
Content-Length: 12
Content-Type: text/plain;charset=UTF-8 Date: Thu, 13 Jul 2023 15:40:45 GMT
Keep-Alive: timeout=60

Hello world!
```

## First versions for Dockerfile

From this point, my aim is to build the application inside a container ecosystem.

I started with a simple Dockerfile like this:

```dockerfile
FROM openjdk:11-jdk-slim

COPY mvnw . COPY ./.mvn ./.mvn COPY pom.xml . COPY src ./src

RUN ./mvnw clean install
```

Which worked correctly:

```shell
docker run -p 8443:8443 -it --rm test java -jar /target/demo-0.0.1-SNAPSHOT.jar
```

Then, I adjusted to a multi-stage Dockerfile to slim down the production image:

```dockerfile
FROM openjdk:11-jdk-slim as build

COPY mvnw . COPY ./.mvn ./.mvn COPY pom.xml . COPY src ./src

RUN ./mvnw clean install

FROM openjdk:11-jre-slim

COPY --from=build /target/demo-0.0.1-SNAPSHOT.jar app.jar

CMD java -jar app.jar
```

## Back to the Challenge

You fixed the main objectives to use scripts files and to be included into a Continuous Integration tool. So I revamped my approach to include the building logic into the build file and lighten the Dockerfile.

This way, it should be more easy to add more steps to the CI/CD pipeline (code analysis, linters, integration and acceptance tests, etc.)

## Continuous Integration Tool: GitHub Actions

As you mentioned during the interview, you’re migrating from Travis to GitHub Actions. I haven't used either of them so I tried GitHub Actions.

I found an Action which includes Maven and caches dependencies so I just used. You can follow my improvements through the Actions tabs.

You defined no branching strategy, so I used a simple trunk based development for trigger events.

## Optional: Publishing docker images to AWS

I made this part blind, no real AWS account used. But you can read what I’ve inferred from the docs in the [README](./README.md) file.

## Additional comments

I’ve made one change outside scripts file, concerning Maven wrapper:

- removed `.mvn/wrapper/maven-wrapper.jar` from the repository

- added `.mvn/wrapper/maven-wrapper.properties` to pin down the exact Maven version used.

Also, I’ve run a linter over Dockerfile:

```shell
docker run --rm -i hadolint/hadolint < Dockerfile
```

## Other things to consider

- openjdk-11 image is deprecated, you should update it for security reasons. (I’ve used corretto for GitHub Actions.)

- I didn’t add the support for Windows.

- The .dockerignore could be improved.
