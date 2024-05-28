
echo "--------------------------------"
echo "Test for FR7.1"
#Find innit number of photos
echo "Sending 0 to angleScript for conversion"
mosquitto_pub -h localhost -p 1883 -u emil -P emil -t angleRead -m "0"

echo "Waiting for new angle on angleSet"
output="$(mosquitto_sub -d -h localhost -p 1883 -u emil -P emil -C 1 -W 5 -t angleSet)"

if [ $output -eq "30" ]; then
    echo "FR7.1 Passed"
else
    echo "FR7.1 Failed"
fi
echo "------------------------------"
echo "Test for FR7.2"
echo "Sending 190 to angleScript for conversion"
mosquitto_pub -h localhost -p 1883 -u emil -P emil -t angleRead -m "190"

echo "Waiting for new angle on angleSet"
output="$(mosquitto_sub -d -h localhost -p 1883 -u emil -P emil -C 1 -W 5 -t angleSet)"

if [ $output -eq "180" ]; then
    echo "FR7.2 Passed"
else
    echo "FR7.2 Failed"
fi
echo "------------------------------"

echo "Test for FR7.3"
echo "Sending 150 to angleScript for conversion"
mosquitto_pub -h localhost -p 1883 -u emil -P emil -t angleRead -m "180"
echo "Waiting for new angle on angleSet"
output="$(mosquitto_sub -d -h localhost -p 1883 -u emil -P emil -C 1 -W 5 -t angleSet)"

if [ $output -eq "120" ]; then
    echo "FR7.3 Passed"
else
    echo "FR7.3 Failed"
fi
echo "------------------------------"

echo "Test for FR7.4"
echo "Sending 0 to angleScript for conversion"
mosquitto_pub -h localhost -p 1883 -u emil -P emil -t angleRead -m "0"
echo "Waiting for new angle on angleSet"
output="$(mosquitto_sub -d -h localhost -p 1883 -u emil -P emil -C 1 -W 5 -t angleSet)"

if [ $output -eq "0" ]; then
    echo "FR7.4 Passed"
else
    echo "FR7.4 Failed"
fi
echo "------------------------------"