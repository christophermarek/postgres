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
	@until docker exec $(POSTGRES_CONTAINER_NAME) pg_isready -U postgres -q 2>/dev/null; do sleep 1; done; true
	@docker exec $(POSTGRES_CONTAINER_NAME) psql -U postgres -c "DO \$$$$ BEGIN IF NOT EXISTS (SELECT 1 FROM pg_roles WHERE rolname='$(POSTGRES_USER)') THEN CREATE ROLE $(POSTGRES_USER) WITH LOGIN PASSWORD '$(shell echo '$(POSTGRES_PASSWORD)' | sed "s/'/''/g")'; END IF; END \$$$$;" 2>/dev/null || true
	@docker exec $(POSTGRES_CONTAINER_NAME) psql -U postgres -tAc "SELECT 1 FROM pg_database WHERE datname='$(POSTGRES_DB)'" 2>/dev/null | grep -q 1 || docker exec $(POSTGRES_CONTAINER_NAME) psql -U postgres -c "CREATE DATABASE $(POSTGRES_DB) OWNER $(POSTGRES_USER);" 2>/dev/null || true
	@docker exec $(POSTGRES_CONTAINER_NAME) psql -U postgres -d $(POSTGRES_DB) -c "GRANT ALL ON SCHEMA public TO $(POSTGRES_USER);" 2>/dev/null || true
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
