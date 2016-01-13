#--- Global Variables ---#
SERVERNAME='VanillaQA'
MYSQL_ROOT_PW='secretpassword'
PHPMYADMIN_PW='secretphppw'
VANLLA_USER_PW='secretapppassword'
DB_BACKUP_NAME='localhost.sql'
MOTD='VanillaQA at your service...'

apt-get -qqy update

#--- Apache ---#
# Install Apache
apt-get -qqy install apache2
# Set ServerName
echo -e "\nServerName \"${SERVERNAME}\"" >> /etc/apache2/apache2.conf
# Enable mod_rewrite for more readable URL's
a2enmod rewrite

#--- MySQL ---#
# Use Debconf for unattended MySQL installation
debconf-set-selections <<< "mysql-server mysql-server/root_password password $MYSQL_ROOT_PW"
debconf-set-selections <<< "mysql-server mysql-server/root_password_again password $MYSQL_ROOT_PW"
# Install MySQL Server
apt-get -qqy install mysql-server
# Install module for MySQL connections directly from PHP scripts
apt-get -qqy install php5-mysql

#--- PHP ---#
# Install PHP5
apt-get -qqy install php5
# Install PHP5 module for Apache
apt-get -qqy install libapache2-mod-php5
# Install Mcrypt for PHP
apt-get -qqy install php5-mcrypt
php5enmod mcrypt
# Install cURL
apt-get -qqy install php5-curl

#--- phpMyAdmin ---#
# Use Debconf for unattended phpMyAdmin installation
debconf-set-selections <<< "phpmyadmin phpmyadmin/reconfigure-webserver multiselect apache2"
debconf-set-selections <<< "phpmyadmin phpmyadmin/dbconfig-install boolean true"
debconf-set-selections <<< "phpmyadmin phpmyadmin/mysql/admin-pass password $MYSQL_ROOT_PW"
debconf-set-selections <<< "phpmyadmin phpmyadmin/mysql/app-pass password $PHPMYADMIN_PW"
debconf-set-selections <<< "phpmyadmin phpmyadmin/app-password-confirm password $PHPMYADMIN_PW"
# Install phpMyAdmin and Apache utilities
apt-get -qqy install phpmyadmin apache2-utils

#--- Git ---#
apt-get -qqy install git

#--- Composer ---#
curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer # Install globally as `composer`

#--- Vanilla Forum ---#
git clone https://github.com/vanilla/vanilla.git /vanillaforum # Clones Vanilla repository into `/vanillaforum`
composer install -d /vanillaforum # Use Composer to build Vanilla repository
chmod -R 777 /vanillaforum/conf /vanillaforum/cache /vanillaforum/uploads # Grants necessary permissions
cp /vanilla/apache.conf /etc/apache2/sites-available/000-default.conf # Update DocumentRoot and <Directory >
# Load the MySQL backup if applicable, otherwise create a new database
if [ -f /vanilla/$DB_BACKUP_NAME ];
then
    mysql -uroot -p$MYSQL_ROOT_PW < /vanilla/$DB_BACKUP_NAME
else
    mysql -uroot -p$MYSQL_ROOT_PW -e "CREATE DATABASE IF NOT EXISTS vanilla_db;"
fi

# Restart Apache
service apache2 restart

# Set Message of the Day
echo -e "\033[36m\033[1m$MOTD\033[m" > /etc/motd

# Disable Root SSH
sed -i 's/permitrootlogin.*/PermitRootLogin no/gI' /etc/ssh/sshd_config
service ssh restart
