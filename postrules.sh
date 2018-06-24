#!/bin/bash
# Description: Simple script to post embeded messages containing rules to #rules in Discord Linux
# License: MIT
# Author: simonizor
# Dependencies: curl

# find running directory
RUNNING_DIR="$(readlink -f "$(dirname "$0")")"
# get WEBHOOK_URL from $RUNNING_DIR/config for #rules webhook or run $EDITOR to create file if it doesn't exist
if [ ! -f "$RUNNING_DIR/config" ]; then
    echo "Missing required '$RUNNING_DIR/config'; creating and launching $EDITOR ..."
    echo "WEBHOOK_URL='InsertURLHere'" > "$RUNNING_DIR"/config
    "$EDITOR" "$RUNNING_DIR"/config || { echo "Failed to launch EDITOR; edit '$RUNNING_DIR/config' manually and restart script."; exit 1; }
fi
if [ -f "$RUNNING_DIR/config" ]; then
    . "$RUNNING_DIR"/config
fi
if [ -z "$WEBHOOK_URL" ] || [ "$WEBHOOK_URL" = "InsertURLHere" ]; then
    echo "WEBHOOK_URL missing; was it entered in '$RUNNING_DIR/config'?"
    exit 1
fi
# list of json files in $RUNNING_DIR to upload
JSON_FILES="dlwelcome.json
dlrules.json
dlpunish.json
dlchannels.json
dlinfo.json"
# upload json files using curl to create embeded messages in #rules
function uploadjson {
    CURRENT_JSON=""$RUNNING_DIR"/"$1""
    curl -iL -X POST -H "Content-Type: application/json" -T "$CURRENT_JSON" "$WEBHOOK_URL"
    echo
}
# run a for loop to upload each file in ${JSON_FILES}
for jsonfile in ${JSON_FILES}; do
    echo "Uploading $jsonfile"
    uploadjson "$jsonfile" || { echo "Failed to upload $jsonfile; exiting..."; exit 1; }
    sleep 0.8
done
echo
exit 0
