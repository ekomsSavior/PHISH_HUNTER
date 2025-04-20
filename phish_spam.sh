#!/bin/bash
# phish_spam.sh
# by ekomsSavior

TARGET_URL="http://74.98.47.117/"                  #edit ip

while true; do
  USER="user$(openssl rand -hex 3)"
  PASS="pass$(openssl rand -hex 3)"
  
  RESPONSE=$(curl -s -o /dev/null -w "%{http_code}" -X POST "$TARGET_URL" \
    -d "username=$USER&password=$PASS" \
    -H "Content-Type: application/x-www-form-urlencoded")

  echo "[+] Sent fake login -> $USER:$PASS | HTTP $RESPONSE"
  sleep 0.2
done
