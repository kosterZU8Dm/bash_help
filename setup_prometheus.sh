#!/bin/bash
prometheus_url=https://github.com/prometheus/prometheus/releases/download/v2.45.3/prometheus-2.45.3.linux-amd64.tar.gz
prometheus_arch=$(basename "$prometheus_url")
workdir=prom_dir
mkdir $workdir
cd $workdir || exit
pwd
wget $prometheus_url
echo "---Download is done---"
tar -xvzf $prometheus_arch
rm $prometheus_arch
echo "---Archive is removed---"
prom_dir_name=$(ls -d */ | head -n 1)
cd $prom_dir_name || exit
pwd
mkdir /etc/prometheus /var/lib/prometheus
mv prometheus promtool /usr/local/bin/
mv prometheus.yml /etc/prometheus/prometheus.ymlb