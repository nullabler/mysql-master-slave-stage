##@ —— Develop 🐳 —————————————————————————————————————————————————————

example-table: ## add example table [make example-table]
	docker-compose exec mysql-$(MAIN_SVC) mysql -u root -p$(MYSQL_ROOT_PASSWORD) $(MYSQL_DATABASE) -e "CREATE TABLE staff (id INT PRIMARY KEY AUTO_INCREMENT, name VARCHAR(255) NOT NULL);"
	make show-tables
	echo 'Created staff table'

show-tables: ## show tables for all service [make show-tables]
	echo $(MAIN_SVC)
	docker-compose exec mysql-$(MAIN_SVC) mysql -u root -p$(MYSQL_ROOT_PASSWORD) $(MYSQL_DATABASE) -e "SHOW TABLES;"
	echo $(SECOND_SVC)
	docker-compose exec mysql-$(SECOND_SVC) mysql -u root -p$(MYSQL_ROOT_PASSWORD) $(MYSQL_DATABASE) -e "SHOW TABLES;"

add-row: ## add some row to table [make add-row username]
	docker-compose exec mysql-$(MAIN_SVC) mysql -u root -p$(MYSQL_ROOT_PASSWORD) $(MYSQL_DATABASE) -e "INSERT staff SET name='$(ARGS)';"
	make check-rows

check-rows: ## show rows for all service [make show-rows]
	echo $(MAIN_SVC)
	docker-compose exec mysql-$(MAIN_SVC) mysql -u root -p$(MYSQL_ROOT_PASSWORD) $(MYSQL_DATABASE) -e "SELECT * FROM staff;"
	echo $(SECOND_SVC)
	docker-compose exec mysql-$(SECOND_SVC) mysql -u root -p$(MYSQL_ROOT_PASSWORD) $(MYSQL_DATABASE) -e "SELECT * FROM staff;"

add-brake-row: ## add some row for slave [make add-brake-row]
	docker-compose exec mysql-$(SECOND_SVC) mysql -u root -p$(MYSQL_ROOT_PASSWORD) $(MYSQL_DATABASE) -e "INSERT staff SET name='$(ARGS)';"
	make check-rows
	echo 'Done'

