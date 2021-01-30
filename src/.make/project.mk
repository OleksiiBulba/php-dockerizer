.DEFAULT_GOAL := help

DOCKER_COMPOSE := docker-compose -f docker-compose.base.yaml -f docker-compose.${ENV}.yaml

.PHONY: help
help::
	@printf "$(BROWN) Project commands:$(NC)\n"
	@printf "$(GREEN)   	help		$(NC)	Display this help message\n"
	@printf "$(GREEN)   	run		$(NC)	Run docker containers\n"
	@printf "$(GREEN)   	ps		$(NC)	Show running containers\n"
	@printf "$(GREEN)   	stop		$(NC)	Stops all containers\n"
	@printf "$(GREEN)   	restart		$(NC)	Stops and runs again all containers\n"
	@printf "$(GREEN)   	logs		$(NC)	Show containers logs\n"
	@printf "$(GREEN)   	bash		$(NC)	Show containers logs\n\n\n"
	@printf "$(GREEN)   	NGINX_SERVER_CONFIG_FILE:	$(NGINX_SERVER_CONFIG_FILE)\n"

.env.local .env.${ENV} .env.${ENV}.local:
	cp .env.dist $@

.PHONY: init
init: .env .env.local .env.${ENV} .env.${ENV}.local

.PHONY: run
run: init src composer.json composer.lock vendor .docker docker-compose.base.yaml docker-compose.${ENV}.yaml
	$(DOCKER_COMPOSE) up -d
	@touch .dc-running

.PHONY: ps
ps: init
	$(DOCKER_COMPOSE) ps -a

.PHONY: stop
stop:
	$(DOCKER_COMPOSE) down
	@rm .dc-running

.PHONY: restart
restart: .dc-running stop run

.PHONY: logs
logs: .dc-running
	$(DOCKER_COMPOSE) logs $(service)

.PHONY: bash
bash: .dc-running
	$(DOCKER_COMPOSE) exec php bash