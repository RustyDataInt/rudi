#!/bin/sh
#----------------------------------------------------------------
# run the app server in 'remote' mode
# this script executes on the remote login server 
#    (not on the user's local computer)
#----------------------------------------------------------------

# get input variables
SERVER_PORT=$1    # must be a port number that matches the forwarded port
RUDI_DIRECTORY=$2 # must be valid, as it was used to call this script
TOOL_SUITE=$3
DATA_DIRECTORY=$4
DEVELOPER=$5
DIOXUS_CONTAINER=$6
REMOTE_DOMAIN=$7
REMOTE_MODE=remote

# export variables
export SERVER_PORT
export RUDI_DIRECTORY
export TOOL_SUITE
export DATA_DIRECTORY
export DEVELOPER
export DIOXUS_CONTAINER
export REMOTE_DOMAIN
export REMOTE_MODE

# launch app server as background process on the login node
SEPARATOR="---------------------------------------------------------------------"
export SEPARATOR

sh "$RUDI_DIRECTORY/remote/remote.sh" & # server runs in background
SERVER_PID=$! # the pid of the server process (after a series of execs)
trap "kill -9 $SERVER_PID; exit" INT QUIT HUP # make sure we always kill the server on exit

# source the remote server monitor in the main process
. "$RUDI_DIRECTORY/remote/remote-monitor.sh"
