#!/bin/sh

source 01-set-environment-variables.sh
source 02-set-gcloud.sh


gcloud container clusters get-credentials ${CLUSTER_NAME} --zone "${COMPUTE_ZONE}"

#Delete your cluster by running gcloud container clusters delete:
gcloud container clusters delete ${CLUSTER_NAME} --zone=${COMPUTE_ZONE} --async --quiet
