# thanos-cluster-setup

Multi-Node Thanos Cluster Setup

- Work in Progress.. see [wiki](https://github.com/ruanbekker/thanos-cluster-setup/wiki/Install)

## Components

Components used in my Thanos Setup:

```
- prometheus
- thanos-sidecar
- thanos-store-gw
- thanos-compactor
- thanos-receive
- thanos-query
- alertmanager
- grafana
```

## Infrastructure:

Nodes hosted in Amsterdam:

- prometheus-ams-0
- prometheus-ams-1
- thanos-store-gw
- thanos-query
- thanos-compactor
- thanos-retrieve
- alertmanager

Nodes hosted in Frankfurt

- prometheus-fra-0
- prometheus-fra-1

Nodes with their respective components:

```
node: [prometheus-ams-0]:
  - prometheus
  - thanos-sidecar

node: [prometheus-ams-1]:
  - prometheus
  - thanos-sidecar

node: [prometheus-fra-0]:
  - prometheus
  - thanos-sidecar

node: [prometheus-fra-1]:
  - prometheus
  - thanos-sidecar

node: [thanos-querier]:
  - thanos-query
  - grafana

node: [thanos-compactor]:
  - thanos-compact

node: [thanos-store-gw]:
  - thanos-store

node: [thanos-receive]:
  - thanos-receive

node: [alertmanager]:
  - alertmanager
```
