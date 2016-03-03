#--- Global Variables ---#
$MYSQL_ROOT_PW='baculamysqlpassword'

apt-get -qqy update

#--- MySQL ---#
# Use Debconf for unattended MySQL installation
debconf-set-selections <<< "mysql-server mysql-server/root_password password $MYSQL_ROOT_PW"
debconf-set-selections <<< "mysql-server mysql-server/root_password_again password $MYSQL_ROOT_PW"
# Install MySQL Server
apt-get -qqy install mysql-server

#--- Bacula ---#
# Debconf selections for Bacula installation

# Install Bacula Server
apt-get -qqy install bacula-server
# Install Bacula Client
apt-get -qqy install bacula-client
