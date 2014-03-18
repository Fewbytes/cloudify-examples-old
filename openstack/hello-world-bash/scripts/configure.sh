#!/bin/sh

TEMP_DIR="/tmp"
PYTHON_FILE_SERVER_ROOT=${TEMP_DIR}/python-simple-http-webserver
if [ -d ${PYTHON_FILE_SERVER_ROOT} ]; then
	echo "Removing file server root folder ${PYTHON_FILE_SERVER_ROOT}"
	rm -rf ${PYTHON_FILE_SERVER_ROOT}
fi
echo "Creating HTTP server root directory at ${PYTHON_FILE_SERVER_ROOT}"
mkdir -p ${PYTHON_FILE_SERVER_ROOT}

if [ $DEV_MODE = true ]; then	
	echo "Copying index.html to file server root"
	cp ../index.html ${PYTHON_FILE_SERVER_ROOT}
else
	echo "Downloading index.html to file server root"
	wget ${CLOUDIFY_FILE_SERVER_BLUEPRINT_ROOT}/index.html -O  ${PYTHON_FILE_SERVER_ROOT}/index.html
fi	

