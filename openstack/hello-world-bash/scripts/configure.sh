#!/bin/bash

TEMP_DIR="/tmp"
PYTHON_FILE_SERVER_ROOT=${TEMP_DIR}/python-simple-http-webserver
if [ -d ${PYTHON_FILE_SERVER_ROOT} ]; then
	echo "Removing file server root folder ${PYTHON_FILE_SERVER_ROOT}"
	rm -rf ${PYTHON_FILE_SERVER_ROOT} || exit $?
fi
echo "Creating HTTP server root directory at ${PYTHON_FILE_SERVER_ROOT}"
mkdir -p ${PYTHON_FILE_SERVER_ROOT} || exit $?

cd ${PYTHON_FILE_SERVER_ROOT} || exit $?
echo "Downloading index to web server"
wget -x -nH ${CLOUDIFY_FILE_SERVER_BLUEPRINT_ROOT}/${index_path} || exit $?
echo "Downloading image to web server"
wget -x -nH ${CLOUDIFY_FILE_SERVER_BLUEPRINT_ROOT}/${image_path} || exit $?

# Add dynamic data

echo "Generating dynamic data"

sed -i "s|{0}|${CLOUDIFY_BLUEPRINT_ID}|g" ${PYTHON_FILE_SERVER_ROOT}/${index_path} || exit $?
sed -i "s|{1}|${CLOUDIFY_DEPLOYMENT_ID}|g" ${PYTHON_FILE_SERVER_ROOT}/${index_path} || exit $?
sed -i "s|{2}|${CLOUDIFY_NODE_ID}|g" ${PYTHON_FILE_SERVER_ROOT}/${index_path} || exit $?
sed -i "s|{3}|{image_path}|g" ${PYTHON_FILE_SERVER_ROOT}/${index_path} || exit $?

echo "index file is ready"

