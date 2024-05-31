TRIGGERTOPIC="emil/wildlife_trigger"
echo "--------------------------------"
echo "Test for FR9"
#count amount of lines in logfile
var=wc -l /var/www/html/EventLog.txt

cd ../projektFiles/take_photo.sh
#do something loggable
mosquitto_pub -h localhost -p 1883 -u emil -P emil -t $TRIGGERTOPIC -m "1"
sleep(2)
# assert presence of logfile
var2=wc -l /var/www/html/EventLog.txt
#Check if photos grew by 2 in size
if [ $var2 -gt $var ]; then
    echo "FR9 Passed"
else
    echo "FR9 Failed"
fi
echo "------------------------------"