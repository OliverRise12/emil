#!/bin/sh
#serial setup :D
sudo stty -F /dev/ttyACM0 min 1 time 0 cs8 -brkint -icrnl -imaxbel -opost -isig -icanon -iexten -echo -echoe -echok -echoctl -echoke
log_file_path="/var/www/html/EventLog.txt"
while true
do
    var="$(head -1 /dev/ttyACM0)"
    echo "$var" #>>  /home/emil/debug.txt
    wipeDone="0"
	
    if [ "${var: -3:1}" == "1" ]; then #if rain detected, go to wiper loop
        sudo echo "$(date): Rain detected, starting wipe procedure" >> "$log_file_path"
        while true #wiper loop 
        do
            
            var="$(head -1 /dev/ttyACM0)" #get json string
            echo "$var" #>>  /home/emil/debug.txt
	    #get second element in var 
            let "i = 0"
            for element in $var 
            do	
                if [ "$i" == "1" ]; then

                    let "angle = ${element::${#element}-1}" #angle is second element segmented line (comma removed)
                    break
                fi
                let "i = 1"
            done
	    #if angle is 0 and wiper has been at end break wiper loop
            if [ "$angle" == "0" ]; then
            	if [ "$wipeDone" == "1" ];then
            		break
		        fi
	        fi	
            #check if wiper reached end
            if [ "$angle" == "180" ];then
            	wipeDone="1"
            fi
            new_angle_received="0"
            while [ "$new_angle_received" -eq "0" ];
            do
             
                #read new angle #code hangs in sub loop, sub does not catch new angle (latch??)
                mosquitto_pub -h localhost -p 1883 -t angleRead -u emil -P emil -m "$angle"

                #read sub msg
                output="$(mosquitto_sub -d -h localhost -p 1883 -u emil -P emil -C 1 -W 2 -t angleSet)"
                
                next_is_angle="0"
                for payload in $output; do #iterate mqtt sub msg, look for "bytes))" which precedes angle 
                    if [ "$next_is_angle" == "1" ]; then
                        echo "{'wiper_angle': $payload}"  #>>  /home/emil/debug.txt

                        echo "{'wiper_angle': $payload}"  > /dev/ttyACM0  
                        sleep 1.2 #delay read after write 
                        new_angle_received="1"
                        break 
                    fi 
                    if [ "$payload" == "bytes))" ]; then
                        next_is_angle="1"
                    fi
                    
                done
            done
 
 
        done

    fi

   
done
