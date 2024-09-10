.PHONY: all build up down logs install update restart shell

all: up

install:
	@echo "Starting installation..."
	./setup.sh
	docker-compose build
	docker-compose run --rm --entrypoint /home/steam/install.sh satisfactory-server

build:
	docker-compose build

up:
	docker-compose up -d

down:
	docker-compose down

logs:
	docker-compose logs -f

update:
	docker-compose run --rm --entrypoint /home/steam/install.sh satisfactory-server

restart:
	docker-compose restart

shell:
	docker-compose exec -it satisfactory-server /bin/bash
