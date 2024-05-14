#!/bin/sh
trigger="${1:-None}" # Time/Motion/External default:None
root_dir="${2:-photos}" # root directory of where it puts photos default:photos
timestamp=$(date '+%Y-%m-%d %H:%M:%S.%3N%:z')

mkdir -p "/home/emil/$root_dir" && cd "/home/emil/$root_dir"
dir_name=$(date -d "$timestamp" +%Y-%m-%d)
img_name="$(date -d "$timestamp" -d '+1 hour' +%H)$(date -d "$timestamp" +%M%S_%3N)"
mkdir -p "./$dir_name" && cd "./$dir_name"
if rpicam-still -t 0.01 -v 0 -o "$img_name.jpg" ; then 
	create_date=$(date -d "$timestamp" '+%Y-%m-%d %H:%M:%S.%3N%:z') 
	seconds_since_epoch=$(date -d "$timestamp" '+%s.%3N')

	metadata=$(exif "$img_name.jpg")
	exposure_time=$(echo "$metadata" | grep -Po 'Exposure Time.*\|\K[\d|,|\/]*')
	subject_distance=$(echo "$metadata" | grep -Po 'Subject Distance.*\|\K[\d|,|\/]*' | tr ',' '.')
	ISO=$(echo "$metadata" | grep -Po 'ISO.*\|\K[\d|,|\/]*')
	json_metadata="{\n\t\"File Name\": \"$img_name\",\n\t\"Create Date\": \"$create_date\",\n\t\"Create Seconds Epoch\": $seconds_since_epoch,\n\t\"Trigger\": \"$trigger\",\n\t\"Subject Distance\": $subject_distance m,\n\t\"Exposure Time\": \"$exposure_time\",\n\t\"ISO\": $ISO\n}"
	echo "$json_metadata" >> "$img_name.json"
else
	sleep $((1 + RANDOM % 10))
	sh /home/emil/projectFiles/take_photo.sh "$trigger" "$root_dir"
fi
