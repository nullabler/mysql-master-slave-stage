##@ —— DB 🐳 ——————————————————————————————————————————————————————————

db: ## connect to db [make db master][make db slave]
	docker-compose exec mysql-$(ARGS) mysql -u root -p$(MYSQL_ROOT_PASSWORD) $(MYSQL_DATABASE)

db-resync: ## resync master/slave [make db-resync]
	docker-compose exec mysql-$(MAIN_SVC) mysql -u root -p$(MYSQL_ROOT_PASSWORD) $(MYSQL_DATABASE) -e "RESET MASTER; FLUSH TABLES WITH READ LOCK;"
	docker-compose exec mysql-$(MAIN_SVC) sh -c "mysqldump -u root -p$(MYSQL_ROOT_PASSWORD) --all-databases > /tmp/dump.sql"
	docker-compose exec mysql-$(MAIN_SVC) mysql -u root -p$(MYSQL_ROOT_PASSWORD) $(MYSQL_DATABASE) -e "UNLOCK TABLES;"
	docker-compose exec mysql-$(SECOND_SVC) mysql -u root -p$(MYSQL_ROOT_PASSWORD) $(MYSQL_DATABASE) -e "STOP SLAVE;"
	docker-compose cp mysql-$(MAIN_SVC):/tmp/dump.sql ./dump.sql
	docker-compose cp ./dump.sql mysql-$(SECOND_SVC):/tmp/dump.sql
	rm dump.sql
	docker-compose exec mysql-$(SECOND_SVC) sh -c "mysql -u root -p$(MYSQL_ROOT_PASSWORD) $(MYSQL_DATABASE) < /tmp/dump.sql"
	docker-compose exec mysql-$(SECOND_SVC) mysql -u root -p$(MYSQL_ROOT_PASSWORD) $(MYSQL_DATABASE) -e "RESET SLAVE;"
	.build/dev/mysql/setup.sh
	docker-compose exec mysql-$(SECOND_SVC) mysql -u root -p$(MYSQL_ROOT_PASSWORD) $(MYSQL_DATABASE) -e "START SLAVE; SHOW SLAVE STATUS\G;"
	echo 'Done'

db-switch: ## switch master/slave [make db-switch]
	docker-compose exec mysql-$(MAIN_SVC) mysql -u root -p$(MYSQL_ROOT_PASSWORD) $(MYSQL_DATABASE) -e "SET GLOBAL read_only=ON; FLUSH TABLES; FLUSH LOGS;"
	docker-compose exec mysql-$(SECOND_SVC) mysql -u root -p$(MYSQL_ROOT_PASSWORD) $(MYSQL_DATABASE) -e "STOP SLAVE; SET GLOBAL read_only=OFF; SHOW VARIABLES LIKE '%read_only%';"
	.build/dev/mysql/setup.sh $(SECOND_SVC)
	echo 'You need change MAIN_SVC/SECOND_SVC in .env file'
	echo 'Done'

