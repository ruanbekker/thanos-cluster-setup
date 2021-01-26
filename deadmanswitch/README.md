## Setup for DeadManSwitch with Cole

Credit:
- https://jpweber.io/blog/taking-advantage-of-deadmans-switch-in-prometheus/

Register for a new timer id:

```
$ curl https://deadmanswitch.localdns.xyz/id
{"timerid":"btq5ook02neh18pmuu4g"}
```

Your alertmanager config:

```
$ cat alertmanager.yml
global:
  resolve_timeout: 5m

route:
  group_by: ['alertname', 'environment', 'severity', 'job']
  group_wait: 45s
  group_interval: 10m
  repeat_interval: 1h
  receiver: 'default-catchall-slack'
  routes:
  - match:
      alertname: DeadManSwitch
    receiver: critical-deadmanswitch-alert
    group_wait: 0s
    group_interval: 1m
    repeat_interval: 50s

receivers:
- name: 'critical-deadmanswitch-alert'
  webhook_configs:
    - url: 'https://deadmanswitch.localdns.xyz/ping/btq5ook02neh18pmuu4g'
      send_resolved: false
```

```
cat rules/deadmanswitch.rules
groups:
- name: deadmanswitch.rules
  rules:

  # allows us to trigger an alert when our Prometheus cluster is no longer functioning correctly.
  # https://jpweber.io/blog/taking-advantage-of-deadmans-switch-in-prometheus/
  - alert: DeadManSwitch
    expr: vector(1)
    labels:
      severity: warning
      team: devops
    annotations:
      title: "DeadManSwitch"
      summary: Alerting DeadManSwitch
      description: This is a DeadManSwitch meant to ensure that the entire Alerting pipeline is functional.
      impact: Alerting is down
      action: Follow runbook and determine why prometheus isnt working
      dashboard: https://monitoring.localdns.xyz/d/WojOgXTmk/prometheus-alertmanager?orgId=1&refresh=5s
      runbook: https://runbooks.localdns.xyz/books/pages/runbook-a
```

Include rules in prometheus:

```
$ cat prometheus.yml
cat /etc/prometheus/prometheus.yml
rule_files:
  - '/etc/prometheus/rules/deadmanswitch.rules'
```

If using ECS:

```
$ cat taskdef.json
{
  "family": "deadmanswitch",
  "executionRoleArn":"arn:aws:iam::000000000000:role/ecs-exec-role",
  "taskRoleArn":"arn:aws:iam::000000000000:role/ecs-task-role",
  "containerDefinitions": [
    {
      "name": "deadmanswitch",
      "image": "ruanbekker/cole-deadmanswitch:0.2.0",
      "memoryReservation": 64,
      "portMappings":[
        {
          "protocol":"tcp",
          "containerPort":8080,
          "hostPort":0
        }
      ],
      "environment": [
        {
          "name": "SENDER_TYPE",
          "value": "slack"
        },
        {
          "name": "SLACK_CHANNEL",
          "value": "#system-events"
        },
        {
          "name": "SLACK_ICON",
          "value": ":fire:"
        },
        {
          "name": "SLACK_USERNAME",
          "value": "DeadManSwitch Monitor"
        },
        {
          "name": "INTERVAL",
          "value": "300"
        }
      ],
      "secrets": [
        {
          "valueFrom": "arn:aws:ssm:eu-west-1:000000000000:parameter/deadmanswitch/prod/SLACK_WEBHOOK_URL",
          "name": "HTTP_ENDPOINT"
        }
      ],
      "essential": true,
      "privileged": true
    }
  ]
}
```

with interval=60

```
time="2020-09-30T11:36:44Z" level=info msg="Starting application..."
time="2020-09-30T11:36:44Z" level=info msg="Using ENV Vars for configuration"
time="2020-09-30T11:37:04Z" level=info msg="timerID: btq5ook02neh18pmuu4g"
time="2020-09-30T11:37:04Z" level=info msg="POST - /ping/btq5ook02neh18pmuu4g"
time="2020-09-30T11:38:04Z" level=info msg="Sending Alert. Missed deadman switch notification."
time="2020-09-30T11:38:04Z" level=info msg="slack method"
time="2020-09-30T11:38:05Z" level=info msg=ok
time="2020-09-30T11:38:36Z" level=info msg="timerID: btq5ook02neh18pmuu4g"
time="2020-09-30T11:38:36Z" level=info msg="POST - /ping/btq5ook02neh18pmuu4g"
time="2020-09-30T11:39:36Z" level=info msg="timerID: btq5ook02neh18pmuu4g"
time="2020-09-30T11:39:36Z" level=info msg="POST - /ping/btq5ook02neh18pmuu4g"
time="2020-09-30T11:40:36Z" level=info msg="Sending Alert. Missed deadman switch notification."
time="2020-09-30T11:40:36Z" level=info msg="slack method"
time="2020-09-30T11:40:36Z" level=info msg=ok
```

Logs:

```
[ec2-user@ip-172-31-49-227 ~]$ docker logs -f 12218a0c9039
time="2020-09-30T11:40:11Z" level=info msg="Starting application..."
time="2020-09-30T11:40:11Z" level=info msg="Using ENV Vars for configuration"
time="2020-09-30T11:40:36Z" level=info msg="timerID: btq5ook02neh18pmuu4g"
time="2020-09-30T11:40:36Z" level=info msg="POST - /ping/btq5ook02neh18pmuu4g"
time="2020-09-30T11:41:36Z" level=info msg="timerID: btq5ook02neh18pmuu4g"
time="2020-09-30T11:41:36Z" level=info msg="POST - /ping/btq5ook02neh18pmuu4g"
time="2020-09-30T11:42:36Z" level=info msg="timerID: btq5ook02neh18pmuu4g"
time="2020-09-30T11:42:36Z" level=info msg="POST - /ping/btq5ook02neh18pmuu4g"
time="2020-09-30T11:43:36Z" level=info msg="timerID: btq5ook02neh18pmuu4g"
time="2020-09-30T11:43:36Z" level=info msg="POST - /ping/btq5ook02neh18pmuu4g"
```
