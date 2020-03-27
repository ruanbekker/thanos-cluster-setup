#!/usr/bin/env bash

PROMTAIL_VERSION="1.3.0"

apt install unzip -y
wget https://github.com/grafana/loki/releases/download/v${PROMTAIL_VERSION}/promtail-linux-amd64.zip
unzip promtail-linux-amd64.zip
mv promtail-linux-amd64 /usr/local/bin/promtail

mkdir -p /var/lib/promtail /etc/promtail

cat > /etc/systemd/system/promtail.service << EOF
[Unit]
Description=Promtail
After=network.target

[Service]
Type=simple
ExecStart=/usr/local/bin/promtail -config.file /etc/promtail/promtail-config.yml

[Install]
WantedBy=multi-user.target
EOF

cat > /etc/promtail/promtail-config.yml << EOF
server:
  http_listen_port: 9080
  grpc_listen_port: 0

positions:
  filename: /var/lib/promtail/positions.yaml

clients:
  - url: http://grafana.loki.domain.local:3100/loki/api/v1/push

scrape_configs:
  - job_name: journal
    journal:
      max_age: 12h
      path: /var/log/journal
      labels:
        job: systemd-journal
        env: production
        host: $HOSTNAME
    relabel_configs:
      - source_labels: ['__journal__systemd_unit']
        target_label: 'unit'
EOF

systemctl daemon-reload
systemctl start promtail
systemctl enable promtail
