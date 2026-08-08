#!/bin/bash

# 1. Create the systemd directory if it doesn't exist
mkdir -p ~/.config/systemd/user/

# 2. Write the service file
cat <<EOF > ~/.config/systemd/user/ollama.service
[Unit]
Description=Ollama Service
After=network.target

[Service]
Environment="OLLAMA_CONTEXT_LENGTH=64000"
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

echo "Pulling base models"
ollama pull sorc/qwen3.5-claude-4.6-opus-q4:9b
ollama pull gemma4:12b
ollama pull gemma4:e4b

echo "Creating 'zig-coder' submodels..."
ollama create gemma4:12-32k -f ./gemma4:12-32k
ollama create gemma4:e4b-32k -f ./gemma4:e4b-32k
ollama create qwen3.5-claude-4.6-opus-q4:9b-32k -f./qwen3.5-claude-4.6-opus-q4:9b-32k

echo "------------------------------------------------"
echo "Setup complete! You can now run your model with:"
echo "ollama run zig-coder"
