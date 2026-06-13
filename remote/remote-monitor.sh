#----------------------------------------------------------------
# provide a clean process for monitoring and terminating the server
# sourced by 'remote-server.sh' or 'remote-node.sh'
#----------------------------------------------------------------

# give time to start up before showing further prompts   
WAIT_SECONDS=15
sleep "$WAIT_SECONDS"

# report the PID to the user
echo "$SEPARATOR"
echo "App server process running as PID: $SERVER_PID"

# prompt for quit request
USER_ACTION=""
while [ "$USER_ACTION" != "quit" ]; do
    echo "$SEPARATOR"
    echo ""
    echo "Type 'quit' and hit Enter to stop the server: "
    read USER_ACTION
done

# kill the web server process
kill -9 "$SERVER_PID"

# send a final helpful message
# note: ssh process on client will NOT exit when this script exits since it is port forwarding
echo ""
echo "Thank you for using the Rusty Data Interface (RuDI)."
echo "You may now safely close this command window."