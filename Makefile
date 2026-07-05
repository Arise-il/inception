NAME        = inception
LOGIN       = $(shell whoami)
DATA_PATH   = /home/$(LOGIN)/data
COMPOSE     = docker compose -f srcs/docker-compose.yml --env-file srcs/.env

all: up

up: data_dirs
	$(COMPOSE) up -d --build

build: data_dirs
	$(COMPOSE) build

down:
	$(COMPOSE) down

stop:
	$(COMPOSE) stop

start:
	$(COMPOSE) start

restart: down up

logs:
	$(COMPOSE) logs -f

ps:
	$(COMPOSE) ps

data_dirs:
	mkdir -p $(DATA_PATH)/mariadb
	mkdir -p $(DATA_PATH)/wordpress

clean: down
	docker system prune -f

fclean: down
	docker system prune -af --volumes
	sudo rm -rf $(DATA_PATH)

re: fclean all

.PHONY: all up build down stop start restart logs ps data_dirs clean fclean re
