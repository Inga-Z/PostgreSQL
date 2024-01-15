# PostgreSQL_13
## Обновить системные файлы
update обновляет список доступных пакетов и их версий, но не устанавливает и не обновляет какие-либо пакеты

upgrade фактически устанавливает более новые версии имеющихся у вас пакетов и принудительно удаляет устаревшие пакеты
можно запускать по отдельности
```
ubuntu@ubuntu-inga:~$ sudo apt -y update
ubuntu@ubuntu-inga:~$ sudo apt -y upgrade
```
или сразу
```
ubuntu@ubuntu-inga:~$ sudo apt -y update && sudo apt -y upgrade
```
