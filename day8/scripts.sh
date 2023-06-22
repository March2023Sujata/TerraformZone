#!/bin/bash
sudo apt update
sudo apt upgrade -y
sudo apt install openjdk-17-jdk -y
sudo apt install maven -y
sudo cp /home/sujata/scp.service /etc/systemd/system/scp.service
git clone https://github.com/spring-projects/spring-petclinic.git
cd spring-petclinic
./mvnw package
sudo systemctl daemon-reload
sudo systemctl enable scp.service
sudo systemctl start scp.service
