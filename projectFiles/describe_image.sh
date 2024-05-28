#!/bin/sh
image_name="$1"
convert "$image_name" -resize 50x50 "$image_name.temp"
image_base64=$(base64 -w 0 "$image_name.temp")
rm "$image_name.temp"
api_request="{\"model\": \"llava:7b\", \"prompt\": \"describe\", \"stream\": false, \"images\": [\"$image_base64\"], \"options\": {
    \"repeat_last_n\": 0
  }}"
response=$(curl http://localhost:11434/api/generate -d "$api_request")
response=$(echo "$response" | tr -d '\n')
description=$(echo "$response" | grep -Po '"response":"\K.*?(?=")')
echo "$description"
