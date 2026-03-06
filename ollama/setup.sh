#!/bin/bash

# 1. Create the systemd directory if it doesn't exist
mkdir -p ~/.config/systemd/user/

# 2. Write the service file
cat <<EOF > ~/.config/systemd/user/ollama.service
[Unit]
Description=Ollama Service
After=network.target

[Service]
ExecStart=$(which ollama) serve
Restart=always
RestartSec=3

[Install]
WantedBy=default.target
EOF

# 3. Reload systemd to recognize the new service
systemctl --user daemon-reload

# 4. Enable and start the service
systemctl --user enable ollama.service
systemctl --user start ollama.service

echo "Ollama service has been configured and started at the user level."

# Ensure Ollama is running before trying to create models
# (This assumes you've set up the systemd service from the previous step)
if ! systemctl --user is-active --quiet ollama; then
    echo "Starting Ollama service..."
    systemctl --user start ollama
    sleep 2 # Give it a moment to initialize
fi

echo "Pulling base model qwen3.5:9b..."
ollama pull qwen3.5:9b

echo "Creating 'zig-coder' submodel..."
# This command builds the model named 'zig-coder' using the 'Zigfile'
ollama create qwen3.5-9b-zig -f ./qwen3.5:9b:zig

echo "------------------------------------------------"
echo "Setup complete! You can now run your model with:"
echo "ollama run zig-coder"
