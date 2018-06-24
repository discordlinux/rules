#!/bin/bash
# Description: Simple script to post embeded messages containing rules to #rules in Discord Linux
# License: MIT
# Author: simonizor
# Dependencies: curl

# URL for #rules webhook
WEBHOOK_URL="https://discordapp.com/api/webhooks/channelid/webhooktoken"
# find running directory
RUNNING_DIR="$(readlink -f "$(dirname "$0")")"
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
