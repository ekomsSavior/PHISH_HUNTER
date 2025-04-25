# PHISH HUNTER  
_by ek0ms savi0r_

Phish Hunter is a two-part toolkit for ethical hackers and defenders.  
One script investigates phishing sites. The other spams fake logins to waste attacker time.

---

## INSTALLATION

Clone the repository from GitHub:
```bash
git clone https://github.com/ekomsSavior/PHISH_HUNTER
cd PHISH_HUNTER
```

Install required tools

```bash
sudo apt update
sudo apt install whois whatweb curl tor -y
```

Start and enable Tor

```bash
sudo systemctl enable tor
sudo systemctl start tor
```

---

## 1. DOMAIN RECON (`phish_hunter.sh`)

This script investigates a phishing domain by:
- Resolving the IP address
- Performing a WHOIS lookup
- Fetching HTTP headers
- Fingerprinting the server with WhatWeb
- Identifying IP ownership
- Locating abuse contact info

**Usage:**

```bash
chmod +x phish_hunter.sh
./phish_hunter.sh
```

You will be prompted to enter a domain like
```
tracker2051.com
```

The tool will create a report
```
phish_report_tracker2051.com.txt
```

---

## 2. SPAMMER (`phish_spammer_v3.sh`)

This script sends fake login attempts to phishing pages. It

- Targets common phishing paths such as `/login`, `/verify`, etc.
- Routes traffic through Tor
- Randomizes delays to simulate human typing
- Rotates Tor circuits every few minutes

**Usage:**

```bash
chmod +x phish_spammer_v3.sh
./phish_spammer_v3.sh "https://examplephish.site"
```

Press CTRL+C to stop at any time.

---

## OPTIONAL: Proxy List Support

You can use a custom list of SOCKS5 proxies for extra anonymity.

1. Create a file named `proxy_list.txt` in the same directory  
2. Add one proxy per line, for example:
```
socks5://127.0.0.1:9050  
socks5://proxy1.example.net:1080  
socks5://192.168.1.100:1080
```
3. Run the spammer with the proxy list:
```bash
./phish_spammer_v3.sh https://examplephish.site proxy_list.txt
```

If no proxy list is provided, the tool defaults to Tor via `127.0.0.1:9050`.

---

## WHAT TO DO IF THE SITE REDIRECTS

Phishing pages often redirect to a secondary domain.

Run

```bash
curl -L -I http://originalsite.com
```

Look for a `Location:` header — that is your real target.  

Use that final URL when running the spammer.

---

## DISCLAIMER

Use Phish Hunter only for

- Ethical hacking with permission  
- Educational purposes  
- Systems and networks you own or are authorized to test

Unauthorized use of these tools may violate the law. Be responsible and ethical.


