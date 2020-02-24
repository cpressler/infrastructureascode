#!/bin/sh

export VER=0.11.1

wget https://github.com/prometheus/mysqld_exporter/releases/download/v${VER}/mysqld_exporter-${VER}.linux-amd64.tar.gz

tar xvf mysqld_exporter-${VER}.linux-amd64.tar.gz


