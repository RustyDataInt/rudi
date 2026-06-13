#!/bin/sh
#----------------------------------------------------------------
# launch the app server when running in 'remote' or 'node' mode
# called by 'remote-server.sh' or 'remote-node.sh'
#----------------------------------------------------------------
echo "$SEPARATOR" 
echo "Please wait for the app server to start"
echo "$SEPARATOR"

# set app server port
if [ "$SERVER_PORT" = "" ]; then 
    SERVER_PORT=3839
    export SERVER_PORT
fi

# set directories
if [ "$DATA_DIRECTORY" = "" ]; then 
    DATA_DIRECTORY=NULL
    export DATA_DIRECTORY
fi

# set developer mode for rudi command
DEV_FLAG=""
if [ "$DEVELOPER" = "TRUE" ]; then 
    DEV_FLAG="--develop"
fi

# report the host name and port for use by apps launcher
echo "$SEPARATOR" 
echo "App server running on host port `hostname`:$SERVER_PORT"
echo "$SEPARATOR" 

# launch the server
exec "$RUDI_DIRECTORY/rudi" $DEV_FLAG serve \
    --server-command "$REMOTE_MODE" \
    --data-dir "$DATA_DIRECTORY" \
    --port "$SERVER_PORT"
