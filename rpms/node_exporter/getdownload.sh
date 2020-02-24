#!/bin/sh

export VER=0.18.1
export EXPORTER=node_exporter

wget https://github.com/prometheus/${EXPORTER}/releases/download/v${VER}/${EXPORTER}-${VER}.linux-amd64.tar.gz

tar xvf ${EXPORTER}-${VER}.linux-amd64.tar.gz

rm  ${EXPORTER}-${VER}.linux-amd64.tar.gz


