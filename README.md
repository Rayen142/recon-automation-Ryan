# 🛠️ Recon Automation Tool: Bash Scripting

**Nama Repository:** recon-automation-Ryan
**Nama Script:** `recon-auto.sh`

## Deskripsi Proyek

Proyek ini adalah implementasi dari **Assignment Build Your Own Recon Automation Tool** yang bertujuan untuk mengotomatisasi alur kerja *subdomain enumeration* dan validasi host yang hidup (*live hosts*) menggunakan Bash Scripting.

Script `recon-auto.sh` dirancang untuk berjalan *end-to-end* tanpa *error*, mengintegrasikan minimal 3 *tools* (`subfinder`, `anew`, dan `httpx`)  
dalam satu *pipeline*, mengelola *input/output* file, melakukan *deduplikasi*, dan mencatat *logging* yang informatif[cite: 15]. Seluruh hasil pengerjaan diunggah ke *repository* GitHub publik ini.

## Struktur Direktori

Struktur folder ini wajib ada untuk memastikan skrip berjalan dengan benar.
recon-automation-Ryan/ ├── input/ │ ├── domains.txt │ └── all-subdomains.txt ├── output/ │ └── live.txt ├── scripts/ │ └── recon-auto.sh └── logs/ ├── progress.log └── errors.log
| File/Folder | Deskripsi |
| :--- | :--- |
| `input/domains.txt` | [cite_start]Daftar minimal 5 domain target untuk *scanning*[cite: 45]. |
| `input/all-subdomains.txt` | [cite_start]File master yang mencatat semua subdomain unik yang ditemukan (untuk deduplikasi menggunakan `anew`)[cite: 35, 50]. |
| `output/live.txt` | [cite_start]Hasil akhir: daftar host hidup yang berhasil diakses[cite: 38, 46]. |
| `scripts/recon-auto.sh` | [cite_start]Script utama Bash yang menjalankan seluruh proses (Wajib *executable*)[cite: 40, 47]. |
| `logs/progress.log` | [cite_start]Log kemajuan skrip yang dilengkapi dengan *timestamp*[cite: 42, 52]. |
| `logs/errors.log` | [cite_start]Log untuk mencatat semua *Standard Error* (stderr) dari *tools*[cite: 43, 53]. |

## Cara Setup Environment

Berikut adalah langkah-langkah yang diperlukan untuk menyiapkan lingkungan dan menginstal *tools* yang digunakan oleh skrip ini:

1.  **Instalasi GoLang:**
    ```bash
    sudo apt update && sudo apt install golang -y
    ```
2.  **Konfigurasi PATH untuk Go:**
    ```bash
    echo 'export PATH=$PATH:$(go env GOPATH)/bin' >> ~/.zshrc # atau ~/.bashrc
    source ~/.zshrc
    ```
3.  **Instalasi Tools Project Discovery (`subfinder`, `httpx`):**
    ```bash
    go install -v [github.com/projectdiscovery/subfinder/v2/cmd/subfinder@latest](https://github.com/projectdiscovery/subfinder/v2/cmd/subfinder@latest)
    go install -v [github.com/projectdiscovery/httpx/cmd/httpx@latest](https://github.com/projectdiscovery/httpx/cmd/httpx@latest)
    ```
4.  **Instalasi Tool Deduplikasi (`anew`):**
    ```bash
    go install -v [github.com/tomnomnom/anew@latest](https://github.com/tomnomnom/anew@latest)
    ```

    ## Cara Menjalankan Script

1.  **Kloning Repository:**
    ```bash
    git clone [https://github.com/Rayen142/recon-automation-Rayen.git](https://github.com/Rayen142/recon-automation-Rayen.git)
    cd recon-automation-Rayen
    ```
2.  [cite_start]**Isi Input:** Pastikan file `input/domains.txt` berisi minimal 5 domain[cite: 45].
3.  **Jalankan Skrip:**
    ```bash
    ./scripts/recon-auto.sh
    ```

## Penjelasan Singkat Kode (`recon-auto.sh`)

| Baris Kode | Tujuan Fungsional | Objektif Dipenuhi |
| :--- | :--- | :--- |
| `log() { ... | tee -a "$LOG_FILE" }` | [cite_start]Fungsi kustom untuk *logging* yang mencetak ke terminal dan menyimpan ke `progress.log` dengan *timestamp*[cite: 52]. | Logging & Timestamp |
| `subfinder -d "$domain" ... 2>> "$ERROR_LOG"` | Mencari subdomain. [cite_start]`2>> "$ERROR_LOG"` mengalihkan *error* ke file log[cite: 53]. | Integrasi Tool 1, Error Handling |
| `| anew "$SUBDOMAIN_FILE"` | [cite_start]Menerima *output* dari `subfinder` dan menghapus duplikasi *subdomain* sebelum mencatatnya ke `all-subdomains.txt`[cite: 50]. | Deduplikasi |
| `| httpx -silent -status-code -title` | Menerima *host* yang baru, memvalidasi apakah host hidup, dan mengambil kode status serta judul. | Integrasi Tool 2 & 3 |
| `| tee -a "$LIVE_FILE"` | [cite_start]Menyimpan *output* akhir host hidup ke `output/live.txt`[cite: 38]. | Output Terstruktur |
| `wc -l < "$SUBDOMAIN_FILE"` | [cite_start]Menghitung jumlah total subdomain unik sebagai *summary*[cite: 54]. | Output Ringkasan |

## Hasil Eksekusi dan Verifikasi
<img width="1919" height="1008" alt="Screenshot 2025-11-16 190040" src="https://github.com/user-attachments/assets/f8ef436b-fcb4-4efb-a826-692d38f3c27f" />
<img width="1919" height="1003" alt="Screenshot 2025-11-16 190410" src="https://github.com/user-attachments/assets/311e4add-15c1-41c5-b3d7-1537e7881685" />
<img width="1919" height="1005" alt="Screenshot 2025-11-16 190423" src="https://github.com/user-attachments/assets/8a2e6453-54b3-4cf6-b899-e249f16531ef" />

**PETUNJUK AKHIR:** Setelah `README.md` ini lengkap dan tersimpan, 
lakukan `git add .`, `git commit -m "feat: Finalisasi dokumentasi dan hasil"` dan `git push origin main` untuk mengumpulkan tugas Anda.



