#!/usr/bin/env bash

LOKI_VERSION="1.3.0"

wget https://github.com/grafana/loki/releases/download/v${LOKI_VERSION}/loki-linux-amd64.zip
apt install unzip -y
unzip loki-linux-amd64.zip
mv loki-linux-amd64 /usr/local/bin/loki
chmod +x /usr/local/bin/loki
mkdir /etc/loki
mkdir /var/lib/loki
