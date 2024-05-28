#SERVERIP="10.0.0.10" #193.1'
receiptTopic="downloadReceipt"
requestTopic="downloadRequest"
DRONEPHOTOFOLDER="/home/sigurd/photos"
SERVERIP="192.168.10.1"
ADAPTER="wlo1"
HANDSHAKETOPIC="droneHello"
DRONEID="1"

while true; do
	#search for wifi
	until [[ $(iwgetid) == *"EMIL-TEAM-19-2.4GHz"* ]]; do
	    sudo iw dev "$ADAPTER" scan | grep SSID| while read -r line ; do
		    if [[ "$line" == *"EMIL-TEAM-19-2.4GHz"* ]]; then
		      echo "CAM FOUND"
		      #connect
		      sudo nmcli dev wifi connect "EMIL-TEAM-19-2.4GHz" password "emilemil" 
		      break
		    fi   
		  
	    done
	   sleep 2
	done
	#send drone ID and time 
	currenttime="$(date +%Y-%m-%dT%H:%M:%S%Z)"
	mosquitto_pub -h $SERVERIP -p 1883 -u emil -P emil -t $HANDSHAKETOPIC -m "$DRONEID,$currenttime" 


	#listen on topic with files to download

	while true
	do
	    mkdir -p $DRONEPHOTOFOLDER && cd $DRONEPHOTOFOLDER 
	    #wait for request
	    output="$(mosquitto_sub -d -h $SERVERIP -p 1883 -u emil -P emil -C 1 -W 10 -t $requestTopic)"
	    #find msg in mosquitto sub output
	    exitBool="0"
	    next_is_string="0"
	    for payload in $output; do 
		if [ "$next_is_string" == "1" ]; then 
		    #cam sends date/time of jpg/json
		    dateFolder="${payload:0:11}"
		    mkdir -p "$DRONEPHOTOFOLDER/$dateFolder"

		    #go to dateFolder
		    cd "$DRONEPHOTOFOLDER/$dateFolder"
		    
		    curl -O -m 20 "$SERVERIP/photos/$payload.jpg"  
		    curl -O -m 20 "$SERVERIP/photos/$payload.json" 
		    
		    echo "$SERVERIP/photos/$payload.jpg"  
		    if [ $? -eq 0 ]; then 		    
			mosquitto_pub -h $SERVERIP -p 1883 -u emil -P emil -t $receiptTopic -m "$payload" 
		    else
		    	exitBool="1"
		    
		    fi
		    break
		    
		fi 
		if [ "$payload" == "bytes))" ]; then 
		    next_is_string="1"
		fi
		if [ "$payload" == "DISCONNECT" ]; then
		    exitBool="1"
		    break
		fi
	    done
	    if [ "$exitBool" == "1" ]; then
	    	exitBool="0"
	    	break
	    fi
		# Log wifi signal quality to sql database
		#mysql --user=root --password=password -e "CREATE DATABASE IF NOT EXISTS logDB"
		#mysql --user=root --password=password -e "USE logDB; CREATE TABLE IF NOT EXISTS wifistats (time DOUBLE(40, 3), link_quality INT, signal_level INT);"
		wifi_stats=$(tail /proc/net/wireless)
		regex=' -*[\d]+'
		res=($(echo "$wifi_stats" | grep -Po "$regex"))
		link=$(echo "${res[2]}")
		level=$(echo "${res[3]}")
		secs=$(date +%s.%3N)
		mysql --user=root --password=password -e "INSERT INTO logDB.wifistats (time, link_quality, signal_level) VALUES ('$secs', '$link', '$level');"
	done

done









