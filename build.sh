#!/bin/bash

#source build vars
source config/build.conf

function cleanup {
    echo "Destroying environment..."
    rm -rf ./${VENV}
    rm -rf ./*.zip 
    rm -rf ./*.log 
}

function setup { # ->  Creates a new vurtual python enviroment
    echo "[+] Creating environment... [$NOW]"  >> ${BUILD_LOG}
    cd ${BASE} 
    virtualenv ${VENV}  >> ${BUILD_LOG}
    source ${VENV}/bin/activate  >> ${BUILD_LOG}
    for i in "${pkg_list[@]}"
    do
        pip install "$i" >> ${BUILD_LOG}
    done
    mkdir ${VENV}/dist  >> ${BUILD_LOG}
}

function build {
    # -> Packages lambda function into acceptable ZIP format
    echo "[+] Building Lambda package at ${BASE}/${PACKAGE_NAME}.zip... [$NOW]"  >> ${BUILD_LOG}
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