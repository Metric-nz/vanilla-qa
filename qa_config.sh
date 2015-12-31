apt-get -qqy update

# Install Apache
apt-get -qqy install apache2

# Use Debconf for unattended MySQL installation
debconf-set-selections <<< 'mysql-server mysql-server/root_password password SuperSecretPasswordString'
debconf-set-selections <<< 'mysql-server mysql-server/root_password_again password SuperSecretPasswordString'
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
debconf-set-selections <<< 'phpmyadmin phpmyadmin/reconfigure-webserver multiselect apache2'
debconf-set-selections <<< 'phpmyadmin phpmyadmin/dbconfig-install boolean true'
debconf-set-selections <<< 'phpmyadmin phpmyadmin/mysql/admin-pass password SuperSecretPasswordString'
debconf-set-selections <<< 'phpmyadmin phpmyadmin/mysql/app-pass password vanilla'
debconf-set-selections <<< 'phpmyadmin phpmyadmin/app-password-confirm password vanilla'
# Install phpMyAdmin and Apache utilities
apt-get -qqy install phpmyadmin apache2-utils
# Add phpMyAdmin to Apache configuration
echo 'Include /etc/phpmyadmin/apache.conf' >> /etc/apache2/apache2.conf

service apache2 restart
