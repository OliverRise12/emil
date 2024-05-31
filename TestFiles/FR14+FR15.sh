echo "--------------------------------"
echo "Test for FR14 and FR15"
#Drone Script
#get amount of files in git
var=git ls-files --directory "metadata" | wc -l

#take photo (manually)
read -n 1 -p "Did you take photo" input
#downloadPictures
sudo bash droneDownload.sh
sleep(180)
#get amount of annotated pictures
var2=git ls-files --directory "metadata" | wc -l

if [ $var2 -gt $var ]; then
    echo "FR14 and FR15 Passed"
else
    echo "FR14 and FR15 Failed"
fi
echo "------------------------------"