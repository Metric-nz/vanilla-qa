#--- Prometheus Server ---#
# Get package archive for Prometheus
wget -q "https://github.com/prometheus/prometheus/releases/download/0.15.1/prometheus-0.15.1.linux-amd64.tar.gz" -P /prometheus
# Create installation directory
mkdir -p /usr/local/prometheus/server
# Extract archive
tar -xf /prometheus/prometheus-0.15.1.linux-amd64.tar.gz -C /usr/local/prometheus/server
# Copy configuration file into installation directory
cp /prometheus/prometheus.yml /usr/local/prometheus/server/
# Set path
echo 'export PATH=$PATH:/usr/local/prometheus/server' >> /home/vagrant/.profile
