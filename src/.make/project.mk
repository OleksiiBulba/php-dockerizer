.DEFAULT_GOAL := help

DOCKER_COMPOSE := docker-compose -f ./.dockerizer/docker-compose.base.yaml -f ./.dockerizer/docker-compose.${APP_ENV}.yaml

.PHONY: help
help::
	@printf "$(BROWN) Project commands:$(NC)\n"
	@printf "$(GREEN)	help	$(NC)	Display this help message\n"
	@printf "$(GREEN)	run	$(NC)	Run docker containers\n"
	@printf "$(GREEN)	ps	$(NC)	Show running containers\n"
	@printf "$(GREEN)	stop	$(NC)	Stops all containers\n"
	@printf "$(GREEN)	restart	$(NC)	Stops and runs again all containers\n"
	@printf "$(GREEN)	build	$(NC)	Rebuild php container if there is any changes\n"
	@printf "$(GREEN)	rebuild	$(NC)	Stops containers (if running),\n\t\t\t  rebuilds php container (see build command)\n\t\t\t  and starts containers back\n"
	@printf "$(GREEN)	logs	$(NC)	Show containers logs\n"
	@printf "$(GREEN)	bash	$(NC)	Show containers logs\n"

.env:
	cp ./.dockerizer/.env.dist .env

.env.${APP_ENV} .env.${APP_ENV}.local .env.local:
	touch $@

.PHONY: init
init: .env .env.local .env.${APP_ENV} .env.${APP_ENV}.local .env.local

.PHONY: run
run: init composer.json composer.lock vendor .dockerizer/docker-compose.base.yaml .dockerizer/docker-compose.${APP_ENV}.yaml
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