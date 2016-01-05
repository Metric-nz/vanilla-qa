SERVERNAME='VanillaQA'
MYSQL_ROOT_PW='secretpassword'
PHPMYADMIN_PW='secretphppw'

apt-get -qqy update

# Install Apache
apt-get -qqy install apache2
# Set ServerName
echo -e "\nServerName \"${SERVERNAME}\"" >> /etc/apache2/apache2.conf

# Use Debconf for unattended MySQL installation
debconf-set-selections <<< "mysql-server mysql-server/root_password password $MYSQL_ROOT_PW"
debconf-set-selections <<< "mysql-server mysql-server/root_password_again password $MYSQL_ROOT_PW"
# Install MySQL Server
apt-get -qqy install mysql-server
# Install module for MySQL connections directly from PHP scripts
apt-get -qqy install php5-mysql

# Install PHP5
apt-get -qqy install php5
# Install PHP5 module for Apache
apt-get -qqy install libapache2-mod-php5
# Install Mcrypt for PHP
apt-get -qqy install php5-mcrypt
php5enmod mcrypt

# Use Debconf for unattended phpMyAdmin installation
debconf-set-selections <<< "phpmyadmin phpmyadmin/reconfigure-webserver multiselect apache2"
debconf-set-selections <<< "phpmyadmin phpmyadmin/dbconfig-install boolean true"
debconf-set-selections <<< "phpmyadmin phpmyadmin/mysql/admin-pass password $MYSQL_ROOT_PW"
debconf-set-selections <<< "phpmyadmin phpmyadmin/mysql/app-pass password $PHPMYADMIN_PW"
debconf-set-selections <<< "phpmyadmin phpmyadmin/app-password-confirm password $PHPMYADMIN_PW"
# Install phpMyAdmin and Apache utilities
apt-get -qqy install phpmyadmin apache2-utils

# Restart Apache
service apache2 restart

MOTD="\033[36m\033[1mVanillaQA At Your Service...\033[m"
echo -e $MOTD > /etc/motd

# Disable Root SSH
sed -i 's/permitrootlogin.*/PermitRootLogin no/gI' /etc/ssh/sshd_config
service ssh restart
