#!/bin/bash

# === Phish Hunter ULTRA MERGED — FINAL FORM  ===
# by ek0ms savi0r 🫂
# One beautiful .txt report, live screen updates, full control 

GREEN='\033[1;92m'
RED='\033[1;91m'
CYAN='\033[1;96m'
NC='\033[0m'

echo -e "${CYAN}🌸 Welcome to Phish Hunter 🌸 Let's stop the scammers!${NC}"
read -p "Enter the phishing domain (e.g. tucker2015.com or www.tesla.com): " INPUT_DOMAIN

# Normalize domain
STRIPPED_DOMAIN=$(echo "$INPUT_DOMAIN" | sed 's/^www\.//')
DOMAIN="$STRIPPED_DOMAIN"
CLEAN_DOMAIN=$(echo "$DOMAIN" | tr '.' '_')
REPORT_FILE="phish_report_$CLEAN_DOMAIN.txt"

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

# Start unified report file
echo "🌸 PHISH HUNTER REPORT — $DOMAIN 🌸" > "$REPORT_FILE"
echo "Generated on $(date)" >> "$REPORT_FILE"
echo "Resolved IP: $RESOLVED_IP" >> "$REPORT_FILE"
echo "----------------------------------------" >> "$REPORT_FILE"

# WHOIS domain
echo -e "\n${CYAN}🔍 WHOIS lookup for domain...${NC}"
echo -e "\n🔍 WHOIS for $DOMAIN:\n" >> "$REPORT_FILE"
whois "$DOMAIN" | tee -a "$REPORT_FILE"

# HTTP headers
echo -e "\n${CYAN}📡 Checking HTTP Headers...${NC}"
echo -e "\n📡 HTTP Headers:\n" >> "$REPORT_FILE"
curl -I "http://$DOMAIN" --max-time 5 | tee -a "$REPORT_FILE"

# WhatWeb fingerprint
echo -e "\n${CYAN}🕵️‍♀️ Fingerprinting site with WhatWeb...${NC}"
echo -e "\n🕵️‍♀️ WhatWeb Fingerprinting:\n" >> "$REPORT_FILE"
whatweb "http://$DOMAIN" | tee -a "$REPORT_FILE"

# WHOIS for IP
echo -e "\n${CYAN}🌍 WHOIS lookup for resolved IP...${NC}"
echo -e "\n🌍 WHOIS for $RESOLVED_IP:\n" >> "$REPORT_FILE"
whois "$RESOLVED_IP" | tee -a "$REPORT_FILE"

# Recon links
echo -e "\n${CYAN}🧪 Adding passive recon links...${NC}"
echo -e "\n🧪 Passive Recon Links:" >> "$REPORT_FILE"
echo "→ VirusTotal: https://www.virustotal.com/gui/domain/$DOMAIN" | tee -a "$REPORT_FILE"
echo "→ URLScan:    https://urlscan.io/domain/$DOMAIN" | tee -a "$REPORT_FILE"

# Abuse contacts
echo -e "\n${CYAN}📬 Searching WHOIS output for abuse contacts...${NC}"
echo -e "\n📬 Abuse Emails from WHOIS:\n" >> "$REPORT_FILE"
grep -Ei 'abuse|contact|email' "$REPORT_FILE" | sort -u | tee -a "$REPORT_FILE"

# Final advice
echo -e "\n${CYAN}🛡️ Recommended Next Steps:${NC}"
echo -e "\n🛡️ Final Steps:\n" >> "$REPORT_FILE"
echo "1. Report to Google Safe Browsing" | tee -a "$REPORT_FILE"
echo "2. Email abuse contacts with this report attached" | tee -a "$REPORT_FILE"
echo "3. File complaint via ICANN if needed" | tee -a "$REPORT_FILE"

# Done!
echo -e "\n${GREEN}🎉 Report saved as $REPORT_FILE — go off, defender supreme! 🛡️💖${NC}"
