#!/bin/sh
let "direction = 1"
while true
do
    output="$(mosquitto_sub -d -h localhost -p 1883 -u emil -P emil -C 1 -W 5 -t angleRead)"
    next_is_string="0"
    for payload in $output; do 
        if [ "$next_is_string" == "1" ]; then 
           if [ ${#payload} -le 3 ]; then
                #adjust angle based on direction
                if [ "$direction" == "1" ]; then
                    let "newangle = $payload + 30"
                fi

                if [ "$direction" == "0" ]; then
                    let "newangle = $payload - 30"
                fi
                
                #adjust direction at ends
                if [ "$newangle" -gt 180 ]; then
                    let "direction = 0"
                    let "newangle = 180"
                fi 

                if [ "$newangle" -lt 0 ]; then
                    let "direction = 1"
                    let "newangle = 0"
                fi 
                #sleep 0.2  #letsub get connection
                #echo "newangle pub: $newangle" # >>  /home/emil/debug.txt
                mosquitto_pub -h localhost -p 1883 -u emil -P emil -t angleSet -m "$newangle"
            fi 
        fi 
        if [ "$payload" == "bytes))" ]; then 
            next_is_string="1"
        fi
        if [ "$payload" == "DISCONNECT" ]; then #
            # if timed out, wait for next
            break
        fi
    done
                  
    echo "$payload" #>> /home/emil/debug.txt
    
done
