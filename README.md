## PostgreSQL — программа, которая относится к классу систем управления базами данных. PostgreSQL — это объектно-реляционная система управления базами данных (ОРСУБД, ORDBMS).  
## PostgreSQL — СУБД с открытым исходным кодом, основой которого был код, написанный в Беркли. Она поддерживает большую часть стандарта SQL и предлагает множество современных функций
PostgreSQL - ванильная опенсорсная версия. Postgre Pro - как бы она же, с лейблом от компании 'Postgres Professional' и доступны дополнительные возможности, например: улучшенный механизм проверки блокировок; увеличенная скорость и эффективность планирования для различных типов запросов; уменьшенное потребление памяти при обработке сложных запросов со множеством таблиц и [многое другое](https://postgrespro.ru/docs/postgrespro/14/intro-pgpro-vs-pg).

# PostgreSQL_13 на Ubuntu из пакетов
Установить Postgresql можно из исходных кодов или из пакетов. Установка из исходных кодов может быть использована если необходимы нестандартные параметры СУБД или необходимо собрать СУБД неспецифической архитектуры. Установка из пакетов наиболее предпочтительный способ, так как в этом случае получается понятная, поддерживаемаяи легко обновляемая установка.  
Сервер работает под выделенным пользователем ОС (postgres). Перед использованием сервера при установке из исходных кодов необходимо инициализировать кластер баз данных через утилиту initdb.

## Подготовка ОС для установки Postgresql
Подключится к хосту под пользователем root или под пользователем с правами root <br>
__update__ обновляет список доступных пакетов и их версий, но не устанавливает и не обновляет какие-либо пакеты <br>  
__upgrade__ фактически устанавливает более новые версии имеющихся у вас пакетов и принудительно удаляет устаревшие пакеты <br>  
запускать по отдельности от пользователя с правами root
```
~$ sudo apt -y update
~$ sudo apt -y upgrade
```
или сразу
```
~$ sudo apt -y update && sudo apt -y upgrade
```
после установки обновлений желательно перезагрузить хост
```
~$ sudo reboot
```
установка PostgreSQL 13 версия из пакета командой. Добавляем репозиторий и делаем импорт ключей:
```
~$ sudo apt -y install vim bash-completion wget
~$ wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | sudo apt-key add -
~$ echo "deb http://apt.postgresql.org/pub/repos/apt/ `lsb_release -cs`-pgdg main" |sudo tee /etc/apt/sources.list.d/pgdg.list
```
Обновляем индексы пакетов:
```
~$ sudo apt update
```
Собственно установка:
```
~$ sudo apt install postgresql-13 postgresql-client-13
```
Во время установки автоматически создаётся пользователь postgres. Это суперадминистратор, который имеет полный доступ ко всему PostgreSQL  
По умолчанию у пользователя postgres отсутствует пароль. Можем задать пароль в ОС
```
~$ sudo passwd postgres
```
также задаем пароль пользователя postgres в БД. Переключаемся на пользователя postgres в ОС и потом выполняем команду psql
```
~$ sudo su - postgres
~$ psql -c "alter user postgres with password 'ВашНадежныПароль'"
```
информация о кластере postgresql
```
~$ pg_lsclusters

Ver Cluster Port Status Owner    Data directory              Log file
13  main    5432 online postgres /var/lib/postgresql/13/main /var/log/postgresql/postgresql-13-main.log
```

Один экземпляр PostgreSQL одновременно работает с несколькими базами данных. Этот набор баз данных называется кластером баз данных. Проверить статус работы кластера БД, перезапустить, остановить или запустить кластер. Проверить статус работы кластера можно из под любого пользователя. Для рестарта / остановки / запуска требуются права root
```
~$ systemctl status postgresql@13-main
~$ systemctl restart postgresql@13-main
~$ systemctl stop postgresql@13-main
~$ systemctl start postgresql@13-main
```
Для останова сервера используется команда stop с различными ключами в зависисмости от потребности. По умолчанию используется режим fast.
fast — принудительно завершает сеансы и записывает на диск изменения из оперативной памяти; <br> 
smart — ожидает завершения всех сеансов и записывает на диск изменения из оперативной памяти; <br> 
immediate — принудительно завершает сеансы, при запуске потребуется восстановление. <br> 
```
pg_ctlcluster <version> <cluster> <action>
~$ pg_ctlcluster 13 main stop -m fast
```
проверить с какой конфигурацией PostgreSQL собран
```
sudo /usr/lib/postgresql/13/bin/pg_config --configure
```
Журнал сообщений сервера при пакетной установке находится здесь: /var/log/postgresql
```
~$ ls -l /var/log/postgresql/postgresql-13-main.log
```
Заглянем в конец журнала:
```
~$ tail -n 10 /var/log/postgresql/postgresql-13-main.log
```

## Донастрока после установки
Включить подсчет контрольные суммы страниц — эта функция, помогающая проверить целостность данных, хранящихся на диске. Используется утилита pg_checksums — включить, отключить или проверить контрольные суммы данных в кластере PostgreSQL. Включить или отключить контрольные суммы данных можно на уровне всего кластера, но не для отдельной базы данных или таблицы
Включить защиту страниц данных контрольными суммами можно сделать только при инициализации кластера, но в версии PostgreSQL 12 ее можно включать и выключать с помощью утилиты pg_checksums
Проверить включена ли функция подсчет контрольных сумм
```
~$ psql
postgres=# SHOW data_checksums;
 data_checksums 
----------------
 off
(1 row)
```
Включить функцию подсчета контрольных сумм
```
~$ pg_ctlcluster 13 main stop -m fast
~$ sudo /usr/lib/postgresql/13/bin/pg_checksums --check -D /var/lib/postgresql/13/main
## результат запроса
pg_checksums: error: data checksums are not enabled in cluster

~$ sudo /usr/lib/postgresql/13/bin/pg_checksums --enable -D /var/lib/postgresql/13/main
## результат запроса
Checksum operation completed
Files scanned:  916
Blocks scanned: 2964
pg_checksums: syncing data directory
pg_checksums: updating control file
Checksums enabled in cluster

~$ pg_ctlcluster 13 main start
~$ systemctl status postgresql@13-main

~$ su - postgres
~$  psql
postgres=# SHOW data_checksums;
 data_checksums 
----------------
 on
(1 row)
```
В дальнейшем очень важно контролировать количество ошибок контрольных сумм в страницах данных с помощью какой-то системы мониторинга, иначе Вы не сможете во время узнать о появлении ошибок и произвести исправление данных. Для контроля нужно использовать представление pg_stat_database и проверять значение столбцов datname (Имя базы данных), checksum_failures (Количество ошибок контрольных сумм в страницах данных этой базы (или общего объекта) либо NULL, если контрольные суммы не проверяются) и checksum_last_failure (Время выявления последней ошибки контрольной суммы в страницах данных этой базы (или общего объекта) либо NULL, если контрольные суммы не проверяются)
Пример запроса для проверки наличия ошибок:
```
SELECT datname, checksum_failures, checksum_last_failure FROM pg_stat_database WHERE datname IS NOT NULL;
```
