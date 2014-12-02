#!/usr/bin/env bash
mkdir /root/.subversion

echo -e "[global]\nstore-plaintext-passwords = yes\n" > /root/.subversion/servers

apt-get update
export DEBIAN_FRONTEND=noninteractive
apt-get install -y mysql-server-5.5 libapache2-mod-php5 \
  php5-cli php5-mysql vim snmp-mibs-downloader \
  php5-gd php5-snmp php5-mcrypt php-pear snmp graphviz subversion mysql-server \
  mysql-client rrdtool fping imagemagick whois mtr-tiny nmap ipmitool

if [ ! -f "/opt/observium" ]; then
  svn --username `cat /opt/misc/svn.user` --password `cat /opt/misc/svn.passwd` co http://svn.observium.org/svn/observium/trunk/ /opt/observium
else
  svn up
fi

cd /opt/observium
mysql -u root -e "CREATE DATABASE observium;"

cat config.php.default | sed s/PASSWORD//g | sed s/USERNAME/root/g > config.php
echo "\$config['rrd_dir']       = \"/opt/observium-rrd\";">>config.php

php includes/update/update.php

mkdir graphs logs
chown www-data:www-data graphs
chmod -R 777 graphs

mkdir /opt/observium-rrd
chown www-data:www-data /opt/observium-rrd
chmod -R 777 /opt/observium-rrd

rm /etc/apache2/sites-available/default
cp /opt/misc/apache /etc/apache2/sites-available/default
a2enmod rewrite
apache2ctl restart

./adduser.php admin admin 10

cp /opt/misc/cron /etc/cron.d/observium
echo "mibdirs /opt/observium/mibs">/etc/snmp/snmp.conf
