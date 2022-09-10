sudo systemctl stop mysql
sudo apt-get purge -y mysql-server mysql-client mysql-common mysql-server-core-* mysql-client-core-*
sudo rm -rf /etc/mysql /var/lib/mysql
sudo apt autoremove
sudo apt autoclean

sudo apt-get remove --purge mysql-server mysql-client mysql-common -y
$ sudo apt-get autoremove -y
$ sudo apt-get autoclean
$ sudo rm -rf /etc/mysql
# Delete all MySQL files on your server:
$ sudo find / -iname 'mysql*' -exec rm -rf {} \;

#For Demo purpose
#mysql -u [username] -p [password] << EOF
#[Mysql Command]
#EOF