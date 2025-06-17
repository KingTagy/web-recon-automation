# 🕵️‍♂️ web-recon-automation

Automated web reconnaissance script for bug bounty and penetration testing.  
Includes subdomain discovery, HTTP probing, directory fuzzing, CSP/XSS checks, and optional Dalfox support.

---

## 💼 Ideal for
- 🎯 Bug bounty hunters  
- 🔐 Penetration testers  
- 🛡️ Red teamers  

---

## 🚀 Usage

### ✅ 1. Prerequisites

Make sure you have the following tools installed:

- [`assetfinder`](https://github.com/tomnomnom/assetfinder)
- [`httpx`](https://github.com/projectdiscovery/httpx)
- [`ffuf`](https://github.com/ffuf/ffuf)
- [`jq`](https://stedolan.github.io/jq/) (for URL encoding)
- `curl`
- *(Optional)* [`dalfox`](https://github.com/hahwul/dalfox) for advanced XSS scanning

Install them with:

```bash
go install github.com/tomnomnom/assetfinder@latest
go install github.com/projectdiscovery/httpx/cmd/httpx@latest
go install github.com/ffuf/ffuf@latest
go install github.com/hahwul/dalfox/v2@latest
sudo apt install jq curl -y
```
2. Download & Setup:
```bash

git clone https://github.com/KingTagy/web-recon-automation.git
cd web-recon-automation
chmod +x recon.sh
```
3. Run the Script
```bash

./recon.sh <Target.com>
