echo "--------------------------------"
echo "Test for FR13"

#Drone Script
echo "Count number of wifilogs"
var="$(mysql --user=root --password=password -e "SELECT COUNT(*) FROM logDB.wifistats;" | grep '[0-9]' | sed 's/[^0-9]*//g')"

echo "Turn on drone download script, ctrl+C once after downloading a few photos"
sudo bash ../projectFiles/droneDownload.sh
sleep 2
sleep 2
echo "Wait 2 seconds"
echo "Count number of wifilogs again"
var2="$(mysql --user=root --password=password -e "SELECT COUNT(*) FROM logDB.wifistats;" | grep '[0-9]' | sed 's/[^0-9]*//g')"

if [ $var2 -gt $var ]; then
    echo "FR13 Passed"
else
    echo "FR13 Failed"
fi
echo "------------------------------"
