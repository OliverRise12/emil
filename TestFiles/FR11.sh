echo "--------------------------------"
echo "Test for FR11"
#Drone Script
echo "Turn of network card and then turn it back on"
nmcli d disconnect wlo1
nmcli d connect wlo1

sudo bash ../projectFiles/droneDownload.sh &
echo "Run drone download script" #Might have to run seperately if this file gets stuck in loop.
sleep 3
ssid_of_connected_wifi=$(iwgetid)
echo "Slept for 3 seconds on now is getting the SSID of currently connected wifi"

if  [[ $ssid_of_connected_wifi =~ "EMIL-TEAM-19-2.4GHz" ]]; then
    echo "FR11 Passed"
else
    echo "FR11 Failed"
fi
echo "------------------------------"
