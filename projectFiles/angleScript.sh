
let "direction = 1"

mosquitto_sub -d -h localhost -p 1883 -u emil -P emil -t angleRead  | while read -r payload 
do
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
        sleep 0.2  #letsub get connection
        mosquitto_pub -h localhost -p 1883 -u emil -P emil -t angleSet -m "$newangle"
    fi
done