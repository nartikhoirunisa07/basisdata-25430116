# Dokumen Kebutuhan Data - Proyek Toko Daring (Milestone 2)
**Nama Organisasi:** Toko Daring Berkah Jaya NK  
**Nama Pengembang:** Narti Khoirunisa  
**NIM:** 25430116  
**Kelas:** D  

---

## 1. Proses Bisnis (Minimal 4 Proses)
1. **Registrasi & Autentikasi Pengguna:** Pelanggan atau admin mendaftarkan akun baru, melakukan masuk (*login*), dan memverifikasi identitas.
2. **Katalog & Pengelolaan Produk:** Admin mengelola data produk (kategori, stok, harga), sementara pelanggan dapat mencari dan melihat detail produk.
3. **Pemesanan & Keranjang Belanja:** Pelanggan memilih produk, memasukkannya ke keranjang, dan melakukan *checkout* untuk membuat pesanan baru.
4. **Pembayaran & Konfirmasi Pengiriman:** Pelanggan mengunggah bukti pembayaran, admin memverifikasi pembayaran, lalu memperbarui status pengiriman barang hingga sampai ke alamat tujuan.

---

## 2. Entitas Kandidat (Minimal 6 Entitas)
1. `Pelanggan` (Menyimpan data diri, email, dan alamat pengguna).
2. `Admin` (Menyimpan data pengelola sistem toko daring).
3. `Kategori` (Menyimpan kelompok jenis produk).
4. `Produk` (Menyimpan informasi barang, harga, dan stok).
5. `Pesanan` (Menyimpan transaksi pembelian beserta total harga dan status).
6. `Detail_Pesanan` (Menyimpan item produk apa saja yang dibeli dalam suatu nomor pesanan).
7. `Pembayaran` (Menyimpan bukti dan status transaksi pembayaran).

---

## 3. Aturan Bisnis (Minimal 8 Aturan)
1. Setiap pelanggan wajib memiliki satu alamat email yang unik sebagai identitas akun.
2. Pelanggan dapat melakukan banyak transaksi pesanan, tetapi satu pesanan hanya milik satu pelanggan.
3. Satu produk harus memiliki minimal satu kategori yang jelas.
4. Stok produk akan berkurang secara otomatis ketika pesanan berhasil dikonfirmasi atau dibayar.
5. Status pesanan memiliki siklus: *Pending* (Menunggu Pembayaran) -> *Paid* (Dibayar) -> *Shipped* (Dikirim) -> *Completed* (Selesai).
6. Pembayaran harus diverifikasi oleh admin sebelum barang diproses untuk pengiriman.
7. Setiap transaksi pesanan menghasilkan satu dokumen bukti pembayaran atau resi pengiriman.
8. Harga produk bersifat mengikat pada saat transaksi pesanan dibuat, terlepas dari perubahan harga di masa mendatang.

---

## 4. Kebutuhan Informasi (Minimal 5 Kebutuhan)
1. Laporan daftar produk terlaris berdasarkan jumlah kuantitas yang terjual tiap bulan.
2. Riwayat transaksi pesanan lengkap untuk setiap pelanggan.
3. Rekapitulasi pendapatan atau total penjualan harian dan bulanan bagi admin.
4. Informasi status pengiriman paket secara *real-time* bagi pelanggan.
5. Laporan ketersediaan stok barang untuk menghindari kekurangan inventaris.

---

## 5. Matriks CRUD Lengkap
| No | Entitas | Create (C) | Read (R) | Update (U) | Delete (D) | Keterangan / Pengecualian |
| :-- | :-- | :-- | :-- | :-- | :-- | :-- |
| 1 | Pelanggan | Register Akun | Profil & Data Diri | Ubah Profil/Alamat | Hapus Akun | - |
| 2 | Admin | Tambah Admin | Lihat Data Admin | Edit Admin | Nonaktifkan Admin | - |
| 3 | Kategori | Tambah Kategori | Lihat Kategori | Edit Kategori | Hapus Kategori | - |
| 4 | Produk | Tambah Produk | Katalog/Detail | Ubah Harga/Stok | Hapus Produk | - |
| 5 | Pesanan | Checkout | Riwayat Pesanan | Ubah Status Pesanan| Batalkan Pesanan | - |
| 6 | Detail_Pesanan | Tambah Item | Lihat Isi Pesanan| - | Hapus Item | Terikat langsung pada Pesanan |
| 7 | Pembayaran | Unggah Bukti | Cek Pembayaran | Update Status | - | - |

---

## 6. Kamus Data Awal (Minimal 20 Elemen)

| No | Nama Kolom / Atribut | Entitas Asal | Tipe Data & Ukuran | Penanggung Jawab | Deskripsi / Keterangan |
| :-- | :-- | :-- | :-- | :-- | :-- |
| 1 | `id_pelanggan` | Pelanggan | INT (Primary Key) | Sistem / DB Admin | Nomor identitas unik pelanggan |
| 2 | `nama_pelanggan` | Pelanggan | VARCHAR(100) | Pelanggan | Nama lengkap pengguna |
| 3 | `email` | Pelanggan | VARCHAR(100) | Pelanggan | Alamat surel untuk login |
| 4 | `password_hash` | Pelanggan | VARCHAR(255) | Sistem Keamanan | Kata sandi terenkripsi |
| 5 | `no_telepon` | Pelanggan | VARCHAR(15) | Pelanggan | Nomor kontak aktif |
| 6 | `alamat` | Pelanggan | TEXT | Pelanggan | Alamat pengiriman barang |
| 7 | `id_produk` | Produk | INT (Primary Key) | Admin Gudang | Kode unik produk |
| 8 | `nama_produk` | Produk | VARCHAR(150) | Admin Katalog | Nama barang yang dijual |
| 9 | `harga` | Produk | DECIMAL(10,2) | Admin Katalog | Harga satuan barang |
| 10 | `stok` | Produk | INT | Admin Gudang | Jumlah stok barang tersedia |
| 11 | `id_kategori` | Kategori | INT (Primary Key) | Admin Katalog | Kode kategori produk |
| 12 | `nama_kategori` | Kategori | VARCHAR(50) | Admin Katalog | Nama kelompok produk |
| 13 | `id_pesanan` | Pesanan | INT (Primary Key) | Sistem Transaksi | Nomor unik transaksi pesanan |
| 14 | `tanggal_pesan` | Pesanan | DATETIME | Sistem Transaksi | Waktu saat pesanan dibuat |
| 15 | `total_harga` | Pesanan | DECIMAL(12,2) | Sistem Transaksi | Akumulasi total biaya belanja |
| 16 | `status_pesanan` | Pesanan | VARCHAR(50) | Admin Toko | Status proses transaksi |
| 17 | `id_detail` | Detail_Pesanan| INT (Primary Key) | Sistem Transaksi | Kode unik rincian item pesanan |
| 18 | `jumlah_beli` | Detail_Pesanan| INT | Pelanggan | Kuantitas produk yang dibeli |
| 19 | `id_pembayaran` | Pembayaran | INT (Primary Key) | Sistem Keuangan | Nomor unik bukti bayar |
| 20 | `metode_bayar` | Pembayaran | VARCHAR(50) | Pelanggan | Cara pembayaran (Transfer/E-Wallet) |
| 21 | `bukti_transfer` | Pembayaran | VARCHAR(255) | Pelanggan | Nama file/path gambar bukti bayar |

---

## 7. Kebutuhan Non-Fungsional & Keamanan Data (Data Pribadi)
* **Identifikasi Data Pribadi:** Data yang dikategorikan sebagai informasi pribadi sensitif meliputi: `email`, `no_telepon`, `alamat` pengiriman, dan riwayat transaksi keuangan pelanggan.
* **Hak Akses & Batasan:**
  1. Pelanggan hanya berhak melihat dan mengubah data profil pribadinya sendiri.
  2. Data kata sandi (`password_hash`) **wajib** disimpan dalam bentuk enkripsi (*hashing*), tidak boleh terbaca langsung sebagai teks biasa (*plaintext*).
  3. Admin toko memiliki akses melihat data pesanan dan alamat pelanggan, tetapi dilarang keras mengubah atau membocorkan data kata sandi pelanggan.
* **Kinerja & Ketersediaan:** Sistem harus mampu merespons pencarian katalog produk dalam waktu kurang dari 2 detik dan melakukan pencadangan (*backup*) basis data secara berkala setiap malam.

---

## 8. Dokumen Sumber Fiktif & Pembedahannya (Analisis Dokumen)
Berikut adalah rancangan dokumen sumber fiktif berupa **Halaman Pesanan & Resi Pengiriman (Nota)**:

```text
==================================================
        TOKO DARING BERKAH JAYA NK
    Jl. Ahmad Dahlan No. 16, Metro, Lampung
==================================================
Nomor Pesanan : ORD-20261006-001
Tanggal       : 06 Oktober 2026
Pelanggan     : Budi Santoso (budi@email.com)
Alamat Kirim  : Jl. Kenanga Indah Blok C2, Lampung
--------------------------------------------------
No | Nama Produk          | Qty | Harga      | Subtotal
--------------------------------------------------
1  | Kemeja Flanel Pria   |  1  | Rp 150.000 | Rp 150.000
2  | Celana Chino Hitam   |  2  | Rp 200.000 | Rp 400.000
--------------------------------------------------
Total Belanja            :                 Rp 550.000
Biaya Ongkir             :                 Rp  20.000
--------------------------------------------------
GRAND TOTAL              :                 Rp 570.000
Metode Bayar             : Transfer Bank BCA
Status                   : PAID (Lunas)
Resi Kurir               : JNE-REG-987654321
==================================================