#!/bin/bash

SCRIPTS_DIRECTORY=container-automation

source ./${SCRIPTS_DIRECTORY}/01-set-environment-variables.sh
source ./${SCRIPTS_DIRECTORY}/02-set-gcloud.sh
source ./${SCRIPTS_DIRECTORY}/07-delete-deployment.sh
source ./${SCRIPTS_DIRECTORY}/08-tear-down-cluster.sh
