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

#enter the systemd/system directory so we can setup ec2 startup behaviors
cd /etc/systemd/system/

#create the minecraft service file
touch minecraft.service

#write to the minecraft server service file
printf '[Unit]\nDescription=Minecraft Server on start up\nWants=network-online.target\n[Service]\nUser=minecraft\nWorkingDirectory=/opt/minecraft/server\nExecStart=/opt/minecraft/server/start\nStandardInput=null\n[Install]\nWantedBy=multi-user.target' >> minecraft.service

#reload systemctl with the changes
systemctl daemon-reload

#enable the minecraft service
systemctl enable minecraft.service

#start the minecraft service
systemctl start minecraft.service