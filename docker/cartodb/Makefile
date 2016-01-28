.PHONY: build build-no-cache start stop logs rm reload all
.DEFAULT_GOAL := all

build:
	docker-compose build $(c)

build-no-cache:
	docker-compose build --no-cache $(c)

start:
	docker-compose run -d $(c)

stop:
	docker-compose stop $(c)

logs:
	docker-compose logs $(c)

rm:
	docker-compose stop $(c) && docker-compose rm -vf $(c)

reload:
	docker-compose stop $(c) && docker-compose rm -vf $(c) && docker-compose build $(c) && docker-compose up -d $(c) && docker-compose logs

all: reload
