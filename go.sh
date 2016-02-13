# Pull Go package
curl -sO https://storage.googleapis.com/golang/go1.5.3.linux-amd64.tar.gz
# Unpack package
tar -xf go1.5.3.linux-amd64.tar.gz
# Move installation
mv go /usr/local
# Set Go path
echo 'export PATH=$PATH:/usr/local/go/bin' >> ~/.profile
