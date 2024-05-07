SERVERIP="10.0.0.10" #193.1'
receiptTopic="downloadReceipt"
requestTopic="downloadRequest"

DRONEPHOTOFOLDER="/home/philip/photos"

#scan for network

#connect


#send drone ID



#listen on topic with files to download

while true
do
    cd $DRONEPHOTOFOLDER 
    #wait for request
    output="$(mosquitto_sub -d -h $SERVERIP -p 1883 -u emil -P emil -C 1 -t $requestTopic)"
    #find msg in mosquitto sub output
    next_is_string="0"
    for payload in $output; do 
        if [ "$next_is_string" == "1" ]; then 
            #cam sends date/time of jpg/json
            dateFolder="${payload:0:11}"
            mkdir -p "$DRONEPHOTOFOLDER/$dateFolder"

            #go to dateFolder
            cd $dateFolder

            curl -O "$SERVERIP/$payload.jpg" 
            curl -O "$SERVERIP/$payload.json"

            mosquitto_pub -h $SERVERIP -p 1883 -u emil -P emil -t $receiptTopic -m "$payload" 
            break
        fi 
        if [ "$payload" == "bytes))" ]; then 
            next_is_string="1"
        fi
    done


done











