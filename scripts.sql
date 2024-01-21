-- информация о кластере postgresql
pg_lsclusters
-- результат вывода
Ver Cluster Port Status Owner    Data directory              Log file
14  main    5432 online postgres /var/lib/postgresql/14/main /var/log/postgresql/postgresql-14-main.log

-- команды подключения
psql -U <user_name> -h <ip_host> -p 5432 -d <db_name> -W
<password>
psql -U <user_name> -h 127.0.0.1 -p 5432 -d <db_name> -W
<password>

-- перечитать конфигурационный файл через psql
select pg_reload_conf();

SELECT current_setting('hba_file');
select version();
SHOW password_encryption;
select current_database();
select current_role;
SELECT * FROM information_schema.role_table_grants WHERE grantee = 'YOUR_USER':
select * from pg_roles;

--конфиги
cd /etc/postgresql/14/main/
cd /var/lib/postgresql/14/main

nano postgresql.conf
nano pg_hba.conf

--логи
cd /var/log/postgresql
tail -n 10 postgresql-14-main.log

service postgresql status
service postgresql restart
systemctl restart postgresql@14-main
systemctl status postgresql@14-main

CREATE ROLE comita_user_test WITH LOGIN PASSWORD '3B15XBI342';
CREATE GROUP "e416_applmbfs-comita-otkazm-test-a";
ALTER GROUP "e416_applmbfs-comita-otkazm-test-a" add user "spozdny";
ALTER GROUP имя_группы RENAME TO новое_имя;
ALTER USER comita_user_test WITH PASSWORD '3B15XBI342';
DROP ROLE comita_user_test;
GRANT pg_write_all_data TO gpavlin;
GRANT pg_read_all_data TO gpavlin;
REVOKE pg_write_all_data FROM gpavlin;
REVOKE pg_read_all_data FROM gpavlin;
ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT SELECT ON TABLES TO myuser;

CREATE DATABASE comita_otkazm_test OWNER comita_user_test;
ALTER DATABASE _311p OWNER TO postgres;
DROP DATABASE _311p_test;
GRANT ALL PRIVILEGES ON DATABASE comita_otkazm_test to comita_user_test;
ALTER DATABASE _311p_test OWNER TO comita_user_test;
