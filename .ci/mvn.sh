#!/bin/bash
#
# Script to run mvn commands setting options and cli parameters for suitable CI execution
#
# Requires CI_PROJECT_DIR to be set to cache maven packages correctly
#

# Switch on echo of commands
set -x

if [ -z "$CI_PROJECT_DIR" ]; then
  echo "ERROR: CI_PROJECT_DIR must be set.  Exiting...."
  exit 1
fi

# Maven options
export MAVEN_OPTS="-Dmaven.repo.local=$CI_PROJECT_DIR/.m2/repository -Dorg.slf4j.simpleLogger.log.org.apache.maven.cli.transfer.Slf4jMavenTransferListener=WARN -Dorg.slf4j.simpleLogger.showDateTime=true -Djava.awt.headless=true"
MAVEN_CLI_OPTS="--batch-mode --errors --fail-at-end --show-version -DinstallAtEnd=true -DdeployAtEnd=true -Dsurefirce.useFile=false"
MAVEN_HOME=/app/maven

# Execute the maven command
$MAVEN_HOME/bin/mvn "$MAVEN_CLI_OPTS" "$@"
