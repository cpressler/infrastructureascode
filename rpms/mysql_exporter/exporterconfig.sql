
--- only set low in lower environment
-- must match settings in .mysql_exporter.cnf
SET GLOBAL validate_password_policy=LOW;
CREATE USER 'prom'@'localhost' identified by 'prometheus';
GRANT REPLICATION CLIENT, PROCESS ON *.* TO 'prom'@'localhost';
flush privileges;