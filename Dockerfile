# Stage 1: Build the Traccar application
FROM eclipse-temurin:17-jdk-jammy AS builder

# Set the working directory
WORKDIR /opt/traccar

# Copy the Gradle wrapper and build scripts
COPY ./traccar/gradlew ./traccar/gradlew.bat ./traccar/build.gradle ./traccar/settings.gradle /opt/traccar/
# COPY gradle /opt/traccar/gradle

# Copy the source code
COPY ./traccar /opt/traccar

# Make the Gradle wrapper executable
RUN chmod +x gradlew

# Build the project using the Gradle wrapper
RUN ./gradlew assemble --no-daemon

# Stage 2: Run the Traccar application
FROM eclipse-temurin:17-jre-jammy

# Set the working directory
WORKDIR /opt/traccar

COPY --from=builder /opt/traccar/ ./

COPY --from=builder /opt/traccar/target/ ./

# Expose the Traccar port
EXPOSE 8082

# Set the entry point
ENTRYPOINT ["java", "-Xms512m", "-Xmx512m", "-Djava.net.preferIPv4Stack=true", "-jar", "tracker-server.jar", "setup/traccar.xml"]
