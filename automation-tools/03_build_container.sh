CURRENT_DIR=$(dirname $0)
cd CURRENT_DIR/../lens2northwind/
docker build -t quorum360-halyard-v1.5-4gbram .
cd CURRENT_DIR
docker tag quorum360-halyard-v1.5-4gbram gcr.io/quorum-360-187413/quorum360:halyard-v1.5-4gb-ram
docker push gcr.io/quorum-360-187413/quorum360:halyard-v1.5-4gb-ram
