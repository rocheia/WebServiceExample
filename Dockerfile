FROM openjdk:17-jdk-alpine

# Create local account to run the process
RUN addgroup -S local_group && adduser -S sys_local_app -G local_group

# Create directory to contain the application
RUN mkdir /app
# Change ownership to the local account
RUN chown sys_local_app /app

# Change to the local user so we do not run as root in the container
USER sys_local_app:local_group
# Change the working directory to /app
WORKDIR /app

# Argument is the location of the extracted layers of the spring boot fat jar
ARG DEPENDENCY=target/extracted
# Copy the layers into the container
COPY ${DEPENDENCY}/dependencies/ ./
COPY ${DEPENDENCY}/spring-boot-loader/ ./
COPY ${DEPENDENCY}/snapshot-dependencies/ ./
COPY ${DEPENDENCY}/application/ ./

# Run the application using the spring boot loader so we do not need to
# configure the main class name
ENTRYPOINT ["java","org.springframework.boot.loader.JarLauncher"]
