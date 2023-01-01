#!/usr/bin/env bash
MACHINE_UUID="产品uuid"
BOT_API="tgbotapi"
CHAT_ID="tg个人账号"
STAR_MACHINE() {
    scw instance server start "${MACHINE_UUID}"
}
SEND_NOTIFY(){
    curl -X POST \
    -H 'Content-Type: application/json' \
    -d '{"chat_id": '${CHAT_ID}', "text": "Your Sacleway machine is opening now."}' \
    https://api.telegram.org/bot${BOT_API}/sendMessage
}
while true; do
    STATUS=$(scw instance server list | sed -n '2p' | awk '{print $4}')
    if [[ ${STATUS} == "starting" ]]; then
        echo "Your server status is ${STATUS}"
        echo "Starting...Wait for 60 seconds to check again..."
        sleep 60
    elif [[ ${STATUS} == "archived" ]]; then
        echo "Your server status is ${STATUS}"
        echo "Now we start your machine..."
        STAR_MACHINE
        sleep 60
    else
        SEND_NOTIFY
        break
    fi
done