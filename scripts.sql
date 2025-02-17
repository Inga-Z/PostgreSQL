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

CREATE ROLE user_name WITH LOGIN PASSWORD 'your_password';
CREATE GROUP "group_name";
ALTER GROUP "group_name" add user "user_name";
ALTER GROUP group_name RENAME TO new_group_name;
ALTER USER user_name WITH PASSWORD 'new_password';
DROP ROLE user_name;
GRANT pg_write_all_data TO user_name;
GRANT pg_read_all_data TO user_name;
REVOKE pg_write_all_data FROM user_name;
REVOKE pg_read_all_data FROM user_name;
ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT SELECT ON TABLES TO myuser;

CREATE DATABASE comita_otkazm_test OWNER comita_user_test;
ALTER DATABASE db_name OWNER TO user_name;
DROP DATABASE db_name;
GRANT ALL PRIVILEGES ON DATABASE db_name to user_name;
ALTER DATABASE db_name OWNER TO user_name;
