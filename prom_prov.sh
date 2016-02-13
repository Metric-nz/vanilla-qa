apt-get -qqy install docker.io

docker run -d --name prometheus -p 9090:9090 -v /prometheus/prometheus.yml:/etc/prometheus/prometheus.yml prom/prometheus -config.file=/etc/prometheus/prometheus.yml -storage.local.path=/prometheus -storage.local.memory-chunks=10000

docker run -d --name node_exporter -p 9100:9100 -v "/proc:/host/proc" -v "/sys:/host/sys" -v "/:/rootfs" --net="host" prom/node-exporter -collector.procfs /host/proc -collector.sysfs /host/proc -collector.filesystem.ignored-mount-points "^/(sys|proc|dev|host|etc)($|/)"

docker run -d --name grafana -p 3000:3000 -e "GF_SECURITY_ADMIN_PASSWORD=admin" -v ~/grafana_db:/var/lib/grafana grafana/grafana
