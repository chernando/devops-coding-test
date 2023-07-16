FROM openjdk:11-jre-slim
ARG jar_file
EXPOSE 8443

RUN useradd -m -s /bin/bash app
USER app
WORKDIR /home/app

COPY $jar_file app.jar

CMD ["java", "-jar", "app.jar"]
