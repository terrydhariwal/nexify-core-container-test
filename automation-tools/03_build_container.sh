CURRENT_DIR=$(dirname $0)
cd ${CURRENT_DIR}/../lens2northwind/
docker build -t quorum360-halyard-v1.5-4gbram .
cd CURRENT_DIR
docker tag ${image_name} gcr.io/${PROJECT_ID}/quorum360:${image_name}
docker push gcr.io/${PROJECT_ID}/quorum360:${image_name}
