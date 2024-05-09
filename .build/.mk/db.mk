##@ —— DB 🐳 ——————————————————————————————————————————————————————————

db: ## connect to db [make db master][make db slave]
	docker-compose exec mysql-$(ARGS) mysql -u root -p$(MYSQL_ROOT_PASSWORD) $(MYSQL_DATABASE)

db-resync: ## resync master/slave [make db-resync]
	docker-compose exec mysql-master mysql -u root -p$(MYSQL_ROOT_PASSWORD) $(MYSQL_DATABASE) -e "RESET MASTER; FLUSH TABLES WITH READ LOCK;"
	docker-compose exec mysql-master sh -c "mysqldump -u root -p$(MYSQL_ROOT_PASSWORD) --all-databases > /tmp/dump.sql"
	docker-compose exec mysql-master mysql -u root -p$(MYSQL_ROOT_PASSWORD) $(MYSQL_DATABASE) -e "UNLOCK TABLES;"
	docker-compose exec mysql-slave mysql -u root -p$(MYSQL_ROOT_PASSWORD) $(MYSQL_DATABASE) -e "STOP SLAVE;"
	docker-compose cp mysql-master:/tmp/dump.sql ./dump.sql
	docker-compose cp ./dump.sql mysql-slave:/tmp/dump.sql
	rm dump.sql
	docker-compose exec mysql-slave sh -c "mysql -u root -p$(MYSQL_ROOT_PASSWORD) $(MYSQL_DATABASE) < /tmp/dump.sql"
	docker-compose exec mysql-slave mysql -u root -p$(MYSQL_ROOT_PASSWORD) $(MYSQL_DATABASE) -e "RESET SLAVE;"
	 .build/dev/mysql/setup.sh
	docker-compose exec mysql-slave mysql -u root -p$(MYSQL_ROOT_PASSWORD) $(MYSQL_DATABASE) -e "START SLAVE; SHOW SLAVE STATUS\G;"

