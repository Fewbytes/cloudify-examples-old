#!/bin/bash

. ${CLOUDIFY_LOGGING}

TEMP_DIR="/tmp"
PYTHON_FILE_SERVER_ROOT=${TEMP_DIR}/python-simple-http-webserver
BLUEPRINT_PATH=blueprints/${CLOUDIFY_BLUEPRINT_ID}
if [ -d ${PYTHON_FILE_SERVER_ROOT} ]; then
	echo "Removing file server root folder ${PYTHON_FILE_SERVER_ROOT}"
	rm -rf ${PYTHON_FILE_SERVER_ROOT} || exit $?
fi
info "Creating HTTP server root directory at ${PYTHON_FILE_SERVER_ROOT}"
mkdir -p ${PYTHON_FILE_SERVER_ROOT} || exit $?

echo "Changing directory to ${PYTHON_FILE_SERVER_ROOT}"
cd ${PYTHON_FILE_SERVER_ROOT}
info "Downloading index to web server"
wget -x -nH ${CLOUDIFY_FILE_SERVER_BLUEPRINT_ROOT}/${index_path} || exit $?
info "Downloading image to web server"
wget -x -nH ${CLOUDIFY_FILE_SERVER_BLUEPRINT_ROOT}/${image_path} || exit $?

# Add dynamic data

echo "Generating dynamic data"

sed -i "s|{0}|${CLOUDIFY_BLUEPRINT_ID}|g" ${PYTHON_FILE_SERVER_ROOT}/${BLUEPRINT_PATH}/${index_path} || exit $?
sed -i "s|{1}|${CLOUDIFY_DEPLOYMENT_ID}|g" ${PYTHON_FILE_SERVER_ROOT}/${BLUEPRINT_PATH}/${index_path} || exit $?
sed -i "s|{2}|${CLOUDIFY_NODE_ID}|g" ${PYTHON_FILE_SERVER_ROOT}/${BLUEPRINT_PATH}/${index_path} || exit $?
sed -i "s|{3}|/blueprints/${CLOUDIFY_BLUEPRINT_ID}/{image_path}|g" ${PYTHON_FILE_SERVER_ROOT}/${BLUEPRINT_PATH}/${index_path} || exit $?

echo "index file is ready"

