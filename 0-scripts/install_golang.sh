#!/bin/sh

apt update
apt install curl -y
export GOLANG_VERSION="1.14"
curl -SLsf https://dl.google.com/go/go${GOLANG_VERSION}.linux-amd64.tar.gz > go.tgz
rm -rf /usr/local/go
mkdir -p /usr/local/go
tar -xvf go.tgz -C /usr/local/go/ --strip-components=1
echo 'export GOPATH=$HOME/go/' > /etc/profile.d/golang.sh
echo 'export PATH=$PATH:/usr/local/go/bin/' >> /etc/profile.d/golang.sh


