#!/bin/sh
photo_dir="${1:-../../var/www/html/photos}"
freq="${2:-5}"
log_file_path="/var/www/html/EventLog.txt"

mkdir -p /home/emil/.motion_detector/ && cd /home/emil/.motion_detector
sudo rm -r *
while true ; do
	sudo sh /home/emil/projectFiles/take_photo.sh Motion .motion_detector
	count=$(grep -Rl "" ./ | grep ".jpg" | wc -l)
	if [ "$count" -lt "2" ]; then
		sudo sh /home/emil/projectFiles/take_photo.sh Motion .motion_detector
	fi
	img_paths=$(grep -Rl "" ./ | grep ".jpg" | sort | tail -n 2)
	json_paths=$(grep -Rl "" ./ | grep ".json" | sort | tail -n 2)
	res="$(python3 /home/emil/projectFiles/motion_detect.py $(echo $img_paths | tr '\n' ' '))"

	if [ "$res" = "Motion detected" ]; then	
		img_path=$(echo "$img_paths" | tail -n 1)
		sudo echo "$(date): Motion detected" >> "$log_file_path"

		sudo mkdir -p "/home/emil/$photo_dir$(echo $img_path | grep -Po '\/.+\/')"
		sudo cp "$img_path" "/home/emil/$photo_dir$(echo $img_path | grep -Po '\/.+')"
		json_path=$(echo "$json_paths" | tail -n 1) 
		sudo cp "$json_path" "/home/emil/$photo_dir$(echo $json_path | grep -Po '\/.+')"
	fi
	img_path=$(echo "$img_paths" | tail -n 1 | grep -Po '\/.+')
	json_path=$(echo "$json_paths" | tail -n 1 | grep -Po '\/.+') 
	find /home/emil/.motion_detector/ -type f -not -wholename "/home/emil/.motion_detector$img_path" -not -wholename "/home/emil/.motion_detector$json_path" -delete
	find /home/emil/.motion_detector/ -type d -empty -delete
	sleep "$freq"
done
