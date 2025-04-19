#!/bin/bash

# === Phish Hunter Recon Script ===
# By ekoms savior 

read -p "Enter the phishing URL (no http): " PHISH_DOMAIN

echo "==== Resolving Domain ===="
dig $PHISH_DOMAIN +short

echo -e "\n==== Whois Info ===="
whois $PHISH_DOMAIN | tee whois_$PHISH_DOMAIN.txt

echo -e "\n==== Checking HTTP Headers ===="
curl -I http://$PHISH_DOMAIN

echo -e "\n==== Fingerprinting Website ===="
whatweb http://$PHISH_DOMAIN | tee whatweb_$PHISH_DOMAIN.txt

echo -e "\n==== Looking Up IP Ownership ===="
IP=$(dig +short $PHISH_DOMAIN | tail -n1)
if [ ! -z "$IP" ]; then
    echo "IP: $IP"
    whois $IP | tee ipwhois_$PHISH_DOMAIN.txt
fi

echo -e "\n==== Submitting to VirusTotal ===="
echo "Visit: https://www.virustotal.com/gui/domain/$PHISH_DOMAIN"

echo -e "\n==== Submitting to URLScan ===="
echo "Visit: https://urlscan.io/ and paste: http://$PHISH_DOMAIN"

echo -e "\n==== Recommended Takedown Targets ===="
grep -Ei 'abuse|contact|email' whois_$PHISH_DOMAIN.txt | sort -u

echo -e "\n==== Next Steps ===="
echo "1. Report at Google Safe Browsing: https://safebrowsing.google.com/safebrowsing/report_phish/"
echo "2. Email abuse contact found above with all files generated."
echo "3. Optionally submit report to ICANN: https://www.icann.org/compliance/complaint"

echo -e "\nDONE. Files saved as whois_$PHISH_DOMAIN.txt and whatweb_$PHISH_DOMAIN.txt"
