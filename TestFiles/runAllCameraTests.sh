for f in *.sh; do
    if [ $f != "runAllCameraTests.sh" ] && [ $f != "runAllDroneTests.sh" ]  && [ $f != "FR13.sh" ] && [ $f != "FR14+FR15.sh" ]; then
    bash "$f" 
    fi
done
