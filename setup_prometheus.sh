#!/bin/bash
prometheus_url=https://github.com/prometheus/prometheus/releases/download/v2.45.3/prometheus-2.45.3.linux-amd64.tar.gz
prometheus_arch=$(basename "$prometheus_url")
workdir=prom_dir
mkdir $workdir
cd $workdir || exit
wget $prometheus_url
echo "---Download is Done---"
tar -xvzf $prometheus_arch
rm $prometheus_arch
echo "---Archive is Removed---"
prom_dir_name=$(ls -d */ | head -n 1)
cd $prom_dir_name
mkdir /etc/prometheus /var/lib/prometheus
mv prometheus promtool /usr/local/bin/
mv prometheus.yml /etc/prometheus/prometheus.yml
mv consoles/ console_libraries/ /etc/prometheus/
echo "---Check Prometheus Version---"
prometheus --version
echo "---Start proccess of Prometheus service creation---"
useradd -rs /bin/false prometheus
chown -R prometheus: /etc/prometheus /var/lib/prometheus
touch /etc/systemd/system/prometheus.service
cat <<EOF > /etc/systemd/system/prometheus.service
[Unit]
Description=Prometheus
Wants=network-online.target
After=network-online.target

[Service]
User=prometheus
Group=prometheus
Type=simple
Restart=on-failure
RestartSec=5s
ExecStart=/usr/local/bin/prometheus \
    --config.file /etc/prometheus/prometheus.yml \
    --storage.tsdb.path /var/lib/prometheus/ \
    --web.console.templates=/etc/prometheus/consoles \
    --web.console.libraries=/etc/prometheus/console_libraries \
    --web.listen-address=0.0.0.0:9090 \
    --web.enable-lifecycle \
    --log.level=info

[Install]
WantedBy=multi-user.target
EOF
systemctl daemon-reload
systemctl enable prometheus
systemctl start prometheus
service_status=$(systemctl status prometheus | grep Active | awk '{print $2}')
if [ "$service_status" == "active" ]; then
    echo "Service is Work"
else
    echo "Service doesn't Work"
    exit 1
fi
cd .. && rm -r $workdir