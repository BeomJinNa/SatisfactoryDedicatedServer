FROM ubuntu:20.04

# 필요한 패키지 설치
RUN apt-get update && \
    apt-get install -y \
    curl \
    wget \
    unzip \
    sudo \
    lib32gcc1 \
    rsync \
    locales \
    neovim && \
    locale-gen en_US.UTF-8 && \
    update-locale LANG=en_US.UTF-8

# steam 사용자 생성 및 sudo 그룹 추가
RUN useradd -m steam && echo "steam:steam" | chpasswd && adduser steam sudo

# sudoers 파일에 steam 사용자에 대한 설정 추가
RUN echo 'steam ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

# SteamCMD 설치
RUN mkdir -p /home/steam/Steam && \
    cd /home/steam/Steam && \
    curl -sqL https://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz | tar zxvf -

# 권한 설정
RUN chown -R steam:steam /home/steam && \
    chmod -R 755 /home/steam

# /home/steam/Server 디렉토리 생성 및 권한 설정
RUN mkdir -p /home/steam/Server && \
    chown -R steam:steam /home/steam/Server

# 스크립트 복사 및 실행 권한 부여
COPY init.sh /home/steam/
COPY run.sh /home/steam/
COPY install.sh /home/steam/

RUN chmod +x /home/steam/init.sh
RUN chmod +x /home/steam/run.sh
RUN chmod +x /home/steam/install.sh

# 사용자 전환
USER steam

WORKDIR /home/steam

CMD ["./init.sh"]
