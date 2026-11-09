-- =============================================================================
-- PRAKTIKUM BASIS DATA - MODUL 7: MENJAWAB PERTANYAAN DENGAN SELECT & FUNGSI SKALAR
-- LANGKAH PERCOBAAN BASIS DATA KOPMA (KOPERASI MAHASISWA)
-- NAMA      : Narti Khoirunisa
-- NIM       : 25430116
-- KELAS     : D (Semester 3)
-- BASIS DATA: kopma_116 (atau kopma_<3d>)
-- DOSEN     : Dedi Irawan, S.Kom., M.T.I.
-- FILE      : p07_kueri_kopma_25430116.sql
-- =============================================================================

USE kopma_116;

-- =============================================================================
-- D.1 PROYEKSI DAN PENYARINGAN
-- =============================================================================

-- 1. KI-03: Barang yang perlu dipesan ulang (di bawah stok minimum)
-- Pertanyaan: Barang apa saja yang stok fisiknya di bawah stok minimum, serta berapa kekurangannya?
-- Hasil yang diharapkan: Daftar barang dengan selisih stok_min - stok > 0 terurut dari kekurangan terbanyak.
SELECT 
    kode_barang, 
    nama_barang, 
    stok_barang, 
    stok_min_barang,
    stok_min_barang - stok_barang AS kurang
FROM barang
WHERE stok_barang < stok_min_barang
ORDER BY kurang DESC;

-- 2. Tiga Kueri Penyaringan Lain:

-- 2.a. Penyaringan Operator IN: Barang kategori ATK atau Minuman
-- Pertanyaan: Tampilkan daftar barang yang termasuk dalam kelompok kategori ATK atau minuman!
-- Hasil yang diharapkan: Hanya barang kategori 'ATK' atau 'minuman' yang tampil.
SELECT 
    kode_barang, 
    nama_barang, 
    kategori_barang, 
    harga_jual_barang, 
    stok_barang
FROM barang
WHERE kategori_barang IN ('ATK', 'minuman')
ORDER BY kategori_barang ASC, nama_barang ASC;

-- 2.b. Penyaringan Operator BETWEEN: Transaksi Penjualan pada Rentang Tanggal Tertentu
-- Pertanyaan: Nota transaksi mana saja yang diterbitkan antara tanggal 01 September hingga 05 September 2026?
-- Hasil yang diharapkan: Transaksi dengan rentang waktu 2026-09-01 s.d. 2026-09-05.
SELECT 
    no_penjualan, 
    no_nota_penjualan, 
    tgl_penjualan, 
    total_penjualan
FROM penjualan
WHERE tgl_penjualan BETWEEN '2026-09-01 00:00:00' AND '2026-09-05 23:59:59'
ORDER BY tgl_penjualan ASC;

-- 2.c. Penyaringan Operator IS NULL: Anggota Tanpa Nomor Handphone
-- Pertanyaan: Siapa saja anggota koperasi yang belum mencantumkan nomor kontak HP aktif?
-- Hasil yang diharapkan: Anggota yang kolom no_hp_anggota bernilai NULL.
SELECT 
    no_anggota, 
    nama_anggota, 
    no_hp_anggota, 
    status_anggota
FROM anggota
WHERE no_hp_anggota IS NULL;

-- -----------------------------------------------------------------------------
-- TITIK ANALISIS 1: URUTAN EVALUASI LOGIS SELECT & ALIAS KOLOM
-- -----------------------------------------------------------------------------
-- Percobaan Galat:
-- Mengganti ORDER BY kurang menjadi WHERE kurang > 0.
-- Kueri berikut sengaja dinonaktifkan/dikomentari karena memicu galat:
-- ERROR 1054 (42S22): Unknown column 'kurang' in 'where clause'
/*
SELECT kode_barang, nama_barang, stok_barang, stok_min_barang,
       stok_min_barang - stok_barang AS kurang
FROM barang
WHERE kurang > 0;
*/

-- Kueri Perbaikan Titik Analisis 1:
-- Mengulang ekspresi aritmatika secara eksplisit di WHERE tanpa menggunakan alias kolom:
SELECT 
    kode_barang, 
    nama_barang, 
    stok_barang, 
    stok_min_barang,
    stok_min_barang - stok_barang AS kurang
FROM barang
WHERE (stok_min_barang - stok_barang) > 0
ORDER BY kurang DESC;


-- =============================================================================
-- D.2 POLA TEKS DAN NILAI KOSONG
-- =============================================================================

-- 3. Cari anggota yang namanya mengandung huruf tertentu ('%a%') dengan label rapi
-- Pertanyaan: Tampilkan 5 anggota yang namanya memuat huruf 'a', dengan format nama (nomor),
-- tanggal Indonesia, nomor HP berpenanganan nilai kosong, dan status diskon anggota!
SELECT 
    CONCAT(nama_anggota, ' (', no_anggota, ')') AS anggota,
    DATE_FORMAT(tgl_daftar_anggota, '%d-%m-%Y') AS tgl_daftar_anggota,
    IFNULL(no_hp_anggota, '-') AS hp,
    CASE status_anggota 
        WHEN 'aktif' THEN 'Diskon 5%'
        ELSE 'Tanpa diskon' 
    END AS keterangan
FROM anggota
WHERE nama_anggota LIKE '%a%'
ORDER BY tgl_daftar_anggota DESC
LIMIT 5;

-- -----------------------------------------------------------------------------
-- TITIK ANALISIS 2: LOGIKA TERNARY TIGA NILAI (THREE-VALUED LOGIC) & NILAI NULL
-- -----------------------------------------------------------------------------
-- Percobaan Galat Semantik (Salah Logika):
-- Perbandingan menggunakan '= NULL' menghasilkan UNKNOWN sehingga tidak ada baris yang lolos (Empty set):
SELECT no_anggota, nama_anggota, no_hp_anggota
FROM anggota
WHERE no_hp_anggota = NULL;

-- Kueri Perbaikan Titik Analisis 2:
-- Menggunakan operator khusus IS NULL untuk memeriksa ketiadaan nilai:
SELECT 
    no_anggota, 
    nama_anggota, 
    no_hp_anggota
FROM anggota
WHERE no_hp_anggota IS NULL;


-- =============================================================================
-- D.3 TANGGAL DAN PERHITUNGAN PER BARIS
-- =============================================================================

-- 4. Hitung masa keanggotaan dalam hari dan kategorisasi baru/lama (< 180 hari)
-- Pertanyaan: Berapa lama masing-masing anggota telah bergabung (dalam hari) dan bagaimana status keanggotaannya?
SELECT 
    no_anggota, 
    nama_anggota, 
    tgl_daftar_anggota,
    DATEDIFF(CURDATE(), tgl_daftar_anggota) AS lama_hari,
    IF(DATEDIFF(CURDATE(), tgl_daftar_anggota) < 180, 'baru', 'lama') AS status_keanggotaan
FROM anggota
ORDER BY lama_hari ASC;

-- 5. Detail item nota PJ-2609-0142 beserta subtotal per baris
-- Pertanyaan: Tampilkan rincian barang, kuantitas, harga satuan, dan perkalian subtotal pada transaksi PJ-2609-0142!
SELECT 
    no_penjualan, 
    kode_barang, 
    qty_detail_penjualan, 
    harga_satuan_detail_penjualan,
    qty_detail_penjualan * harga_satuan_detail_penjualan AS subtotal
FROM detail_penjualan
WHERE no_penjualan = 'PJ-2609-0142';

-- -----------------------------------------------------------------------------
-- TITIK ANALISIS 3: SKALAR VS AGREGASI MULTI-BARIS
-- -----------------------------------------------------------------------------
-- Catatan Analisis:
-- Ekspresi 'qty_detail_penjualan * harga_satuan_detail_penjualan' di atas beroperasi secara skalar
-- (baris demi baris). Untuk menjumlahkan seluruh subtotal baris menjadi satu total nota tunggal,
-- diperlukan fungsi agregasi SUM(qty_detail_penjualan * harga_satuan_detail_penjualan) 
-- dan pengelompokan GROUP BY no_penjualan yang akan dipelajari pada Modul 09.


-- =============================================================================
-- E. LATIHAN DAN MODIFIKASI
-- =============================================================================

-- E.1. Nama barang huruf kapital dan format harga rupiah Indonesia
-- Pertanyaan: Sajikan daftar katalog barang dengan nama berhuruf besar (kapital) dan format mata uang Rp!
SELECT 
    kode_barang,
    UPPER(nama_barang) AS nama_barang_kapital,
    CONCAT('Rp', FORMAT(harga_jual_barang, 0, 'id_ID')) AS harga_format,
    stok_barang
FROM barang
ORDER BY kode_barang ASC;

-- E.2. Demonstrasi Kesalahan Semantik: Presedensi Operator AND vs OR Tanpa Tanda Kurung

-- Kasus Salah Secara Semantik (Tanpa Kurung):
-- Niat bisnis: Mencari barang kategori 'makanan' yang harganya di bawah Rp5.000 ATAU stoknya di bawah 10 unit.
-- Kueri salah:
SELECT kode_barang, nama_barang, kategori_barang, harga_jual_barang, stok_barang
FROM barang
WHERE kategori_barang = 'makanan' AND harga_jual_barang < 5000 OR stok_barang < 10;
-- Penjelasan hasil salah: Karena AND memiliki presedensi lebih tinggi daripada OR, kueri dievaluasi
-- sebagai: (kategori = 'makanan' AND harga < 5000) OR (stok < 10).
-- Akibatnya, barang non-makanan (misal ATK 'Pulpen Standard') yang memiliki stok < 10 ikut terambil!

-- Kueri Perbaikan Semantik (Dengan Tanda Kurung Eksplisit):
SELECT 
    kode_barang, 
    nama_barang, 
    kategori_barang, 
    harga_jual_barang, 
    stok_barang
FROM barang
WHERE kategori_barang = 'makanan' AND (harga_jual_barang < 5000 OR stok_barang < 10);
-- Hasil perbaikan: Hanya barang yang benar-benar berkategori 'makanan' yang lolos saringan.

-- =============================================================================
-- AKHIR DARI FILE p07_kueri_kopma_25430116.sql
-- =============================================================================

