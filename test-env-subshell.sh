#!/bin/bash

# usage() {
#  echo "run using: "
#  echo "source ./test-env-subshell.sh --customer-name test123"
# }

# while [ "$1" != "" ]; do
#     case $1 in
#         --customer-name )          shift
#                                    source ./01-set-environment-variables.sh
#                                    ;;
#         --halyard-version )        shift
#                                    source ./01-set-environment-variables.sh
#                                    ;;
#         -h | --help )              usage
#                                    exit
#                                    ;;
#         * )                        usage
#                                    exit 1
#     esac
#     shift
# done

CURRENT_DIR=`pwd`
SCRIPTS_DIRECTORY=container-automation
cd ${SCRIPTS_DIRECTORY}
source ./01-set-environment-variables.sh $1 $2 $3 $4 $5 $6 $7 $8 $9 ${10} ${12} ${13} ${14} ${15} ${16} ${17} ${18} ${19} ${20} ${21} ${22} ${23} ${24} ${25} ${26} ${27} ${28}
cd ${CURRENT_DIR}
echo "CUSTOMER_NAME=${CUSTOMER_NAME}"
echo "HALYARD_VERSION=${HALYARD_VERSION}"
