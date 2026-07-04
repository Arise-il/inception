COMPOSE = docker compose -f srcs/docker-compose.yml

up:
	$(COMPOSE) up
	
down:
	$(COMPOSE) down

rebuild:
	$(COMPOSE) up --build

clean:
	$(COMPOSE) down --rmi all

re: down rebuild
