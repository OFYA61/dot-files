#!/bin/bash

# 1. Detect the lms binary path
LMS_PATH=$(which lms)

if [ -z "$LMS_PATH" ]; then
    echo "Error: 'lms' command not found."
    exit 1
fi

# 2. Define the system-wide service file path
SERVICE_FILE="/etc/systemd/system/lmstudio.service"

# 3. Create the service file (Requires sudo)
sudo bash -c "cat <<EOF > $SERVICE_FILE
[Unit]
Description=LM Studio Local Server
After=network.target

[Service]
Type=simple
User=$USER
Group=$(id -gn)
WorkingDirectory=$HOME
ExecStart=$LMS_PATH server start --port 9999
Restart=on-failure
RestartSec=5

[Install]
WantedBy=multi-user.target
EOF"

echo "Service file created at $SERVICE_FILE"

# 4. Reload, enable, and start
sudo systemctl daemon-reload
sudo systemctl enable lmstudio.service
sudo systemctl restart lmstudio.service

echo "------------------------------------------------"
echo "System-wide setup complete!"
echo "Check status with: systemctl status lmstudio"
