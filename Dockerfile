# syntax=docker/dockerfile:experimental
# FROM maven:3.8-jdk-11 as builder
# WORKDIR /workspace/app

# WORKDIR /app
# COPY pom.xml .
# COPY src ./src

# # RUN ./mvn install -DskipTests
# RUN mvn install -DskipTests

# COPY --from=builder target/*.jar target/application.jar
# RUN java -Djarmode=layertools -jar target/application.jar extract --destination target/extracted

# FROM openjdk:8-jdk-alpine
# RUN addgroup -S demo && adduser -S demo -G demo
# VOLUME /tmp
# USER demo
# ARG EXTRACTED=/workspace/app/target/extracted
# WORKDIR application
# COPY --from=build ${EXTRACTED}/dependencies/ ./
# COPY --from=build ${EXTRACTED}/spring-boot-loader/ ./
# COPY --from=build ${EXTRACTED}/snapshot-dependencies/ ./
# COPY --from=build ${EXTRACTED}/application/ ./
# ENTRYPOINT ["java","-noverify","-XX:TieredStopAtLevel=1","-Dspring.main.lazy-initialization=true","org.springframework.boot.loader.JarLauncher"]

FROM maven:3.8-jdk-11 as builder

# Copy local code to the container image.
WORKDIR /app
COPY pom.xml .
COPY src ./src

# Build a release artifact.
RUN mvn package -DskipTests

# Use AdoptOpenJDK for base image.
# It's important to use OpenJDK 8u191 or above that has container support enabled.
# https://hub.docker.com/r/adoptopenjdk/openjdk8
# https://docs.docker.com/develop/develop-images/multistage-build/#use-multi-stage-builds
FROM adoptopenjdk/openjdk11:alpine-jre

# Copy the jar to the production image from the builder stage.
COPY --from=builder /app/target/*.jar /application.jar

# Run the web service on container startup.
CMD ["java", "-Djava.security.egd=file:/dev/./urandom", "-jar", "/application.jar"]
