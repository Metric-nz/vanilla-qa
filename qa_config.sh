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
