echo "--------------------------------"
echo "Test for FR11"
echo "Turn of network card and then turn it back on"
nmcli d disconnect wlp9s0
nmcli d connect wlp9s0

sudo bash droneDownload.sh
echo "Run drone download script" #Might have to run seperately if this file gets stuck in loop.
sleep 3
ssid_of_connected_wifi = iwgetid
echo "Slept for 3 seconds on now is getting the SSID of currently connected wifi"
if [ $(ssid_of_connected_wifi) -eq "EMIL-TEAM-19-2.4GHz" ]; then
    echo "FR11 Passed"
else
    echo "FR11 Failed"
fi
echo "------------------------------"