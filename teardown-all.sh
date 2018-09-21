#!/bin/bash

CURRENT_DIR=`pwd`
SCRIPTS_DIRECTORY=container-automation

cd ${SCRIPTS_DIRECTORY}
source ./01-set-environment-variables.sh
source ./02-set-gcloud.sh
source ./07-delete-deployment.sh
source ./08-tear-down-cluster.sh
cd ${CURRENT_DIR}
