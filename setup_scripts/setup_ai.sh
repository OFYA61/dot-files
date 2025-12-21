#!/bin/bash

# --- 1. Install System Dependencies ---
echo "Installing Docker, NVIDIA Toolkit, and UFW..."
yay -S --needed docker nvidia-container-toolkit ufw lazydocker curl

# --- 2. Install Ollama via Official Script ---
echo "Downloading and installing Ollama..."
curl -fsSL https://ollama.com/install.sh | sh

# --- 3. Configure Docker Daemon ---
echo "Configuring Docker..."
sudo systemctl enable --now docker
sudo usermod -aG docker $USER
docker context use default

# --- 4. Configure NVIDIA Container Runtime (For Docker) ---
echo "Setting up NVIDIA Container Runtime..."
sudo nvidia-ctk runtime configure --runtime=docker
sudo systemctl restart docker

# --- 5. Firewall Configuration ---
echo "Configuring UFW for Docker Bridge..."
sudo systemctl enable --now ufw
sudo ufw allow in on docker0
sudo ufw reload

# --- 6. Apply Network Overrides to Ollama ---
echo "Configuring Ollama for Network Access..."
# The official script creates /etc/systemd/system/ollama.service
# We create an override directory so updates don't wipe our changes
sudo mkdir -p /etc/systemd/system/ollama.service.d/
cat <<EOF | sudo tee /etc/systemd/system/ollama.service.d/override.conf
[Service]
Environment="OLLAMA_HOST=0.0.0.0:11434"
EOF

sudo systemctl daemon-reload
sudo systemctl restart ollama

# Wait for Ollama to be ready
echo "Waiting for Ollama to initialize..."
until curl -s localhost:11434 > /dev/null; do
  sleep 2
done

# --- 7. Create Open WebUI Systemd Service ---
echo "Creating Open WebUI Systemd Service..."
cat <<EOF | sudo tee /etc/systemd/system/docker-open-webui.service
[Unit]
Description=Open WebUI Docker Container
Requires=docker.service
After=docker.service

[Service]
Restart=always
ExecStart=/usr/bin/docker start -a open-webui
ExecStop=/usr/bin/docker stop -t 2 open-webui

[Install]
WantedBy=multi-user.target
EOF

# --- 8. Finalize ---
sudo systemctl daemon-reload
sudo systemctl enable --now docker-open-webui.service

echo "-------------------------------------------------------"
echo "SETUP COMPLETE!"
echo "1. IMPORTANT: Log out and log back in for group changes."
echo "2. Open WebUI: http://localhost:3000"
echo "3. Ollama is running as a system service."
echo "-------------------------------------------------------"
