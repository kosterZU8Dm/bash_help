#!/bin/bash
node_exporter_url=https://github.com/prometheus/node_exporter/releases/download/v1.7.0/node_exporter-1.7.0.linux-amd64.tar.gz
node_exporter_arch=$(basename "$node_exporter_url")
workdir=NE_dir
mkdir $workdir
cd $workdir || exit
wget $node_exporter_url
echo "---Download is Done---"
tar -xvzf $node_exporter_arch
rm $node_exporter_arch
echo "---Archive is Removed---"
NE_dir_name=$(ls -d */ | head -n 1)
cd $NE_dir_name
mv node_exporter /usr/local/bin
useradd -rs /bin/false node_exporter
touch /etc/systemd/system/node_exporter.service
cat <<EOF > /etc/systemd/system/node_exporter.service
[Unit]
Description=Node Exporter
Wants=network-online.target
After=network-online.target

[Service]
User=node_exporter
Group=node_exporter
Type=simple
Restart=on-failure
RestartSec=5s
ExecStart=/usr/local/bin/node_exporter

[Install]
WantedBy=multi-user.target
EOF
systemctl daemon-reload
systemctl enable node_exporter
systemctl start node_exporter
service_status=$(systemctl status node_exporter | grep Active | awk '{print $2}')
if [ "$service_status" == "active" ]; then
    echo "Service is Work"
else
    echo "Service doesn't Work"
    exit 1
fi
cd ../../ && rm -r $workdir