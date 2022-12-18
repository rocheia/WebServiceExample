#!/usr/bin/env bash

#
# This script builds a layered docker image from a Spring Boot built executable Jar.
#
# The script extracts the built-in layers of the Spring Boot jar and creates layers in the Docker
# image for each (makes build and startup of the container faster if the base layers are already cached).
#
# The script uses the Spring Boot launcher to avoid the need to hard code the main class of the executable Jar
#

usage() { echo "Usage: $0 -j JarFile -t ImageTag" 1>&2; exit 1; }

# Validate Arguments
while getopts "j:t:" o; do
  case "${o}" in
    j)
      JAR_FILE=${OPTARG}
      ;;
    t)
      TAG_NAME=${OPTARG}
      ;;
    *)
      usage
      ;;
  esac
done

echo "Executing Spring Boot Docker image ${TAG_NAME} build with jar ${JAR_FILE}" 1>&2


# Create temporary directory to extract the Jar layers into and extract them
mkdir extracted
java -Djarmode=layertools -jar "${JAR_FILE}" extract --destination ./extracted

docker build -t "${TAG_NAME}" -<< EOF
FROM rhel7

# Create local account to run the process
RUN addgroup -S app_group && adduser -S sys_local_app -G app_group

# Create directory to contain the application and change ownersip to sys_local_app
RUN mkdir /app
RUN chown sys_local_app /app

# Change to the sys_local_app user so we do not run as root in the container
USER sys_local_app:local_group

# Switch to /app directory
WORKDIR /app

# Copy into the image the Spring Boot layers
COPY ./extracted/dependencies/ ./
COPY ./extracted/spring-boot-loader/ ./
COPY ./extracted/snapshot-dependencies/ ./
COPY ./extracted/application/ ./

# Execute the Jar using the Spring Boot loader to locate the main class
ENTRYPOINT ["java","org.springframework.boot.loader.JarLauncher"]

EOF

echo "Spring Boot Docker image build completed" 1>&2
