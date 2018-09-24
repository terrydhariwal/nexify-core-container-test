#!/bin/bash

usage() {
 echo "run using: "
 echo "source ./test-env-subshell.sh --customer-name test123"
}

run-01-set-environment-variables() {
  CURRENT_DIR=`pwd`
  SCRIPTS_DIRECTORY=container-automation
  cd ${SCRIPTS_DIRECTORY}
  source ./01-set-environment-variables.sh $1 $2 $3 $4 $5 $6 $7 $8 $9 ${10} ${12} ${13} ${14} ${15} ${16} ${17} ${18} ${19} ${20} ${21} ${22} ${23} ${24} ${25} ${26} ${27} ${28}
  cd ${CURRENT_DIR}
  echo "CUSTOMER_NAME=${CUSTOMER_NAME}"
  echo "HALYARD_VERSION=${HALYARD_VERSION}"
}

while [ "$1" != "" ]; do
    case $1 in
        --customer-name )          shift
                                   export CUSTOMER_NAME=$1
                                   ;;
        --halyard-version )        shift
                                   export HALYARD_VERSION=$1
                                   ;;
        -h | --help )              usage
                                   exit
                                   ;;
        * )                        usage
                                   exit 1
    esac
    shift
done

run-01-set-environment-variables
