#!/bin/bash

TEMP_DIR="/tmp"
PYTHON_FILE_SERVER_ROOT=${TEMP_DIR}/python-simple-http-webserver
PID_FILE="server.pid"

echo "Starting HTTP server from ${PYTHON_FILE_SERVER_ROOT}"

cd ${PYTHON_FILE_SERVER_ROOT} || exit $?
nohup python -m SimpleHTTPServer ${port} > /dev/null 2>&1 &
echo $! > ${PID_FILE}

echo "Waiting for server to launch"

STARTED=false
for i in $(seq 1 15)
do
	if wget http://localhost:${port} 2>/dev/null ; then
		echo "Server is up."
		STARTED=true
    	break
	else
		echo "Server not up. waiting 1 second."
		sleep 1
	fi	
done
if [ ${STARTED} = false ]; then
	echo "Failed starting web server in 15 seconds."
	exit 1
fi
