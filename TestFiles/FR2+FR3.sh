echo "--------------------------------"
echo "Test for FR2 and FR3"
#Find innit number of photos
cd ../photos
var=$(ls -1 | wc -l)
echo "Initially photos has $var photos"

#take photo
sudo bash ../projectFiles/take_photo.sh
echo "Taking photo"
cd ../photos
varfter=$(ls -1 | wc -l)
echo "Now photos has $varfter photos"
#Check if photos grew by 2 in size
if [ $((var+2)) -eq $varfter ]; then
    echo "FR2 + FR3 Passed"
else
    echo "FR2 + FR3 Failed"
fi
echo "------------------------------"