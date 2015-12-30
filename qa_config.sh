apt-get -qqy update

apt-get -qqy install apache2

debconf-set-selections <<< 'mysql-server mysql-server/root_password password SuperSecretPasswordString'
debconf-set-selections <<< 'mysql-server mysql-server/root_password_again password SuperSecretPasswordString'
apt-get -qqy install mysql-server

apt-get -qqy install php5-mysql
