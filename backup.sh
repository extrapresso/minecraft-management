#!/bin/sh

filename=minecraftbackup #Set filename to be used.

#Warns of backup, saves world, and gracefully stops the server.
screen -S minecraft -p 0 -X stuff "say starting a backup in 30 seconds^M"
sleep 30
screen -S minecraft -p 0 -X stuff "save-all^M"
sleep 10
screen -S minecraft -p 0 -X stuff "stop^M"
sleep 5
screen -S minecraft -p 0 -X stuff "exit^M"



#Creates a zip file of the worlds and whitelist
zip -r ~/$filename\.zip ~/minecraft/world ~/minecraft/world_nether ~/minecraft/world_the_end/ ~/minecraft/whitelist.json


#uploads file to S3
aws s3 cp ~/$filename\.zip s3://<bucket-name>

#Cleanup
rm ~/$filename\.zip


#Restarts the server
screen -A -m -d -S minecraft
screen -S minecraft -p 0 -X stuff 'cd ~/minecraft^M'
screen -S minecraft -p 0 -X stuff 'java -Xms1G -Xmx1G -jar ~/minecraft/spigot.jar nogui^M'
