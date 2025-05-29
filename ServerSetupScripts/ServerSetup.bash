#!/bin/bash

echo "0"

echo "1"

#get the necessary java version
sudo yum install -y java-21-amazon-corretto-headless

echo "2"

#make a minecraft user
sudo adduser minecraft

echo "3"

#create a minecraft directory
sudo mkdir /opt/minecraft/

echo "4"

#create a server directory within the minecraft directory
sudo mkdir /opt/minecraft/server/

echo "5"

#enter the minecraft/server directory
cd /opt/minecraft/server

#replace this link with the server file of the minecraft version you want to use
sudo wget https://piston-data.mojang.com/v1/objects/e6ec2f64e6080b9b5d9b471b291c33cc7f509733/server.jar

echo "6"

#make the minecraft user we created the owner of the minecraft directory we created
sudo chown -R minecraft:minecraft /opt/minecraft/

#run the server file
sudo java -Xmx1300M -Xms1300M -jar server.jar nogui
sleep 40

echo "7"

#agree to the eula
sudo sed -i 's/false/true/p' eula.txt

echo "8"

#create server start file
sudo touch start

#write to the start file
starttemp=$(mktemp)
printf '#!/bin/bash\njava -Xmx1300M -Xms1300M -jar server.jar nogui\n' >> $starttemp
sudo cp $starttemp start

#give execute permissions to the server start file
sudo chmod +x start
sleep 1

#create server stop file
sudo touch stop

#write to the stop file
stoptemp=$(mktemp)
printf '#!/bin/bash\nkill -9 $(ps -ef | pgrep -f "java")' >> $stoptemp
sudo cp $stoptemp stop

#give execute permissions to the server stop file
sudo chmod +x stop
sleep 1

echo "9"

#enter the systemd/system directory so we can setup ec2 startup behaviors
cd /etc/systemd/system/

#create the minecraft service file
sudo touch minecraft.service

#edit minecraft service file the funny way since you can't sudo printf >>
servicetemp=$(mktemp)
printf '[Unit]\nDescription=Minecraft Server on start up\nWants=network-online.target\n[Service]\nUser=minecraft\nWorkingDirectory=/opt/minecraft/server\nExecStart=/opt/minecraft/server/start\nStandardInput=null\n[Install]\nWantedBy=multi-user.target' >> $servicetemp
sudo cp $servicetemp minecraft.service

echo "10"

#reload systemctl with the changes
sudo systemctl daemon-reload

#enable the minecraft service
sudo systemctl enable minecraft.service

#start the minecraft service
sudo systemctl start minecraft.service

echo "11"