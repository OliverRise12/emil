#!/bin/sh
receiptTopic="downloadReceipt"
requestTopic="downloadRequest"
handShakeTopic="droneHello"

path_to_txt="/var/www/testimgs.txt"
path_to_archive="/home/emil/photos"

while true; do
    # todo: delete empty dirs (exitscript) from server, make drone send ID, send last img
    droneID="null"

    #check that drone is connected via topic, drone sends name.
    output="$(mosquitto_sub -d -h localhost -p 1883 -u emil -P emil -C 1 -t $handShakeTopic)"
    #find msg in mosquitto sub output
    next_is_string="0"
    for payload in $output; do 
        if [ "$next_is_string" == "1" ]; then 
            droneID="$payload"
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
    sudo sed -i -e 's/\/home\/emil\/photos\///g' $path_to_txt
    sudo sed -i -e 's/.json//g' $path_to_txt


    #add dummy line to tracker file to ensure we send last image
    echo "dummy" >> $path_to_txt

    filestring="$(cat $path_to_txt)"

    #go to img folder
    cd "$path_to_archive"

    prevFile=""

    #iterate file with names of un-uploaded imgs. format: 2024-04-23/161914_409
    for pic in $filestring  #iterate un-uploaded, date/time 
    do	
        if [ "$pic" == "dummy" ]; then
            : #skip if dummy (we are at last)
        else
            #if pic date directory is not on webserver, create it
            picDir="${pic:0:10}" #stops working in year 10000 
            mkdir -p /var/www/html/$picDir
            #copy indexed file to webserver folder
            cp "$pic.jpg" /var/www/html/$picDir/
            cp "$pic.json" /var/www/html/$picDir/
        fi
        if [ "$prevFile" == "" ]; then #check if previous file is empty (happens on first copy), if not, wait for prev img to be downloaded by drone
            : #upload next such that 2 imgs are always on server
        else 

            #wait for prev img to be downloaded
            img_downloaded="0"
            while [ "$img_downloaded" -eq "0" ]
            do
                #tell drone to download prev pic
                mosquitto_pub -h localhost -p 1883 -u emil -P emil -t $requestTopic -m "$prevFile" 
                #get drone feedback
                output="$(mosquitto_sub -d -h localhost -p 1883 -u emil -P emil -C 1 -W 5 -t $receiptTopic)"
                #find msg in mosquitto sub output
                
                next_is_string="0"
                for payload in $output; do 
                    if [ "$next_is_string" == "1" ]; then 
                        #drome responds with date/time (same format as prevFile)
                        if [ "$payload" ==  "$prevFile" ]; then #if msg says prev file has been downloaded: "${prevFile:11:${#prevFile}}"
                            #delete downloaded file
                            sudo rm /var/www/html/$prevFile.json
                            sudo rm /var/www/html/$prevFile.jpg
                            #delete line from undownloaded file 
                            sudo sed -i '1d' $path_to_txt  > /dev/null #line: 1, d: delete
                            sudo sed -i '/^$/d' $path_to_txt > /dev/null #delete first line in file
                            
                            #update json(derulooo) in photo archive 
                            sudo sed -i '$d' $path_to_archive/$prevFile.json #delete last line from file
                            sudo truncate -s-1 $path_to_archive/$prevFile.json #write to last line of file
                            sudo echo -e ",\n\t\"Drone Copy\": $droneID,\n\t\"Seconds Epoch\": $(date +%s) \n}" >> $path_to_archive/$prevFile.json #pipe data to file
                            

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
            
        fi
        if [ "$exitBool" == "1" ]; then
            echo "disconnect exit" 
            break
        fi
        echo "pushing next"
        prevFile="$pic"

    done

    if [ "$filestring" == "dummy" ]; then #if no new images were uploaded
        sudo rm $path_to_txt #delete uploaded files folder
    else 
        echo "out of img exit"
        sudo rm -r /var/www/html/2* #delete date folders
        sudo rm $path_to_txt #delete uploaded files folder
        
    fi

done
