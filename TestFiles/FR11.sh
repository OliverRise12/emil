echo "--------------------------------"
echo "Test for FR11"
read -n 1 -p "run droneDownload.sh and press enter." input
oldDate="$(date +%Y+%M+%d)"

#set wrong date
sudo date --set="1999-04-28T15:25:47 BST"

#try to sync
read -n 1 -p "run droneDownload.sh and press enter." input

newDate="$(date +%Y+%M+%d)"


if  [ "$newDate" == "$oldDate" ]; then
    echo "FR11 Passed"
else
    echo "FR11 Failed"
fi
echo "------------------------------"
