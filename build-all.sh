#!/bin/bash

CURRENT_DIR=`pwd`
SCRIPTS_DIRECTORY=container-automation

echo "in build-all"
echo "1 = $1"
echo "2 = $2"
echo "3 = $3"
echo "4 = $4"

cd ${SCRIPTS_DIRECTORY}
source ./01-set-environment-variables.sh $1 $2 $3 $4 $5 $6 $7 $8 $9 ${10} ${12} ${13} ${14} ${15} ${16} ${17} ${18} ${19} ${20} ${21} ${22} ${23} ${24} ${25} ${26} ${27} ${28}
#source ./02-set-gcloud.sh
# source ./03-build-container.sh
# source ./04-create-cluster-if-not-exists.sh
# source ./05-deploy-container-image.sh
# source ./06-test-deployment.sh
cd ${CURRENT_DIR}
