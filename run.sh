#!/bin/bash

echo "Initializing Satisfactory Server"
echo "Checking directory and file permissions"
ls -l /home/steam

# 서버 디렉토리 확인 및 필요 시 설치
if [ ! "$(ls -A /home/steam/Server)" ]; then
    echo "Server directory is empty. Installing the server."
    /home/steam/Steam/steamcmd.sh +login anonymous +force_install_dir /home/steam/temp +app_update 1690800 validate +quit
    echo "Copying server files to persistent directory."
    cp -R /home/steam/temp/* /home/steam/Server/
fi

echo "Starting the server from /home/steam/Server"
cd /home/steam/Server
./FactoryServer.sh
