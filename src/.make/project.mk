.DEFAULT_GOAL := help

DOCKER_COMPOSE := docker-compose -f ./.docker/docker-compose.base.yaml -f ./.docker/docker-compose.${APP_ENV}.yaml

.PHONY: help
help::
	@printf "$(BROWN) Project commands:$(NC)\n"
	@printf "$(GREEN)   	help		$(NC)	Display this help message\n"
	@printf "$(GREEN)   	run		$(NC)	Run docker containers\n"
	@printf "$(GREEN)   	ps		$(NC)	Show running containers\n"
	@printf "$(GREEN)   	stop		$(NC)	Stops all containers\n"
	@printf "$(GREEN)   	restart		$(NC)	Stops and runs again all containers\n"
	@printf "$(GREEN)   	logs		$(NC)	Show containers logs\n"
	@printf "$(GREEN)   	bash		$(NC)	Show containers logs\n"

.env:
	cp ./.docker/.env.dist .env

.env.${APP_ENV:-dev} .env.${APP_ENV:-dev}.local .env.local:
	touch $@

.PHONY: init
init: .env .env.local .env.${APP_ENV} .env.${APP_ENV}.local

.PHONY: run
run: init src composer.json composer.lock vendor .docker/docker-compose.base.yaml .docker/docker-compose.${APP_ENV}.yaml
	$(DOCKER_COMPOSE) up -d
	@touch .dc-running

.PHONY: build
build:
	$(DOCKER_COMPOSE) build

.PHONY: rebuild
rebuild: stop build run

.PHONY: ps
ps: init
	$(DOCKER_COMPOSE) ps -a

.PHONY: stop
stop:
	$(DOCKER_COMPOSE) down
	@rm .dc-running

.PHONY: restart
restart: stop run

.PHONY: logs
logs: .dc-running
	$(DOCKER_COMPOSE) logs $(service)

.PHONY: bash
bash: .dc-running
	$(DOCKER_COMPOSE) exec php bash