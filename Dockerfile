FROM ubuntu:20.04

# 패키지 업데이트 및 필수 패키지 설치
RUN apt-get update && \
    apt-get install -y \
    curl \
    wget \
    unzip \
    sudo \
    lib32gcc1 \
    neovim && \
    apt-get clean

# steam 사용자 추가 및 설정
RUN useradd -m steam && echo "steam:steam" | chpasswd && adduser steam sudo

# SteamCMD 설치
RUN mkdir -p /home/steam/Steam && \
    cd /home/steam/Steam && \
    curl -o steamcmd_linux.tar.gz https://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz && \
    tar -xvzf steamcmd_linux.tar.gz && \
    rm steamcmd_linux.tar.gz

# ficsit-cli 설치
RUN mkdir -p /home/steam/ficsit-cli && \
    wget -O /home/steam/ficsit-cli/ficsit-cli https://github.com/satisfactorymodding/ficsit-cli/releases/download/v0.5.1/ficsit_linux_amd64 && \
    chmod +x /home/steam/ficsit-cli/ficsit-cli && \
		echo 'export PATH=$PATH:/home/steam/ficsit-cli' >> /home/steam/.bashrc

# 권한 설정
RUN chown -R steam:steam /home/steam && \
    chmod -R 755 /home/steam

# 스크립트 복사 및 실행 권한 설정
COPY init.sh /home/steam/
COPY run.sh /home/steam/
RUN chmod +x /home/steam/init.sh
RUN chmod +x /home/steam/run.sh

USER steam
WORKDIR /home/steam

ENTRYPOINT ["/home/steam/init.sh"]
