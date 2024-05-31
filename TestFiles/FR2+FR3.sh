TRIGGERTOPIC="emil/wildlife_trigger"
echo "--------------------------------"
echo "Test for FR2 and FR3"
#Camera Script
#Find init number of photos
var=$(find /var/www/html/photos -type f | wc -l)
echo "Initially photos has $var photos"

#take photo
echo "Publishing to $TRIGGERTOPIC to activate external trigger"
mosquitto_pub -h localhost -p 1883 -u emil -P emil -t $TRIGGERTOPIC -m "1"
sleep 2
varfter=$(find /var/www/html/photos -type f | wc -l)
echo "Now photos has $varfter photos"
#Check if photos grew by 2 in size
if [ $((var+2)) -eq $varfter ]; then
    echo "FR2 + FR3 Passed"
else
    echo "FR2 + FR3 Failed"
fi
echo "------------------------------"