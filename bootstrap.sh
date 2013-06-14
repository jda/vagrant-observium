#!/usr/bin/env bash
apt-get update
export DEBIAN_FRONTEND=noninteractive
apt-get install -y mysql-server-5.5 libapache2-mod-php5 \
  php5-cli php5-mysql vim \
  php5-gd php5-snmp php-pear snmp graphviz subversion mysql-server \
  mysql-client rrdtool fping imagemagick whois mtr-tiny nmap ipmitool

if [ ! -f "/opt/observium/README" ]; then
  svn co http://observium.org/svn/observer/trunk/ /opt/observium
else
  svn up
fi

cd /opt/observium
mysql -u root -e "CREATE DATABASE observium;"

if [ ! -f "config.php" ]; then
  cat config.php.default | sed s/PASSWORD//g | sed s/USERNAME/root/g > config.php
fi

php includes/sql-schema/update.php
mkdir graphs rrd
chown www-data:www-data graphs rrd

rm /etc/apache2/sites-available/default
cp /opt/misc/apache /etc/apache2/sites-available/default
a2enmod rewrite
apache2ctl restart

./adduser.php admin admin 10

cp /opt/misc/cron /etc/cron.d/observium
echo "mibdirs /opt/observium/mibs">/etc/snmp/snmp.conf
