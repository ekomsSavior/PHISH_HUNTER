#!/bin/bash

# === PHISH SPAMMER V3  by ek0ms savi0r ===

if [ -z "$1" ]; then
    echo "Usage: $0 <base_url> (e.g. https://phishingsite.com)"
    exit 1
fi

BASE_URL="$1"
INTERVAL_MINUTES=3   # Rotate Tor circuit every X minutes
LAST_ROTATE=$(date +%s)

# User agents to rotate through
USER_AGENTS=(
    "Mozilla/5.0 (Windows NT 10.0; Win64; x64)"
    "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7)"
    "Mozilla/5.0 (X11; Linux x86_64)"
    "Mozilla/5.0 (iPhone; CPU iPhone OS 16_0 like Mac OS X)"
    "Mozilla/5.0 (iPad; CPU OS 15_2 like Mac OS X)"
)

# Common phishing login paths
TARGET_PATHS=("/verify" "/login.php" "/signin" "/login" "/auth")

# Function to simulate fake logins
send_fake_login() {
    local url="$1"
    local email="j$(openssl rand -hex 3)smith$(shuf -i 1975-2002 -n1)@gmail.com"
    local pass="pass$(openssl rand -hex 3)"
    local ua="${USER_AGENTS[$RANDOM % ${#USER_AGENTS[@]}]}"
    
    local response=$(curl -sL \
        --socks5 127.0.0.1:9050 \
        -o /dev/null \
        -w "%{http_code}" \
        -A "$ua" \
        -d "username=$email&password=$pass" \
        "$url")

    echo "[+] Sent fake login -> $email : $pass | HTTP $response"
}

# Function to refresh Tor circuit
refresh_tor() {
    echo "[*] Refreshing Tor identity 🌐"
    pkill -HUP tor 2>/dev/null
}

echo -e "🌸 Starting Phish Spammer v3 — ethical & fabulous 💅"
echo "🌐 Base URL: $BASE_URL"
echo "🔁 Targeting: ${TARGET_PATHS[*]}"
echo "🧅 Routing through Tor SOCKS5 proxy"
echo "⏰ Refreshing Tor circuit every $INTERVAL_MINUTES minutes"
echo

# Infinite loop until interrupted
while true; do
    for path in "${TARGET_PATHS[@]}"; do
        full_url="${BASE_URL}${path}"

        # Send fake login
        send_fake_login "$full_url"

        # Random sleep to simulate human typing
        sleep $((RANDOM % 3 + 1)).$((RANDOM % 10))

        # Check if it's time to refresh Tor
        now=$(date +%s)
        elapsed=$(( (now - LAST_ROTATE) / 60 ))
        if [ "$elapsed" -ge "$INTERVAL_MINUTES" ]; then
            refresh_tor
            LAST_ROTATE=$now
        fi
    done
done
