#need to call scripts using source - since this works to set environment variables
#CURRENT_DIR=$(dirname $0) # does not work with source ./this-script
# when using source we need to use pwd
CURRENT_DIR=`pwd`
echo ${CURRENT_DIR}
cd ${CURRENT_DIR}/../lens2northwind/
pwd
docker build -t ${IMAGE_NAME} .
cd ${CURRENT_DIR}
docker tag ${IMAGE_NAME} gcr.io/${PROJECT_ID}/quorum360:${IMAGE_NAME}
docker push gcr.io/${PROJECT_ID}/quorum360:${IMAGE_NAME}
