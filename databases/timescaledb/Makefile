# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.
# prepares image base names and tag
GIT_COMMIT := $(shell git rev-parse --short HEAD)
GIT_UNTRACKEDCHANGES := $(shell git status --porcelain --untracked-files=no)
ifneq ($(GIT_UNTRACKEDCHANGES),)
	GIT_COMMIT := $(GIT_COMMIT)-dirty
endif
ifeq ($(GIT_COMMIT),master)
	CONTAINER_TAG := latest
else
	CONTAINER_TAG := $(GIT_COMMIT)
endif
export BASE_NAME := flowtimedb
export DB_SAMPLE_DATA_NAME := $(BASE_NAME)_sample_data
export CONTAINER_TAG

.PHONY: sample-db
sample-db: build-sample-db start-sample-db ## Run all build and deploy steps for DB with sample data

.PHONY: build-all
build-all: build-flowtimedb build-sample-db ## Run all build steps

.PHONY: build-flowtimedb
build-flowtimedb: ## Build DB base image with no sample data included
	@echo "Now building $(BASE_NAME):$(CONTAINER_TAG) image..."
	docker-compose -f docker-compose.yml build
	@docker tag $(BASE_NAME):$(CONTAINER_TAG) $(BASE_NAME):latest

.PHONY: build-sample-db
build-sample-db: ## Build DB image with sample data
	@echo "Now building $(DB_SAMPLE_DATA_NAME):$(CONTAINER_TAG) image..."
	docker-compose -f docker-compose-sample-data.yml build
	@docker tag $(DB_SAMPLE_DATA_NAME):$(CONTAINER_TAG) $(DB_SAMPLE_DATA_NAME):latest

.PHONY: start-flowtimedb
start-flowtimedb: ## Start base database
	@echo "Starting $(BASE_NAME):$(CONTAINER_TAG) ..."
	docker-compose -f docker-compose.yml up -d

.PHONY: start-sample-db
start-sample-db: ## Start sample database
	@echo "Starting $(DB_SAMPLE_DATA_NAME):$(CONTAINER_TAG) ..."
	docker-compose -f docker-compose-sample-data.yml up -d

.PHONY: stop-flowtimedb
stop-flowtimedb: ## Stop base database
	@echo "Stopping $(BASE_NAME):$(CONTAINER_TAG) ..."
	docker-compose -f docker-compose.yml down

.PHONY: stop-sample-db
stop-sample-db: ## Stop sample database but retain volumes
	@echo "Stopping $(DB_SAMPLE_DATA_NAME):$(CONTAINER_TAG) ..."
	docker-compose -f docker-compose-sample-data.yml down

.PHONY: stop-flowtimedb-and-remove-volumes
stop-flowtimedb-and-remove-volumes: ## Stop base database and remove volumes
	@echo "Stopping $(BASE_NAME):$(CONTAINER_TAG) ..."
	docker-compose -f docker-compose.yml down -v

.PHONY: stop-sample-db-and-remove-volumes
stop-sample-db-and-remove-volumes: ## Stop sample database and remove volumes
	@echo "Stopping $(DB_SAMPLE_DATA_NAME):$(CONTAINER_TAG) ..."
	docker-compose -f docker-compose-sample-data.yml down -v

.PHONY: connect-to-db-as-admin-via-container
connect-to-db-as-admin-via-container: ## Connect to base database as admin user via container
	docker exec -ti flowtimedb psql "postgresql://${POSTGRES_USER}:${POSTGRES_PASSWORD}@127.0.0.1:5432/${POSTGRES_DB}"

.PHONY: connect-to-sample-db-as-admin-via-container
connect-to-sample-db-as-admin-via-container: ## Connect to sample database as admin user via container
	docker exec -ti flowtimedb_sample_data psql "postgresql://${POSTGRES_USER}:${POSTGRES_PASSWORD}@127.0.0.1:5432/${POSTGRES_DB}"

.PHONY: connect-to-db-via-host
connect-to-db-via-host: ## Connect to database as admin user via host
	psql "postgresql://${POSTGRES_USER}:${POSTGRES_PASSWORD}@127.0.0.1:${PORT}/${POSTGRES_DB}"

.PHONY: help
help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'
