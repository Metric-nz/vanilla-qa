#--- Global Variables ---#
SERVERNAME='snackula'
MYSQL_ROOT_PW='snackulamysqlpassword'
BACULA_DB_PW='secretbaculapassword'

apt-get -qqy update

#--- MySQL ---#
# Use Debconf for unattended MySQL installation
debconf-set-selections <<< "mysql-server mysql-server/root_password password $MYSQL_ROOT_PW"
debconf-set-selections <<< "mysql-server mysql-server/root_password_again password $MYSQL_ROOT_PW"
# Install MySQL Server
apt-get -qqy install mysql-server

#--- Bacula ---#
# Debconf selections for Bacula installation
debconf-set-selections <<< "postfix postfix/mailname string $SERVERNAME.example.com"
debconf-set-selections <<< "postfix postfix/main_mailer_type select Internet Site"
debconf-set-selections <<< "bacula-director-mysql bacula-director-mysql/dbconfig-install boolean true"
debconf-set-selections <<< "bacula-director-mysql bacula-director-mysql/mysql/admin-pass password $MYSQL_ROOT_PW"
debconf-set-selections <<< "bacula-director-mysql bacula-director-mysql/mysql/app-pass password $BACULA_DB_PW"
debconf-set-selections <<< "bacula-director-mysql bacula-director-mysql/app-password-confirm password $BACULA_DB_PW"
# Install Bacula Server
apt-get -qqy install bacula-server
# Install Bacula Client
apt-get -qqy install bacula-client
# Adjust permissions of script used during catalog backup
chmod 755 /etc/bacula/scripts/delete_catalog_backup
