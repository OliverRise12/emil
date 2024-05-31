echo "--------------------------------"
echo "Test for FR14 and FR15"
#Drone Script
#get amount of files in git
echo "get amount of metadata files in git"
var=git ls-files --directory "metadata" | wc -l

#take photo (manually)
read -n 1 -p "Did you take photo" input
#downloadPictures
echo "Downloading pictures"
sudo bash droneDownload.sh
echo "Sleeping for 3 minutes"
sleep(180)
#get amount of annotated pictures
var2=git ls-files --directory "metadata" | wc -l

if [ $var2 -gt $var ]; then
    echo "FR14 and FR15 Passed"
else
    echo "FR14 and FR15 Failed"
fi
echo "------------------------------"