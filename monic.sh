    #!/bin/bash
    # This script will install Node Exporter with systemd
    sudo wget "https://github.com/prometheus/node_exporter/releases/download/v1.0.1/node_exporter-1.0.1.linux-armv7.tar.gz"
    sudo tar xvf node_exporter-1.0.1.linux-amd64.tar.gz -C /opt/
    sudo mv /opt/node_exporter-1.0.1.linux-amd64 /opt/node-exporter
    cat << EOF >node_exporter.service
    [Unit]
    Description=Node Exporter

    [Service]
    User=root
    ExecStart=/opt/node-exporter/node_exporter

    [Install]
    WantedBy=default.target
    EOF
    sudo mv node_exporter.service /etc/systemd/system/
    sudo systemctl daemon-reload
    sudo systemctl enable node_exporter.service
    sudo systemctl start node_exporter.service
    sudo systemctl status node_exporter.service
    sudo rm -rf node_exporter-1.0.1.linux-amd64.tar.gz
    sudo rm -f node-exporter.sh