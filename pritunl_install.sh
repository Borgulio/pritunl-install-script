#!/bin/bash


if [[ "$EUID" -ne 0 ]]; then
	echo "Этот скрипт нужно запускать с правами root"
	exit 2
fi


yum install epel-release -y
yum update -y
yum upgrade -y
yum install wget -y

tee /etc/yum.repos.d/mongodb-org-4.4.repo << EOF
[mongodb-org-4.4]
name=MongoDB Repository
baseurl=https://repo.mongodb.org/yum/redhat/7/mongodb-org/4.4/x86_64/
gpgcheck=1
enabled=1
gpgkey=https://www.mongodb.org/static/pgp/server-4.4.asc
EOF

tee /etc/yum.repos.d/pritunl.repo << EOF
[pritunl]
name=Pritunl Repository
baseurl=https://repo.pritunl.com/stable/yum/centos/7/
gpgcheck=1
enabled=1
EOF

rpm -Uvh https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
gpg --keyserver hkp://keyserver.ubuntu.com --recv-keys 7568D9BB55FF9E5287D586017AE645C0CF8E292A
gpg --armor --export 7568D9BB55FF9E5287D586017AE645C0CF8E292A > key.tmp; sudo rpm --import key.tmp; rm -f key.tmp
yum -y install pritunl mongodb-org
systemctl start mongod pritunl
systemctl enable mongod pritunl
systemctl stop firewalld
systemctl disable firewalld

IP=$(wget -4qO- "http://whatismyip.akamai.com/")
echo ''
echo ''
echo "Далее переходим в браузере по ссылке https://$IP и завершаем установку следуя инструкции"
echo 'Должен быть открыт 443 порт, позже можно будет сменить'
echo
read -n1 -r -p "Нажмите любую кнопку для продолжения..."
