#!/bin/bash

# === Recon Automation Script ===
# Author: mohamed eltagy
# Usage: ./recon.sh <domain>

if [ $# -ne 1 ]; then
    echo "Usage: $0 <domain>"
    exit 1
fi

DOMAIN="$1"
WORDLIST="$HOME/SecLists/Discovery/Web-Content/combined_directories.txt"
OUTPUT_DIR="$HOME/report/${DOMAIN}"
USER_AGENT="Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/115.0 Safari/537.36"
XSS_PAYLOAD='"><script>alert(1337)</script>'

# === Tool Check ===
for tool in assetfinder httpx ffuf curl; do
    if ! command -v $tool &>/dev/null; then
        echo "[!] Required tool '$tool' not found. Install it first."
        exit 1
    fi
done

mkdir -p "$OUTPUT_DIR"

echo "[*] Enumerating subdomains for $DOMAIN..."
assetfinder --subs-only "$DOMAIN" > "$OUTPUT_DIR/subdomains.txt"

echo "[*] Probing subdomains for live hosts..."
httpx -silent -status-code -title -tech-detect -ip -cdn -server \
  -H "User-Agent: $USER_AGENT" < "$OUTPUT_DIR/subdomains.txt" | grep -v '\[404\]' > "$OUTPUT_DIR/live_subdomains.txt"

echo "[*] Filtering important subdomains (api, ads, cpa, support)..."
grep -Ei 'api|ads|cpa|support' "$OUTPUT_DIR/live_subdomains.txt" > "$OUTPUT_DIR/focus_subdomains.txt"

echo "[*] Checking CSP headers..."
> "$OUTPUT_DIR/csp_headers.txt"
while read -r line; do
    url=$(echo "$line" | awk '{print $1}')
    echo -n "$url - " >> "$OUTPUT_DIR/csp_headers.txt"
    curl -sk -I -H "User-Agent: $USER_AGENT" "$url" | grep -i "content-security-policy" >> "$OUTPUT_DIR/csp_headers.txt"
done < "$OUTPUT_DIR/focus_subdomains.txt"

echo "[*] Directory fuzzing + XSS testing on focus subdomains..."
while read -r line; do
    url=$(echo "$line" | awk '{print $1}')
    clean_url=$(echo "$url" | sed 's|https\?://||; s|[/?&=]|_|g')

    echo "[*] Fuzzing $url ..."

    ffuf -w "$WORDLIST" -u "${url}/FUZZ" -t 30 \
      -H "User-Agent: $USER_AGENT" \
      -H "Accept: text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8" \
      -o "$OUTPUT_DIR/ffuf_${clean_url}_dirs.json" -of json \
      -mc 200,301,302,403,401 -fc 404

    ffuf -w "$WORDLIST" -u "${url}/page.php?file=FUZZ" -t 30 \
      -H "User-Agent: $USER_AGENT" \
      -H "Accept: text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8" \
      -o "$OUTPUT_DIR/ffuf_${clean_url}_fileparam.json" -of json \
      -mc 200,301,302,403,401 -fc 404

    echo "[*] XSS test: $url/?q=... "
    response=$(curl -sk "$url/?q=$(printf "%s" "$XSS_PAYLOAD" | jq -sRr @uri)" -H "User-Agent: $USER_AGENT")
    if echo "$response" | grep -q "$XSS_PAYLOAD"; then
        echo "[!] Reflected XSS detected on $url?q=" | tee -a "$OUTPUT_DIR/xss_hits.txt"
    fi

    if command -v dalfox &>/dev/null; then
        echo "[*] Running dalfox on $url ..."
        dalfox url "$url?q=test" --user-agent "$USER_AGENT" --output "$OUTPUT_DIR/dalfox_${clean_url}.txt"
    fi
done < "$OUTPUT_DIR/focus_subdomains.txt"

echo "[*] Done. Results saved in $OUTPUT_DIR/"
