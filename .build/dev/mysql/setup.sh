#!/bin/bash

until docker-compose exec mysql-master mysql -u root -proot -e ";"
do
    echo "Waiting for mysql-master database connection..."
    sleep 4
done

STATUS=`docker-compose exec mysql-master mysql -u root -proot -e "SHOW MASTER STATUS\G"`
pattern='File: (mysql-bin\.[0-9]+)'
if  [[ $STATUS =~ $pattern ]]; then
    LOG=${BASH_REMATCH[1]}
fi

pattern='Position: ([0-9]+)'
if  [[ $STATUS =~ $pattern ]]; then
    POS=${BASH_REMATCH[1]}
fi

until docker-compose exec mysql-slave mysql -u root -proot -e ";"
do
    echo "Waiting for mysql-slave database connection..."
    sleep 4
done

docker-compose exec mysql-slave mysql -u root -proot -e "CHANGE MASTER TO MASTER_HOST='mysql-master', MASTER_USER='replication', MASTER_PASSWORD='passwd', MASTER_LOG_FILE='$LOG', MASTER_LOG_POS=$POS; START SLAVE;"
docker-compose exec mysql-slave mysql -u root -proot -e "SHOW SLAVE STATUS \G"
