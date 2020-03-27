#!/usr/bin/env bash

THANOS_VERSION="0.11.0"

useradd --no-create-home --shell /bin/false prometheus
mkdir -p /var/lib/thanos/data/{store,sidecar,query,receive,compact,rules} /var/lib/thanos/config
wget https://github.com/thanos-io/thanos/releases/download/v${THANOS_VERSION}/thanos-${THANOS_VERSION}.linux-amd64.tar.gz
tar -xf thanos-${THANOS_VERSION}.linux-amd64.tar.gz
mv thanos-${THANOS_VERSION}.linux-amd64/thanos /usr/local/bin/thanos
chown prometheus:prometheus /usr/local/bin/thanos
chown -R prometheus:prometheus /var/lib/thanos
