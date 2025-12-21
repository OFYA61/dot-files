#!/bin/bash

# --- CONFIGURATION AREA ---
# Add new apps here: "domain:port"
APP_LIST=(
  "search.local:8888"
  "ai.local:3000"
)
# --------------------------

CADDYFILE_PATH="/etc/caddy/Caddyfile"

echo "--- Starting Extensible Local Proxy Setup ---"

# 1. Install Dependencies
echo "Ensuring Caddy and NSS are installed..."
sudo pacman -S --needed --noconfirm caddy nss

# 2. Clear/Initialize Caddyfile
# We start fresh so we don't append duplicates
sudo bash -c "echo '# Auto-generated Caddyfile' > $CADDYFILE_PATH"

# 3. Loop through the APPS array
for ITEM in "${APP_LIST[@]}"; do
  DOMAIN="${ITEM%%:*}"
  PORT="${ITEM##*:}"

  echo "Processing $DOMAIN -> localhost:$PORT"

  # Update /etc/hosts if domain isn't there
  if ! grep -q "$DOMAIN" /etc/hosts; then
    echo "Adding $DOMAIN to /etc/hosts..."
    echo "127.0.0.1  $DOMAIN" | sudo tee -a /etc/hosts
  fi

  # Append to Caddyfile
  sudo bash -c "cat >> $CADDYFILE_PATH" <<EOF

  $DOMAIN {
    reverse_proxy localhost:$PORT
    tls internal
  }
EOF
done

# 4. Restart Caddy to apply changes
echo "Restarting Caddy..."
sudo systemctl enable --now caddy
sudo systemctl restart caddy

# 5. Ensure the Local CA is trusted
echo "Ensuring system trusts Caddy's local certificates..."
sudo caddy trust

echo "--- All apps are configured! ---"
for ITEM in "${APP_LIST[@]}"; do
  DOMAIN="${ITEM%%:*}"
  echo " -> https://$DOMAIN"
done
