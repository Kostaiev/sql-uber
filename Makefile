.DEFAULT_GOAL := help

MYSQL_ADMIN ?= sudo mysql
MYSQL ?= mysql --login-path=uber --default-character-set=utf8mb4

DB := uber

TABLE_SQL := \
    db/001_create_region.sql \
    db/002_create_city.sql \
    db/003_create_street.sql \
    db/004_create_house.sql \
	db/005_create_passenger.sql

SEED_SQL := seeds/dev_seed.sql

.PHONY: help create-user login create-db create-tables seed verify setup reset

help:
	@printf '%s\n' \
		'setup          Initialize local environment' \
		'verify         Show tables and sample data' \
		'seed           Insert development data' \
		'reset          Delete database, user, and login' \
		'create-user    Create MySQL user' \
		'login          Configure MySQL login path' \
		'create-db      Create database' \
		'create-tables  Create tables'

create-user:
	@$(MYSQL_ADMIN) --table -e "CREATE USER IF NOT EXISTS 'uber'@'localhost' IDENTIFIED BY RANDOM PASSWORD; GRANT ALL PRIVILEGES ON uber.* TO 'uber'@'localhost';"
	@echo 'For a new account, save the generated password for the next step.'

login:
	@mysql_config_editor set --login-path=uber --host=localhost --user=uber --password

create-db:
	@$(MYSQL) < db/000_create_database.sql

create-tables:
	@set -e; for file in $(TABLE_SQL); do \
		echo "Applying $$file"; \
		$(MYSQL) --database="$(DB)" < "$$file"; \
	done

seed:
	@$(MYSQL) --database="$(DB)" < "$(SEED_SQL)"

verify:
	@$(MYSQL) --database="$(DB)" --table -e "SHOW TABLES; \
		SELECT c.name AS city, s.name AS street, s.drivable, h.house_number \
		FROM city c JOIN street s ON s.city_id = c.id \
		LEFT JOIN house h ON h.street_id = s.id \
		ORDER BY c.name, s.name, h.house_number; \
		SELECT COUNT(*) AS passenger_amount FROM passenger;"

setup:
	@$(MAKE) create-user
	@$(MAKE) login
	@$(MAKE) create-db
	@$(MAKE) create-tables
	@$(MAKE) seed
	@$(MAKE) verify

reset:
	@printf 'Type RESET uber to delete the database, account, and local login: '; \
		read -r answer; \
		[ "$$answer" = 'RESET uber' ] || { echo 'Cancelled'; exit 1; }
	@$(MYSQL_ADMIN) -e "DROP DATABASE IF EXISTS uber; DROP USER IF EXISTS 'uber'@'localhost';"
	@if mysql_config_editor print --login-path=uber 2>/dev/null | grep -Fqx '[uber]'; then \
		mysql_config_editor remove --login-path=uber; \
	fi