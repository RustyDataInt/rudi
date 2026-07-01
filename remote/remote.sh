#!/bin/sh
#----------------------------------------------------------------
# launch the app server when running in 'remote' or 'node' mode
# called by 'remote-server.sh' or 'remote-node.sh'
#----------------------------------------------------------------

# set app server IP address
if [ "${SERVER_ADDRESS}" = "" ]; then 
    if [ "${REMOTE_MODE}" = "remote" ]; then
        SERVER_ADDRESS="127.0.0.1"
    else 
        SERVER_ADDRESS="0.0.0.0"
    fi
    export SERVER_ADDRESS
fi

# set app server port
if [ "${SERVER_PORT}" = "" ]; then 
    SERVER_PORT=3839
    export SERVER_PORT
fi

# set directories
if [ "${DATA_DIRECTORY}" = "" ]; then 
    DATA_DIRECTORY=USE_DEFAULT
    export DATA_DIRECTORY
fi

# set developer mode for rudi command
DEV_FLAG=""
if [ "${DEVELOPER}" = "TRUE" ]; then 
    DEV_FLAG="--develop"
fi

# report the host name and port for use by apps launcher
echo "${SEPARATOR}" 
echo "App server running on host port `hostname`:${SERVER_PORT}"

# launch the server
exec "${RUDI_DIRECTORY}/rudi" ${DEV_FLAG} serve \
    --tool-suite "${TOOL_SUITE}" \
    --address "${SERVER_ADDRESS}" \
    --port "${SERVER_PORT}" \
    --data-dir "${DATA_DIRECTORY}" \
    --dioxus-version "${DIOXUS_VERSION}" \
    --cargo-home "${CARGO_HOME}" \
    --fast-tmp-dir "${FAST_TMP_DIR}"
