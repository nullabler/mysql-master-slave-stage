##@ —— Develop 🐳 —————————————————————————————————————————————————————

example-table: ## add example table [make example-table]
	docker-compose exec mysql-master mysql -u root -p$(MYSQL_ROOT_PASSWORD) $(MYSQL_DATABASE) -e "CREATE TABLE staff (id INT PRIMARY KEY AUTO_INCREMENT, name VARCHAR(255) NOT NULL);"
	docker-compose exec mysql-slave mysql -u root -p$(MYSQL_ROOT_PASSWORD) $(MYSQL_DATABASE) -e "SHOW TABLES;"

show-tables: ## show tables by service [make show-tables slave]
	docker-compose exec mysql-$(ARGS) mysql -u root -p$(MYSQL_ROOT_PASSWORD) $(MYSQL_DATABASE) -e "SHOW TABLES;"

add-row: ## add some row to table [make add-row username]
	docker-compose exec mysql-master mysql -u root -p$(MYSQL_ROOT_PASSWORD) $(MYSQL_DATABASE) -e "INSERT staff SET name='$(ARGS)';"
	docker-compose exec mysql-slave mysql -u root -p$(MYSQL_ROOT_PASSWORD) $(MYSQL_DATABASE) -e "SELECT * FROM staff;"

show-rows: ## show rows by service [make show-rows slave]
	docker-compose exec mysql-$(ARGS) mysql -u root -p$(MYSQL_ROOT_PASSWORD) $(MYSQL_DATABASE) -e "SELECT * FROM staff;"

add-brake-row: ## add some row for slave [make add-brake-row bug_username]
	docker-compose exec mysql-slave mysql -u root -p$(MYSQL_ROOT_PASSWORD) $(MYSQL_DATABASE) -e "INSERT staff SET name='$(ARGS)';"

