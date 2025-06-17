# web-recon-automation
Automated web reconnaissance script for bug bounty and penetration testing. Includes subdomain discovery, HTTP probing, directory fuzzing, CSP/XSS checks, and optional Dalfox support.

Ideal for:
- 🎯 Bug bounty hunters
- 🔐 Penetration testers
- 🛡️ Red teamers

🚀 Usage
✅ 1. Prerequisites
Make sure you have the following tools installed:
assetfinder
httpx
ffuf
jq (for URL encoding)
curl
(Optional) dalfox for advanced XSS scanning


go install github.com/tomnomnom/assetfinder@latest
go install github.com/projectdiscovery/httpx/cmd/httpx@latest
go install github.com/ffuf/ffuf@latest
go install github.com/hahwul/dalfox/v2@latest
sudo apt install jq curl -y


 2. Download & Setup
Clone the repo or download the

git clone https://github.com/yourusername/web-recon-automation.git
cd web-recon-automation
chmod +x recon.sh



3. Run the Script
./recon.sh <Target url>
