#!/bin/bash

#become the root user to we don't need to keep typing sudo
sudo su -

#get the necessary java version
yum install -y java-21-amazon-corretto-headless

#make a minecraft user
adduser minecraft

#create a minecraft directory
mkdir /opt/minecraft/

#create a server directory within the minecraft directory
mkdir /opt/minecraft/server/

#enter the minecraft/server directory
cd /opt/minecraft/server

#replace this link with the server file of the minecraft version you want to use
wget https://piston-data.mojang.com/v1/objects/e6ec2f64e6080b9b5d9b471b291c33cc7f509733/server.jar

#make the minecraft user we created the owner of the minecraft directory we created
chown -R minecraft:minecraft /opt/minecraft/

#run the server file
java -Xmx1300M -Xms1300M -jar server.jar nogui

#agree to the eula
sed -i 's/false/true/p' eula.txt

#create server start file
touch start

#write to the start file
printf '#!/bin/bash\njava -Xmx1300M -Xms1300M -jar server.jar nogui\n' >> start

#give execute permissions to the server start file
chmod +x start

#create server stop file
touch stop

#write to the stop file
printf '#!/bin/bash\nkill -9 $(ps -ef | pgrep -f "java")' >> stop

#give execute permissions to the server stop file
chmod +x stop