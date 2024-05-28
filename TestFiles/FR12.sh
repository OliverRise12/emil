echo "--------------------------------"
echo "Test for FR12"
#Might need version for PI and version for drone.

#Version for PI:
#Take photo 
#Assert photos have been taken and number metadata files that contain "Drone Copy" is X 
#manually run droneDownload
#Wait some time
#Assert that photos metadata files metadatafiles that contain Drone Copy is begger than X

if [ $(ssid_of_connected_wifi) -eq "EMIL-TEAM-19-2.4GHz" ]; then
    echo "FR11 Passed"
else
    echo "FR11 Failed"
fi
echo "------------------------------"