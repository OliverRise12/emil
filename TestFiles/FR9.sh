echo "--------------------------------"
echo "Test for FR9"
#Cd into html folder
#rm log file

#do something loggable

# assert presence of logfile

#Check if photos grew by 2 in size
if [ $((var+2)) -eq $varfter ]; then
    echo "FR6 Passed"
else
    echo "FR6 Failed"
fi
echo "------------------------------"