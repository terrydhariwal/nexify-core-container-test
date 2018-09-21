#!/bin/bash

CURRENT_DIR=`pwd`
SCRIPTS_DIRECTORY=container-automation

cd ${SCRIPTS_DIRECTORY}
source ./01-set-environment-variables.sh
source ./02-set-gcloud.sh
source ./03-build-container.sh
source ./04-create-cluster-if-not-exists.sh
source ./05-deploy-container-image.sh
source ./06-test-deployment.sh
cd ${CURRENT_DIR}
