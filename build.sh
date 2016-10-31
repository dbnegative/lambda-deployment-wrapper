#!/bin/bash
FUNCTION_NAME="CHANGEME" #aka cloudfront-log-ingester


# VirtualEnv vars
VENV="_venv"
VENV_LIBS=${VENV}/lib/python2.7/site-packages
BASE=`pwd`

#Build Vars
NOW=`date`
SUFFIX=`date -j -f "%a %b %d %T %Z %Y" "${NOW}" "+%s"`
PACKAGE_NAME="${FUNCTION_NAME}-${SUFFIX}"
SERVICE_FILE="lambda_function.py"
BUILD_LOG="${BASE}/build-${SUFFIX}.log"

function cleanup {
    echo "Destroying environment...."
    rm -rf ./${VENV}
    rm -rf ./*.zip 
    rm -rf ./*.log 
}

function setup { # ->  Creates a new vurtual python enviroment
    echo "[+] Creating environment \n [$NOW]"  >> ${BUILD_LOG}
    cd ${BASE} 
    virtualenv ${VENV}  >> ${BUILD_LOG}
    source ${VENV}/bin/activate  >> ${BUILD_LOG}
    pip install elasticsearch  >> ${BUILD_LOG}
    pip install aws_requests_auth  >> ${BUILD_LOG}
    mkdir ${VENV}/dist  >> ${BUILD_LOG}
}

function build {
    # -> Packages lambda function into acceptable ZIP format
    echo "[+] Building Lambda package at ${BASE}/${PACKAGE_NAME}.zip [$NOW]"  >> ${BUILD_LOG}
    rm -rf ${VENV}/dist/*  >> ${BUILD_LOG}
    cp -R ${VENV_LIBS}/* ${VENV}/dist/  >> ${BUILD_LOG}
    cp ${SERVICE_FILE} ${VENV}/dist/  >> ${BUILD_LOG}
    cd ${VENV}/dist && zip -r ${BASE}/${PACKAGE_NAME}.zip *  >> ${BUILD_LOG}
    echo "${PACKAGE_NAME}.zip"
}

usage="$(basename "$0") [-h] [-bcs] -- Build Lambda Function

where:
    -h  show this help text
    -b  build
    -c  cleanup
    -s  setup"

while getopts ':hbsc' option; do
  case "$option" in
    h) echo "$usage"
       exit
       ;;
    b) build
       ;;
    c) cleanup
       ;;
    s) setup
       ;;

  esac
done
shift $((OPTIND - 1))