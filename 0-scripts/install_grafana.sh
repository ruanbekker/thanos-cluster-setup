#!/usr/bin/env bash

GRAFANA_VERSION="6.7.1"

sudo apt install adduser libfontconfig1 -y
wget https://dl.grafana.com/oss/release/grafana_${GRAFANA_VERSION}_amd64.deb
sudo dpkg -i grafana_${GRAFANA_VERSION}_amd64.deb
rm -rf grafana_${GRAFANA_VERSION}_amd64.deb

systemctl daemon-reload
systemctl enable grafana-server
systemctl start grafana-server

grafana-cli plugins list-remote
grafana-cli plugins install grafana-piechart-panel
grafana-cli plugins install grafana-clock-panel
grafana-cli plugins install farski-blendstat-panel
grafana-cli plugins install digiapulssi-breadcrumb-panel
grafana-cli plugins install briangann-gauge-panel
grafana-cli plugins install digrich-bubblechart-panel
grafana-cli plugins install agenty-flowcharting-panel
grafana-cli plugins install mtanda-histogram-panel
grafana-cli plugins install michaeldmoore-multistat-panel
grafana-cli plugins install vonage-status-panel
grafana-cli plugins install flant-statusmap-panel
grafana-cli plugins install smartmakers-trafficlight-panel
service grafana-server restart
