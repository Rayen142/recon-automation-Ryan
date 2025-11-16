# 🛠️ Recon Automation Tool: Bash Scripting

**Nama Repository:** recon-automation-Ryan
**Nama Script:** `recon-auto.sh`

## Deskripsi Proyek

Proyek ini adalah implementasi dari **Assignment Build Your Own Recon Automation Tool** yang bertujuan untuk mengotomatisasi alur kerja *subdomain enumeration* dan validasi host yang hidup (*live hosts*) menggunakan Bash Scripting.

Script `recon-auto.sh` dirancang untuk berjalan *end-to-end* tanpa *error* kritis, mengintegrasikan minimal 3 *tools* (`subfinder`, `anew`, dan `httpx`) dalam satu *pipeline*, mengelola *input/output* file, melakukan *deduplikasi*, dan mencatat *logging* yang informatif.

## Struktur Direktori

Struktur folder ini wajib ada untuk memastikan skrip berjalan dengan benar sesuai panduan *assignment*.
recon-automation-Ryan/ ├── input/ │ ├── domains.txt │ └── all-subdomains.txt ├── output/ 
│ └── live.txt ├── scripts/ │ └── recon-auto.sh └── logs/ ├── progress.log └── errors.log
| File/Folder | Deskripsi |
| :--- | :--- |
| `input/domains.txt` | Daftar minimal 5 domain target untuk *scanning*. |
| `input/all-subdomains.txt` | File master yang mencatat semua subdomain unik yang ditemukan (untuk deduplikasi menggunakan **`anew`**). |
| `output/live.txt` | Hasil akhir: daftar host hidup yang berhasil diakses (Format: URL [STATUS] [TITLE]). |
| `scripts/recon-auto.sh` | Script utama Bash yang menjalankan seluruh proses (Wajib *executable*). |
| `logs/progress.log` | Log kemajuan skrip yang dilengkapi dengan *timestamp* (wajib). |
| `logs/errors.log` | Log untuk mencatat semua *Standard Error* (stderr) dari *tools* (wajib). |

## Cara Setup Environment

Berikut adalah langkah-langkah yang diperlukan untuk menyiapkan lingkungan dan menginstal *tools* yang digunakan oleh skrip ini (semua *tools* berbasis Go):

1.  **Instalasi GoLang:**
    ```bash
    sudo apt update && sudo apt install golang -y
    ```
2.  **Konfigurasi PATH untuk Go:**
    ```bash
    echo 'export PATH=$PATH:$(go env GOPATH)/bin' >> ~/.zshrc # atau ~/.bashrc
    source ~/.zshrc
    ```
3.  **Instalasi Tools (`subfinder`, `httpx`, `anew`):**
    ```bash
    go install -v [github.com/projectdiscovery/subfinder/v2/cmd/subfinder@latest](https://github.com/projectdiscovery/subfinder/v2/cmd/subfinder@latest)
    go install -v [github.com/projectdiscovery/httpx/cmd/httpx@latest](https://github.com/projectdiscovery/httpx/cmd/httpx@latest)
    go install -v [github.com/tomnomnom/anew@latest](https://github.com/tomnomnom/anew@latest)
    ```

## Cara Menjalankan Script

1.  **Kloning Repository:**
    ```bash
    git clone [https://github.com/Rayen142/recon-automation-Rayen.git](https://github.com/Rayen142/recon-automation-Rayen.git)
    cd recon-automation-Rayen
    ```
2.  **Isi Input:** Pastikan file `input/domains.txt` berisi minimal 5 domain.
3.  **Jalankan Skrip:**
    ```bash
    ./scripts/recon-auto.sh
    ```

## Penjelasan Singkat Kode (`recon-auto.sh`)

| Logika Inti | Keterangan Fungsional |
| :--- | :--- |
| **`log() { ... | tee -a "$LOG_FILE" }`** | Fungsi kustom untuk *logging* yang mencetak ke terminal dan menyimpan ke `progress.log` dengan *timestamp* (`date +'%Y-%m-%d %H:%M:%S'`). |
| **`subfinder ... 2>> "$ERROR_LOG"`** | Mencari subdomain. Output *error* (stderr) dari *tool* ini dialihkan ke `logs/errors.log` (Error Handling). |
| **`| anew "$SUBDOMAIN_FILE"`** | Menerima *output* dari `subfinder` dan menghapus duplikasi. Hanya subdomain baru yang diteruskan ke *pipeline* dan dicatat ke `all-subdomains.txt`. |
| **`| httpx ... | tee -a "$LIVE_FILE"`** | Memvalidasi apakah subdomain hidup, mengambil kode status dan judul. Hasil akhir dicatat ke `output/live.txt` (Output Terstruktur). |
| **`wc -l < "$SUBDOMAIN_FILE"`** | Menghitung jumlah total subdomain unik dan host hidup sebagai *summary* akhir. |

## Hasil Eksekusi dan Verifikasi
<img width="1919" height="1008" alt="Screenshot 2025-11-16 190040" src="https://github.com/user-attachments/assets/f8ef436b-fcb4-4efb-a826-692d38f3c27f" />
<img width="1919" height="1003" alt="Screenshot 2025-11-16 190410" src="https://github.com/user-attachments/assets/311e4add-15c1-41c5-b3d7-1537e7881685" />
<img width="1919" height="1005" alt="Screenshot 2025-11-16 190423" src="https://github.com/user-attachments/assets/8a2e6453-54b3-4cf6-b899-e249f16531ef" />

**PETUNJUK AKHIR:** Setelah `README.md` ini lengkap dan tersimpan, 
lakukan `git add .`, `git commit -m "feat: Finalisasi dokumentasi dan hasil"` dan `git push origin main` untuk mengumpulkan tugas Anda.



