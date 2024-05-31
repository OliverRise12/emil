for f in *.sh; do
    if [ $f != "runAllDroneTests.sh" ] && [ $f != "runAllCameraTests.sh" ] && [ $f != "FR+2+FR3.sh" ] && [ $f != "FR6.sh" ] && [ $f != "FR7.sh" ] && [ $f != "FR9.sh" ] && [ $f != "FR12.sh" ] ; then
    bash "$f" 
    fi
done
