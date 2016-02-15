#--- Prometheus Server ---#
# Get package archive for Prometheus
wget -q "https://github.com/prometheus/prometheus/releases/download/0.15.1/prometheus-0.15.1.linux-amd64.tar.gz" -P /prometheus
# Create installation directory
mkdir -p /usr/local/prometheus/server
# Extract archive and remove
tar -xf /prometheus/prometheus-0.15.1.linux-amd64.tar.gz -C /usr/local/prometheus/server
rm /prometheus/prometheus-0.15.1.linux-amd64.tar.gz
# Set path
echo 'export PATH=$PATH:/usr/local/prometheus/server' >> /home/vagrant/.profile

#--- Node Exporter ---#
# Pull down Node Exporter archive
wget -q "https://github.com/prometheus/node_exporter/releases/download/0.11.0/node_exporter-0.11.0.linux-amd64.tar.gz" -P /prometheus
# Create installation directory
mkdir /usr/local/prometheus/node_exporter
# Extract archive and remove
tar -xf /prometheus/node_exporter-0.11.0.linux-amd64.tar.gz -C /usr/local/prometheus/node_exporter
rm /prometheus/node_exporter-0.11.0.linux-amd64.tar.gz
