# PostgreSQL_13 на Ubunut
## Обновить системные файлы
update обновляет список доступных пакетов и их версий, но не устанавливает и не обновляет какие-либо пакеты /n upgrade фактически устанавливает более новые версии имеющихся у вас пакетов и принудительно удаляет устаревшие пакеты
\n можно запускать по отдельности
```
ubuntu@ubuntu-inga:~$ sudo apt -y update
ubuntu@ubuntu-inga:~$ sudo apt -y upgrade
```
или сразу
```
ubuntu@ubuntu-inga:~$ sudo apt -y update && sudo apt -y upgrade
```
