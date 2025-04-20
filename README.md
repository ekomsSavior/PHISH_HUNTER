PHISH_HUNTER

by ek0ms savi0r x0x

Phish Hunter is a two-script combo for ethically tracking and disrupting phishing sites.

One script hunts. One script spams. 

---------------------------

REQUIREMENTS

Run this on Kali or any Debian-based system.

Install tools

sudo apt update

sudo apt install whois whatweb curl tor -y

Start Tor

sudo systemctl enable tor

sudo systemctl start tor

---------------------------

USAGE

1. DOMAIN RECON

nano phish_hunter.sh

# Paste in the script from GitHub

CTRL+X → Y → ENTER

chmod +x phish_hunter.sh

./phish_hunter.sh

You’ll be prompted to enter a phishing domain like

tracker2051.com

Phish Hunter will

- Resolve the IP

- Run WHOIS

- Grab HTTP headers

- Fingerprint the server with WhatWeb

- Lookup IP ownership

- Provide abuse contacts

- Save everything to: phish_report_<domain>.txt

Use this to investigate who you’re dealing with.

---------------------------

2. SPAM THE LOGIN PAGE

nano phish_spammer_v3.sh

# Paste in the script from GitHub

CTRL+X → Y → ENTER

chmod +x phish_spammer_v3.sh

Then run it

./phish_spammer_v3.sh "https://examplephish.site"          

This will

- Send fake logins to common phishing paths (/verify, /login.php, etc)

- Rotate through them continuously

- Route everything through Tor SOCKS5

- Randomize delays to simulate human behavior

- Refresh Tor circuits every 3 minutes

CTRL+C to stop at any time

---------------------------

WHAT TO DO IF THE SITE REDIRECTS

Phish sites love redirecting you to a new domain.

Run this

curl -L -I http://taker2051.com

Look for the “Location:” header. That’s your new target.

Now run the spammer on that new domain.

---------------------------

DISCLAIMER

Use Phish Hunter only for

Ethical hacking with permission

Educational and on networks you have permission to test on.


