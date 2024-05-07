#!/bin/sh
image_base64=$(base64 -w 0 "$1")
api_request="{\"model\": \"llava:7b\", \"prompt\": \"describe\", \"stream\": false, \"images\": [\"$image_base64\"]}"
response=$(curl http://localhost:11434/api/generate -d "$api_request")
response=$(echo "$response" | tr -d '\n')
description=$(echo "$response" | grep -Po '"response":"\K.*?(?=")')
echo "$description"
