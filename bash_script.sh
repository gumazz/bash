#!/bin/bash

log_file='/vagrant/apache_logs'
last_execution_date_file="/vagrant/last_execution"
if [[ -f "$last_execution_date_file" ]]
then
	last_date=`cat $last_execution_date_file | sed -e 's@\/@\\\/@g'`
else
	last_date="*"
fi
pidfile="/var/run/bash_script.sh.pid"



if [[ -f "$pidfile" ]]
then
	echo  "Этот скрипт уже запущен"
else
	echo $$ > $pidfile 
	echo "Список IP адресов (с наибольшим кол-вом запросов) с указанием кол-ва запросов c момента последнего запуска скрипта;"
	ipaddresses=`sed -n "/$last_date/,/*/p" $log_file |awk '{print $1}'|sort |uniq -c |sort -hr|wc -l`
	if [ $ipaddresses -ge 1 ];
	then 
		sed -n "/$last_date/,/*/p" $log_file |awk '{print $1}'|sort |uniq -c |sort -hr
	else 
		echo "нет новых записей"
	fi

	echo ""
	
	echo "Список запрашиваемых URL (с наибольшим кол-вом запросов) с указанием кол-ва запросов c момента последнего запуска скрипта;"
	urls=`sed -n "/$last_date/,/*/p" $log_file |awk '{print $7}'|sort |uniq -c |sort -hr|wc -l`
	if [ $urls -ge 1 ] 
	then
		sed -n "/$last_date/,/*/p" $log_file |awk '{print $7}'|sort |uniq -c |sort -hr
	else
		echo "нет новых записей" 
	fi
	echo ""

	echo "Ошибки веб-сервера/приложения c момента последнего запуска;"
	errs=`sed -n "/$last_date/,/*/p" $log_file |grep -v "\" 200"|wc -l`
	if [ $errs -ge 1 ]
	then
		sed -n "/$last_date/,/*/p" $log_file |grep -v "\" 200"
	else
		echo "нет новых записей"
	fi
	echo ""

	echo "Список всех кодов HTTP ответа с указанием их кол-ва с момента последнего запуска скрипта."
	http_resps=`sed -n "/$last_date/,/*/p" $log_file |awk '{print $9}'|sort |uniq -c |sort -hr|wc -l`
	if [ $http_resps -ge 1 ]
	then
		sed -n "/$last_date/,/*/p" $log_file |awk '{print $9}'|sort |uniq -c |sort -hr
	else
		echo "нет новых записей"
	fi
fi
date +%d/%m/%Y:%T > $last_execution_date_file
trap "rm -f -- '$pidfile'" EXIT
