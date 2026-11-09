# Repositori Praktikum Basis Data (Semester 3)

**Nama Mahasiswa:** Narti Khoirunisa  
**NIM:** 25430116  
**Kelas:** D  
**Dosen Pengampu:** Dedi Irawan, S.Kom., M.T.I.  
**Tema Proyek:** Toko Daring Berkah Jaya NK (NisaStore Online)  
**Basis Data Utama:** `db_toko_daring_25430116`  
**Basis Data Praktikum:** `kopma_116`  
**Parameter Personal P:** $P = (16 \pmod 9) + 1 = 8$  

---

## Struktur Repositori dan Milestone Proyek

| Pertemuan / Milestone | Topik Materi | Berkas Skrip & Data | Dokumen Laporan |
| :--- | :--- | :--- | :--- |
| **Pertemuan 01** | Lingkungan Kerja & Setup MariaDB/MySQL | `p01_lingkungan_25430116.sql` | `laporan/p01_laporan_25430116.md` |
| **Pertemuan 02** | Analisis Kebutuhan Data & Dokumen Sumber | `p02_kebutuhan_data_25430116.md` | `laporan/p02_laporan_25430116.md` |
| **Pertemuan 03** | Entity Relationship Diagram (ERD) | `po3_erd_25430116.sql` | `laporan/p03_laporan_25430116.md` |
| **Pertemuan 04** | Normalisasi Basis Data (1NF s.d. 3NF/BCNF) | - | `laporan/p04_normalisasi_25430116.md` |
| **Pertemuan 05** | Data Definition Language (DDL) Skema Fisik | `p05_ddl_25430116.sql` | `laporan/p05_laporan_25430116.md` |
| **Pertemuan 06** | Data Manipulation Language (DML) & Pengujian | `p06_data_25430116.sql`, `p06_uji_25430116.md` | `laporan/p06_laporan_25430116.md` |
| **Pertemuan 07** | Query SELECT, Operator Filter, & Fungsi Skalar | `p07_kueri_kopma_25430116.sql`, `p07_kueri_25430116.sql` | `laporan/p07_laporan_25430116.md` |

---

## Petunjuk Instalasi dan Rekonstruksi Basis Data Proyek

Skrip DDL, DML, dan Kueri bersifat idempoten (*reproducible*) dan dapat dipasang ulang dari awal melalui command line / PowerShell:

```powershell
# 1. Bangun struktur tabel dan konstrain (DDL)
D:\xampp\mysql\bin\mysql.exe -u root -e "source d:/praktikum/basisdata-25430116/p05_ddl_25430116.sql;"

# 2. Isi data sampel realistis toko daring 80 transaksi (DML)
D:\xampp\mysql\bin\mysql.exe -u root -e "source d:/praktikum/basisdata-25430116/p06_data_25430116.sql;"

# 3. Jalankan pengujian kueri satu tabel dan fungsi skalar
D:\xampp\mysql\bin\mysql.exe -u root -e "source d:/praktikum/basisdata-25430116/p07_kueri_25430116.sql;"
```

