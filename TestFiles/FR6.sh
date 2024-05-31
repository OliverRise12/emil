TRIGGERTOPIC="emil/wildlife_trigger"
echo "--------------------------------"
echo "Test for FR6"
#Find innit number of photos
cd /var/www/html/photos
var=$(find /var/www/html/photos -type f | wc -l) #$(ls -1 | wc -l)
echo "Initially photos has $var photos"

echo "Publishing to $TRIGGERTOPIC to activate external trigger"
mosquitto_pub -h localhost -p 1883 -u emil -P emil -t $TRIGGERTOPIC -m "1"

sleep 2
varfter=$(find /var/www/html/photos -type f | wc -l)
echo "After having activated the trigger, photos has $varfter photos"

#Check if photos grew by 2 in size
if [ $((var+2)) -eq $varfter ]; then
    echo "FR6 Passed"
else
    echo "FR6 Failed"
fi
echo "------------------------------"