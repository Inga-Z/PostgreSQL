-- Активные пользовательские соединения
SELECT  @@Servername AS Server ,
        DB_NAME(database_id) AS DatabaseName ,
        COUNT(database_id) AS Connections ,
        Login_name AS  LoginName ,
        MIN(Login_Time) AS Login_Time ,
        MIN(COALESCE(last_request_end_time, last_request_start_time)) AS  Last_Batch
FROM    sys.dm_exec_sessions
WHERE   database_id > 0
        AND DB_NAME(database_id) NOT IN ( 'master', 'msdb' )
GROUP BY database_id ,
         login_name
ORDER BY DatabaseName;

--проверить % выполнение команд и сколько времени до завершения
select	r.session_id as SPID, 
		command, 
		a.text as query, 
		start_time, 
		percent_complete,
		dateadd(second, estimated_completion_time/1000, GETDATE()) as estimated_completion_time
from sys.dm_exec_requests r
cross apply sys.dm_exec_sql_text(r.sql_handle) a
where r.command in ('BACKUP DATABASE', 'RESTORE DATABASE', 'BACKUP LOG', 'RESTORE LOG',
					'ALTER INDEX', 'KILLED/ROLLBACK')
					or r.command like '%DBCC%' or r.command like 'RESTORE%'

-- backup history
select
bs.database_name
,[backup_type] = case bs.type when 'D' then 'full' when 'I' then 'differential' when 'L' then 'log' end
,bs.name
,bs.user_name
,bs.backup_start_date
,bs.backup_finish_date
,bmf.physical_device_name
,bs.is_damaged
,bs.is_copy_only
,bs.server_name
,bs.machine_name
,cast(round(bs.backup_size/1048576,2) as decimal(10,0)) as 'backup_size_mb'
,cast(round(bs.compressed_backup_size/1048576,2) as decimal(10,0)) as 'compressed_backup_size_mb'
from msdb.dbo.backupset bs
left join msdb.dbo.backupmediafamily bmf on bmf.media_set_id=bs.media_set_id
where
bs.backup_finish_date > dateadd(dd,-1,getdate())
-- and bs.database_name in ('PADM')
-- and bs.database_name like 'Flex%'
and bs.type = 'L' -- log backup
or bs.type = 'D' -- full backup
-- and bs.type = 'I' -- diff backup
order by bs.backup_finish_date desc
