#!/bin/bash
yum install mailx -y
echo '01 * * * * bash /vagrant/bash_script.sh  | mail -s "Log stats" root@localhost >/dev/null 2>&1'|crontab
