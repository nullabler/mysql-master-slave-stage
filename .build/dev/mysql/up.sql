CREATE USER 'replication'@'%' IDENTIFIED BY 'passwd';
GRANT REPLICATION SLAVE ON *.* TO 'replication'@'%';
FLUSH PRIVILEGES;
