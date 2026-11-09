-- =============================================================================
-- PRAKTIKUM BASIS DATA - PERTEMUAN 07: QUERY SELECT & FUNGSI SKALAR
-- TUGAS MANDIRI: MILESTONE PROYEK 7 - KUERI SATU TABEL & FUNGSI SKALAR
-- NAMA        : Narti Khoirunisa
-- NIM         : 25430116
-- KELAS       : D (Semester 3)
-- PROYEK      : Toko Daring Berkah Jaya NK (NisaStore Online)
-- BASIS DATA  : db_toko_daring_25430116
-- DOSEN       : Dedi Irawan, S.Kom., M.T.I.
-- FILE        : p07_kueri_25430116.sql
-- =============================================================================

USE db_toko_daring_25430116;

-- =============================================================================
-- 1. PEMETAAN KEBUTUHAN INFORMASI (KI) PROYEK TOKO DARING BERKAH JAYA NK
-- =============================================================================
-- KI-01 : Laporan Produk Terlaris dan Pergerakan Kuantitas Terjual [MULTI-TABEL / MODUL 09-10]
-- KI-02 : Riwayat Transaksi Pesanan Lengkap dan Profil Data Pelanggan [SEBAGIAN SATU TABEL]
-- KI-03 : Rekapitulasi Pendapatan, Transaksi Finansial, dan Diskon Belanja [SEBAGIAN SATU TABEL]
-- KI-04 : Pelacakan Status Pengiriman Paket Logistik dan Ekspedisi Real-Time [SEBAGIAN SATU TABEL]
-- KI-05 : Pengawasan Inventaris, Ketersediaan Stok, dan Buffer Minimum [SATU TABEL]
-- KI-06 : Pengelolaan dan Verifikasi Pembayaran Transaksi Pelanggan [SEBAGIAN SATU TABEL]
-- KI-07 : Klasifikasi Segmentasi Loyalitas dan Keaktifan Akun Pelanggan [SATU TABEL]
-- KI-08 : Analisis Rincian Nilai Belanja per Baris Detail Transaksi [SATU TABEL]
-- =============================================================================


-- =============================================================================
-- 2. KUERI SATU TABEL MENDUKUNG KEBUTUHAN INFORMASI (MINIMAL 10 KUERI)
-- =============================================================================

-- -----------------------------------------------------------------------------
-- KUERI 01
-- Kode KI    : KI-05 (Pengawasan Inventaris dan Stok Kritis)
-- Pertanyaan : "Produk apa saja yang persediaan stok fisiknya berada pada level ketat
--               (stok <= 60 unit), dan berapa rasio ketersediaan stok terhadap batas
--               minimumnya untuk memprioritaskan pemesanan ulang ke pemasok?"
-- Fitur SQL  : Proyeksi kolom, alias, operator pembanding (<=), fungsi string UPPER,
--               fungsi numerik ROUND, ORDER BY ASC.
-- Hasil yang Diharapkan:
--               Menampilkan 4 produk (Jaket Denim, Tas Ransel Laptop, Sepatu Sneakers,
--               dan Dompet Kulit) terurut dari stok fisik paling sedikit.
-- -----------------------------------------------------------------------------
SELECT 
    kode_produk, 
    UPPER(nama_produk) AS nama_produk_kapital, 
    stok_produk, 
    stok_minimum, 
    ROUND(stok_produk / stok_minimum, 1) AS rasio_buffer
FROM produk 
WHERE stok_produk <= 60 
ORDER BY stok_produk ASC;


-- -----------------------------------------------------------------------------
-- KUERI 02
-- Kode KI    : KI-02 (Profil Pelanggan dan Wilayah Pengiriman)
-- Pertanyaan : "Siapa saja pelanggan toko daring yang beralamat atau berdomisili di
--               wilayah Lampung atau Metro, dengan format label profil 'Nama [Kode]',
--               alamat lengkap, dan nomor kontak aktif terurut alfabetis?"
-- Fitur SQL  : Operator pencarian pola teks LIKE ('%Lampung%', '%Metro%'),
--               operator logika OR, fungsi penggabungan string CONCAT, ORDER BY ASC.
-- Hasil yang Diharapkan:
--               Menampilkan 8 baris data pelanggan yang beralamat di Lampung / Metro
--               dengan nama terurut A sampai Z.
-- -----------------------------------------------------------------------------
SELECT 
    CONCAT(nama_pelanggan, ' [', kode_pelanggan, ']') AS profil_pelanggan, 
    email, 
    no_telepon, 
    alamat_utama 
FROM pelanggan 
WHERE alamat_utama LIKE '%Lampung%' 
   OR alamat_utama LIKE '%Metro%' 
ORDER BY nama_pelanggan ASC;


-- -----------------------------------------------------------------------------
-- KUERI 03
-- Kode KI    : KI-03 (Rekapitulasi Transaksi Finansial dan Omzet)
-- Pertanyaan : "Pesanan mana saja yang terjadi pada rentang tanggal 07 hingga 08
--               Oktober 2026 dengan nilai total bayar antara Rp200.000 hingga Rp500.000,
--               disajikan dengan format tanggal transaksi standar Indonesia?"
-- Fitur SQL  : Operator rentang BETWEEN (pada DATETIME dan DECIMAL), fungsi format
--               tanggal DATE_FORMAT, operator logika AND, ORDER BY ASC, LIMIT.
-- Hasil yang Diharapkan:
--               Menampilkan 8 sampel transaksi pada tanggal 7-8 Oktober 2026 yang
--               memiliki total bayar pada rentang 200rb - 500rb.
-- -----------------------------------------------------------------------------
SELECT 
    no_pesanan, 
    DATE_FORMAT(tgl_pesanan, '%d/%m/%Y %H:%i') AS tgl_transaksi, 
    total_belanja, 
    diskon, 
    total_bayar, 
    status_pesanan 
FROM pesanan 
WHERE tgl_pesanan BETWEEN '2026-10-07 00:00:00' AND '2026-10-08 23:59:59' 
  AND total_bayar BETWEEN 200000.00 AND 500000.00 
ORDER BY tgl_pesanan ASC 
LIMIT 8;


-- -----------------------------------------------------------------------------
-- KUERI 04
-- Kode KI    : KI-05 (Katalog Produk Fashion Unggulan)
-- Pertanyaan : "Tampilkan produk-produk yang tergolong dalam rumpun pakaian dan alas kaki
--               (Kategori 1: Pakaian Pria, 2: Pakaian Wanita, 4: Sepatu & Sandal)
--               dengan nama huruf kapital dan format harga rupiah Indonesia!"
-- Fitur SQL  : Operator keanggotaan IN, fungsi string UPPER, fungsi pemformatan
--               angka FORMAT dengan locale 'id_ID', fungsi string CONCAT,
--               ORDER BY multi-kolom (id_kategori ASC, harga_katalog DESC).
-- Hasil yang Diharapkan:
--               Menampilkan 8 produk fashion dengan tampilan harga seperti 'Rp350.000'.
-- -----------------------------------------------------------------------------
SELECT 
    kode_produk, 
    UPPER(nama_produk) AS nama_produk, 
    id_kategori, 
    CONCAT('Rp', FORMAT(harga_katalog, 0, 'id_ID')) AS harga_rupiah, 
    stok_produk 
FROM produk 
WHERE id_kategori IN (1, 2, 4) 
ORDER BY id_kategori ASC, harga_katalog DESC;


-- -----------------------------------------------------------------------------
-- KUERI 05
-- Kode KI    : KI-04 (Pelacakan Pengiriman dan Resi yang Belum Sampai)
-- Pertanyaan : "Paket pengiriman mana saja yang masih dalam perjalanan menuju alamat
--               penerima dan belum diterima pelanggan (tanggal diterima masih kosong/NULL),
--               serta tampilkan tanda '-' jika paket belum tiba di tujuan?"
-- Fitur SQL  : Operator nilai kosong IS NULL, fungsi penanganan NULL IFNULL,
--               fungsi tanggal DATE_FORMAT, ORDER BY ASC, LIMIT.
-- Hasil yang Diharapkan:
--               Menampilkan data pengiriman dengan status 'dalam_perjalanan' di mana
--               kolom waktu_diterima secara rapi menampilkan karakter '-'.
-- -----------------------------------------------------------------------------
SELECT 
    no_resi, 
    id_pesanan, 
    id_kurir, 
    DATE_FORMAT(tgl_kirim, '%d-%m-%Y %H:%i') AS waktu_kirim, 
    IFNULL(DATE_FORMAT(tgl_diterima, '%d-%m-%Y %H:%i'), '-') AS waktu_diterima, 
    status_kirim 
FROM pengiriman 
WHERE tgl_diterima IS NULL 
  AND status_kirim = 'dalam_perjalanan' 
ORDER BY id_pengiriman ASC 
LIMIT 8;


-- -----------------------------------------------------------------------------
-- KUERI 06
-- Kode KI    : KI-07 (Segmentasi Loyalitas Pelanggan Berdasarkan Durasi Akun)
-- Pertanyaan : "Hitung berapa lama masing-masing pelanggan telah bergabung (dalam hari)
--               sejak registrasi hingga hari ini, lalu kelompokkan status loyalitasnya:
--               'Pelanggan Setia' jika lebih dari 60 hari, dan 'Pelanggan Baru' jika
--               <= 60 hari menggunakan klausa CASE!"
-- Fitur SQL  : Fungsi selisih tanggal DATEDIFF, fungsi tanggal sistem CURDATE,
--               fungsi ekstraksi DATE, fungsi format tanggal DATE_FORMAT,
--               pernyataan kondisional CASE WHEN ... THEN ... ELSE ... END,
--               ORDER BY tgl_registrasi ASC.
-- Hasil yang Diharapkan:
--               10 pelanggan terklasifikasi secara dinamis ke dalam 'Pelanggan Setia'
--               (3 pelanggan awal) dan 'Pelanggan Baru' (7 pelanggan berikutnya).
-- -----------------------------------------------------------------------------
SELECT 
    kode_pelanggan, 
    nama_pelanggan, 
    DATE_FORMAT(tgl_registrasi, '%d/%m/%Y') AS tgl_gabung, 
    DATEDIFF(CURDATE(), DATE(tgl_registrasi)) AS lama_hari, 
    CASE 
        WHEN DATEDIFF(CURDATE(), DATE(tgl_registrasi)) > 60 THEN 'Pelanggan Setia' 
        ELSE 'Pelanggan Baru' 
    END AS status_loyalitas 
FROM pelanggan 
ORDER BY tgl_registrasi ASC;


-- -----------------------------------------------------------------------------
-- KUERI 07
-- Kode KI    : KI-03 & KI-06 (Analisis Kanal Dompet Digital & Penggunaan Voucher)
-- Pertanyaan : "Transaksi pesanan apa saja yang memanfaatkan pembayaran dompet digital
--               (GoPay, OVO, ShopeePay), dan jelaskan apakah transaksi tersebut menikmati
--               'Diskon Voucher Rp8.000' atau 'Harga Normal' menggunakan fungsi IF?"
-- Fitur SQL  : Operator himpunan IN, fungsi kondisional IF, fungsi string CONCAT,
--               fungsi FORMAT id_ID, ORDER BY id_pesanan ASC, LIMIT.
-- Hasil yang Diharapkan:
--               Daftar pesanan digital wallet dengan kejelasan label status diskon.
-- -----------------------------------------------------------------------------
SELECT 
    no_pesanan, 
    metode_bayar, 
    CONCAT('Rp', FORMAT(total_bayar, 0, 'id_ID')) AS nominal_bayar, 
    IF(diskon > 0, 'Diskon Voucher Rp8.000', 'Harga Normal') AS status_diskon, 
    status_pesanan 
FROM pesanan 
WHERE metode_bayar IN ('E-Wallet GoPay', 'E-Wallet OVO', 'ShopeePay') 
ORDER BY id_pesanan ASC 
LIMIT 8;


-- -----------------------------------------------------------------------------
-- KUERI 08
-- Kode KI    : KI-05 (Valuasi Nilai Kapitalisasi Aset Inventaris Gudang)
-- Pertanyaan : "Berapa total nilai kapitalisasi stok barang yang tersimpan di gudang
--               (stok * harga katalog) untuk setiap produk bernilai jual di atas Rp100.000,
--               dibulatkan ke ribuan terdekat dan disajikan dalam format mata uang?"
-- Fitur SQL  : Ekspresi perkalian skalar per baris, fungsi pembulatan angka ROUND
--               dengan digit negatif (-3), fungsi FORMAT id_ID, fungsi CONCAT,
--               operator perbandingan (>), ORDER BY DESC.
-- Hasil yang Diharapkan:
--               Menampilkan 9 produk bernilai di atas 100rb terurut dari total aset
--               tertinggi (Gamis Premium Rp16.650.000 hingga Dompet Kulit Rp6.600.000).
-- -----------------------------------------------------------------------------
SELECT 
    kode_produk, 
    nama_produk, 
    stok_produk, 
    CONCAT('Rp', FORMAT(harga_katalog, 0, 'id_ID')) AS harga_satuan, 
    CONCAT('Rp', FORMAT(ROUND(stok_produk * harga_katalog, -3), 0, 'id_ID')) AS total_nilai_inventaris 
FROM produk 
WHERE harga_katalog > 100000.00 
ORDER BY (stok_produk * harga_katalog) DESC;


-- -----------------------------------------------------------------------------
-- KUERI 09
-- Kode KI    : KI-04 (Pemeriksaan Integritas Kontak Telepon Ekspedisi Kurir)
-- Pertanyaan : "Tampilkan profil seluruh mitra ekspedisi kurir toko, nama layanannya,
--               panjang digit nomor telepon kontak, serta tampilkan 'Belum Ada Kontak'
--               jika nomor telepon bernilai NULL?"
-- Fitur SQL  : Fungsi penanganan nilai kosong IFNULL, fungsi panjang string LENGTH,
--               ORDER BY id_kurir ASC.
-- Hasil yang Diharapkan:
--               Menampilkan 5 mitra kurir lengkap dengan panjang karakter kontak resmi.
-- -----------------------------------------------------------------------------
SELECT 
    id_kurir, 
    nama_kurir, 
    layanan_ekspedisi, 
    IFNULL(kontak_kurir, 'Belum Ada Kontak') AS kontak_layanan, 
    LENGTH(IFNULL(kontak_kurir, '')) AS digit_kontak 
FROM kurir 
ORDER BY id_kurir ASC;


-- -----------------------------------------------------------------------------
-- KUERI 10
-- Kode KI    : KI-03 (Daftar Pesanan Terbesar / High-Value Orders)
-- Pertanyaan : "Tampilkan 5 transaksi pesanan dengan nilai total belanja tertinggi
--               yang transaksinya sah/selesai (Completed atau PAID), beserta format waktu
--               pembelian dan nominal rupiah yang rapi!"
-- Fitur SQL  : Operator IN, fungsi DATE_FORMAT, fungsi string FORMAT dan CONCAT,
--               ORDER BY multi-kolom (total_belanja DESC, tgl_pesanan ASC), klausa LIMIT.
-- Hasil yang Diharapkan:
--               Tepat 5 transaksi dengan total belanja tertinggi (Rp555.000 dan Rp545.000).
-- -----------------------------------------------------------------------------
SELECT 
    no_pesanan, 
    DATE_FORMAT(tgl_pesanan, '%d-%m-%Y %H:%i') AS waktu_transaksi, 
    CONCAT('Rp', FORMAT(total_belanja, 0, 'id_ID')) AS nilai_belanja, 
    CONCAT('Rp', FORMAT(total_bayar, 0, 'id_ID')) AS nilai_bayar, 
    status_pesanan 
FROM pesanan 
WHERE status_pesanan IN ('Completed', 'PAID') 
ORDER BY total_belanja DESC, tgl_pesanan ASC 
LIMIT 5;


-- -----------------------------------------------------------------------------
-- KUERI 11
-- Kode KI    : KI-03 & KI-06 (Ragam Unik Metode Pembayaran yang Diterima Toko)
-- Pertanyaan : "Metode pembayaran apa saja yang pernah dipilih dan digunakan secara unik
--               oleh konsumen saat berbelanja, disajikan dalam huruf besar (UPPER)
--               beserta panjang karakter string namanya?"
-- Fitur SQL  : Eliminasi baris duplikat DISTINCT, fungsi string UPPER,
--               fungsi string LENGTH, ORDER BY kanal_bayar ASC.
-- Hasil yang Diharapkan:
--               Menampilkan 7 kanal pembayaran unik tanpa duplikasi.
-- -----------------------------------------------------------------------------
SELECT DISTINCT 
    UPPER(metode_bayar) AS kanal_bayar, 
    LENGTH(metode_bayar) AS jumlah_karakter 
FROM pesanan 
ORDER BY kanal_bayar ASC;


-- -----------------------------------------------------------------------------
-- KUERI 12
-- Kode KI    : KI-08 (Kalkulasi Subtotal Finansial per Baris Detail Nota)
-- Pertanyaan : "Tampilkan setiap baris item belanjaan pada transaksi pesanan nomor 2
--               (id_pesanan = 2) beserta perhitungan subtotal rupiahnya
--               (qty_beli * harga_satuan) untuk memvalidasi rincian faktur!"
-- Fitur SQL  : Proyeksi kolom, perkalian aritmatika skalar (qty_beli * harga_satuan),
--               fungsi pemformatan rupiah CONCAT dan FORMAT id_ID,
--               klausa WHERE id_pesanan = 2, ORDER BY id_detail_pesanan ASC.
-- Hasil yang Diharapkan:
--               Menampilkan 2 baris item rincian pesanan #2 dengan total belanja
--               Rp135.000 + Rp65.000 = Rp200.000 (sesuai total_belanja nota pesanan #2).
-- -----------------------------------------------------------------------------
SELECT 
    id_detail_pesanan, 
    id_pesanan, 
    id_produk, 
    qty_beli, 
    CONCAT('Rp', FORMAT(harga_satuan, 0, 'id_ID')) AS harga_satuan_rp, 
    (qty_beli * harga_satuan) AS subtotal, 
    CONCAT('Rp', FORMAT(qty_beli * harga_satuan, 0, 'id_ID')) AS subtotal_rp 
FROM detail_pesanan 
WHERE id_pesanan = 2 
ORDER BY id_detail_pesanan ASC;


-- =============================================================================
-- 3. PENANDAAN KEBUTUHAN INFORMASI (KI) YANG BELUM DAPAT DIJAWAB SATU TABEL
-- =============================================================================
-- Sesuai batasan materi Modul 7 (Kueri Satu Tabel & Fungsi Skalar), terdapat beberapa
-- kebutuhan informasi strategis toko daring yang BELUM DAPAT dijawab secara tuntas
-- karena membutuhkan fitur SQL tingkat lanjut yang akan dipelajari pada pertemuan berikutnya:
--
-- 1. [KI-01: Produk Terlaris Bulanan]
--    Alasan: Memerlukan penggabungan tabel produk dan detail_pesanan (JOIN) serta
--    penjumlahan total kuantitas per produk menggunakan fungsi agregat SUM(qty_beli)
--    dan GROUP BY id_produk (Materi Modul 09 dan Modul 10).
--
-- 2. [KI-02: Riwayat Transaksi Lengkap Pelanggan]
--    Alasan: Informasi nama pelanggan, daftar nama produk yang dibeli, dan nomor resi
--    tersebar pada 5 tabel berbeda (pelanggan, pesanan, detail_pesanan, produk, pengiriman).
--    Menyatukannya dalam satu baris tampilan memerlukan Multi-table INNER/LEFT JOIN
--    (Materi Modul 10).
--
-- 3. [KI-03: Rekapitulasi Pendapatan Harian dan Bulanan]
--    Alasan: Menghitung total omzet (grand total) dan rata-rata penjualan per hari/bulan
--    memerlukan fungsi agregasi SUM(total_bayar), COUNT(id_pesanan), AVG(total_bayar),
--    serta pengelompokan baris GROUP BY DATE(tgl_pesanan) (Materi Modul 09).
--
-- 4. [KI-04: Pelacakan Pengiriman Lengkap dengan Nama Kurir dan Konsumen]
--    Alasan: Tabel pengiriman hanya menyimpan id_pesanan dan id_kurir dalam bentuk kode integer.
--    Untuk menampilkan nama kurir (tabel kurir) beserta nama dan alamat tujuan penerima
--    (tabel pesanan & pelanggan), dibutuhkan operasi JOIN multi-tabel (Materi Modul 10).
--
-- 5. [KI-06: Verifikasi Pembayaran Silang Rekening dan Pesanan]
--    Alasan: Memvalidasi kesesuaian antara jumlah_bayar di tabel pembayaran dengan
--    total_bayar di tabel pesanan memerlukan perbandingan lintas-tabel atau subquery
--    (Materi Modul 11 & 12).
-- =============================================================================
-- AKHIR DARI FILE p07_kueri_25430116.sql
-- =============================================================================

