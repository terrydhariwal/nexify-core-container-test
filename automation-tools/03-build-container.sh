#!/bin/sh

# need to call scripts using source - since this works to set environment variables
# CURRENT_DIR=$(dirname $0) # does not work with source ./this-script
# when using source we need to use pwd
IMAGE_VERSIONS=`gcloud container images list-tags ${CONTAINER_REGISTRY}/${PROJECT_ID}/${IMAGE_NAME} --format=json`
echo ${IMAGE_VERSIONS} | jq
IMAGE_TAGS=`echo ${IMAGE_VERSIONS} | jq -r ".[].tags[]"`
echo ${IMAGE_TAGS}

if [[ $IMAGE_TAGS = *"$IMAGE_TAG"* ]]; then
   echo "Container image with tag ${IMAGE_TAG} already exists!"
else
  CURRENT_DIR=`pwd`
  echo ${CURRENT_DIR}
  cd ${CURRENT_DIR}/../container-build/docker/
  pwd
  gcloud builds submit --tag ${CONTAINER_REGISTRY}/${PROJECT_ID}/${IMAGE_NAME}:${IMAGE_TAG} .
  cd ${CURRENT_DIR}
fi
