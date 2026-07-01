#!/bin/sh
#----------------------------------------------------------------
# run the app server in 'remote' mode
# this script executes on the remote login server 
#    (not on the user's local computer)
#----------------------------------------------------------------

# get input variables
SERVER_PORT=${1}    # must be a port number that matches the forwarded port
RUDI_DIRECTORY=${2} # must be valid, as it was used to call this script
TOOL_SUITE=${3}
DATA_DIRECTORY=${4}
DEVELOPER=${5}
DIOXUS_VERSION=${6}
REMOTE_DOMAIN=${7}
FAST_TMP_DIR=${8}
CARGO_HOME=${9}
REMOTE_MODE=remote
RUDI_TIMESTAMP=$(date +"%Y-%m-%d-%H-%M-%S")
SEPARATOR="--------------------------------------------------------------------------------"

# export variables
export SERVER_PORT
export RUDI_DIRECTORY
export TOOL_SUITE
export DATA_DIRECTORY
export DEVELOPER
export DIOXUS_VERSION
export REMOTE_DOMAIN
export FAST_TMP_DIR
export CARGO_HOME
export REMOTE_MODE
export RUDI_TIMESTAMP
export SEPARATOR

# launch app server as background process on the login node
sh "${RUDI_DIRECTORY}/remote/remote.sh" & # server runs in background
RUDI_SERVER_PID=$! # the pid of the server process (after a series of execs)

# source the remote server monitor in the main process
. "${RUDI_DIRECTORY}/remote/remote-monitor.sh"
