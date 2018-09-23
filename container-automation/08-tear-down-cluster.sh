#!/bin/sh

# TODO - print env variables set in 01-set-environment-variables.#!/bin/sh
# and prompt user if they are sure deletion is ok
# use --quiet to force deletion w/o prompt

gcloud container clusters get-credentials ${CLUSTER_NAME} --zone "${COMPUTE_ZONE}"

#Delete your cluster by running gcloud container clusters delete:
gcloud container clusters delete ${CLUSTER_NAME} --zone=${COMPUTE_ZONE} --async --quiet
