TRIGGERTOPIC="emil/wildlife_trigger"

while true
do
    output="$(mosquitto_sub -d -h localhost -p 1883 -u emil -P emil -C 1 -W 5 -t $TRIGGERTOPIC)"
    next_is_string="0"
    for payload in $output; do 
        if [ "$next_is_string" == "1" ]; then 
            if [ "$payload" -eq "1" ];then
                sudo sh /home/emil/projectFiles/take_photo.sh External   
                break
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



done
