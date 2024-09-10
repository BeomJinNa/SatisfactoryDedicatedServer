#!/bin/bash

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

log() {
  echo -e "[${CYAN}$(date '+%Y-%m-%d %H:%M:%S')${NC}] $1"
}

success() {
  echo -e "[${CYAN}$(date '+%Y-%m-%d %H:%M:%S')${NC}] ${GREEN}$1${NC}"
}

warn() {
  echo -e "[${CYAN}$(date '+%Y-%m-%d %H:%M:%S')${NC}] ${YELLOW}$1${NC}"
}

log "Starting Satisfactory Server installation..."

# 권한 설정
sudo chown -R steam:steam /home/steam/Server

# 서버 설치 또는 업데이트
log "Downloading and installing server files..."
/home/steam/Steam/steamcmd.sh +login "$STEAM_USER" "$STEAM_PASS" +force_install_dir /home/steam/ServerTemp +app_update "$SATISFACTORY_DB_CODE" validate +quit

# 서버 파일 업데이트 (설정 및 모드 제외)
log "Updating server files while preserving configurations and mods."
rsync -av --no-owner --no-group --chmod=ugo=rwX \
  --exclude='FactoryGame/Saved' \
  --exclude='FactoryGame/Config' \
  /home/steam/ServerTemp/ /home/steam/Server/
chmod +x /home/steam/Server/FactoryServer.sh

# 임시 디렉토리 삭제
rm -rf /home/steam/ServerTemp

success "Satisfactory Server installation completed successfully."
