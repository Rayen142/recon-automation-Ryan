#!/bin/bash

# --- Definisi Variabel Warna untuk Tampilan Terminal ---
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# --- Definisi Variabel Path File (Sesuai Struktur Assignment) ---
DOMAIN_FILE="input/domains.txt"
SUBDOMAIN_FILE="input/all-subdomains.txt" # File master untuk deduplikasi global
LIVE_FILE="output/live.txt"
LOG_FILE="logs/progress.log"
ERROR_LOG="logs/errors.log"

# --- Fungsi Logging (Wajib dengan Timestamp) ---
# Fungsi ini mencetak log ke terminal dan mencatatnya ke progress.log
log() {
    echo "[$(date +'%Y-%m-%d %H:%M:%S')] $1" | tee -a "$LOG_FILE"
}

# --- Mulai Script ---
log "--- Sesi Recon Otomatis Dimulai ---"
echo -e "${BLUE}Memulai proses recon... Log lengkap ada di $LOG_FILE${NC}"

# Membaca setiap domain dari file input
while read -r domain || [[ -n "$domain" ]]; do
    
    if [ -z "$domain" ]; then
        continue # Lewati baris kosong
    fi

    log "Memproses domain: $domain"
    echo -e "\n${YELLOW}[*] Menjalankan Subfinder untuk: $domain${NC}"

    # --- INTI PIPELINE (Integrasi subfinder | anew | httpx) ---
    # 1. subfinder: Mencari subdomain.
    # 2. anew: Menyimpan yang baru ke $SUBDOMAIN_FILE dan hanya meneruskan yang BARU.
    # 3. httpx: Memeriksa host yang hidup, mengambil kode status dan judul.
    # 4. tee -a "$LIVE_FILE": Menyimpan output host hidup ke output/live.txt.
    # 5. 2>> $ERROR_LOG: Mengalihkan semua pesan error (stderr) ke logs/errors.log.
    
    subfinder -d "$domain" -silent 2>> "$ERROR_LOG" | \
        anew "$SUBDOMAIN_FILE" 2>> "$ERROR_LOG" | \
        httpx -silent -status-code -title 2>> "$ERROR_LOG" | \
        tee -a "$LIVE_FILE"

    log "Selesai memproses: $domain"

done < "$DOMAIN_FILE"

log "--- Sesi Recon Selesai ---"
UNIQUE_SUBS=$(wc -l < "$SUBDOMAIN_FILE")
LIVE_HOSTS=$(wc -l < "$LIVE_FILE")

log "Total subdomain unik ditemukan: $UNIQUE_SUBS"
log "Total host hidup ditemukan: $LIVE_HOSTS"

echo -e "\n${GREEN}--- Proses Selesai ---${NC}"
echo -e "Total Subdomain Unik: ${YELLOW}$UNIQUE_SUBS${NC}"
echo -e "Total Host Hidup: ${YELLOW}$LIVE_HOSTS${NC} (di $LIVE_FILE)"
echo -e "Error (jika ada) tercatat di ${YELLOW}$ERROR_LOG${NC}"
