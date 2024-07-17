# Satisfactory Dedicated Server with Docker

## 1. 프로젝트 소개

#### 목적
이 프로젝트는 Satisfactory Dedicated Server를 세이브 파일 관리와 모드 설치가 용이하도록 Docker를 이용하여 구축하는 것을 목적으로 합니다.

#### 환경
- 운영 체제: Windows (WSL2 사용), Linux, macOS
- 필수 소프트웨어: Docker, Docker Compose, WSL2 (Windows 사용자)

## 2. 사전 준비 사항

#### 필수 소프트웨어 설치
프로젝트를 시작하기 전에 다음 소프트웨어를 설치해야 합니다:

- **Docker**: [Docker 공식 사이트](https://www.docker.com/get-started)에서 Docker를 설치합니다.
- **Docker Compose**: Docker와 함께 제공되며, 별도의 설치가 필요 없습니다.
- **WSL2 (Windows 사용자)**: [WSL2 설치 가이드](https://docs.microsoft.com/ko-kr/windows/wsl/install) 를 참고하여 WSL2를 설치합니다.

## 3. 프로젝트 구조

프로젝트는 다음과 같은 디렉토리 및 파일 구조로 구성되어 있습니다:

```
.
├── docker-compose.yml
├── Dockerfile
├── init.sh
├── Makefile
├── README.md
├── run.sh
└── satisfactory_data
    ├── ficsit
    │   ├── cache
    │   └── installations
    ├── saves
    └── server
```

- **docker-compose.yml**: Docker Compose 설정 파일로, 컨테이너의 서비스 정의 및 볼륨 마운트 설정이 포함되어 있습니다.
- **Dockerfile**: Docker 이미지를 빌드하는 데 사용되는 설정 파일입니다.
- **init.sh**: 컨테이너 초기화 스크립트입니다.
- **Makefile**: 자주 사용하는 명령어를 간편하게 실행하기 위한 스크립트입니다.
- **README.md**: 프로젝트 설명 및 설정 가이드 문서입니다.
- **run.sh**: 서버 실행 스크립트입니다.
- **satisfactory_data**: 서버 데이터와 모드를 저장하는 디렉토리입니다.
  - **ficsit**: ficsit-cli 관련 캐시 및 설정 파일을 저장합니다.
  - **saves**: Satisfactory 게임 세이브 파일과 서버 설정 데이터를 저장합니다.
  - **server**: Satisfactory Dedicated Server 파일을 저장합니다.

## 4. 설치 및 설정

#### Setup 스크립트 실행
프로젝트 디렉토리에 포함된 `setup.sh` 스크립트를 실행하여 필요한 디렉토리를 생성하고, 적절한 권한을 설정합니다. 이 스크립트는 Docker 컨테이너에서 사용할 데이터 저장용 디렉토리를 준비합니다.

실행 전, 스크립트에 실행 권한을 부여합니다:
```bash
chmod +x setup.sh
./setup.sh
```

이 작업은 프로젝트 최초 설정 시 한 번만 수행하면 됩니다.

## 5. Docker 컨테이너 빌드 및 실행

Docker 컨테이너를 빌드하고 실행하는 과정은 다음과 같습니다:

1. **Docker 이미지 빌드**:
   ```bash
   make build
   ```
   이 명령은 `Dockerfile`에 정의된 지침에 따라 필요한 환경을 갖춘 Docker 이미지를 생성합니다.

2. **Docker 컨테이너 실행**:
   ```bash
   make up
   ```
   `docker-compose.yml` 파일에 정의된 서비스 설정을 사용하여 Docker 컨테이너를 백그라운드 모드로 실행합니다.

## 6. Docker 컨테이너 및 스크립트 설명

#### Docker 컨테이너 환경
컨테이너 내부에는 다음과 같은 소프트웨어가 설치되어 있습니다:
- **curl, wget, unzip**: 파일 다운로드 및 압축 해제를 위한 유틸리티.
- **sudo**: 관리자 권한으로 명령 실행을 가능하게 합니다.
- **lib32gcc1**: 32비트 호환성 라이브러리.
- **neovim**: 텍스트 편집을 위한 고급 에디터.
- **SteamCMD**: Steam 게임 서버를 설치 및 관리하기 위한 명령줄 인터페이스.
- **ficsit-cli**: Satisfactory 모드 관리를 위한 CLI 툴.

#### 스크립트 설명
- **init.sh**: 컨테이너 시작 시 기본적인 환경 설정을 수행하고, `run.sh` 스크립트를 실행합니다. 이 스크립트는 컨테이너의 진입점(ENTRYPOINT)으로 설정되어 있습니다.
- **run.sh**: Satisfactory 서버를 설치하고 실행하는 주요 스크립트입니다. SteamCMD를 사용하여 서버를 설치하고, 필요한 설정을 적용한 후 서버를 실행합니다.

## 7. 모드 설치 방법

새티스팩토리 서버에 모드를 설치하는 과정은 다음과 같습니다:

1. **컨테이너에 접속**:
   컨테이너의 이름이나 ID를 확인한 후, Bash 쉘을 통해 컨테이너 내부로 진입합니다.
   ```bash
   docker ps  # 컨테이너 목록 확인
   docker exec -it [컨테이너 ID의 앞 4자리] bash  # 컨테이너에 접속
   ```

2. **Ficsit-CLI 실행**:
   Ficsit-CLI는 인터랙티브 모드로 실행되며, 사용자는 명령줄 인터페이스를 통해 모드를 관리할 수 있습니다.
   ```bash
   ficsit-cli
   ```

3. **서버 경로 설정**:
   Ficsit-CLI 내에서 `Installation`을 선택하고 `/home/steam/Server`를 서버 경로로 입력하여 설정을 완료합니다.

4. **모드 선택 및 설치**:
   `All Mods` 섹션으로 이동하여 설치하고자 하는 모드를 선택합니다. 선택이 완료되면 `Apply Changes`를 선택하여 설치를 진행합니다.

5. **컨테이너 종료 및 재시작**:
   모드 설치 후, Ficsit-CLI를 종료하고 컨테이너에서도 `exit`를 입력하여 나옵니다. 이후, Docker 컨테이너를 재시작하여 모드가 적용된 서버를 구동합니다.
   ```bash
   make down
   make up
   ```

## 8. 세이브 파일 관리

서버의 세이브 파일은 Docker 컨테이너의 마운트된 볼륨에 저장되어 호스트 시스템에서 직접 접근할 수 있습니다. 다음은 세이브 파일 관리를 위한 기본적인 지침입니다:

- **세이브 파일 위치**:
  세이브 파일은 `satisfactory_data/saves` 디렉토리에 위치합니다. 이 위치는 `docker-compose.yml` 파일에서 정의된 볼륨 설정에 따라 컨테이너와 호스트 간에 동기화됩니다.

## 9. 참고사항

- **포트 포워딩**:
  서버가 외부에서 접근 가능하도록 하려면 공유기 등의 라우터에서 포트 포워딩 설정이 필요합니다. 아래의 포트를 포워딩하세요:
  - UDP 포트 7777
  - UDP 포트 15000
  - UDP 포트 15777

- **절전 모드**:
  호스트하는 윈도우 PC에서 절전 모드로 진입할 경우, 절전 모드 해제 시 서버도 자동으로 재개됩니다. 따라서 서버가 계속 동작하도록 보장할 수 있습니다. (PC를 아예 종료하는 경우는 이후에 WSL2 실행 후, 도커를 실행하고 make up을 이용해 서버를 다시 실행해야 합니다.)

- **서버 부하 관리**:
  데디케이티드 서버는 기본적으로 유저가 없는 동안에는 서버가 중지되고, 유저가 입장할 때만 서버가 구동됩니다. 이 기능 덕분에 컨테이너를 상시 켜두어도 컴퓨터에 큰 부하를 주지 않습니다.

# Satisfactory Dedicated Server with Docker

## 1. Project Introduction

#### Purpose
The purpose of this project is to set up a Satisfactory Dedicated Server using Docker, facilitating the management of save files and mod installations.

#### Environment
- Operating Systems: Windows (using WSL2), Linux, macOS
- Required Software: Docker, Docker Compose, WSL2 (for Windows users)

## 2. Prerequisites

#### Required Software Installation
Before starting the project, you need to install the following software:

- **Docker**: Install Docker from the [official Docker website](https://www.docker.com/get-started).
- **Docker Compose**: Provided with Docker, no separate installation needed.
- **WSL2 (for Windows users)**: Follow the [WSL2 installation guide](https://docs.microsoft.com/en-us/windows/wsl/install) to set up WSL2.

## 3. Project Structure

The project consists of the following directory and file structure:

```
.
├── docker-compose.yml
├── Dockerfile
├── init.sh
├── Makefile
├── README.md
├── run.sh
└── satisfactory_data
    ├── ficsit
    │   ├── cache
    │   └── installations
    ├── saves
    └── server
```

- **docker-compose.yml**: Defines the services, volume mounts, and other settings for Docker Compose.
- **Dockerfile**: Used to build the Docker image.
- **init.sh**: Initialization script for the container.
- **Makefile**: Provides shortcuts for commonly used commands.
- **README.md**: Project description and setup guide.
- **run.sh**: Main script to install and run the server.
- **satisfactory_data**: Directory for server data and mods.
  - **ficsit**: Stores cache and configuration files for ficsit-cli.
  - **saves**: Stores Satisfactory game save files and server configuration data.
  - **server**: Stores the Satisfactory Dedicated Server files.

## 4. Setup and Configuration

#### Running the Setup Script
Run the `setup.sh` script included in the project directory to create the necessary directories and set appropriate permissions. This script prepares the data directories for use within the Docker container.

Before running, grant execution permissions to the script:
```bash
chmod +x setup.sh
./setup.sh
```

This step only needs to be performed once during the initial setup.

## 5. Building and Running the Docker Container

Follow these steps to build and run the Docker container:

1. **Build the Docker image**:
   ```bash
   make build
   ```
   This command generates the Docker image based on the instructions defined in the `Dockerfile`.

2. **Run the Docker container**:
   ```bash
   make up
   ```
   This command starts the Docker container in the background using the service settings defined in the `docker-compose.yml` file.

## 6. Docker Container and Script Descriptions

#### Docker Container Environment
The following software is installed inside the container:
- **curl, wget, unzip**: Utilities for downloading and extracting files.
- **sudo**: Allows commands to be run with administrative privileges.
- **lib32gcc1**: 32-bit compatibility library.
- **neovim**: Advanced text editor.
- **SteamCMD**: Command-line interface for installing and managing Steam game servers.
- **ficsit-cli**: CLI tool for managing Satisfactory mods.

#### Script Descriptions
- **init.sh**: Performs basic environment setup when the container starts and runs the `run.sh` script. This script is set as the entry point for the container.
- **run.sh**: Main script for installing and running the Satisfactory server. It uses SteamCMD to install the server, applies necessary configurations, and then runs the server.

## 7. Installing Mods

To install mods on the Satisfactory server, follow these steps:

1. **Access the container**:
   Identify the container name or ID, then enter the container using a Bash shell.
   ```bash
   docker ps  # List running containers
   docker exec -it [first 4 characters of container ID] bash  # Access the container
   ```

2. **Run Ficsit-CLI**:
   Launch Ficsit-CLI in interactive mode to manage mods.
   ```bash
   ficsit-cli
   ```

3. **Set the server path**:
   In Ficsit-CLI, select `Installation` and enter `/home/steam/Server` as the server path, then select `Select` to complete the configuration.

4. **Select and install mods**:
   Navigate to `All Mods`, select the desired mods, then select `Apply Changes` to install the mods.

5. **Exit the container and restart it**:
   After installing mods, exit Ficsit-CLI, and type `exit` to leave the container. Restart the Docker container to apply the mods.
   ```bash
   make down
   make up
   ```

## 8. Managing Save Files

The server's save files are stored in a mounted volume accessible from the host system. Here are the basic guidelines for managing save files:

- **Save file location**:
  Save files are located in the `satisfactory_data/saves` directory. This location is synchronized between the container and the host system according to the volume settings defined in the `docker-compose.yml` file.

## 9. Additional Notes

- **Port Forwarding**:
  To make the server accessible from outside, configure port forwarding on your router for the following ports:
  - UDP port 7777
  - UDP port 15000
  - UDP port 15777

- **Sleep Mode**:
  When the host Windows PC enters sleep mode, the server will automatically resume when sleep mode is exited. This ensures that the server remains operational. (If the PC is completely shut down, you need to restart WSL2, Docker, and use `make up` to restart the server.)

- **Server Load Management**:
  The dedicated server stops when no users are connected and starts only when a user joins. This feature ensures that keeping the container running does not put a significant load on your computer.
