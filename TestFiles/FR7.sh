
echo "--------------------------------"
echo "Test for FR7.1"
#Camera Script
#Find init number of photos
echo "Sending 0 to angleScript for conversion"


payload="DISCONNECT"	
while [ "$payload" == "DISCONNECT" ]; do
	mosquitto_pub -h localhost -p 1883 -u emil -P emil -t angleRead -m "0"

	echo "Waiting for new angle on angleSet"
	output="$(mosquitto_sub -d -h localhost -p 1883 -u emil -P emil -C 1 -W 6 -t angleSet)"
	
	next_is_string="0"
	for payload in $output; do 
		if [ "$next_is_string" == "1" ]; then 
		
			if [ $payload -eq "30" ]; then
			    echo "FR7.1 Passed"
			else
			    echo "FR7.1 Failed"
			fi
			break    
		fi 	
		if [ "$payload" == "bytes))" ]; then 
		    next_is_string="1"
		fi
	done
done
echo "------------------------------"
echo "Test for FR7.2"
echo "Sending 190 to angleScript for conversion"
payload="DISCONNECT"	
while [ "$payload" == "DISCONNECT" ]; do
	mosquitto_pub -h localhost -p 1883 -u emil -P emil -t angleRead -m "190"

	echo "Waiting for new angle on angleSet"
	output="$(mosquitto_sub -d -h localhost -p 1883 -u emil -P emil -C 1 -W 6 -t angleSet)"
	
	next_is_string="0"
	for payload in $output; do 
		if [ "$next_is_string" == "1" ]; then 
		
			if [ $payload -eq "180" ]; then
			    echo "FR7.2 Passed"
			else
			    echo "FR7.2 Failed"
			fi
			break    
		fi 	
		if [ "$payload" == "bytes))" ]; then 
		    next_is_string="1"
		fi
	done
done
echo "------------------------------"

echo "Test for FR7.3"
echo "Sending 150 to angleScript for conversion"
payload="DISCONNECT"	
while [ "$payload" == "DISCONNECT" ]; do
	mosquitto_pub -h localhost -p 1883 -u emil -P emil -t angleRead -m "150"

	echo "Waiting for new angle on angleSet"
	output="$(mosquitto_sub -d -h localhost -p 1883 -u emil -P emil -C 1 -W 6 -t angleSet)"
	
	next_is_string="0"
	for payload in $output; do 
		if [ "$next_is_string" == "1" ]; then 
		
			if [ $payload -eq "120" ]; then
			    echo "FR7.3 Passed"
			else
			    echo "FR7.3 Failed"
			fi
			break    
		fi 	
		if [ "$payload" == "bytes))" ]; then 
		    next_is_string="1"
		fi
	done
done
echo "------------------------------"

echo "Test for FR7.4"
echo "Sending 0 to angleScript for conversion"
payload="DISCONNECT"	
while [ "$payload" == "DISCONNECT" ]; do
	mosquitto_pub -h localhost -p 1883 -u emil -P emil -t angleRead -m "0"

	echo "Waiting for new angle on angleSet"
	output="$(mosquitto_sub -d -h localhost -p 1883 -u emil -P emil -C 1 -W 6 -t angleSet)"
	
	next_is_string="0"
	for payload in $output; do 
		if [ "$next_is_string" == "1" ]; then 
		
			if [ $payload -eq "0" ]; then
			    echo "FR7.4 Passed"
			else
			    echo "FR7.4 Failed"
			fi
			break    
		fi 	
		if [ "$payload" == "bytes))" ]; then 
		    next_is_string="1"
		fi
	done
done
echo "------------------------------"
