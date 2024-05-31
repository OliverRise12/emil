# Embedded Linux - Group 19 Repository
Welcome to the repository of group 19. The repository is structed in the following way:
1. /TestFiles: Contains all of the automated tests for the functional requirements of the project. 
2. /metadata: Contains example metadata.
3. /projectFiles: Contains all of the scripts used in the project.

The content of the projectFiles has the following the following associated functionality:
1. ImageUplaoder.sh: (Camera Script) Received handshake from drone and sends images to download to drone, adjusts metadata after successful download. 
2. angleScript.sh: (Camera Script) Calculates new angles for serialWiperControl.sh
3. annotator.sh: (Cloud Script) Annotates images by calling describe_image and adjusts metadata 
4. describe_image.sh: (Cloud Script) Gets image annotation via Ollama
5. droneDownload.sh: (Drone Script) connects to wifi, downloads all not-downloaded images.
6. externalPhotoTrigger.sh: (Camera Script) Take photo with Trigger = External when msg received on topic emil/wildlife_trigger
7. motion_detect.py: (Camera Script) Compares 2 images to detect motion
8. motion_logic.sh: (Camera Script) Uses motion_detect.py to determine motion, and then adds image to photos if motion is detected.
9. serialWiperControl.sh: Reads input from Pico, if rain is detected, sets new angle via angleScript.sh.
10. take_photo.sh: Takes a photo
11. testimgs.txt: Temp storage of image names of images to download.
