#SERVERIP="10.0.0.10" #193.1'
receiptTopic="downloadReceipt"
requestTopic="downloadRequest"
DRONEPHOTOFOLDER="/home/philip/photos"
SERVERIP="192.168.10.1"
HANDSHAKETOPIC="droneHello"
DRONEID="1"

while true; do
	#search for wifi
	until [[ $(iwgetid) == *"EMIL-TEAM-19-2.4GHz"* ]]; do
	    sudo iw dev wlo1 scan | grep SSID| while read -r line ; do
		    if [[ "$line" == *"EMIL-TEAM-19-2.4GHz"* ]]; then
		      echo "CAM FOUND"
		      #connect
		      sudo nmcli dev wifi connect "EMIL-TEAM-19-2.4GHz" password "emilemil" 
		      break
		    fi   
		  
	    done
	   sleep 2
	done
	#send drone ID
	mosquitto_pub -h $SERVERIP -p 1883 -u emil -P emil -t $HANDSHAKETOPIC -m "$DRONEID" 


	#listen on topic with files to download

	while true
	do
	    cd $DRONEPHOTOFOLDER 
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
		    
		    curl -O -m 20 "$SERVERIP/$payload.jpg"  
		    curl -O -m 20 "$SERVERIP/$payload.json" 
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
	done

done









