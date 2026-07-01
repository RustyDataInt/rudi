#----------------------------------------------------------------
# provide a clean process for monitoring and terminating the server
# sourced by 'remote-server.sh' or 'remote-node.sh'
#----------------------------------------------------------------

# make sure we always elegantly kill the server on exit
server_cleanup(){
     # script created by rudi::serve()::createRestoreFromFastTmpDir()
    ARCHIVE_SCRIPT=${RUDI_DIRECTORY}/archive-${RUDI_TIMESTAMP}.sh
    if [ -f ${ARCHIVE_SCRIPT} ]; then # script uses ssh to run on the server host
        sh ${ARCHIVE_SCRIPT}          # the script auto-deletes after being run
    fi
    echo "Done"
    kill -9 ${RUDI_SERVER_PID} 2>/dev/null
}
trap "server_cleanup; exit" INT QUIT HUP 

# report the PID to the user
echo "$SEPARATOR"
echo "App server launched at: $RUDI_TIMESTAMP"
echo "App server process running as PID: $RUDI_SERVER_PID"

# prompt for quit request
USER_ACTION=""
while [ "$USER_ACTION" != "quit" ]; do
    echo "$SEPARATOR"
    echo "Type 'quit' and hit Enter to stop the server: "
    read USER_ACTION
done

# kill the web server process
server_cleanup
