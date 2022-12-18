FROM openjdk:17-jdk-alpine

# Create local account to run the process
RUN groupadd --gid 1000 localapp && useradd --uid 1000 --gid 1000 -m localapp

# Create directory to contain the application
RUN mkdir /app
# Change ownership to the local account
RUN chown localapp:localapp /app

# Change to the local user so we do not run as root in the container
USER localapp
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
