#!/usr/bin/env bash

PUSHGATEWAY_VERSION="1.2.0"
# useradd --no-create-home --shell /bin/false prometheus
wget https://github.com/prometheus/pushgateway/releases/download/v${PUSHGATEWAY_VERSION}/pushgateway-${PUSHGATEWAY_VERSION}.linux-amd64.tar.gz
tar -xf pushgateway-${PUSHGATEWAY_VERSION}.linux-amd64.tar.gz
cd pushgateway-${PUSHGATEWAY_VERSION}.linux-amd64/
mv pushgateway /usr/local/bin/
#mkdir var/pushgateway
#chown -R prometheus:prometheus /var/pushgateway
systemctl daemon-reload
systemctl restart pushgateway
# test
# echo "cpu_utilization 20.25" | curl --data-binary @- http://localhost:9091/metrics/job/my_custom_metrics/instance/10.20.0.1:9000/provider/hetzner
