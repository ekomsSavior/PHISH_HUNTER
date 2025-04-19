#!/bin/bash

# === Phish Hunter FINAL FINAL VICTORY EDITION 💀 ===
# by: ek0ms savi0r
# Now with fixed variable flow. DNS, prepare to be humbled.

GREEN='\033[1;92m'
RED='\033[1;91m'
CYAN='\033[1;96m'
NC='\033[0m'

echo -e "${CYAN}🌸 Welcome to Phish Hunter 🌸 Let's stop the scammers!${NC}"
read -p "Enter the phishing domain (e.g. tucker2015.com or www.tucker2015.com): " INPUT_DOMAIN

# Strip www. if present
STRIPPED_DOMAIN=$(echo "$INPUT_DOMAIN" | sed 's/^www\.//')

# Init DOMAIN properly (this is the real fix)
DOMAIN="$STRIPPED_DOMAIN"

echo -e "\n${CYAN}✨ Checking DNS resolution for $DOMAIN...${NC}"
RESOLVED_IP=$(dig +short "$DOMAIN" | head -n1)

if [ -z "$RESOLVED_IP" ]; then
  echo -e "${RED}❌ No IP found for $DOMAIN. Trying www.$STRIPPED_DOMAIN...${NC}"
  DOMAIN="www.$STRIPPED_DOMAIN"
  RESOLVED_IP=$(dig +short "$DOMAIN" | head -n1)
fi

if [ -z "$RESOLVED_IP" ]; then
  echo -e "${GREEN}🌈 Domain appears to be offline or unregistered. MISSION ACCOMPLISHED 💅${NC}"
  echo -e "${CYAN}✅ You can still report it to takedown services below.${NC}"
  echo -e "\n${CYAN}🔗 Report here:${NC}"
  echo "• Google: https://safebrowsing.google.com/safebrowsing/report_phish/"
  echo "• ICANN: https://www.icann.org/compliance/complaint"
  exit 0
fi

echo -e "${GREEN}✅ Domain resolves to: $RESOLVED_IP${NC}"

CLEAN_DOMAIN=$(echo "$DOMAIN" | tr '.' '_')

echo -e "\n${CYAN}🔍 WHOIS lookup...${NC}"
whois "$DOMAIN" | tee "recon_whois_$CLEAN_DOMAIN.txt"

echo -e "\n${CYAN}📡 HTTP Headers...${NC}"
curl -I "http://$DOMAIN" --max-time 5 | tee "recon_headers_$CLEAN_DOMAIN.txt"

echo -e "\n${CYAN}🕵️‍♀️ Fingerprinting with WhatWeb...${NC}"
whatweb "http://$DOMAIN" | tee "recon_whatweb_$CLEAN_DOMAIN.txt"

echo -e "\n${CYAN}🌍 IP Ownership...${NC}"
whois "$RESOLVED_IP" | tee "recon_ipwhois_$CLEAN_DOMAIN.txt"

echo -e "\n${CYAN}🧪 Passive Recon Links:${NC}"
echo -e "${GREEN}🔗 VirusTotal: https://www.virustotal.com/gui/domain/$DOMAIN${NC}"
echo -e "${GREEN}🔗 URLScan.io: https://urlscan.io/domain/$DOMAIN${NC}"

echo -e "\n${CYAN}📬 Abuse Contacts (from WHOIS):${NC}"
grep -Ei 'abuse|contact|email' "recon_whois_$CLEAN_DOMAIN.txt" | sort -u

echo -e "\n${CYAN}🛡️ Final Steps:${NC}"
echo "1. Report at Google Safe Browsing"
echo "2. Email abuse contacts with recon files"
echo "3. File complaint via ICANN if needed"

echo -e "\n${GREEN}🎉 Recon saved to recon_*_$CLEAN_DOMAIN.txt — go off, defender supreme 🛡️💖${NC}"
