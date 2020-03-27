#!/usr/bin/env bash

PROMETHEUS_VERSION="2.16.0"

useradd --no-create-home --shell /bin/false prometheus
mkdir /etc/prometheus /var/lib/prometheus
chown -R prometheus:prometheus /etc/prometheus /var/lib/prometheus

wget https://github.com/prometheus/prometheus/releases/download/v${PROMETHEUS_VERSION}/prometheus-${PROMETHEUS_VERSION}.linux-amd64.tar.gz
tar -xf prometheus-${PROMETHEUS_VERSION}.linux-amd64.tar.gz
cp prometheus-${PROMETHEUS_VERSION}.linux-amd64/prometheus /usr/local/bin/
cp prometheus-${PROMETHEUS_VERSION}.linux-amd64/promtool /usr/local/bin/
chown prometheus:prometheus /usr/local/bin/prometheus /usr/local/bin/promtool

cp -r prometheus-${PROMETHEUS_VERSION}.linux-amd64/consoles /etc/prometheus/
cp -r prometheus-${PROMETHEUS_VERSION}.linux-amd64/console_libraries /etc/prometheus/

chown -R prometheus:prometheus /etc/prometheus/consoles /etc/prometheus/console_libraries
rm -rf prometheus-${PROMETHEUS_VERSION}.linux-amd64*
