#!/usr/bin/env bash

component=${1}

if [ ${component} == "store" ]
then

  bash install_thanos.sh
  cp ../thanos-store-gw/thanos_store.service /etc/systemd/system/thanos_store.service
  cp ../thanos-store-gw/bucket.yml /var/lib/thanos/config/bucket.yml
  chown -R prometheus:prometheus /var/lib/thanos
  systemctl daemon-reload 
  systemctl enable thanos_store
  systemctl restart thanos_store

fi
