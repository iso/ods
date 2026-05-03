.PHONY: clone build up down setup update

clone:
	./clone.sh

build:
	./build.sh

up:
	docker compose up -d

down:
	docker compose down

setup: clone build

update:
	./update.sh
