CREATE OR REPLACE FUNCTION pg_temp.get_param() 
returns table (
		max_connections int,
		ram int
	) 
	AS $$
BEGIN
	return query
		select setting::int as max_connections, substring(pg_read_file('/proc/meminfo'),position('MemTotal:' in pg_read_file('/proc/meminfo'))+length('MemTotal:'),position('kB' in pg_read_file('/proc/meminfo'))-position('MemTotal:' in pg_read_file('/proc/meminfo'))-length('MemTotal:'))::int/1024 as ram from pg_settings where name='max_connections';	 
END;
$$ 
LANGUAGE 'plpgsql';

select (select pg_read_file('/etc/hostname') as hostname),
	(select inet_client_addr() as ip),
	(select inet_server_port() as port),
	(select substring(version()::text from '(^.*) on') as "PostgreSQL Version"),
	(select substring(version()::text from '(?<=on ).*') as "Operating System"),
	(select case when (select pid from pg_stat_replication limit 1) is not null then 'Replicated/master' when (select pid from pg_stat_wal_receiver limit 1) is not null then 'Replicated/slave'  else 'Not Replicated' end as Replication),
	(select setting as hot_standby from pg_settings where name='hot_standby'),
	(select setting as archive_command from pg_settings where name='archive_command'),
	(select setting as archive_mode from pg_settings where name='archive_mode'),
	(select setting as config_file from pg_settings where name='config_file'),
	(select setting as hba_file from pg_settings where name='hba_file'),
	(select setting as data_directory from pg_settings where name='data_directory'),
	(select max_connections as max_connections from pg_temp.get_param()),
	(select ((setting::int*8)/1024)::int as shared_buffers_mb from pg_settings where name='shared_buffers'),
	(select ((ram::int)/4)::int as recom_shared_buffers_mb from pg_temp.get_param()),
	(select ((setting::int)/1024)::int work_mem_mb from pg_settings where name='work_mem'),
	(select ((RAM*0.25)/max_connections)::int as recom_work_mem_mb from pg_temp.get_param()),
	(select ((setting::int)/1024)::int as "maintenance_work_mem_mb" from pg_settings where name='maintenance_work_mem'),
	(select (RAM*0.05)::int as recom_maintenance_work_mem_mb from pg_temp.get_param()),
	(select ((setting::int*8)/1024)::int as "effective_cache_size_mb" from pg_settings where name='effective_cache_size'),
	(select (RAM/2)::int as recom_effective_cache_size_mb from pg_temp.get_param()),
	(select setting as autovacuum from pg_settings where name='autovacuum'),
	(select 'on' as recom_autovacuum);
