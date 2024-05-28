#!/bin/sh
receiptTopic="downloadReceipt"
requestTopic="downloadRequest"
handShakeTopic="droneHello"

path_to_txt="/var/www/testimgs.txt"
path_to_archive="/var/www/html/photos"

while true; do
    # todo: delete empty dirs (exitscript) from server, make drone send ID, send last img
    droneID="null"

    #check that drone is connected via topic, drone sends name.
    output="$(mosquitto_sub -d -h localhost -p 1883 -u emil -P emil -C 1 -t $handShakeTopic)"
    #find msg in mosquitto sub output
    next_is_string="0"
    for payload in $output; do 
        if [ "$next_is_string" == "1" ]; then 
            #get ID and date from drone
            droneID="${payload: 0:1}"
            currenttime="${payload: -23:23}"
        
            sudo date --set="$currenttime"
            break
        fi
        if [ "$payload" == "bytes))" ]; then 
            next_is_string="1"
        fi 
    done
    echo "hello $droneID"
    exitBool="0" #check after loop for some exit code
    let resendCount=0


    #generate txt file of un-uploaded images

    grep -L -r  --include='*.json' "Drone Copy" "$path_to_archive" > "$path_to_txt"
   
    #remove path and .json from files
    sudo sed -i -e 's/\/var\/www\/html\/photos\///g' $path_to_txt
    sudo sed -i -e 's/.json//g' $path_to_txt
 
    #add dummy line to tracker file to ensure we send last image
    echo "dummy" >> $path_to_txt

    filestring="$(cat $path_to_txt)"

    #go to img folder
    cd "$path_to_archive"

    
    #iterate file with names of un-uploaded imgs. format: 2024-04-23/161914_409
    for pic in $filestring  #iterate un-uploaded, date/time 
    do	
        echo "$pic"
        #wait for prev img to be downloaded
        img_downloaded="0"
        while [ "$img_downloaded" -eq "0" ]
        do
            #tell drone to download prev pic
            mosquitto_pub -h localhost -p 1883 -u emil -P emil -t $requestTopic -m "$pic" 
            #get drone feedback
            output="$(mosquitto_sub -d -h localhost -p 1883 -u emil -P emil -C 1 -W 5 -t $receiptTopic)"
            #find msg in mosquitto sub output
            
            next_is_string="0"
            for payload in $output; do 
                if [ "$next_is_string" == "1" ]; then 
                    #drome responds with date/time (same format as prevFile)
                    if [ "$payload" ==  "$pic" ]; then #if msg says prev file has been downloaded: "${prevFile:11:${#prevFile}}"
                        #delete line from undownloaded file 
                        sudo sed -i '1d' $path_to_txt  > /dev/null #line: 1, d: delete
                        sudo sed -i '/^$/d' $path_to_txt > /dev/null #delete first line in file
                        
                        #update json(derulooo) in photo archive 
                        sudo sed -i '$d' $path_to_archive/$pic.json #delete last line from file
                        sudo truncate -s-1 $path_to_archive/$pic.json #write to last line of file
                        sudo echo -e ",\n\t\"Drone Copy\": $droneID,\n\t\"Seconds Epoch\": $(date +%s) \n}" >> $path_to_archive/$pic.json #pipe data to file
                        

                        img_downloaded="1"
                        let "resendCount=0"
                        break #go to next
                    fi
                fi 
                if [ "$payload" == "bytes))" ]; then 
                    next_is_string="1"
                fi
                if [ "$payload" == "DISCONNECT" ]; then #
                    if [ "$resendCount" == "2" ]; then
                        exitBool="1"
                    fi
                    echo "DISCONNECTED,retrying"
                    let resendCount=resendCount+1
                    img_downloaded="0"
                    break
                fi
            done
            if [ "$exitBool" == "1" ]; then
                break
            fi
        done
        
    
        if [ "$exitBool" == "1" ]; then
            echo "disconnect exit" 
            break
        fi
        echo "pushing next"

    done

    if [ "$filestring" == "dummy" ]; then #if no new images were uploaded
        sudo rm $path_to_txt #delete uploaded files folder
    else 
        echo "out of img exit"
        
    fi

done
