.PHONY: build build-no-cache start stop logs rm reload all
.DEFAULT_GOAL := all

BIN=docker-compose -f docker-compose.yml

help:
	@echo "Usage: make [OPTION] [ENV=dev|test] [C=\"container\"]"
	@echo ""
	@echo "Options"
	@echo "\thelp      		-- print this help"
	@echo "\tbuild     		-- build docker environment"
	@echo "\tbuild-no-cache   	-- build docker environment by invalidating cache"
	@echo "\tstart        		-- start docker stack"
	@echo "\tstop      		-- stop docker stack"
	@echo "\tlogs       		-- get logs from docker stack"
	@echo "\trm     			-- stop docker stack & clean all artifacts"
	@echo "\tall  			-- stop & rebuild & start docker stack"

build:
	$(BIN) build $(C)

build-no-cache:
	$(BIN) build --no-cache $(C)

start:
	$(BIN) run -d $(C)

stop:
	$(BIN) stop $(C)

logs:
	$(BIN) logs $(C)

rm:
	$(BIN) stop $(C) && $(BIN) rm -vf $(C)

all:
	$(BIN) stop $(C) && $(BIN) rm -vf $(C) && $(BIN) build $(C) && $(BIN) up -d $(C) && $(BIN) logs
