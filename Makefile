.PHONY: start stop status logs

-include .env
POSTGRES_IMAGE ?= postgres:16-alpine
POSTGRES_CONTAINER_NAME ?= postgres
POSTGRES_DATA_DIR ?= $(shell pwd)/data/postgres
POSTGRES_PORT ?= 5432
POSTGRES_USER ?= postgres
POSTGRES_PASSWORD ?= postgres
POSTGRES_DB ?= postgres
TZ ?= America/New_York

export POSTGRES_IMAGE POSTGRES_CONTAINER_NAME POSTGRES_DATA_DIR POSTGRES_PORT
export POSTGRES_USER POSTGRES_PASSWORD POSTGRES_DB TZ

start:
	@mkdir -p $(POSTGRES_DATA_DIR)
	@docker-compose up -d
	@echo "PostgreSQL started!"
	@echo "Host: localhost"
	@echo "Port: $(POSTGRES_PORT)"
	@echo "Database: $(POSTGRES_DB)"
	@echo "User: $(POSTGRES_USER)"
	@echo "Connection: postgresql://$(POSTGRES_USER):$(POSTGRES_PASSWORD)@localhost:$(POSTGRES_PORT)/$(POSTGRES_DB)"

stop:
	@docker-compose down
	@echo "Services stopped"

status:
	@docker-compose ps

logs:
	@docker-compose logs -f
