# need to call scripts using source - since this works to set environment variables
# CURRENT_DIR=$(dirname $0) # does not work with source ./this-script
# when using source we need to use pwd
CONTAINER_IMAGE_VERSIONS=`gcloud container images list-tags gcr.io/quorum-360-187413/quorum360 --format=json`
echo ${CONTAINER_IMAGE_VERSIONS} | jq
CONTAINER_IMAGE_TAGS=`echo ${CONTAINER_IMAGE_VERSIONS} | jq -r ".[].tags[]"`
echo ${CONTAINER_IMAGE_TAGS}

if [[ $CONTAINER_IMAGE_TAGS = *"$IMAGE_NAME"* ]]; then
   echo "Container image with tag ${IMAGE_NAME} already exists!"
else
  CURRENT_DIR=`pwd`
  echo ${CURRENT_DIR}
  cd ${CURRENT_DIR}/../lens2northwind/
  pwd
  gcloud builds submit --tag gcr.io/${PROJECT_ID}/quorum360:${IMAGE_NAME} .
  cd ${CURRENT_DIR}
fi
