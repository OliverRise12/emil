
#!/bin/sh
path_to_txt="/home/sigurd/AnnoLog.txt"
path_to_archive="/home/sigurd/photos"
path_to_metadata="/home/sigurd/emil/metadata"

while true; do
    #sudo rm "$path_to_txt"
    sudo mkdir -p "$path_to_metadata"
    grep -L -r  --include='*.json' "Annotation" "$path_to_archive" > "$path_to_txt"
   
    #remove path and .json from files
    sudo sed -i -e 's/\/home\/sigurd\/photos\///g' $path_to_txt
    sudo sed -i -e 's/.json//g' $path_to_txt
 
    filestring="$(cat $path_to_txt)"
    
    #go to img folder
    cd "$path_to_archive"

    if [ "$filestring" == " " ]; then
    :
    else

	    for pic in $filestring  #
	    do	
		annotation="$(sudo bash /home/sigurd/emil/projectFiles/describe_image.sh "$pic.jpg")"
		#delete line from undownloaded file 
		sudo sed -i '1d' $path_to_txt   #line: 1, d: delete
		sudo sed -i '/^$/d' $path_to_txt #delete first line in file

		#update json(derulooo) in photo archive 
		sudo sed -i '$d' $path_to_archive/$pic.json #delete last line from file
		sudo truncate -s-1 $path_to_archive/$pic.json #write to last line of file
		sudo echo -e ",\n\t\"Annotation\":{\n\t\t\"Source\": \"Ollama:7b\",\n\t\t\"Test\": \"$annotation\"\n\t}\n}" >> $path_to_archive/$pic.json #pipe data to file

		sudo cp "$pic.json" "$path_to_metadata"

	    done	
     cd "$path_to_metadata"
     git add .
     git commit -m "$(date)"
     git push
     fi
done
