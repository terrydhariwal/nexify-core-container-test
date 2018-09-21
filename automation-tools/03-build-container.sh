#CURRENT_DIR=$(dirname $0)
CURRENT_DIR=`pwd`
echo ${CURRENT_DIR}
cd ${CURRENT_DIR}/../lens2northwind/
pwd
docker build -t ${image_name} .
cd ${CURRENT_DIR}
docker tag ${image_name} gcr.io/${PROJECT_ID}/quorum360:${image_name}
docker push gcr.io/${PROJECT_ID}/quorum360:${image_name}
