#!/bin/bash

SCRIPTS_DIRECTORY=container-automation

source ./${SCRIPTS_DIRECTORY}/01-set-environment-variables.sh
source ./${SCRIPTS_DIRECTORY}/02-set-gcloud.sh
source ./${SCRIPTS_DIRECTORY}/03-build-container.sh
source ./${SCRIPTS_DIRECTORY}/04-create-cluster-if-not-exists.sh
source ./${SCRIPTS_DIRECTORY}/05-deploy-container-image.sh
source ./${SCRIPTS_DIRECTORY}/06-test-deployment.sh
