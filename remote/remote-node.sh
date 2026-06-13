#!/bin/sh
#----------------------------------------------------------------
# run the app server in 'node' mode
# this script executes on the remote login server 
#    (not on the user's local computer, and not on the node)
#----------------------------------------------------------------
# at present, only supports the Slurm job scheduler
#----------------------------------------------------------------

# get input variables
SERVER_PORT=$1 # must be a port number, otherwise can be anything
RUDI_DIRECTORY=$2 # must be valid, as it was used to call this script
DATA_DIRECTORY=$3
DEVELOPER=$4
CLUSTER_ACCOUNT=$5
JOB_TIME_MINUTES=$6
CPUS_PER_TASK=$7
MEM_PER_CPU=$8
REMOTE_DOMAIN=$9
REMOTE_MODE=node

# export variables
export SERVER_PORT
export RUDI_DIRECTORY
export DATA_DIRECTORY
export DEVELOPER
export CLUSTER_ACCOUNT
export JOB_TIME_MINUTES
export CPUS_PER_TASK
export MEM_PER_CPU
export REMOTE_DOMAIN
export REMOTE_MODE

# launch app server as background process on a worker node
SEPARATOR="---------------------------------------------------------------------"
export SEPARATOR
srun \
    --account "$CLUSTER_ACCOUNT" \
    --time "$JOB_TIME_MINUTES" \
    --cpus-per-task "$CPUS_PER_TASK" \
    --mem-per-cpu "$MEM_PER_CPU" \
    --job-name=rudi_web_server \
    --nodes=1 \
    --ntasks-per-node=1 \
    --partition=standard \
    sh "$RUDI_DIRECTORY/remote/remote.sh" & # server runs in background
SERVER_PID=$! # the pid of the srun process
trap "kill -9 $SERVER_PID; exit" INT QUIT HUP # make sure we always kill the server on exit

# source the remote server monitor in the main process on the login node
. "$RUDI_DIRECTORY/remote/remote-monitor.sh"
