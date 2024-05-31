echo "--------------------------------"
echo "Test for FR12"
#Camera Script
sudo bash ../projectFiles/take_photo.sh

cd var/www/html/photos

amount_of_downloaded_photos =grep -l "Drone Copy" * -R | wc -l

#Assert photos have been taken and number metadata files that contain "Drone Copy" is X 
#manually run droneDownload
read -n 1 -p "Did you download drone images?" input

amount_of_downloaded_photos2 =grep -l "Drone Copy" * -R | wc -l

#Assert that photos metadata files metadatafiles that contain Drone Copy is begger than X

if [ $amount_of_downloaded_photos2 -gt amount_of_downloaded_photos ]; then
    echo "FR12 Passed"
else
    echo "FR12 Failed"
fi
echo "------------------------------"