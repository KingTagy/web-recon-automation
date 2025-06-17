# 🔍 Recon Automation Script

A powerful Bash script that automates web reconnaissance for bug bounty and penetration testing targets.

## ✨ Features

- Subdomain discovery using `assetfinder`
- HTTP probing with `httpx` (status code, title, tech stack, CDN)
- Directory and file parameter fuzzing with `ffuf`
- CSP header analysis via `curl`
- Reflected XSS testing (manual & with Dalfox)
- Focuses on high-value subdomains (like `api`, `ads`, `cpa`, `support`)

## 📦 Requirements

- `assetfinder`
- `httpx`
- `ffuf`
- `curl`
- `jq`
- *(Optional)* `dalfox` (for advanced XSS detection)
- Wordlist (edit path in script if needed):  
  `/home/tigz/SecLists/Discovery/Web-Content/combined_directories.txt`

## 🚀 Usage

```bash
chmod +x recon.sh
./recon.sh shein.co.uk
```

## 📂 Output

All results are saved in:

```
~/report/<domain>/
```

Includes:
- `subdomains.txt`
- `live_subdomains.txt`
- `focus_subdomains.txt`
- `csp_headers.txt`
- `ffuf_<target>_dirs.json`
- `ffuf_<target>_fileparam.json`
- `xss_hits.txt` (if reflected XSS is detected)

## 📄 License

MIT License
