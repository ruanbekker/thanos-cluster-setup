#!/bin/sh

if [ -z ${SLACK_WEBHOOK_URL} ] || [ -z ${ALERTMANAGER_URL} ] || [ -z ${DEVOPS_OPSGENIE_API_KEY} ] ;
  then
    echo "[ERROR] required devops environment variables does not exist"
    exit 1
fi

if [ -z ${SLACK_WEBHOOK_URL} ] || [ -z ${ALERTMANAGER_URL} ] || [ -z ${TECHOPS_OPSGENIE_API_KEY} ] ;
  then
    echo "[ERROR] required techops environment variables does not exist"
    exit 1
fi

echo "all environment variables are in place, replacing values in config"

sed -i "s|__SLACK_WEBHOOK_URL__|${SLACK_WEBHOOK_URL}|g" /etc/alertmanager/alertmanager.yml
sed -i "s|__ALERTMANAGER_URL__|${ALERTMANAGER_URL}|g" /etc/alertmanager/alertmanager.yml
sed -i "s|__DEVOPS_OPSGENIE_API_KEY__|${DEVOPS_OPSGENIE_API_KEY}|g" /etc/alertmanager/alertmanager.yml
sed -i "s|__TECHOPS_OPSGENIE_API_KEY__|${TECHOPS_OPSGENIE_API_KEY}|g" /etc/alertmanager/alertmanager.yml
sed -i "s|__ALERTA_API_KEY__|${ALERTA_API_KEY}|g" /etc/alertmanager/alertmanager.yml

echo "config updated, starting service"

/bin/alertmanager \
  --config.file="/etc/alertmanager/alertmanager.yml" \
  --storage.path="/alertmanager" \
  --web.external-url="${ALERTMANAGER_URL}" \
  --web.listen-address=":9093"
