#!/bin/bash

# --- 1. Install System Dependencies ---
echo "Pulling searxng latest docker image"
docker pull docker.io/searxng/searxng:latest

echo "Creating directories for configuration and persistent data"
mkdir -p ~/.searxng/config ~/.searxng/data

echo "Starting up docker container"
docker run --name searxng -d -p 8888:8080 -v "${HOME}/.searxng/config/:/etc/searxng/" -v "${HOME}/.searxng/data/:/var/cache/searxng/" docker.io/searxng/searxng:latest

# --- 7. Create Open WebUI Systemd Service ---
echo "Creating Open WebUI Systemd Service..."
cat <<EOF | sudo tee /etc/systemd/system/docker-searxng.service
[Unit]
Description=SearXNG Docker Container
Requires=docker.service
After=docker.service

[Service]
Restart=always
ExecStart=/usr/bin/docker start -a searxng
ExecStop=/usr/bin/docker stop -t 2 searxng

[Install]
WantedBy=multi-user.target
EOF

# Reload services
sudo systemctl daemon-reload
sudo systemctl enable --now docker-searxng.service

echo "-------------------------------------------------------"
echo "SETUP COMPLETE!"
echo "1. IMPORTANT: Log out and log back in for group changes."
echo "2. SearXNG: http://localhost:8888"
echo "-------------------------------------------------------"
