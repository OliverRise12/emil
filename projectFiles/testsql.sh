#!/bin/bash
mysql --user=root --password=password -e "CREATE DATABASE IF NOT EXISTS logDB" && 
mysql --user=root --password=password -e "USE logDB; CREATE TABLE IF NOT EXISTS wifistats (time DOUBLE(40, 3), link_quality INT, signal_level INT);"
while true; do
    wifi_stats=$(tail /proc/net/wireless)
    regex=' -*[\d]+'
    res=($(echo "$wifi_stats" | grep -Po "$regex"))
    link=$(echo "${res[2]}")
    level=$(echo "${res[3]}")
    secs=$(date +%s.%3N)
    mysql --user=root --password=password -e "INSERT INTO logDB.wifistats (time, link_quality, signal_level) VALUES ('$secs', '$link', '$level');"
done
