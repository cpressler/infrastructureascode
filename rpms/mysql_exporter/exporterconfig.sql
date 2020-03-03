
--- only set low in lower environment
-- must match settings in .mysql_exporter.cnf
SET GLOBAL validate_password_policy=LOW;
CREATE USER 'prometheus'@'localhost' identified by 'prometheus';
GRANT REPLICATION CLIENT, PROCESS ON *.* TO 'prometheus'@'localhost';
flush privileges;