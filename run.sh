#!/bin/bash

GREEN='\033[0;32m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

log() {
  echo -e "[${CYAN}$(date '+%Y-%m-%d %H:%M:%S')${NC}] $1"
}

log "Starting the Satisfactory Server..."

# 서버 실행
cd /home/steam/Server
./FactoryServer.sh
