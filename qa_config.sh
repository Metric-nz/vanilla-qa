#--- Global Variables ---#
SERVERNAME='VanillaQA'
MYSQL_ROOT_PW='secretpassword'
PHPMYADMIN_PW='secretphppw'
VANILLA_USER_PW='secretapppassword'
DB_BACKUP_NAME='localhost.sql'
DB_NAME='vanilla_test'
MOTD='VanillaQA at your service...'

apt-get -qqy update

#--- UFW ---#
ufw default deny incoming # Deny all incoming connections on all ports
ufw default allow outgoing # Allow all outgoing connections on all ports
ufw allow ssh # Allow connections on default SSH port (22)
ufw allow http # Allow connections on default HTTP port (80)
ufw allow https # Allow connections on default HTTPS port (443)
ufw --force enable # Enable Uncomplicated Firewall

#--- Apache ---#
# Install Apache and Apache utilities
apt-get -qqy install apache2 apache2-utils
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
# Install phpMyAdmin
apt-get -qqy install phpmyadmin

#--- Git ---#
apt-get -qqy install git

#--- Composer ---#
curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer # Install globally as `composer`

#--- Vanilla Forum ---#
git clone https://github.com/vanilla/vanilla.git /vanillaforum # Clones Vanilla repository into `/vanillaforum`
composer install -d /vanillaforum # Use Composer to build Vanilla repository
chmod -R 777 /vanillaforum/conf /vanillaforum/cache /vanillaforum/uploads # Grants necessary permissions
cp /vanilla/apache.conf /etc/apache2/sites-available/vanilla_forum.conf # Copy VirtualHost conf
a2ensite vanilla_forum.conf # Enable `vanilla_forum` site
rm /etc/apache2/sites-available/000-default.conf /etc/apache2/sites-enabled/000-default.conf # Remove default configuration and symlink
# Load the MySQL backup if applicable, otherwise create a new database
mysql -uroot -p$MYSQL_ROOT_PW -e "CREATE DATABASE IF NOT EXISTS $DB_NAME;" # Create a database for testing
mysql -uroot -p$MYSQL_ROOT_PW -e "CREATE USER 'vanilla_user'@'localhost' IDENTIFIED BY '$VANILLA_USER_PW';
                                  GRANT ALL PRIVILEGES ON $DB_NAME.* TO 'vanilla_user'@'localhost';
                                  FLUSH PRIVILEGES;"
if [ -f /vanilla/$DB_BACKUP_NAME ]; # If the specified backup exists in /vanilla/
then
    mysql -uroot -p$MYSQL_ROOT_PW $DB_NAME < /vanilla/$DB_BACKUP_NAME # Load SQL backup into specified database ($DB_NAME)
else
    echo "No database backup found..." # Temporary message
fi

# Restart Apache
service apache2 restart

# Set Message of the Day
echo -e "\033[36m\033[1m$MOTD\033[m" > /etc/motd

# Disable Root SSH
sed -i 's/permitrootlogin.*/PermitRootLogin no/gI' /etc/ssh/sshd_config
service ssh restart
