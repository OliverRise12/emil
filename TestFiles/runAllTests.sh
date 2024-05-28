for f in *.sh; do
    if [ $f != "runAllTests.sh" ]; then 
    bash "$f" 
    fi
done
